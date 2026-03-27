<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Email\Styles;

class PlainTextStyle implements EmailStyleInterface
{
    public function getIdentifier(): string { return 'plain'; }
    public function getLabel(): string { return 'Nur Text'; }

    public function wrap(string $content, array $mergeData): string
    {
        // HTML zu Plain Text konvertieren
        $text = strip_tags(str_replace(['<br>', '<br/>', '<br />', '</tr>'], "\n", $content));
        $text = html_entity_decode($text, ENT_QUOTES, 'UTF-8');
        $text = preg_replace('/\n{3,}/', "\n\n", trim($text));

        $formName = $mergeData['formular_name'] ?? 'Formular';
        $shopName = $mergeData['shop_name'] ?? '';

        return $formName . "\n" . str_repeat('=', mb_strlen($formName)) . "\n\n"
            . $text . "\n\n---\n" . $shopName;
    }
}
