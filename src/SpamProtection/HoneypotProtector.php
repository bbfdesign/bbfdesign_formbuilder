<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

class HoneypotProtector implements SpamProtectorInterface
{
    public const FIELD_NAME = 'bbf_hp_field';

    public function getIdentifier(): string { return 'honeypot'; }
    public function getDisplayName(): string { return 'Honeypot'; }
    public function requiresExternalScripts(): bool { return false; }
    public function requiresConsent(): bool { return false; }
    public function getScripts(): array { return []; }
    public function getConfigFields(): array { return []; }

    public function renderWidget(array $formConfig): string
    {
        return '<div style="position:absolute;left:-9999px;top:-9999px;" aria-hidden="true">'
            . '<input type="text" name="' . self::FIELD_NAME . '" value="" tabindex="-1" autocomplete="off">'
            . '</div>';
    }

    public function validate(array $submissionData): SpamCheckResult
    {
        if (!empty($submissionData[self::FIELD_NAME])) {
            return SpamCheckResult::fail('honeypot', 'Honeypot field was filled', 1.0);
        }
        return SpamCheckResult::pass('honeypot');
    }
}
