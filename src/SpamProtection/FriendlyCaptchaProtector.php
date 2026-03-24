<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;

class FriendlyCaptchaProtector implements SpamProtectorInterface
{
    public function getIdentifier(): string { return 'friendly_captcha'; }
    public function getDisplayName(): string { return 'Friendly Captcha (EU/DSGVO)'; }
    public function requiresExternalScripts(): bool { return true; }
    public function requiresConsent(): bool { return false; }

    public function getScripts(): array
    {
        return [['src' => 'https://cdn.friendlycaptcha.com/sdk/v2/friendly-challenge.min.js', 'defer' => true]];
    }

    public function getConfigFields(): array
    {
        return [Setting::FRIENDLY_CAPTCHA_SITE_KEY, Setting::FRIENDLY_CAPTCHA_SECRET];
    }

    public function renderWidget(array $formConfig): string
    {
        $siteKey = PluginHelper::getSetting(Setting::FRIENDLY_CAPTCHA_SITE_KEY);
        return '<div class="frc-captcha" data-sitekey="' . htmlspecialchars($siteKey ?? '') . '"></div>';
    }

    public function validate(array $submissionData): SpamCheckResult
    {
        $solution = $submissionData['frc-captcha-solution'] ?? '';
        if (empty($solution)) {
            return SpamCheckResult::fail('friendly_captcha', 'Friendly Captcha not completed', 1.0);
        }

        $secret = PluginHelper::getSetting(Setting::FRIENDLY_CAPTCHA_SECRET);
        $result = file_get_contents('https://api.friendlycaptcha.com/api/v1/siteverify', false, stream_context_create([
            'http' => [
                'method'  => 'POST',
                'header'  => 'Content-Type: application/json',
                'content' => json_encode(['solution' => $solution, 'secret' => $secret]),
            ],
        ]));

        $data = json_decode($result, true);
        if (empty($data['success'])) {
            return SpamCheckResult::fail('friendly_captcha', 'Verification failed', 1.0);
        }

        return SpamCheckResult::pass('friendly_captcha');
    }
}
