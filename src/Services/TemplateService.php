<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Models\FormTemplate;

class TemplateService
{
    private FormTemplate $templateModel;

    public function __construct()
    {
        $this->templateModel = new FormTemplate();
    }

    /**
     * Get all templates grouped by category.
     */
    public function getGroupedByCategory(): array
    {
        $templates = $this->templateModel->getAll();
        $grouped = [];

        foreach ($templates as $template) {
            $category = $template['category'] ?? 'Sonstige';
            $grouped[$category][] = $template;
        }

        return $grouped;
    }
}
