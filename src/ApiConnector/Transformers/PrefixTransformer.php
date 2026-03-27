<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class PrefixTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        return ($config['text'] ?? '') . (string)$value;
    }

    public function getIdentifier(): string { return 'prefix'; }
    public function getLabel(): string { return 'Präfix'; }

    public function getConfigFields(): array
    {
        return [['name' => 'text', 'label' => 'Präfix-Text', 'type' => 'text']];
    }
}
