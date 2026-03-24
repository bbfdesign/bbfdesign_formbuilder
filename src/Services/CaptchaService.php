<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;
use BbfdesignFormbuilder\SpamProtection\AltchaProtector;
use BbfdesignFormbuilder\SpamProtection\FriendlyCaptchaProtector;
use BbfdesignFormbuilder\SpamProtection\RecaptchaV2Protector;
use BbfdesignFormbuilder\SpamProtection\RecaptchaV3Protector;
use BbfdesignFormbuilder\SpamProtection\SpamCheckResult;
use BbfdesignFormbuilder\SpamProtection\SpamProtectorInterface;
use BbfdesignFormbuilder\SpamProtection\TurnstileProtector;

class CaptchaService
{
    /**
     * Get the currently configured CAPTCHA protector.
     */
    public function getActiveProtector(): ?SpamProtectorInterface
    {
        $provider = PluginHelper::getSetting(Setting::CAPTCHA_PROVIDER);

        switch ($provider) {
            case 'altcha':
                return new AltchaProtector();
            case 'recaptcha_v2':
                return new RecaptchaV2Protector();
            case 'recaptcha_v3':
                return new RecaptchaV3Protector();
            case 'turnstile':
                return new TurnstileProtector();
            case 'friendly_captcha':
                return new FriendlyCaptchaProtector();
            case 'none':
            default:
                return null;
        }
    }

    /**
     * Render the CAPTCHA widget HTML.
     */
    public function renderWidget(array $formConfig = []): string
    {
        $protector = $this->getActiveProtector();
        if ($protector === null) {
            return '';
        }

        return $protector->renderWidget($formConfig);
    }

    /**
     * Validate the CAPTCHA response.
     */
    public function validate(array $submissionData): ?SpamCheckResult
    {
        $protector = $this->getActiveProtector();
        if ($protector === null) {
            return null;
        }

        return $protector->validate($submissionData);
    }

    /**
     * Check if the active CAPTCHA requires consent.
     */
    public function requiresConsent(): bool
    {
        $protector = $this->getActiveProtector();
        return $protector !== null && $protector->requiresConsent();
    }
}
