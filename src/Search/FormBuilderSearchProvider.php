<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Search;

use JTL\Shop;

class FormBuilderSearchProvider
{
    private $db;

    public function __construct($db = null)
    {
        $this->db = $db ?? Shop::Container()->getDB();
    }

    public function getProviderName(): string
    {
        return 'formbuilder';
    }

    public function getProviderLabel(): string
    {
        return 'BBF Formbuilder';
    }

    public function getDocuments(string $langIso): array
    {
        $forms = $this->db->queryPrepared(
            'SELECT f.*, fl.title as lang_title, fl.description as lang_description
             FROM bbf_formbuilder_forms f
             LEFT JOIN bbf_formbuilder_form_lang fl ON f.id = fl.form_id AND fl.lang_iso = :lang
             WHERE f.status = :status AND f.is_searchable = 1',
            ['lang' => $langIso, 'status' => 'active']
        );

        $documents = [];
        foreach ($forms as $form) {
            $documents[] = [
                'id'          => 'form_' . $form['id'],
                'type'        => 'form',
                'title'       => $form['lang_title'] ?? $form['title'],
                'description' => $form['lang_description'] ?? $form['description'] ?? '',
                'url'         => '/bbf-form/' . $form['slug'],
                'category'    => 'Formulare',
                'keywords'    => $this->extractFieldLabels($form),
            ];
        }

        return $documents;
    }

    public function getSearchInfo(): array
    {
        $count = $this->db->queryPrepared(
            'SELECT COUNT(*) as cnt FROM bbf_formbuilder_forms WHERE status = :s AND is_searchable = 1',
            ['s' => 'active']
        );

        return [
            'name'      => $this->getProviderName(),
            'label'     => $this->getProviderLabel(),
            'version'   => '1.0.0',
            'doc_count' => (int)($count[0]['cnt'] ?? 0),
            'doc_types' => ['form'],
        ];
    }

    private function extractFieldLabels(array $form): string
    {
        $fields = json_decode($form['fields_json'] ?? '[]', true);
        $labels = [];
        foreach ($fields as $field) {
            if (!empty($field['label'])) {
                $labels[] = $field['label'];
            }
        }
        return implode(', ', $labels);
    }
}
