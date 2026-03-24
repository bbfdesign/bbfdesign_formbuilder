<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class FormConfirmation
{
    public const TABLE = 'bbf_formbuilder_confirmations';
    public const TABLE_LANG = 'bbf_formbuilder_confirmation_lang';

    private $db;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    public function getByFormId(int $formId): array
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` WHERE form_id = :fid ORDER BY sort_order ASC',
                ['fid' => $formId]
            );
            return is_array($result) ? $result : [];
        } catch (\Throwable $e) {
            return [];
        }
    }

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

    public function create(array $data): int
    {
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE . '` (form_id, name, type, message, redirect_url, page_id, is_default, conditional_logic_json, sort_order)
             VALUES (:form_id, :name, :type, :message, :redirect_url, :page_id, :is_default, :conditional_logic_json, :sort_order)',
            [
                'form_id'              => $data['form_id'],
                'name'                 => $data['name'],
                'type'                 => $data['type'] ?? 'message',
                'message'              => $data['message'] ?? null,
                'redirect_url'         => $data['redirect_url'] ?? null,
                'page_id'              => $data['page_id'] ?? null,
                'is_default'           => $data['is_default'] ?? 0,
                'conditional_logic_json' => $data['conditional_logic_json'] ?? null,
                'sort_order'           => $data['sort_order'] ?? 0,
            ]
        );
        $result = $this->db->queryPrepared('SELECT LAST_INSERT_ID() as id', []);
        return (int)($result[0]['id'] ?? 0);
    }

    public function update(int $id, array $data): void
    {
        $sets = [];
        $params = ['id' => $id];
        foreach ($data as $key => $value) {
            if ($key !== 'id') {
                $sets[] = "`{$key}` = :{$key}";
                $params[$key] = $value;
            }
        }
        if (!empty($sets)) {
            $this->db->queryPrepared(
                'UPDATE `' . self::TABLE . '` SET ' . implode(', ', $sets) . ' WHERE id = :id',
                $params
            );
        }
    }

    public function delete(int $id): void
    {
        $this->db->queryPrepared('DELETE FROM `' . self::TABLE . '` WHERE id = :id', ['id' => $id]);
    }

    public function saveLang(int $confirmationId, string $langIso, array $data): void
    {
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE_LANG . '` (confirmation_id, lang_iso, message, redirect_url)
             VALUES (:cid, :lang, :message, :redirect_url)
             ON DUPLICATE KEY UPDATE message = VALUES(message), redirect_url = VALUES(redirect_url)',
            [
                'cid'          => $confirmationId,
                'lang'         => $langIso,
                'message'      => $data['message'] ?? null,
                'redirect_url' => $data['redirect_url'] ?? null,
            ]
        );
    }
}
