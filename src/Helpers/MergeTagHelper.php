<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Helpers;

use BbfdesignFormbuilder\Models\Form;
use JTL\Shop;

class MergeTagHelper
{
    /**
     * Build merge data array from entry values.
     */
    public function buildMergeData(array $values, array $fields, int $entryId, int $formId): array
    {
        $formModel = new Form();
        $form = $formModel->getById($formId);

        $allFieldsHtml = $this->buildAllFieldsTable($values, $fields);

        $data = [
            'alle_felder'   => $allFieldsHtml,
            'formular_name' => $form->title ?? '',
            'eintrag_id'    => (string)$entryId,
            'datum'         => date('d.m.Y'),
            'uhrzeit'       => date('H:i'),
            'ip_adresse'    => $_SERVER['REMOTE_ADDR'] ?? '',
            'seiten_url'    => $_SERVER['HTTP_REFERER'] ?? '',
            'shop_name'     => Shop::getSettingValue(\CONF_GLOBAL, 'global_shopname') ?? '',
            'shop_url'      => Shop::getURL(),
            'admin_link'    => Shop::getAdminURL() . '/',
        ];

        // Add individual field values
        foreach ($fields as $field) {
            $val = $values[$field['id']] ?? '';
            if (is_array($val)) {
                $val = implode(', ', $val);
            }
            $data['feld:' . $field['id']] = (string)$val;
            $data['feld:' . $field['id'] . ':label'] = $field['label'] ?? '';
        }

        return $data;
    }

    /**
     * Parse merge tags in a string.
     */
    public function parse(string $template, array $mergeData): string
    {
        foreach ($mergeData as $key => $value) {
            $template = str_replace('{' . $key . '}', (string)$value, $template);
        }
        return $template;
    }

    /**
     * Build an HTML table of all field values.
     */
    private function buildAllFieldsTable(array $values, array $fields): string
    {
        $html = '<table style="width:100%;border-collapse:collapse;">';

        foreach ($fields as $field) {
            if (in_array($field['type'], ['section_break', 'page_break', 'html_block', 'captcha'], true)) {
                continue;
            }

            $val = $values[$field['id']] ?? '';
            if (is_array($val)) {
                $val = implode(', ', $val);
            }

            $html .= '<tr>';
            $html .= '<td style="padding:8px 12px;border-bottom:1px solid #eee;font-weight:600;width:35%;vertical-align:top;">'
                . htmlspecialchars($field['label'] ?? $field['id'])
                . '</td>';
            $html .= '<td style="padding:8px 12px;border-bottom:1px solid #eee;">'
                . nl2br(htmlspecialchars((string)$val))
                . '</td>';
            $html .= '</tr>';
        }

        $html .= '</table>';
        return $html;
    }
}
