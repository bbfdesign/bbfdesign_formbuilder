<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Email\Styles\EmailStyleInterface;
use BbfdesignFormbuilder\Email\Styles\ModernStyle;
use BbfdesignFormbuilder\Email\Styles\MinimalStyle;
use BbfdesignFormbuilder\Email\Styles\PlainTextStyle;
use BbfdesignFormbuilder\Email\Styles\ShopDefaultStyle;
use BbfdesignFormbuilder\Models\EmailTemplate;

class EmailTemplateService
{
    /** @var array<string, EmailStyleInterface> */
    private array $styles;

    public function __construct()
    {
        $this->styles = [];
        foreach ([new ShopDefaultStyle(), new ModernStyle(), new MinimalStyle(), new PlainTextStyle()] as $style) {
            $this->styles[$style->getIdentifier()] = $style;
        }
    }

    /**
     * Render email content using the specified template type/style.
     */
    public function render(string $templateType, string $messageContent, array $mergeData, int $customTemplateId = 0): string
    {
        // Legacy support: map old type names to new style identifiers
        $styleMap = [
            'standard' => 'shop_default',
            'fancy' => 'modern',
            'custom' => 'modern',
        ];

        $styleId = $styleMap[$templateType] ?? $templateType;

        // Custom template: load from DB
        if ($templateType === 'custom' && $customTemplateId > 0) {
            return $this->renderCustom($messageContent, $mergeData, $customTemplateId);
        }

        // Render with style
        $style = $this->styles[$styleId] ?? $this->styles['shop_default'];
        return $style->wrap($messageContent, $mergeData);
    }

    /**
     * Render using a specific style identifier.
     */
    public function renderWithStyle(string $styleId, string $content, array $mergeData): string
    {
        $style = $this->styles[$styleId] ?? $this->styles['shop_default'];
        return $style->wrap($content, $mergeData);
    }

    /**
     * Verfügbare Stile für die Admin-UI.
     */
    public function getAvailableStyles(): array
    {
        $result = [];
        foreach ($this->styles as $style) {
            $result[] = [
                'id' => $style->getIdentifier(),
                'label' => $style->getLabel(),
            ];
        }
        return $result;
    }

    private function renderCustom(string $content, array $mergeData, int $templateId): string
    {
        $emailTemplateModel = new EmailTemplate();
        $template = $emailTemplateModel->getById($templateId);

        if ($template === null) {
            return $content;
        }

        $html = $template->html_template ?? $content;
        $html = str_replace('{$content}', $content, $html);

        foreach ($mergeData as $key => $value) {
            $html = str_replace('{$' . $key . '}', htmlspecialchars((string)$value), $html);
        }

        return $html;
    }
}
