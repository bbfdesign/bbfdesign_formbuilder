<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class Form
{
    public const TABLE = 'bbf_formbuilder_forms';
    public const TABLE_LANG = 'bbf_formbuilder_form_lang';

    private $db;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    /**
     * Get all forms with entry counts.
     */
    public function getAll(string $status = ''): array
    {
        $sql = 'SELECT f.*,
                    (SELECT COUNT(*) FROM bbf_formbuilder_entries e WHERE e.form_id = f.id AND e.is_trash = 0) as entry_count
                FROM `' . self::TABLE . '` f';
        $params = [];

        if (!empty($status)) {
            $sql .= ' WHERE f.status = :status';
            $params['status'] = $status;
        }

        $sql .= ' ORDER BY f.created_at DESC';

        try {
            $result = $this->db->queryPrepared($sql, $params);
            return is_array($result) ? $result : [];
        } catch (\Throwable $e) {
            return [];
        }
    }

    /**
     * Get a single form by ID.
     */
    public function getById(int $id): ?object
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` WHERE id = :id LIMIT 1',
                ['id' => $id]
            );
            return !empty($result) && is_array($result) ? (object)$result[0] : null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    /**
     * Get a single form by slug.
     */
    public function getBySlug(string $slug): ?object
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` WHERE slug = :slug LIMIT 1',
                ['slug' => $slug]
            );
            return !empty($result) && is_array($result) ? (object)$result[0] : null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    /**
     * Get form with translations for a specific language.
     */
    public function getWithLang(int $id, string $langIso): ?object
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT f.*, fl.title AS lang_title, fl.description AS lang_description,
                        fl.submit_button_text AS lang_submit_button_text,
                        fl.success_message AS lang_success_message,
                        fl.fields_lang_json
                 FROM `' . self::TABLE . '` f
                 LEFT JOIN `' . self::TABLE_LANG . '` fl ON f.id = fl.form_id AND fl.lang_iso = :lang
                 WHERE f.id = :id LIMIT 1',
                ['id' => $id, 'lang' => $langIso]
            );
            return !empty($result) && is_array($result) ? (object)$result[0] : null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    /**
     * Create a new form.
     */
    public function create(array $data): int
    {
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE . '` (title, slug, description, fields_json, settings_json, css_classes, status, is_multi_step, submit_button_text, is_searchable)
             VALUES (:title, :slug, :description, :fields_json, :settings_json, :css_classes, :status, :is_multi_step, :submit_button_text, :is_searchable)',
            [
                'title'              => $data['title'],
                'slug'               => $data['slug'],
                'description'        => $data['description'] ?? null,
                'fields_json'        => $data['fields_json'] ?? '[]',
                'settings_json'      => $data['settings_json'] ?? null,
                'css_classes'        => $data['css_classes'] ?? null,
                'status'             => $data['status'] ?? 'draft',
                'is_multi_step'      => $data['is_multi_step'] ?? 0,
                'submit_button_text' => $data['submit_button_text'] ?? 'Absenden',
                'is_searchable'      => $data['is_searchable'] ?? 1,
            ]
        );

        $result = $this->db->queryPrepared('SELECT LAST_INSERT_ID() as id', []);
        return (int)($result[0]['id'] ?? 0);
    }

    /**
     * Update an existing form.
     */
    public function update(int $id, array $data): void
    {
        $sets = [];
        $params = ['id' => $id];

        $allowedFields = [
            'title', 'slug', 'description', 'fields_json', 'settings_json',
            'css_classes', 'status', 'is_multi_step', 'submit_button_text', 'is_searchable',
        ];

        foreach ($allowedFields as $field) {
            if (array_key_exists($field, $data)) {
                $sets[] = "`{$field}` = :{$field}";
                $params[$field] = $data[$field];
            }
        }

        if (empty($sets)) {
            return;
        }

        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET ' . implode(', ', $sets) . ' WHERE id = :id',
            $params
        );
    }

    /**
     * Delete a form and all related data (cascades via FK).
     */
    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE id = :id',
            ['id' => $id]
        );
    }

    /**
     * Duplicate a form.
     */
    public function duplicate(int $id): ?int
    {
        $form = $this->getById($id);
        if ($form === null) {
            return null;
        }

        $newSlug = $form->slug . '-copy-' . time();
        return $this->create([
            'title'              => $form->title . ' (Kopie)',
            'slug'               => $newSlug,
            'description'        => $form->description,
            'fields_json'        => $form->fields_json,
            'settings_json'      => $form->settings_json,
            'css_classes'        => $form->css_classes,
            'status'             => 'draft',
            'is_multi_step'      => $form->is_multi_step,
            'submit_button_text' => $form->submit_button_text,
            'is_searchable'      => $form->is_searchable,
        ]);
    }

    /**
     * Save translation for a form.
     */
    public function saveLang(int $formId, string $langIso, array $data): void
    {
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE_LANG . '` (form_id, lang_iso, title, description, submit_button_text, success_message, fields_lang_json)
             VALUES (:form_id, :lang_iso, :title, :description, :submit_button_text, :success_message, :fields_lang_json)
             ON DUPLICATE KEY UPDATE
                title = VALUES(title),
                description = VALUES(description),
                submit_button_text = VALUES(submit_button_text),
                success_message = VALUES(success_message),
                fields_lang_json = VALUES(fields_lang_json)',
            [
                'form_id'            => $formId,
                'lang_iso'           => $langIso,
                'title'              => $data['title'] ?? null,
                'description'        => $data['description'] ?? null,
                'submit_button_text' => $data['submit_button_text'] ?? null,
                'success_message'    => $data['success_message'] ?? null,
                'fields_lang_json'   => $data['fields_lang_json'] ?? null,
            ]
        );
    }

    /**
     * Generate a unique slug from a title.
     */
    public function generateSlug(string $title, ?int $excludeId = null): string
    {
        $slug = mb_strtolower(trim($title));
        $slug = preg_replace('/[äÄ]/', 'ae', $slug);
        $slug = preg_replace('/[öÖ]/', 'oe', $slug);
        $slug = preg_replace('/[üÜ]/', 'ue', $slug);
        $slug = preg_replace('/ß/', 'ss', $slug);
        $slug = preg_replace('/[^a-z0-9]+/', '-', $slug);
        $slug = trim($slug, '-');

        $baseSlug = $slug;
        $counter = 1;

        while (true) {
            $sql = 'SELECT COUNT(*) as cnt FROM `' . self::TABLE . '` WHERE slug = :slug';
            $params = ['slug' => $slug];
            if ($excludeId !== null) {
                $sql .= ' AND id != :id';
                $params['id'] = $excludeId;
            }
            $result = $this->db->queryPrepared($sql, $params);
            if ((int)$result[0]['cnt'] === 0) {
                break;
            }
            $slug = $baseSlug . '-' . $counter;
            $counter++;
        }

        return $slug;
    }

    /**
     * Get count of active forms.
     */
    public function getActiveCount(): int
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT COUNT(*) as cnt FROM `' . self::TABLE . '` WHERE status = :status',
                ['status' => 'active']
            );
            return is_array($result) && !empty($result) ? (int)($result[0]['cnt'] ?? 0) : 0;
        } catch (\Exception $e) {
            return 0;
        }
    }

    /**
     * Get count of all forms.
     */
    public function getTotalCount(): int
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT COUNT(*) as cnt FROM `' . self::TABLE . '`',
                []
            );
            return is_array($result) && !empty($result) ? (int)($result[0]['cnt'] ?? 0) : 0;
        } catch (\Exception $e) {
            return 0;
        }
    }
}
