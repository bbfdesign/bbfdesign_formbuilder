<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;

class AltchaProtector implements SpamProtectorInterface
{
    public function getIdentifier(): string { return 'altcha'; }
    public function getDisplayName(): string { return 'ALTCHA (Proof-of-Work)'; }
    public function requiresExternalScripts(): bool { return false; }
    public function requiresConsent(): bool { return false; }

    public function getScripts(): array
    {
        return [];
    }

    public function getConfigFields(): array
    {
        return [];
    }

    public function renderWidget(array $formConfig): string
    {
        return '<altcha-widget challengeurl="' . htmlspecialchars($formConfig['challenge_url'] ?? '') . '"></altcha-widget>';
    }

    /**
     * Generate a HMAC-based challenge for the ALTCHA widget.
     */
    public function generateChallenge(): array
    {
        $secret = $this->getHmacKey();
        $salt = bin2hex(random_bytes(12));
        $number = random_int(10000, 100000);
        $challenge = hash('sha256', $salt . $number);
        $signature = hash_hmac('sha256', $challenge, $secret);

        return [
            'algorithm' => 'SHA-256',
            'challenge' => $challenge,
            'salt'      => $salt,
            'maxnumber' => 1000000,
            'signature' => $signature,
        ];
    }

    public function validate(array $submissionData): SpamCheckResult
    {
        $altchaPayload = $submissionData['altcha'] ?? '';
        if (empty($altchaPayload)) {
            return SpamCheckResult::fail('altcha', 'ALTCHA response missing', 1.0);
        }

        $decoded = json_decode(base64_decode($altchaPayload), true);
        if (empty($decoded) || !isset($decoded['algorithm'], $decoded['challenge'], $decoded['number'], $decoded['salt'], $decoded['signature'])) {
            return SpamCheckResult::fail('altcha', 'Invalid ALTCHA payload', 1.0);
        }

        $secret = $this->getHmacKey();
        $expectedChallenge = hash('sha256', $decoded['salt'] . $decoded['number']);
        $expectedSignature = hash_hmac('sha256', $expectedChallenge, $secret);

        if (!hash_equals($expectedChallenge, $decoded['challenge'])) {
            return SpamCheckResult::fail('altcha', 'Challenge mismatch', 1.0);
        }
        if (!hash_equals($expectedSignature, $decoded['signature'])) {
            return SpamCheckResult::fail('altcha', 'Signature mismatch', 1.0);
        }

        return SpamCheckResult::pass('altcha');
    }

    private function getHmacKey(): string
    {
        $key = PluginHelper::getSetting(Setting::ALTCHA_HMAC_KEY);
        if (empty($key)) {
            $key = bin2hex(random_bytes(32));
            $settingModel = new Setting();
            $settingModel->set(Setting::ALTCHA_HMAC_KEY, $key);
        }
        return $key;
    }
}
