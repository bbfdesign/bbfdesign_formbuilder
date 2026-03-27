<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector;

use BbfdesignFormbuilder\Models\ApiConnection;
use BbfdesignFormbuilder\Models\ApiEndpoint;
use BbfdesignFormbuilder\Models\ApiLog;
use BbfdesignFormbuilder\Services\EncryptionService;
use JTL\Shop;

/**
 * Führt API-Requests für Formular-Submissions aus.
 *
 * Sicherheit:
 * - Auth-Daten verschlüsselt in DB, werden nur zur Laufzeit entschlüsselt
 * - Nur Prepared Statements
 * - Keine User-Eingaben unescaped in URLs/Headers
 * - Timeout konfigurierbar pro Verbindung
 */
class ApiConnector
{
    /**
     * Alle aktiven Submit-Endpunkte für eine Formular-Submission ausführen.
     */
    public function executeForForm(int $formId, int $entryId, array $formData): array
    {
        $endpointModel = new ApiEndpoint();
        $endpoints = $endpointModel->getActiveForSubmit();
        $results = [];

        foreach ($endpoints as $endpoint) {
            $endpoint = (array)$endpoint;
            try {
                $payload = $this->buildPayload($endpoint, $formData);
                $response = $this->sendRequest($endpoint, $payload);

                $this->logRequest(
                    (int)$endpoint['id'],
                    $formId,
                    $entryId,
                    $payload,
                    $response
                );

                $results[] = $this->processResponse($endpoint, $response);
            } catch (\Throwable $e) {
                $this->logRequest(
                    (int)$endpoint['id'],
                    $formId,
                    $entryId,
                    [],
                    ['status_code' => 0, 'body' => null, 'duration_ms' => 0, 'error' => $e->getMessage(), 'success' => false]
                );
                $results[] = ['success' => false, 'error' => $e->getMessage()];
            }
        }

        return $results;
    }

    private function buildPayload(array $endpoint, array $formData): array
    {
        $mapping = json_decode($endpoint['field_mapping'] ?? '[]', true);
        if (!is_array($mapping)) {
            return $formData;
        }

        $registry = TransformerRegistry::getInstance();
        $payload = [];

        foreach ($mapping as $map) {
            $value = ($map['source'] ?? '') === 'static'
                ? ($map['value'] ?? '')
                : ($formData[$map['field_id'] ?? ''] ?? null);

            if (!empty($map['transformer'])) {
                $value = $registry->apply(
                    $value,
                    $map['transformer'],
                    $map['transformer_config'] ?? []
                );
            }

            $apiPath = $map['api_path'] ?? '';
            if ($apiPath !== '') {
                $this->setNestedValue($payload, $apiPath, $value);
            }
        }

        return $payload;
    }

    private function sendRequest(array $endpoint, array $payload): array
    {
        $connModel = new ApiConnection();
        $connection = $connModel->getById((int)$endpoint['connection_id']);

        if ($connection === null) {
            return ['status_code' => 0, 'body' => null, 'duration_ms' => 0, 'error' => 'Verbindung nicht gefunden', 'success' => false];
        }

        $baseUrl = rtrim($connection->base_url, '/');
        $path = '/' . ltrim($endpoint['path'] ?? '', '/');
        $url = $baseUrl . $path;

        // Headers aufbauen
        $headers = [];
        $connHeaders = json_decode($connection->connection_headers ?? $connection->headers ?? '{}', true);
        if (is_array($connHeaders)) {
            $headers = $connHeaders;
        }
        $headers['Content-Type'] = $endpoint['content_type'] ?? 'application/json';

        // Auth Headers
        $headers = $this->addAuthHeaders($headers, $connection);

        $method = $endpoint['method'] ?? 'POST';
        $timeout = (int)($connection->timeout ?? 30);

        // cURL
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => $timeout,
            CURLOPT_CUSTOMREQUEST => $method,
            CURLOPT_HTTPHEADER => $this->formatHeaders($headers),
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_MAXREDIRS => 3,
        ]);

        if (in_array($method, ['POST', 'PUT', 'PATCH'])) {
            $body = ($endpoint['content_type'] ?? '') === 'application/json'
                ? json_encode($payload, JSON_UNESCAPED_UNICODE)
                : http_build_query($payload);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
        }

        $start = microtime(true);
        $responseBody = curl_exec($ch);
        $duration = (int)round((microtime(true) - $start) * 1000);
        $statusCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        return [
            'status_code' => $statusCode,
            'body' => json_decode($responseBody ?: '', true) ?? $responseBody,
            'duration_ms' => $duration,
            'error' => $error,
            'success' => $statusCode >= 200 && $statusCode < 300 && empty($error),
        ];
    }

    private function addAuthHeaders(array $headers, object $connection): array
    {
        $authType = $connection->auth_type ?? 'none';
        $authConfig = json_decode($connection->auth_config ?? '{}', true) ?: [];

        switch ($authType) {
            case 'api_key':
                $keyName = $authConfig['key_name'] ?? 'X-API-Key';
                $keyValue = $authConfig['key_value'] ?? '';
                $headers[$keyName] = $keyValue;
                break;

            case 'bearer':
                $headers['Authorization'] = 'Bearer ' . ($authConfig['token'] ?? '');
                break;

            case 'basic':
                $user = $authConfig['username'] ?? '';
                $pass = $authConfig['password'] ?? '';
                $headers['Authorization'] = 'Basic ' . base64_encode($user . ':' . $pass);
                break;
        }

        return $headers;
    }

    private function formatHeaders(array $headers): array
    {
        $formatted = [];
        foreach ($headers as $key => $value) {
            $formatted[] = $key . ': ' . $value;
        }
        return $formatted;
    }

    private function processResponse(array $endpoint, array $response): array
    {
        $responseMap = json_decode($endpoint['response_map'] ?? '{}', true) ?: [];

        $result = [
            'success' => $response['success'],
            'status_code' => $response['status_code'],
        ];

        // Erfolgs-Bedingung prüfen
        if (!empty($responseMap['success_condition'])) {
            $cond = $responseMap['success_condition'];
            $path = $cond['path'] ?? '';
            $equals = $cond['equals'] ?? '';
            $actual = $this->getNestedValue($response['body'] ?? [], $path);
            $result['success'] = (string)$actual === (string)$equals;
        }

        // Bestätigungstext mit Merge-Tags
        if (!empty($responseMap['confirmation_text'])) {
            $text = $responseMap['confirmation_text'];
            $text = preg_replace_callback('/\{\{response\.([^}]+)\}\}/', function ($m) use ($response) {
                return (string)$this->getNestedValue($response['body'] ?? [], $m[1]);
            }, $text);
            $result['confirmation_text'] = $text;
        }

        return $result;
    }

    private function logRequest(int $endpointId, int $formId, int $entryId, array $request, array $response): void
    {
        try {
            $logModel = new ApiLog();
            $logModel->create([
                'endpoint_id' => $endpointId,
                'form_id' => $formId,
                'entry_id' => $entryId,
                'request' => json_encode($request, JSON_UNESCAPED_UNICODE),
                'response' => json_encode($response['body'] ?? $response, JSON_UNESCAPED_UNICODE),
                'status_code' => $response['status_code'] ?? 0,
                'duration_ms' => $response['duration_ms'] ?? 0,
                'success' => (int)($response['success'] ?? false),
                'error_msg' => $response['error'] ?? null,
            ]);
        } catch (\Throwable $e) {
            Shop::Container()->getLogService()->error(
                'BBF ApiConnector: Log failed: ' . $e->getMessage()
            );
        }
    }

    /**
     * Setzt einen verschachtelten Wert (z.B. "customer.email" → $arr['customer']['email'])
     */
    private function setNestedValue(array &$arr, string $path, mixed $value): void
    {
        $keys = explode('.', $path);
        $ref = &$arr;
        foreach ($keys as $key) {
            if (!isset($ref[$key]) || !is_array($ref[$key])) {
                $ref[$key] = [];
            }
            $ref = &$ref[$key];
        }
        $ref = $value;
    }

    /**
     * Liest einen verschachtelten Wert.
     */
    private function getNestedValue(mixed $data, string $path): mixed
    {
        if (!is_array($data)) return null;
        $keys = explode('.', $path);
        $ref = $data;
        foreach ($keys as $key) {
            if (!is_array($ref) || !array_key_exists($key, $ref)) {
                return null;
            }
            $ref = $ref[$key];
        }
        return $ref;
    }
}
