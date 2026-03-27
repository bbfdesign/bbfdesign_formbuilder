<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class ApiLog
{
    public const TABLE = 'bbf_formbuilder_api_logs';

    private $db;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    public function getAll(array $filters = [], int $limit = 50, int $offset = 0): array
    {
        try {
            $where = '1=1';
            $params = [];

            if (!empty($filters['endpoint_id'])) {
                $where .= ' AND l.endpoint_id = :eid';
                $params['eid'] = (int)$filters['endpoint_id'];
            }
            if (isset($filters['success'])) {
                $where .= ' AND l.success = :suc';
                $params['suc'] = (int)$filters['success'];
            }

            $params['lim'] = $limit;
            $params['off'] = $offset;

            $rows = $this->db->queryPrepared(
                "SELECT l.*, e.name AS endpoint_name, e.method, e.path
                 FROM `" . self::TABLE . "` l
                 LEFT JOIN `" . ApiEndpoint::TABLE . "` e ON e.id = l.endpoint_id
                 WHERE {$where}
                 ORDER BY l.created_at DESC
                 LIMIT :lim OFFSET :off",
                $params
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

    public function create(array $data): int
    {
        return (int)$this->db->insert(self::TABLE, (object)[
            'endpoint_id' => $data['endpoint_id'] ?? null,
            'form_id' => $data['form_id'] ?? null,
            'entry_id' => $data['entry_id'] ?? null,
            'request' => $data['request'] ?? '{}',
            'response' => $data['response'] ?? '{}',
            'status_code' => $data['status_code'] ?? 0,
            'duration_ms' => $data['duration_ms'] ?? 0,
            'success' => (int)($data['success'] ?? 0),
            'error_msg' => $data['error_msg'] ?? null,
        ]);
    }

    /**
     * Alte Logs aufräumen (> X Tage).
     */
    public function cleanup(int $days = 90): int
    {
        try {
            $this->db->queryPrepared(
                'DELETE FROM `' . self::TABLE . '` WHERE created_at < DATE_SUB(NOW(), INTERVAL :days DAY)',
                ['days' => $days]
            );
            return 1;
        } catch (\Throwable $e) {
            return 0;
        }
    }
}
