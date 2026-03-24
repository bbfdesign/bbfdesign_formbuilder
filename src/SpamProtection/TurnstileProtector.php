<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;

class TurnstileProtector implements SpamProtectorInterface
{
    public function getIdentifier(): string { return 'turnstile'; }
    public function getDisplayName(): string { return 'Cloudflare Turnstile'; }
    public function requiresExternalScripts(): bool { return true; }
    public function requiresConsent(): bool { return true; }

    public function getScripts(): array
    {
        return [['src' => 'https://challenges.cloudflare.com/turnstile/v0/api.js', 'defer' => true]];
    }

    public function getConfigFields(): array
    {
        return [Setting::TURNSTILE_SITE_KEY, Setting::TURNSTILE_SECRET_KEY];
    }

    public function renderWidget(array $formConfig): string
    {
        $siteKey = PluginHelper::getSetting(Setting::TURNSTILE_SITE_KEY);
        return '<div class="cf-turnstile" data-sitekey="' . htmlspecialchars($siteKey ?? '') . '"></div>';
    }

    public function validate(array $submissionData): SpamCheckResult
    {
        $response = $submissionData['cf-turnstile-response'] ?? '';
        if (empty($response)) {
            return SpamCheckResult::fail('turnstile', 'Turnstile not completed', 1.0);
        }

        $secret = PluginHelper::getSetting(Setting::TURNSTILE_SECRET_KEY);
        $result = file_get_contents('https://challenges.cloudflare.com/turnstile/v0/siteverify', false, stream_context_create([
            'http' => [
                'method'  => 'POST',
                'header'  => 'Content-Type: application/x-www-form-urlencoded',
                'content' => http_build_query(['secret' => $secret, 'response' => $response]),
            ],
        ]));

        $data = json_decode($result, true);
        if (empty($data['success'])) {
            return SpamCheckResult::fail('turnstile', 'Turnstile verification failed', 1.0);
        }

        return SpamCheckResult::pass('turnstile');
    }
}
