<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;

class RecaptchaV3Protector implements SpamProtectorInterface
{
    public function getIdentifier(): string { return 'recaptcha_v3'; }
    public function getDisplayName(): string { return 'Google reCAPTCHA v3'; }
    public function requiresExternalScripts(): bool { return true; }
    public function requiresConsent(): bool { return true; }

    public function getScripts(): array
    {
        $siteKey = PluginHelper::getSetting(Setting::RECAPTCHA_SITE_KEY);
        return [['src' => 'https://www.google.com/recaptcha/api.js?render=' . $siteKey, 'defer' => true]];
    }

    public function getConfigFields(): array
    {
        return [Setting::RECAPTCHA_SITE_KEY, Setting::RECAPTCHA_SECRET_KEY];
    }

    public function renderWidget(array $formConfig): string
    {
        return '<input type="hidden" name="g-recaptcha-response" id="bbf-recaptcha-token">';
    }

    public function validate(array $submissionData): SpamCheckResult
    {
        $response = $submissionData['g-recaptcha-response'] ?? '';
        if (empty($response)) {
            return SpamCheckResult::fail('recaptcha_v3', 'reCAPTCHA token missing', 1.0);
        }

        $secret = PluginHelper::getSetting(Setting::RECAPTCHA_SECRET_KEY);
        $result = file_get_contents('https://www.google.com/recaptcha/api/siteverify?' . http_build_query([
            'secret'   => $secret,
            'response' => $response,
        ]));

        $data = json_decode($result, true);
        if (empty($data['success']) || ($data['score'] ?? 0) < 0.5) {
            return SpamCheckResult::fail('recaptcha_v3', 'Score too low: ' . ($data['score'] ?? 0), $data['score'] ?? 1.0);
        }

        return SpamCheckResult::pass('recaptcha_v3');
    }
}
