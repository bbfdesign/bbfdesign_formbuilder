<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector\Transformers;

use BbfdesignFormbuilder\ApiConnector\TransformerInterface;

class DateFormatTransformer implements TransformerInterface
{
    public function transform(mixed $value, array $config): mixed
    {
        $format = $config['format'] ?? 'Y-m-d';
        try {
            $dt = new \DateTime((string)$value);
            return $dt->format($format);
        } catch (\Throwable $e) {
            return $value;
        }
    }

    public function getIdentifier(): string { return 'date_format'; }
    public function getLabel(): string { return 'Datumsformat'; }

    public function getConfigFields(): array
    {
        return [['name' => 'format', 'label' => 'PHP-Format (z.B. Y-m-d)', 'type' => 'text']];
    }
}
