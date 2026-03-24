<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Portlets;

use BbfdesignFormbuilder\Models\Form;
use BbfdesignFormbuilder\Services\FormRenderService;
use JTL\OPC\InputType;
use JTL\OPC\Portlet;

class FormBuilderPortlet extends Portlet
{
    public function getPropertyDesc(): array
    {
        return [
            'form_id' => [
                'label'    => 'Formular auswählen',
                'type'     => InputType::SELECT,
                'options'  => $this->getFormOptions(),
                'required' => true,
            ],
            'custom_class' => [
                'label' => 'CSS-Klasse',
                'type'  => InputType::TEXT,
            ],
        ];
    }

    public function getPropertyTabs(): array
    {
        return [
            'styles' => 'Styles',
        ];
    }

    /**
     * Get available forms for the select dropdown.
     */
    private function getFormOptions(): array
    {
        $options = ['' => '-- Formular wählen --'];

        try {
            $formModel = new Form();
            $forms = $formModel->getAll('active');
            foreach ($forms as $form) {
                $options[$form['id']] = $form['title'];
            }
        } catch (\Exception $e) {
            // Plugin tables may not exist yet during first install
        }

        return $options;
    }

    /**
     * Get the final HTML output of the portlet.
     */
    public function getFinalHtml(): string
    {
        $formId = (int)($this->getProperty('form_id') ?? 0);
        if ($formId <= 0) {
            return '<p style="color:#999;text-align:center;padding:20px;">Bitte ein Formular auswählen.</p>';
        }

        $renderService = new FormRenderService();
        return $renderService->renderById($formId, [
            'class' => $this->getProperty('custom_class') ?? '',
        ]);
    }

    /**
     * Get the preview HTML for the OPC editor.
     */
    public function getPreviewHtml(): string
    {
        $formId = (int)($this->getProperty('form_id') ?? 0);
        if ($formId <= 0) {
            return '<div style="background:#f8f9fa;border:2px dashed #dee2e6;padding:30px;text-align:center;border-radius:8px;">'
                . '<p style="color:#6c757d;margin:0;">BBF Formbuilder<br><small>Bitte ein Formular auswählen</small></p>'
                . '</div>';
        }

        $formModel = new Form();
        $form = $formModel->getById($formId);
        $title = $form->title ?? 'Formular #' . $formId;

        return '<div style="background:#f8f9fa;border:2px dashed #dee2e6;padding:30px;text-align:center;border-radius:8px;">'
            . '<p style="color:#333;margin:0;font-weight:600;">BBF Formbuilder</p>'
            . '<p style="color:#6c757d;margin:4px 0 0;">' . htmlspecialchars($title) . '</p>'
            . '</div>';
    }
}
