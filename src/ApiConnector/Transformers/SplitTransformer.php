<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class SplitTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        $separator = $config['separator'] ?? ',';
        return array_map('trim', explode($separator, (string)$value));
    }

    public function getIdentifier(): string { return 'split'; }
    public function getLabel(): string { return 'Aufteilen'; }

    public function getConfigFields(): array
    {
        return [['name' => 'separator', 'label' => 'Trennzeichen', 'type' => 'text']];
    }
}
