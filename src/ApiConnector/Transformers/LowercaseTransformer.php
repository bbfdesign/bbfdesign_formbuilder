<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class LowercaseTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        return mb_strtolower((string)$value);
    }

    public function getIdentifier(): string { return 'lowercase'; }
    public function getLabel(): string { return 'Kleinbuchstaben'; }
    public function getConfigFields(): array { return []; }
}
