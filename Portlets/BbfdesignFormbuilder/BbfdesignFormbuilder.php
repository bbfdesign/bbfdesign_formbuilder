<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Portlets\BbfdesignFormbuilder;

use JTL\OPC\InputType;
use JTL\OPC\Portlet;
use JTL\OPC\PortletInstance;
use JTL\Shop;

/**
 * Class BbfdesignFormbuilder
 * OPC Portlet for embedding forms in the OnPage Composer.
 */
class BbfdesignFormbuilder extends Portlet
{
    /**
     * @return array
     */
    public function getPropertyDesc(): array
    {
        return [
            'form_id' => [
                'type'     => InputType::SELECT,
                'label'    => $this->plugin->getLocalization()->getTranslation('select_form') ?: 'Formular auswählen',
                'options'  => $this->getFormOptions(),
                'required' => true,
                'width'    => 50,
            ],
            'custom_class' => [
                'type'    => InputType::TEXT,
                'label'   => $this->plugin->getLocalization()->getTranslation('field_css_class') ?: 'CSS-Klasse',
                'width'   => 50,
                'default' => '',
            ],
        ];
    }

    /**
     * Get available forms for the select dropdown.
     */
    private function getFormOptions(): array
    {
        $options = ['' => '-- Formular wählen --'];

        try {
            $db = Shop::Container()->getDB();
            $forms = $db->queryPrepared(
                "SELECT id, title FROM bbf_formbuilder_forms WHERE status = 'active' ORDER BY title ASC",
                []
            );
            foreach ($forms as $form) {
                $options[$form['id']] = $form['title'];
            }
        } catch (\Exception $e) {
            // Tables may not exist yet
        }

        return $options;
    }
}
