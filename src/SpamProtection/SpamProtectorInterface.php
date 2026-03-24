<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

interface SpamProtectorInterface
{
    public function getIdentifier(): string;
    public function getDisplayName(): string;
    public function requiresExternalScripts(): bool;
    public function requiresConsent(): bool;
    public function renderWidget(array $formConfig): string;
    public function getScripts(): array;
    public function validate(array $submissionData): SpamCheckResult;
    public function getConfigFields(): array;
}
