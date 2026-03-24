<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Models\Form;
use BbfdesignFormbuilder\Models\FormEntry;
use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;

class EntryService
{
    private FormEntry $entryModel;

    public function __construct()
    {
        $this->entryModel = new FormEntry();
    }

    /**
     * Save a form submission.
     */
    public function saveSubmission(int $formId, array $values, array $meta = []): int
    {
        $ipAddress = $this->getClientIp();

        // IP anonymization
        $ipAnon = PluginHelper::getSetting(Setting::IP_ANONYMIZATION);
        if ($ipAnon === 'last_octet') {
            $ipAddress = $this->anonymizeIpLastOctet($ipAddress);
        } elseif ($ipAnon === 'hash') {
            $ipAddress = hash('sha256', $ipAddress);
        }

        $valuesJson = json_encode($values, JSON_UNESCAPED_UNICODE);

        // Optional encryption
        if (PluginHelper::getSetting(Setting::ENCRYPTION_ENABLED) === '1') {
            $encryptionService = new \BbfdesignFormbuilder\Services\EncryptionService();
            $valuesJson = $encryptionService->encrypt($valuesJson);
            $isEncrypted = 1;
        } else {
            $isEncrypted = 0;
        }

        return $this->entryModel->create([
            'form_id'      => $formId,
            'values_json'  => $valuesJson,
            'is_encrypted' => $isEncrypted,
            'ip_address'   => $ipAddress,
            'user_agent'   => mb_substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 500),
            'referrer_url' => mb_substr($_SERVER['HTTP_REFERER'] ?? '', 0, 500),
            'page_url'     => mb_substr($meta['page_url'] ?? '', 0, 500),
            'customer_id'  => $meta['customer_id'] ?? null,
            'lang_iso'     => $meta['lang_iso'] ?? null,
            'status'       => 'unread',
        ]);
    }

    /**
     * Get decrypted entry values.
     */
    public function getDecryptedValues(object $entry): array
    {
        $json = $entry->values_json;

        if ((int)$entry->is_encrypted === 1) {
            $encryptionService = new EncryptionService();
            $json = $encryptionService->decrypt($json);
        }

        return json_decode($json, true) ?? [];
    }

    /**
     * Export entries as CSV.
     */
    public function exportCsv(int $formId): string
    {
        $formModel = new Form();
        $form = $formModel->getById($formId);
        if ($form === null) {
            throw new \RuntimeException('Formular nicht gefunden.');
        }

        $fields = json_decode($form->fields_json, true) ?? [];
        $entries = $this->entryModel->getAll(['form_id' => $formId], 10000, 0);

        $output = fopen('php://temp', 'r+');

        // Header row
        $headers = ['ID', 'Datum'];
        foreach ($fields as $field) {
            if (!in_array($field['type'], ['section_break', 'page_break', 'html_block', 'captcha'], true)) {
                $headers[] = $field['label'];
            }
        }
        $headers[] = 'IP';
        $headers[] = 'Status';
        fputcsv($output, $headers, ';');

        // Data rows
        foreach ($entries as $entry) {
            $entryObj = (object)$entry;
            $values = $this->getDecryptedValues($entryObj);

            $row = [$entry['id'], $entry['created_at']];
            foreach ($fields as $field) {
                if (!in_array($field['type'], ['section_break', 'page_break', 'html_block', 'captcha'], true)) {
                    $val = $values[$field['id']] ?? '';
                    if (is_array($val)) {
                        $val = implode(', ', $val);
                    }
                    $row[] = $val;
                }
            }
            $row[] = $entry['ip_address'] ?? '';
            $row[] = $entry['status'] ?? '';
            fputcsv($output, $row, ';');
        }

        rewind($output);
        $csv = stream_get_contents($output);
        fclose($output);

        return $csv;
    }

    private function getClientIp(): string
    {
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['HTTP_CLIENT_IP'] ?? $_SERVER['REMOTE_ADDR'] ?? '';
        if (strpos($ip, ',') !== false) {
            $ip = trim(explode(',', $ip)[0]);
        }
        return $ip;
    }

    private function anonymizeIpLastOctet(string $ip): string
    {
        if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
            return preg_replace('/\.\d+$/', '.0', $ip);
        }
        if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)) {
            return preg_replace('/:[^:]+$/', ':0', $ip);
        }
        return $ip;
    }
}
