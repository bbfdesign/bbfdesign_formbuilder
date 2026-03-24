<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Models\EmailTemplate;

class EmailTemplateService
{
    /**
     * Render email content using the specified template type.
     */
    public function render(string $templateType, string $messageContent, array $mergeData, int $customTemplateId = 0): string
    {
        switch ($templateType) {
            case 'fancy':
                return $this->renderFancy($messageContent, $mergeData);
            case 'custom':
                return $this->renderCustom($messageContent, $mergeData, $customTemplateId);
            case 'standard':
            default:
                return $messageContent;
        }
    }

    private function renderFancy(string $content, array $mergeData): string
    {
        $emailTemplateModel = new EmailTemplate();
        $template = $emailTemplateModel->getByType('fancy');

        if ($template === null) {
            return $content;
        }

        $html = $template->html_template;
        $html = str_replace('{$content}', $content, $html);

        foreach ($mergeData as $key => $value) {
            $html = str_replace('{$' . $key . '}', htmlspecialchars((string)$value), $html);
        }

        return $html;
    }

    private function renderCustom(string $content, array $mergeData, int $templateId): string
    {
        if ($templateId <= 0) {
            return $content;
        }

        $emailTemplateModel = new EmailTemplate();
        $template = $emailTemplateModel->getById($templateId);

        if ($template === null) {
            return $content;
        }

        $html = $template->html_template;
        $html = str_replace('{$content}', $content, $html);

        foreach ($mergeData as $key => $value) {
            $html = str_replace('{$' . $key . '}', htmlspecialchars((string)$value), $html);
        }

        return $html;
    }
}
