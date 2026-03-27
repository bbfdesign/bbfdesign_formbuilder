<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use BbfdesignFormbuilder\Services\EncryptionService;
use JTL\Shop;

class ApiConnection
{
    public const TABLE = 'bbf_formbuilder_api_connections';

    private $db;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    public function getAll(): array
    {
        try {
            $rows = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` ORDER BY name ASC',
                []
            );
            return is_array($rows) ? $rows : [];
        } catch (\Throwable $e) {
            return [];
        }
    }

    public function getActive(): array
    {
        try {
            $rows = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE . '` WHERE active = 1 ORDER BY name ASC',
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
            if (empty($result) || !is_array($result)) {
                return null;
            }
            $row = (object)$result[0];
            // Auth-Config entschlüsseln
            if (!empty($row->auth_config)) {
                try {
                    $enc = new EncryptionService();
                    $row->auth_config = $enc->decrypt($row->auth_config);
                } catch (\Throwable $e) {
                    // Kann nicht entschlüsselt werden — evtl. unverschlüsselt
                }
            }
            return $row;
        } catch (\Throwable $e) {
            return null;
        }
    }

    public function create(array $data): int
    {
        // Auth-Config verschlüsseln
        $authConfig = $data['auth_config'] ?? '{}';
        if (!empty($authConfig) && $authConfig !== '{}') {
            try {
                $enc = new EncryptionService();
                $authConfig = $enc->encrypt($authConfig);
            } catch (\Throwable $e) {
                // Unverschlüsselt speichern als Fallback
            }
        }

        return (int)$this->db->insert(self::TABLE, (object)[
            'name' => $data['name'] ?? '',
            'description' => $data['description'] ?? '',
            'base_url' => $data['base_url'] ?? '',
            'auth_type' => $data['auth_type'] ?? 'none',
            'auth_config' => $authConfig,
            'headers' => $data['headers'] ?? '{}',
            'timeout' => (int)($data['timeout'] ?? 30),
            'active' => (int)($data['active'] ?? 1),
        ]);
    }

    public function update(int $id, array $data): void
    {
        $sets = [];
        $params = ['id' => $id];
        $allowed = ['name', 'description', 'base_url', 'auth_type', 'auth_config', 'headers', 'timeout', 'active'];

        foreach ($allowed as $field) {
            if (!array_key_exists($field, $data)) continue;
            $value = $data[$field];

            // Auth-Config verschlüsseln
            if ($field === 'auth_config' && !empty($value) && $value !== '{}') {
                try {
                    $enc = new EncryptionService();
                    $value = $enc->encrypt($value);
                } catch (\Throwable $e) {}
            }

            $sets[] = "`{$field}` = :{$field}";
            $params[$field] = $value;
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
