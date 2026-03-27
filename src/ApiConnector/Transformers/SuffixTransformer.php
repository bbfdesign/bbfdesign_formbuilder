<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class SuffixTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        return (string)$value . ($config['text'] ?? '');
    }

    public function getIdentifier(): string { return 'suffix'; }
    public function getLabel(): string { return 'Suffix'; }

    public function getConfigFields(): array
    {
        return [['name' => 'text', 'label' => 'Suffix-Text', 'type' => 'text']];
    }
}
