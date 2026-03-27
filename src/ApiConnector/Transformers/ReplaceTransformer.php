<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class ReplaceTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        $from = $config['from'] ?? '';
        $to = $config['to'] ?? '';
        return str_replace($from, $to, (string)$value);
    }

    public function getIdentifier(): string { return 'replace'; }
    public function getLabel(): string { return 'Ersetzen'; }

    public function getConfigFields(): array
    {
        return [
            ['name' => 'from', 'label' => 'Suchen', 'type' => 'text'],
            ['name' => 'to', 'label' => 'Ersetzen durch', 'type' => 'text'],
        ];
    }
}
