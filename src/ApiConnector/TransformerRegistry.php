<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\ApiConnector;

use BbfdesignFormbuilder\ApiConnector\Transformers;

class TransformerRegistry
{
    private static ?self $instance = null;
    private array $transformers = [];

    public static function getInstance(): self
    {
        if (self::$instance === null) {
            self::$instance = new self();
            self::$instance->registerDefaults();
        }
        return self::$instance;
    }

    public function register(TransformerInterface $t): void
    {
        $this->transformers[$t->getIdentifier()] = $t;
    }

    public function apply(mixed $value, string $id, array $config = []): mixed
    {
        if (!isset($this->transformers[$id])) {
            return $value;
        }
        return $this->transformers[$id]->transform($value, $config);
    }

    /**
     * @return array<string, array{id: string, label: string, config_fields: array}>
     */
    public function getAvailable(): array
    {
        $result = [];
        foreach ($this->transformers as $id => $t) {
            $result[$id] = [
                'id' => $id,
                'label' => $t->getLabel(),
                'config_fields' => $t->getConfigFields(),
            ];
        }
        return $result;
    }

    private function registerDefaults(): void
    {
        $this->register(new Transformers\UppercaseTransformer());
        $this->register(new Transformers\LowercaseTransformer());
        $this->register(new Transformers\TrimTransformer());
        $this->register(new Transformers\PrefixTransformer());
        $this->register(new Transformers\SuffixTransformer());
        $this->register(new Transformers\ReplaceTransformer());
        $this->register(new Transformers\DateFormatTransformer());
        $this->register(new Transformers\NumberFormatTransformer());
        $this->register(new Transformers\JsonEncodeTransformer());
        $this->register(new Transformers\SplitTransformer());
        $this->register(new Transformers\RegexExtractTransformer());
        $this->register(new Transformers\ConditionalTransformer());
    }
}
