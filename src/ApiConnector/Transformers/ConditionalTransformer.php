<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class ConditionalTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        $ifValue = $config['if'] ?? '';
        $thenValue = $config['then'] ?? $value;
        $elseValue = $config['else'] ?? $value;

        return ((string)$value === (string)$ifValue) ? $thenValue : $elseValue;
    }

    public function getIdentifier(): string { return 'conditional'; }
    public function getLabel(): string { return 'Bedingt'; }

    public function getConfigFields(): array
    {
        return [
            ['name' => 'if', 'label' => 'Wenn Wert gleich', 'type' => 'text'],
            ['name' => 'then', 'label' => 'Dann', 'type' => 'text'],
            ['name' => 'else', 'label' => 'Sonst', 'type' => 'text'],
        ];
    }
}
