<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;

class RecaptchaV2Protector implements SpamProtectorInterface
{
    public function getIdentifier(): string { return 'recaptcha_v2'; }
    public function getDisplayName(): string { return 'Google reCAPTCHA v2'; }
    public function requiresExternalScripts(): bool { return true; }
    public function requiresConsent(): bool { return true; }

    public function getScripts(): array
    {
        return [['src' => 'https://www.google.com/recaptcha/api.js', 'defer' => true]];
    }

    public function getConfigFields(): array
    {
        return [Setting::RECAPTCHA_SITE_KEY, Setting::RECAPTCHA_SECRET_KEY];
    }

    public function renderWidget(array $formConfig): string
    {
        $siteKey = PluginHelper::getSetting(Setting::RECAPTCHA_SITE_KEY);
        return '<div class="g-recaptcha" data-sitekey="' . htmlspecialchars($siteKey ?? '') . '"></div>';
    }

    public function validate(array $submissionData): SpamCheckResult
    {
        $response = $submissionData['g-recaptcha-response'] ?? '';
        if (empty($response)) {
            return SpamCheckResult::fail('recaptcha_v2', 'reCAPTCHA not completed', 1.0);
        }

        $secret = PluginHelper::getSetting(Setting::RECAPTCHA_SECRET_KEY);
        $verifyUrl = 'https://www.google.com/recaptcha/api/siteverify';

        $result = file_get_contents($verifyUrl . '?' . http_build_query([
            'secret'   => $secret,
            'response' => $response,
            'remoteip' => $_SERVER['REMOTE_ADDR'] ?? '',
        ]));

        $data = json_decode($result, true);
        if (empty($data['success'])) {
            return SpamCheckResult::fail('recaptcha_v2', 'reCAPTCHA verification failed', 1.0);
        }

        return SpamCheckResult::pass('recaptcha_v2');
    }
}
