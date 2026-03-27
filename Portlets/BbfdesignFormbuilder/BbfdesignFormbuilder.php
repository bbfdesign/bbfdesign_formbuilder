<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Portlets\BbfdesignFormbuilder;

use BbfdesignFormbuilder\Services\FormRenderService;
use JTL\OPC\InputType;
use JTL\OPC\Portlet;
use JTL\OPC\PortletInstance;
use JTL\Shop;

/**
 * OPC Portlet für BBF Formulare im OnPage Composer.
 */
class BbfdesignFormbuilder extends Portlet
{
    public function getPropertyDesc(): array
    {
        return [
            'form_id' => [
                'type' => InputType::SELECT,
                'label' => 'Formular auswählen',
                'options' => $this->getFormOptions(),
                'required' => true,
                'width' => 50,
            ],
            'show_title' => [
                'type' => InputType::CHECKBOX,
                'label' => 'Formular-Titel anzeigen',
                'default' => true,
                'width' => 25,
            ],
            'custom_title' => [
                'type' => InputType::TEXT,
                'label' => 'Eigener Titel (optional)',
                'default' => '',
                'width' => 50,
            ],
            'custom_class' => [
                'type' => InputType::TEXT,
                'label' => 'CSS-Klasse',
                'default' => '',
                'width' => 25,
            ],
        ];
    }

    /**
     * Vorschau im OPC-Editor.
     */
    public function getPreviewHtml(PortletInstance $instance): string
    {
        $formId = (int)$instance->getProperty('form_id');
        if (!$formId) {
            return '<div style="padding:20px;text-align:center;color:#6c757d;border:2px dashed #dee2e6;border-radius:8px;">'
                . '<i class="fa fa-wpforms" style="font-size:24px;margin-bottom:8px;display:block;opacity:0.3;"></i>'
                . 'Kein Formular ausgewählt</div>';
        }

        $form = $this->getFormById($formId);
        $title = $form ? htmlspecialchars($form['title'] ?? '') : 'Unbekanntes Formular';

        return '<div style="padding:16px;border:2px dashed #e8420a;border-radius:8px;background:#fff5f0;">'
            . '<div style="display:flex;align-items:center;gap:8px;">'
            . '<i class="fa fa-wpforms" style="color:#e8420a;"></i>'
            . '<strong>' . $title . '</strong>'
            . '</div>'
            . '<small style="color:#6c757d;">BBF Formular (ID: ' . $formId . ')</small>'
            . '</div>';
    }

    /**
     * Frontend-Ausgabe.
     */
    public function getContentHtml(PortletInstance $instance): string
    {
        $formId = (int)$instance->getProperty('form_id');
        if (!$formId) {
            return '';
        }

        try {
            $renderer = new FormRenderService();
            return $renderer->renderById($formId, [
                'class' => $instance->getProperty('custom_class') ?? '',
            ]);
        } catch (\Throwable $e) {
            return '<!-- BBF Formbuilder Portlet: ' . htmlspecialchars($e->getMessage()) . ' -->';
        }
    }

    private function getFormOptions(): array
    {
        $options = ['' => '-- Formular wählen --'];
        try {
            $db = Shop::Container()->getDB();
            $forms = $db->queryPrepared(
                "SELECT id, title FROM bbf_formbuilder_forms WHERE status = 'active' ORDER BY title ASC",
                []
            );
            if (is_array($forms)) {
                foreach ($forms as $form) {
                    $form = (array)$form;
                    $options[$form['id']] = $form['title'];
                }
            }
        } catch (\Throwable $e) {}

        return $options;
    }

    private function getFormById(int $id): ?array
    {
        try {
            $result = Shop::Container()->getDB()->queryPrepared(
                "SELECT id, title, slug FROM bbf_formbuilder_forms WHERE id = :id LIMIT 1",
                ['id' => $id]
            );
            return !empty($result) && is_array($result) ? (array)$result[0] : null;
        } catch (\Throwable $e) {
            return null;
        }
    }
}
