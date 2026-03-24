<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class FormTemplate
{
    public const TABLE = 'bbf_formbuilder_templates';

    private $db;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    public function getAll(): array
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` ORDER BY sort_order ASC, name ASC',
                []
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

    public function getByCategory(string $category): array
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` WHERE category = :cat ORDER BY sort_order ASC',
                ['cat' => $category]
            );
            return is_array($result) ? $result : [];
        } catch (\Throwable $e) {
            return [];
        }
    }
}
