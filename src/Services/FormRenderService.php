<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Models\Form;
use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;
use JTL\Plugin\Helper;
use JTL\Shop;

class FormRenderService
{
    private Form $formModel;

    public function __construct()
    {
        $this->formModel = new Form();
    }

    /**
     * Render a form by ID.
     */
    public function renderById(int $formId, array $options = []): string
    {
        $langIso = Shop::getLanguageCode() ?? 'ger';
        $form = $this->formModel->getWithLang($formId, $langIso);

        if ($form === null) {
            return '<!-- BBF Formbuilder: Form not found (ID: ' . $formId . ') -->';
        }

        if ($form->status !== 'active') {
            return '<!-- BBF Formbuilder: Form is inactive -->';
        }

        return $this->render($form, $langIso, $options);
    }

    /**
     * Render a form by slug.
     */
    public function renderBySlug(string $slug, array $options = []): string
    {
        $form = $this->formModel->getBySlug($slug);
        if ($form === null) {
            return '<!-- BBF Formbuilder: Form not found (slug: ' . htmlspecialchars($slug) . ') -->';
        }

        $langIso = Shop::getLanguageCode() ?? 'ger';
        $formWithLang = $this->formModel->getWithLang((int)$form->id, $langIso);

        if ($formWithLang === null || $formWithLang->status !== 'active') {
            return '<!-- BBF Formbuilder: Form is inactive -->';
        }

        return $this->render($formWithLang, $langIso, $options);
    }

    /**
     * Render the form HTML.
     */
    private function render(object $form, string $langIso, array $options = []): string
    {
        $plugin = Helper::getPluginById(PluginHelper::PLUGIN_ID);
        if ($plugin === null) {
            return '<!-- BBF Formbuilder: Plugin not found -->';
        }

        $smarty = Shop::Smarty();
        $frontendPath = $plugin->getPaths()->getFrontendPath();

        $fields = json_decode($form->fields_json, true) ?? [];
        $fieldsLang = [];
        if (!empty($form->fields_lang_json)) {
            $fieldsLang = json_decode($form->fields_lang_json, true) ?? [];
        }

        // Merge translations into fields
        foreach ($fields as &$field) {
            if (isset($fieldsLang[$field['id']])) {
                $trans = $fieldsLang[$field['id']];
                if (!empty($trans['label'])) {
                    $field['label'] = $trans['label'];
                }
                if (!empty($trans['placeholder'])) {
                    $field['placeholder'] = $trans['placeholder'];
                }
                if (!empty($trans['description'])) {
                    $field['description'] = $trans['description'];
                }
                if (!empty($trans['choices'])) {
                    $field['choices'] = $trans['choices'];
                }
            }
        }
        unset($field);

        $title = $form->lang_title ?? $form->title;
        $submitText = $form->lang_submit_button_text ?? $form->submit_button_text ?? 'Absenden';
        $cssClass = trim(($form->css_classes ?? '') . ' ' . ($options['class'] ?? ''));

        $csrfToken = bin2hex(random_bytes(32));
        $_SESSION['bbf_form_token_' . $form->id] = $csrfToken;
        $_SESSION['bbf_form_time_' . $form->id] = time();

        $smarty->assign([
            'bbfForm'        => $form,
            'bbfFields'      => $fields,
            'bbfFormTitle'   => $title,
            'bbfSubmitText'  => $submitText,
            'bbfCssClass'    => $cssClass,
            'bbfCsrfToken'   => $csrfToken,
            'bbfAjax'        => ($options['ajax'] ?? true) ? 'true' : 'false',
            'bbfSubmitUrl'   => Shop::getURL() . '/bbf-formbuilder/submit',
            'bbfPluginUrl'   => $plugin->getPaths()->getFrontendURL(),
            'bbfFrontendPath' => $frontendPath,
        ]);

        return $smarty->fetch($frontendPath . 'template/form.tpl');
    }
}
