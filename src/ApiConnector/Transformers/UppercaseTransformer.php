<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class UppercaseTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        return mb_strtoupper((string)$value);
    }

    public function getIdentifier(): string { return 'uppercase'; }
    public function getLabel(): string { return 'Großbuchstaben'; }
    public function getConfigFields(): array { return []; }
}
