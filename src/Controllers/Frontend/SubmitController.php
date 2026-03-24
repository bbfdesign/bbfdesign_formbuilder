<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Controllers\Frontend;

use BbfdesignFormbuilder\Helpers\SanitizerHelper;
use BbfdesignFormbuilder\Models\Form;
use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;
use BbfdesignFormbuilder\Services\CaptchaService;
use BbfdesignFormbuilder\Services\ConditionalLogicService;
use BbfdesignFormbuilder\Services\EntryService;
use BbfdesignFormbuilder\Services\FileUploadService;
use BbfdesignFormbuilder\Services\NotificationService;
use BbfdesignFormbuilder\Services\ValidationService;
use BbfdesignFormbuilder\SpamProtection\HoneypotProtector;
use BbfdesignFormbuilder\SpamProtection\RateLimitProtector;
use BbfdesignFormbuilder\SpamProtection\SpamProtectorRegistry;
use BbfdesignFormbuilder\SpamProtection\TimingProtector;
use BbfdesignFormbuilder\Services\SpamProtectionService;
use JTL\Shop;

class SubmitController
{
    /**
     * Handle form submission via AJAX POST.
     */
    public function handle(): void
    {
        header('Content-Type: application/json; charset=utf-8');

        try {
            $result = $this->processSubmission();
            echo json_encode($result, JSON_UNESCAPED_UNICODE);
        } catch (\Exception $e) {
            echo json_encode([
                'success' => false,
                'errors'  => ['_form' => 'Ein Fehler ist aufgetreten: ' . $e->getMessage()],
            ], JSON_UNESCAPED_UNICODE);
        }

        exit;
    }

    private function processSubmission(): array
    {
        $formId = (int)($_POST['form_id'] ?? 0);
        if ($formId <= 0) {
            return ['success' => false, 'errors' => ['_form' => 'Ungültige Formular-ID.']];
        }

        // CSRF token validation
        $csrfToken = $_POST['bbf_csrf_token'] ?? '';
        $sessionToken = $_SESSION['bbf_form_token_' . $formId] ?? '';
        if (empty($csrfToken) || !hash_equals($sessionToken, $csrfToken)) {
            return ['success' => false, 'errors' => ['_form' => 'Ungültiges Sicherheitstoken. Bitte laden Sie die Seite neu.']];
        }

        // Load form
        $formModel = new Form();
        $form = $formModel->getById($formId);
        if ($form === null || $form->status !== 'active') {
            return ['success' => false, 'errors' => ['_form' => 'Formular nicht gefunden oder inaktiv.']];
        }

        $fields = json_decode($form->fields_json, true) ?? [];

        // Spam protection
        $spamResult = $this->runSpamProtection($formId);
        if ($spamResult !== null) {
            return ['success' => false, 'errors' => ['_form' => 'Ihre Nachricht wurde als Spam erkannt.']];
        }

        // CAPTCHA validation
        $captchaService = new CaptchaService();
        $captchaResult = $captchaService->validate($_POST);
        if ($captchaResult !== null && $captchaResult->isSpam) {
            return ['success' => false, 'errors' => ['_form' => 'CAPTCHA-Überprüfung fehlgeschlagen.']];
        }

        // Determine visible fields (conditional logic)
        $condService = new ConditionalLogicService();
        $visibleFieldIds = $condService->getVisibleFieldIds($fields, $_POST);

        // Collect and sanitize values
        $rawValues = [];
        foreach ($fields as $field) {
            $fieldId = $field['id'];
            if (!in_array($fieldId, $visibleFieldIds, true)) {
                continue;
            }
            if (in_array($field['type'], ['section_break', 'page_break', 'html_block', 'captcha'], true)) {
                continue;
            }
            if (isset($_POST[$fieldId])) {
                $rawValues[$fieldId] = $_POST[$fieldId];
            } elseif (isset($_POST[$fieldId . '[]'])) {
                $rawValues[$fieldId] = $_POST[$fieldId . '[]'];
            } else {
                $rawValues[$fieldId] = '';
            }
        }

        $sanitizedValues = SanitizerHelper::sanitizeAll($rawValues, $fields);

        // Server-side validation
        $validationService = new ValidationService();
        $errors = $validationService->validate($fields, $sanitizedValues, $visibleFieldIds);
        if (!empty($errors)) {
            return ['success' => false, 'errors' => $errors];
        }

        // Save entry
        $entryService = new EntryService();
        $langIso = Shop::getLanguageCode() ?? 'ger';
        $entryId = $entryService->saveSubmission($formId, $sanitizedValues, [
            'page_url'    => $_POST['_page_url'] ?? ($_SERVER['HTTP_REFERER'] ?? ''),
            'customer_id' => $_SESSION['Kunde']->kKunde ?? null,
            'lang_iso'    => $langIso,
        ]);

        // Handle file uploads
        if (!empty($_FILES)) {
            $fileService = new FileUploadService();
            try {
                $fileService->handleUploads($entryId, $fields, $_FILES);
            } catch (\Exception $e) {
                // Log but don't fail the submission
                Shop::Container()->getLogService()->error(
                    'BBF Formbuilder: File upload error: ' . $e->getMessage()
                );
            }
        }

        // Send notifications
        $notificationService = new NotificationService();
        try {
            $notificationService->sendNotifications($formId, $sanitizedValues, $entryId, $fields);
        } catch (\Exception $e) {
            Shop::Container()->getLogService()->error(
                'BBF Formbuilder: Notification error: ' . $e->getMessage()
            );
        }

        // Regenerate CSRF token for next submission
        $newToken = bin2hex(random_bytes(32));
        $_SESSION['bbf_form_token_' . $formId] = $newToken;

        // Get confirmation message
        $confirmationMessage = $this->getConfirmationMessage($formId, $sanitizedValues);

        return [
            'success'   => true,
            'message'   => $confirmationMessage,
            'entry_id'  => $entryId,
            'new_token' => $newToken,
        ];
    }

    /**
     * Run internal spam protectors (honeypot, timing, rate limit).
     */
    private function runSpamProtection(int $formId): ?\BbfdesignFormbuilder\SpamProtection\SpamCheckResult
    {
        $registry = new SpamProtectorRegistry();

        $activeProtectors = [];

        if (PluginHelper::getSetting(Setting::HONEYPOT_ENABLED) === '1') {
            $registry->register(new HoneypotProtector());
            $activeProtectors[] = 'honeypot';
        }

        if (PluginHelper::getSetting(Setting::TIMING_ENABLED) === '1') {
            $minSeconds = (int)(PluginHelper::getSetting(Setting::TIMING_MIN_SECONDS) ?: 3);
            $registry->register(new TimingProtector($minSeconds));
            $activeProtectors[] = 'timing';
        }

        if (PluginHelper::getSetting(Setting::RATE_LIMIT_ENABLED) === '1') {
            $max = (int)(PluginHelper::getSetting(Setting::RATE_LIMIT_MAX) ?: 10);
            $window = (int)(PluginHelper::getSetting(Setting::RATE_LIMIT_WINDOW) ?: 3600);
            $registry->register(new RateLimitProtector($max, $window));
            $activeProtectors[] = 'rate_limit';
        }

        $registry->setActive($activeProtectors);

        $spamService = new SpamProtectionService($registry);
        $_POST['_form_id'] = $formId;

        return $spamService->check($_POST, $formId);
    }

    /**
     * Get the confirmation message for a form.
     */
    private function getConfirmationMessage(int $formId, array $values): string
    {
        $db = Shop::Container()->getDB();
        $confirmations = $db->queryPrepared(
            'SELECT * FROM bbf_formbuilder_confirmations WHERE form_id = :fid ORDER BY sort_order ASC',
            ['fid' => $formId]
        );

        if (empty($confirmations)) {
            return 'Vielen Dank! Ihre Nachricht wurde erfolgreich gesendet.';
        }

        // Find first matching confirmation (check conditional logic)
        $condService = new ConditionalLogicService();
        foreach ($confirmations as $conf) {
            if (!empty($conf['conditional_logic_json'])) {
                $logic = json_decode($conf['conditional_logic_json'], true);
                if (!empty($logic) && !$condService->evaluate($logic, $values)) {
                    continue;
                }
            }
            return $conf['message'] ?? 'Vielen Dank!';
        }

        return 'Vielen Dank! Ihre Nachricht wurde erfolgreich gesendet.';
    }
}
