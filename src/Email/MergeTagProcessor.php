<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Email;

use BbfdesignFormbuilder\Helpers\MergeTagHelper;

/**
 * Verarbeitet Merge-Tags in E-Mail-Templates.
 *
 * Unterstützte Tags:
 * {{field:field_id}}   → Feldwert
 * {{form_name}}        → Formularname
 * {{entry_id}}         → Eintrags-ID
 * {{date}}             → Datum
 * {{time}}             → Uhrzeit
 * {{shop_name}}        → Shop-Name
 * {{shop_url}}         → Shop-URL
 * {{admin_email}}      → Admin-E-Mail
 * {{all_fields}}       → Alle Felder als Tabelle
 * {{ip_address}}       → IP-Adresse
 */
class MergeTagProcessor
{
    private MergeTagHelper $helper;

    public function __construct()
    {
        $this->helper = new MergeTagHelper();
    }

    /**
     * Verarbeitet alle Merge-Tags in einem Template-String.
     */
    public function process(string $template, array $entryValues, array $fields, int $entryId, int $formId): string
    {
        $mergeData = $this->helper->buildMergeData($entryValues, $fields, $entryId, $formId);

        // {{field:field_id}} Tags ersetzen
        $template = preg_replace_callback('/\{\{field:([^}]+)\}\}/', function ($m) use ($mergeData) {
            return htmlspecialchars((string)($mergeData['feld:' . $m[1]] ?? ''), ENT_QUOTES, 'UTF-8');
        }, $template);

        // {{all_fields}} Tag
        $template = str_replace('{{all_fields}}', $mergeData['alle_felder'] ?? '', $template);

        // Globale Tags
        $globalMap = [
            '{{form_name}}' => $mergeData['formular_name'] ?? '',
            '{{entry_id}}' => $mergeData['eintrag_id'] ?? '',
            '{{date}}' => $mergeData['datum'] ?? '',
            '{{time}}' => $mergeData['uhrzeit'] ?? '',
            '{{shop_name}}' => $mergeData['shop_name'] ?? '',
            '{{shop_url}}' => $mergeData['shop_url'] ?? '',
            '{{admin_email}}' => $mergeData['admin_link'] ?? '',
            '{{ip_address}}' => $mergeData['ip_adresse'] ?? '',
        ];

        return str_replace(array_keys($globalMap), array_values($globalMap), $template);
    }

    /**
     * Gibt die verfügbaren Merge-Tags für die UI zurück.
     */
    public static function getAvailableTags(): array
    {
        return [
            ['tag' => '{{all_fields}}', 'label' => 'Alle Felder (Tabelle)'],
            ['tag' => '{{form_name}}', 'label' => 'Formularname'],
            ['tag' => '{{entry_id}}', 'label' => 'Eintrags-ID'],
            ['tag' => '{{date}}', 'label' => 'Datum'],
            ['tag' => '{{time}}', 'label' => 'Uhrzeit'],
            ['tag' => '{{shop_name}}', 'label' => 'Shop-Name'],
            ['tag' => '{{shop_url}}', 'label' => 'Shop-URL'],
            ['tag' => '{{ip_address}}', 'label' => 'IP-Adresse'],
            ['tag' => '{{field:FELD_ID}}', 'label' => 'Einzelnes Feld (ID ersetzen)'],
        ];
    }
}
