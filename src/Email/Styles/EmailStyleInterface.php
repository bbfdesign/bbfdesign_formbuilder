<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Email\Styles;

interface EmailStyleInterface
{
    public function wrap(string $content, array $mergeData): string;
    public function getIdentifier(): string;
    public function getLabel(): string;
}
