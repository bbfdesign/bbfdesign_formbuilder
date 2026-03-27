<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class RegexExtractTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        $pattern = $config['pattern'] ?? '';
        if (empty($pattern)) {
            return $value;
        }

        // Sicherheit: Pattern muss valide sein
        if (@preg_match($pattern, '') === false) {
            return $value;
        }

        if (preg_match($pattern, (string)$value, $matches)) {
            return $matches[1] ?? $matches[0];
        }

        return '';
    }

    public function getIdentifier(): string { return 'regex_extract'; }
    public function getLabel(): string { return 'Regex-Extraktion'; }

    public function getConfigFields(): array
    {
        return [['name' => 'pattern', 'label' => 'Regex-Pattern (z.B. /(\d+)/)', 'type' => 'text']];
    }
}
