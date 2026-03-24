<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Smarty;

use BbfdesignFormbuilder\Services\FormRenderService;

/**
 * Smarty Plugin für {bbf_form} Tag.
 *
 * Usage:
 *   {bbf_form id=1}
 *   {bbf_form slug="kontakt"}
 *   {bbf_form id=3 class="my-custom-form" ajax=true}
 */
class FormBuilderSmartyPlugin
{
    /**
     * Render function called by Smarty.
     *
     * @param array $params Smarty function parameters
     * @param \Smarty_Internal_Template $smarty
     * @return string Rendered HTML
     */
    public static function render(array $params, $smarty): string
    {
        $renderService = new FormRenderService();

        $options = [
            'class' => $params['class'] ?? '',
            'ajax'  => isset($params['ajax']) ? (bool)$params['ajax'] : true,
        ];

        if (!empty($params['id'])) {
            return $renderService->renderById((int)$params['id'], $options);
        }

        if (!empty($params['slug'])) {
            return $renderService->renderBySlug((string)$params['slug'], $options);
        }

        return '<!-- BBF Formbuilder: Bitte id oder slug angeben. Beispiel: {bbf_form id=1} -->';
    }
}
