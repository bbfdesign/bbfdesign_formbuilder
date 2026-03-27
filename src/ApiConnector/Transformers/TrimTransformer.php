<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class TrimTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        return trim((string)$value);
    }

    public function getIdentifier(): string { return 'trim'; }
    public function getLabel(): string { return 'Leerzeichen entfernen'; }
    public function getConfigFields(): array { return []; }
}
