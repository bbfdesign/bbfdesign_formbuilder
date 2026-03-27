<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class NumberFormatTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        $dec = (int)($config['decimals'] ?? 2);
        $decPoint = $config['dec_point'] ?? '.';
        $thousandsSep = $config['thousands_sep'] ?? '';

        // Deutsche Zahlen normalisieren (1.234,56 → 1234.56)
        $normalized = str_replace(['.', ','], ['', '.'], (string)$value);
        $num = (float)$normalized;

        return number_format($num, $dec, $decPoint, $thousandsSep);
    }

    public function getIdentifier(): string { return 'number_format'; }
    public function getLabel(): string { return 'Zahlenformat'; }

    public function getConfigFields(): array
    {
        return [
            ['name' => 'decimals', 'label' => 'Dezimalstellen', 'type' => 'number'],
            ['name' => 'dec_point', 'label' => 'Dezimaltrennzeichen', 'type' => 'text'],
            ['name' => 'thousands_sep', 'label' => 'Tausendertrennzeichen', 'type' => 'text'],
        ];
    }
}
