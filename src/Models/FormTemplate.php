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
        return $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` ORDER BY sort_order ASC, name ASC',
            []
        );
    }

    public function getById(int $id): ?object
    {
        $result = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE id = :id LIMIT 1',
            ['id' => $id]
        );
        return !empty($result) ? (object)$result[0] : null;
    }

    public function getByCategory(string $category): array
    {
        return $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE category = :cat ORDER BY sort_order ASC',
            ['cat' => $category]
        );
    }
}
