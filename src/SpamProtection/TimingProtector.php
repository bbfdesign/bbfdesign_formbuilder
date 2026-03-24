<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

class TimingProtector implements SpamProtectorInterface
{
    private int $minSeconds;

    public function __construct(int $minSeconds = 3)
    {
        $this->minSeconds = $minSeconds;
    }

    public function getIdentifier(): string { return 'timing'; }
    public function getDisplayName(): string { return 'Timing-Schutz'; }
    public function requiresExternalScripts(): bool { return false; }
    public function requiresConsent(): bool { return false; }
    public function getScripts(): array { return []; }
    public function getConfigFields(): array { return []; }

    public function renderWidget(array $formConfig): string
    {
        return '';
    }

    public function validate(array $submissionData): SpamCheckResult
    {
        $formId = $submissionData['_form_id'] ?? 0;
        $loadTime = $_SESSION['bbf_form_time_' . $formId] ?? 0;

        if ($loadTime > 0 && (time() - $loadTime) < $this->minSeconds) {
            return SpamCheckResult::fail('timing', 'Form submitted too quickly', 0.8);
        }

        return SpamCheckResult::pass('timing');
    }
}
