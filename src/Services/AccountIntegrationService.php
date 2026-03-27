<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Models\Form;
use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;
use JTL\Plugin\Helper;
use JTL\Shop;

/**
 * Schnittstelle zwischen Formbuilder und Kundenkonto-Plugin.
 *
 * Bietet drei Methoden: auflisten, rendern, absenden.
 * Wird vom Kundenkonto-Plugin per direktem Aufruf (Admin/DB)
 * oder per REST-API (Frontend) genutzt.
 *
 * Sicherheit: Alle Ausgaben escaped, nur Prepared Statements.
 */
class AccountIntegrationService
{
    private Form $formModel;
    private $db;

    public function __construct()
    {
        $this->formModel = new Form();
        $this->db = Shop::Container()->getDB();
    }

    /**
     * Gibt alle aktiven Formulare zurueck die im Kundenkonto verfuegbar sind.
     *
     * Wird vom Kundenkonto-Plugin im Admin per DB-Query aufgerufen.
     *
     * @return array<int, array{id: int, title: string, slug: string, description: string}>
     */
    public function getAccountForms(): array
    {
        try {
            $rows = $this->db->queryPrepared(
                'SELECT id, title, slug, description
                 FROM `' . Form::TABLE . '`
                 WHERE status = :status AND allow_in_account = 1
                 ORDER BY title ASC',
                ['status' => 'active']
            );

            if (!is_array($rows)) {
                return [];
            }

            $forms = [];
            foreach ($rows as $row) {
                $row = (array)$row;
                $forms[] = [
                    'id' => (int)$row['id'],
                    'title' => $row['title'] ?? '',
                    'slug' => $row['slug'] ?? '',
                    'description' => $row['description'] ?? '',
                ];
            }

            return $forms;
        } catch (\Throwable $e) {
            return [];
        }
    }

    /**
     * Rendert ein Formular als HTML-String mit vorausgefuellten Kundendaten.
     *
     * SICHERHEIT: Alle Ausgaben werden escaped.
     * Nutzt den bestehenden FormRenderService intern.
     *
     * @param int   $formId       Formular-ID
     * @param array $customerData Kundendaten zum Vorausfuellen
     *                            ['email' => '', 'first_name' => '', 'last_name' => '', 'phone' => '']
     * @return array{success: bool, html?: string, error?: string}
     */
    public function renderFormHtml(int $formId, array $customerData = []): array
    {
        $form = $this->formModel->getById($formId);

        if ($form === null) {
            return ['success' => false, 'error' => 'Formular nicht gefunden.'];
        }

        if ($form->status !== 'active') {
            return ['success' => false, 'error' => 'Formular ist nicht aktiv.'];
        }

        if (empty($form->allow_in_account)) {
            return ['success' => false, 'error' => 'Formular ist nicht für das Kundenkonto freigegeben.'];
        }

        // Felder laden und Kundendaten vorausfuellen
        $fields = json_decode($form->fields_json, true) ?? [];
        $prefillMap = $this->buildPrefillMap($customerData);

        foreach ($fields as &$field) {
            $type = $field['type'] ?? '';
            if (isset($prefillMap[$type]) && empty($field['default_value'])) {
                $field['default_value'] = $prefillMap[$type];
            }
        }
        unset($field);

        // Formular mit vorausgefuellten Feldern temporaer ueberschreiben
        $originalFieldsJson = $form->fields_json;
        $form->fields_json = json_encode($fields);

        try {
            $renderService = new FormRenderService();
            $html = $renderService->renderById($formId, [
                'ajax' => true,
                'class' => 'bbf-account-form',
            ]);

            // Felder zuruecksetzen (defensive)
            $form->fields_json = $originalFieldsJson;

            return ['success' => true, 'html' => $html];
        } catch (\Throwable $e) {
            return ['success' => false, 'error' => 'Render-Fehler: ' . $e->getMessage()];
        }
    }

    /**
     * Nimmt Formular-Daten entgegen, validiert und speichert sie.
     *
     * Prueft Rate-Limiting (max 10/Stunde/Kunde).
     *
     * @param int    $formId     Formular-ID
     * @param array  $data       Formulardaten (Key-Value)
     * @param int    $customerId Kunden-ID
     * @param string $ipAddress  IP-Adresse
     * @return array{success: bool, message?: string, entry_id?: int, errors?: array}
     */
    public function submitForm(int $formId, array $data, int $customerId, string $ipAddress = ''): array
    {
        // Formular laden
        $form = $this->formModel->getById($formId);
        if ($form === null || $form->status !== 'active') {
            return ['success' => false, 'errors' => ['_form' => 'Formular nicht gefunden oder inaktiv.']];
        }

        if (empty($form->allow_in_account)) {
            return ['success' => false, 'errors' => ['_form' => 'Formular ist nicht für das Kundenkonto freigegeben.']];
        }

        // Rate-Limiting: max 10 Submissions/Stunde/Kunde
        if (!$this->checkRateLimit($customerId)) {
            return ['success' => false, 'errors' => ['_form' => 'Zu viele Anfragen. Bitte versuchen Sie es später erneut.']];
        }

        $fields = json_decode($form->fields_json, true) ?? [];

        // Validierung: Required-Felder pruefen
        $errors = $this->validateSubmission($fields, $data);
        if (!empty($errors)) {
            return ['success' => false, 'errors' => $errors];
        }

        // Daten sanitizen
        $sanitizedData = $this->sanitizeData($data, $fields);

        // In Entries-Tabelle speichern (bestehende Tabelle)
        try {
            $entryService = new EntryService();
            $entryId = $entryService->saveSubmission($formId, $sanitizedData, [
                'customer_id' => $customerId,
                'page_url' => $_SERVER['HTTP_REFERER'] ?? '/kundenkonto',
                'ip_address' => $ipAddress,
                'lang_iso' => Shop::getLanguageCode() ?? 'ger',
            ]);
        } catch (\Throwable $e) {
            return ['success' => false, 'errors' => ['_form' => 'Speichern fehlgeschlagen.']];
        }

        // Benachrichtigungen senden
        try {
            $notificationService = new NotificationService();
            $notificationService->sendNotifications($formId, $sanitizedData, $entryId, $fields);
        } catch (\Throwable $e) {
            // Notification-Fehler loggen, aber Submission nicht fehlschlagen lassen
            Shop::Container()->getLogService()->error(
                'BBF Formbuilder: Account submission notification error: ' . $e->getMessage()
            );
        }

        // Bestaetigungsnachricht
        $message = $this->getConfirmationMessage($formId);

        return [
            'success' => true,
            'message' => $message,
            'entry_id' => $entryId,
        ];
    }

    /**
     * Baut die Prefill-Map anhand der Kundendaten.
     */
    private function buildPrefillMap(array $customerData): array
    {
        $map = [];
        if (!empty($customerData['email'])) {
            $map['email'] = $customerData['email'];
        }
        if (!empty($customerData['first_name']) || !empty($customerData['last_name'])) {
            $map['name'] = trim(($customerData['first_name'] ?? '') . ' ' . ($customerData['last_name'] ?? ''));
        }
        if (!empty($customerData['phone'])) {
            $map['phone'] = $customerData['phone'];
        }
        return $map;
    }

    /**
     * Rate-Limit pruefen: max 10 Submissions/Stunde/Kunde.
     */
    private function checkRateLimit(int $customerId): bool
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT COUNT(*) AS cnt FROM bbf_formbuilder_entries
                 WHERE customer_id = :cid AND created_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)',
                ['cid' => $customerId]
            );

            $count = 0;
            if (is_array($result) && !empty($result)) {
                $count = (int)($result[0]['cnt'] ?? $result[0]->cnt ?? 0);
            } elseif (is_object($result)) {
                $count = (int)($result->cnt ?? 0);
            }

            return $count < 10;
        } catch (\Throwable $e) {
            // Im Fehlerfall Limit nicht enforzen
            return true;
        }
    }

    /**
     * Pflichtfelder validieren.
     */
    private function validateSubmission(array $fields, array $data): array
    {
        $errors = [];

        foreach ($fields as $field) {
            $id = $field['id'] ?? '';
            $type = $field['type'] ?? '';

            // Nicht-sichtbare Felder ueberspringen
            if (in_array($type, ['section_break', 'page_break', 'html_block', 'captcha'], true)) {
                continue;
            }

            $required = !empty($field['required']);
            $value = $data[$id] ?? '';

            if ($required && (is_string($value) ? trim($value) === '' : empty($value))) {
                $label = $field['label'] ?? $id;
                $errors[$id] = htmlspecialchars($label) . ' ist ein Pflichtfeld.';
            }

            // Laengenlimit
            if (is_string($value) && mb_strlen($value) > 10000) {
                $errors[$id] = 'Eingabe ist zu lang (max. 10.000 Zeichen).';
            }
        }

        return $errors;
    }

    /**
     * Daten sanitizen: strip_tags, trim, Laengenlimit.
     */
    private function sanitizeData(array $data, array $fields): array
    {
        $sanitized = [];
        $fieldMap = [];
        foreach ($fields as $field) {
            $fieldMap[$field['id'] ?? ''] = $field;
        }

        foreach ($data as $key => $value) {
            // Nur bekannte Felder akzeptieren
            if (!isset($fieldMap[$key])) {
                continue;
            }

            if (is_array($value)) {
                $sanitized[$key] = array_map(function ($v) {
                    return mb_substr(strip_tags(trim((string)$v)), 0, 10000);
                }, $value);
            } else {
                $type = $fieldMap[$key]['type'] ?? '';
                $value = trim((string)$value);

                // HTML-Block Felder nicht strippen
                if ($type !== 'html_block') {
                    $value = strip_tags($value);
                }

                $sanitized[$key] = mb_substr($value, 0, 10000);
            }
        }

        return $sanitized;
    }

    /**
     * Bestaetigungsnachricht fuer ein Formular laden.
     */
    private function getConfirmationMessage(int $formId): string
    {
        try {
            $result = $this->db->queryPrepared(
                "SELECT message FROM bbf_formbuilder_confirmations
                 WHERE form_id = :fid AND type = 'message' AND is_default = 1
                 ORDER BY sort_order ASC LIMIT 1",
                ['fid' => $formId]
            );

            if (is_array($result) && !empty($result)) {
                return $result[0]['message'] ?? 'Vielen Dank!';
            }
        } catch (\Throwable $e) {
            // Fallback
        }

        return 'Vielen Dank! Ihre Nachricht wurde erfolgreich gesendet.';
    }
}
