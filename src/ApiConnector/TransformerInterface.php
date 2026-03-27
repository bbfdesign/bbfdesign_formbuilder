<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector;

interface TransformerInterface
{
    public function transform(mixed $value, array $config): mixed;
    public function getIdentifier(): string;
    public function getLabel(): string;

    /**
     * Felder für die UI-Konfiguration.
     * @return array<int, array{name: string, label: string, type: string}>
     */
    public function getConfigFields(): array;
}
