<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class ApiEndpoint
{
    public const TABLE = 'bbf_formbuilder_api_endpoints';

    private $db;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    public function getAll(): array
    {
        try {
            $rows = $this->db->queryPrepared(
                'SELECT e.*, c.name AS connection_name, c.base_url
                 FROM `' . self::TABLE . '` e
                 LEFT JOIN `' . ApiConnection::TABLE . '` c ON c.id = e.connection_id
                 ORDER BY e.name ASC',
                []
            );
            return is_array($rows) ? $rows : [];
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

    /**
     * Aktive Endpunkte für ein bestimmtes Formular (trigger_on = submit).
     */
    public function getActiveForSubmit(): array
    {
        try {
            $rows = $this->db->queryPrepared(
                "SELECT e.*, c.base_url, c.auth_type, c.auth_config, c.headers AS connection_headers, c.timeout
                 FROM `" . self::TABLE . "` e
                 JOIN `" . ApiConnection::TABLE . "` c ON c.id = e.connection_id AND c.active = 1
                 WHERE e.active = 1 AND e.trigger_on = 'submit'
                 ORDER BY e.id ASC",
                []
            );
            return is_array($rows) ? $rows : [];
        } catch (\Throwable $e) {
            return [];
        }
    }

    public function create(array $data): int
    {
        return (int)$this->db->insert(self::TABLE, (object)[
            'connection_id' => (int)($data['connection_id'] ?? 0),
            'name' => $data['name'] ?? '',
            'method' => $data['method'] ?? 'POST',
            'path' => $data['path'] ?? '',
            'content_type' => $data['content_type'] ?? 'application/json',
            'trigger_on' => $data['trigger_on'] ?? 'submit',
            'field_mapping' => $data['field_mapping'] ?? '[]',
            'transformers' => $data['transformers'] ?? '[]',
            'response_map' => $data['response_map'] ?? '{}',
            'error_map' => $data['error_map'] ?? '{}',
            'active' => (int)($data['active'] ?? 1),
        ]);
    }

    public function update(int $id, array $data): void
    {
        $sets = [];
        $params = ['id' => $id];
        $allowed = ['connection_id', 'name', 'method', 'path', 'content_type',
                     'trigger_on', 'field_mapping', 'transformers', 'response_map',
                     'error_map', 'active'];

        foreach ($allowed as $field) {
            if (!array_key_exists($field, $data)) continue;
            $sets[] = "`{$field}` = :{$field}";
            $params[$field] = $data[$field];
        }

        if (empty($sets)) return;

        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET ' . implode(', ', $sets) . ' WHERE id = :id',
            $params
        );
    }

    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE id = :id',
            ['id' => $id]
        );
    }
}
