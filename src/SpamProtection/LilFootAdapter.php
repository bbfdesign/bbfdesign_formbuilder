<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

/**
 * Adapter for LilFOOT SpamProtector compatibility.
 * LilFOOT uses its own hooks (HOOK_KONTAKTFORMULAR_PLAUSICHECKS).
 * This adapter ensures our forms don't conflict with LilFOOT's botfallen.
 */
class LilFootAdapter implements SpamProtectorInterface
{
    public function getIdentifier(): string { return 'lilfoot'; }
    public function getDisplayName(): string { return 'LilFOOT SpamProtector'; }
    public function requiresExternalScripts(): bool { return false; }
    public function requiresConsent(): bool { return false; }
    public function getScripts(): array { return []; }
    public function getConfigFields(): array { return []; }

    public function renderWidget(array $formConfig): string
    {
        // LilFOOT adds its own hidden fields via hooks
        return '';
    }

    public function validate(array $submissionData): SpamCheckResult
    {
        // LilFOOT validation happens through JTL's hook system
        // This adapter is a passthrough — LilFOOT will block spam
        // at the hook level before we even get here
        return SpamCheckResult::pass('lilfoot');
    }

    /**
     * Check if LilFOOT plugin is active.
     */
    public static function isAvailable(): bool
    {
        return class_exists('\\Plugin\\jtl_lilfoot_spamprotector\\Bootstrap')
            || class_exists('\\Plugin\\jtl_lilfoot_spamprotector_lite\\Bootstrap');
    }
}
