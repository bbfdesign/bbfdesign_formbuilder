<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class EmailTemplate
{
    public const TABLE = 'bbf_formbuilder_email_templates';

    private $db;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    public function getAll(): array
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` ORDER BY is_system DESC, name ASC',
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

    public function getByType(string $type): ?object
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` WHERE type = :type AND is_system = 1 LIMIT 1',
                ['type' => $type]
            );
            return !empty($result) && is_array($result) ? (object)$result[0] : null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    public function create(array $data): int
    {
        return (int)$this->db->insert(self::TABLE, (object)[
            'name'          => $data['name'],
            'type'          => $data['type'] ?? 'custom',
            'html_template' => $data['html_template'],
            'is_system'     => (int)($data['is_system'] ?? 0),
        ]);
    }

    public function update(int $id, array $data): void
    {
        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET name = :name, html_template = :html WHERE id = :id AND is_system = 0',
            ['name' => $data['name'], 'html' => $data['html_template'], 'id' => $id]
        );
    }

    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE id = :id AND is_system = 0',
            ['id' => $id]
        );
    }
}
