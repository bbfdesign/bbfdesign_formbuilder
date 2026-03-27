<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Controllers\Frontend;

use BbfdesignFormbuilder\Services\AccountIntegrationService;
use JTL\Session\Frontend;

/**
 * API-Controller fuer Kundenkonto-Formular-Integration.
 *
 * Endpunkte:
 *   GET  /api/bbf-forms/account/forms              → Liste
 *   GET  /api/bbf-forms/account/forms/{id}/html     → Formular rendern
 *   POST /api/bbf-forms/account/forms/{id}/submit   → Formular absenden
 *
 * Sicherheit: Nur eingeloggte Kunden haben Zugriff.
 */
class FormAccountController
{
    private AccountIntegrationService $service;

    public function __construct()
    {
        $this->service = new AccountIntegrationService();
    }

    /**
     * GET /api/bbf-forms/account/forms
     * Liste aller im Kundenkonto verfuegbaren Formulare.
     */
    public function list(): void
    {
        $this->requireAuth();
        $this->jsonResponse($this->service->getAccountForms());
    }

    /**
     * GET /api/bbf-forms/account/forms/{id}/html
     * Rendert ein Formular als HTML mit vorausgefuellten Kundendaten.
     */
    public function html(int $formId): void
    {
        $customer = $this->requireAuth();

        $customerData = [
            'email' => $customer->cMail ?? '',
            'first_name' => $customer->cVorname ?? '',
            'last_name' => $customer->cNachname ?? '',
            'phone' => $customer->cTel ?? '',
        ];

        $result = $this->service->renderFormHtml($formId, $customerData);
        $this->jsonResponse($result);
    }

    /**
     * POST /api/bbf-forms/account/forms/{id}/submit
     * Formular absenden.
     */
    public function submit(int $formId): void
    {
        $customer = $this->requireAuth();

        // JSON-Body lesen
        $rawBody = file_get_contents('php://input');
        $data = json_decode($rawBody, true);

        if (!is_array($data)) {
            $this->jsonResponse(
                ['success' => false, 'errors' => ['_form' => 'Ungültige Anfrage.']],
                400
            );
            return; // unreachable after exit, but for clarity
        }

        $customerId = (int)$customer->kKunde;
        $ipAddress = $_SERVER['REMOTE_ADDR'] ?? '';

        // IP anonymisieren (letztes Oktett)
        if (str_contains($ipAddress, '.')) {
            $parts = explode('.', $ipAddress);
            $parts[count($parts) - 1] = '0';
            $ipAddress = implode('.', $parts);
        }

        $result = $this->service->submitForm($formId, $data, $customerId, $ipAddress);
        $statusCode = $result['success'] ? 200 : 422;
        $this->jsonResponse($result, $statusCode);
    }

    /**
     * Prueft ob ein Kunde eingeloggt ist. Gibt 401 zurueck wenn nicht.
     */
    private function requireAuth(): object
    {
        $customer = Frontend::getCustomer();
        if ($customer === null || (int)$customer->kKunde <= 0) {
            $this->jsonResponse(['error' => 'Nicht eingeloggt.'], 401);
            exit; // redundant, jsonResponse exits — but defensive
        }
        return $customer;
    }

    /**
     * JSON-Response senden und Exit.
     */
    private function jsonResponse(mixed $data, int $statusCode = 200): void
    {
        http_response_code($statusCode);
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: private, no-cache');
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        exit;
    }
}
