<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class JsonEncodeTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        return json_encode($value, JSON_UNESCAPED_UNICODE);
    }

    public function getIdentifier(): string { return 'json_encode'; }
    public function getLabel(): string { return 'JSON-Kodierung'; }
    public function getConfigFields(): array { return []; }
}
