<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Email\Styles;

class ShopDefaultStyle implements EmailStyleInterface
{
    public function getIdentifier(): string { return 'shop_default'; }
    public function getLabel(): string { return 'Shop-Standard'; }

    public function wrap(string $content, array $mergeData): string
    {
        // Gibt den Content unverändert zurück — wird vom JTL-Shop
        // E-Mail-System in das aktive E-Mail-Layout eingebettet.
        return $content;
    }
}
