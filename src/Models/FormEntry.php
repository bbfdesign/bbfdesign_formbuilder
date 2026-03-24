<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class FormEntry
{
    public const TABLE = 'bbf_formbuilder_entries';
    public const TABLE_FILES = 'bbf_formbuilder_entry_files';

    private $db;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    /**
     * Get entries with optional filters.
     */
    public function getAll(array $filters = [], int $limit = 50, int $offset = 0): array
    {
        $sql = 'SELECT e.*, f.title as form_title
                FROM `' . self::TABLE . '` e
                LEFT JOIN `bbf_formbuilder_forms` f ON e.form_id = f.id
                WHERE 1=1';
        $params = [];

        if (!empty($filters['form_id'])) {
            $sql .= ' AND e.form_id = :form_id';
            $params['form_id'] = $filters['form_id'];
        }
        if (isset($filters['status'])) {
            $sql .= ' AND e.status = :status';
            $params['status'] = $filters['status'];
        }
        if (isset($filters['is_spam'])) {
            $sql .= ' AND e.is_spam = :is_spam';
            $params['is_spam'] = $filters['is_spam'];
        }
        if (isset($filters['is_trash'])) {
            $sql .= ' AND e.is_trash = :is_trash';
            $params['is_trash'] = $filters['is_trash'];
        } else {
            $sql .= ' AND e.is_trash = 0';
        }

        $sql .= ' ORDER BY e.created_at DESC LIMIT ' . (int)$limit . ' OFFSET ' . (int)$offset;

        try {
            $result = $this->db->queryPrepared($sql, $params);
            return is_array($result) ? $result : [];
        } catch (\Throwable $e) {
            return [];
        }
    }

    /**
     * Get a single entry by ID.
     */
    public function getById(int $id): ?object
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT e.*, f.title as form_title, f.fields_json
                 FROM `' . self::TABLE . '` e
                 LEFT JOIN `bbf_formbuilder_forms` f ON e.form_id = f.id
                 WHERE e.id = :id LIMIT 1',
                ['id' => $id]
            );
            return !empty($result) && is_array($result) ? (object)$result[0] : null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    /**
     * Create a new entry.
     */
    public function create(array $data): int
    {
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE . '` (form_id, values_json, is_encrypted, ip_address, user_agent, referrer_url, page_url, customer_id, lang_iso, status)
             VALUES (:form_id, :values_json, :is_encrypted, :ip_address, :user_agent, :referrer_url, :page_url, :customer_id, :lang_iso, :status)',
            [
                'form_id'      => $data['form_id'],
                'values_json'  => $data['values_json'],
                'is_encrypted' => $data['is_encrypted'] ?? 0,
                'ip_address'   => $data['ip_address'] ?? null,
                'user_agent'   => $data['user_agent'] ?? null,
                'referrer_url' => $data['referrer_url'] ?? null,
                'page_url'     => $data['page_url'] ?? null,
                'customer_id'  => $data['customer_id'] ?? null,
                'lang_iso'     => $data['lang_iso'] ?? null,
                'status'       => $data['status'] ?? 'unread',
            ]
        );

        $result = $this->db->queryPrepared('SELECT LAST_INSERT_ID() as id', []);
        return (int)($result[0]['id'] ?? 0);
    }

    /**
     * Update entry status.
     */
    public function updateStatus(int $id, string $status): void
    {
        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET status = :status, is_read = :is_read WHERE id = :id',
            ['status' => $status, 'is_read' => ($status !== 'unread') ? 1 : 0, 'id' => $id]
        );
    }

    /**
     * Mark entry as read.
     */
    public function markRead(int $id): void
    {
        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET is_read = 1, status = :status WHERE id = :id AND is_read = 0',
            ['status' => 'read', 'id' => $id]
        );
    }

    /**
     * Toggle star status.
     */
    public function toggleStar(int $id): void
    {
        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET is_starred = 1 - is_starred WHERE id = :id',
            ['id' => $id]
        );
    }

    /**
     * Move entry to trash.
     */
    public function trash(int $id): void
    {
        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET is_trash = 1, status = :status WHERE id = :id',
            ['status' => 'trash', 'id' => $id]
        );
    }

    /**
     * Permanently delete an entry.
     */
    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE id = :id',
            ['id' => $id]
        );
    }

    /**
     * Get entry count for a form.
     */
    public function getCountByForm(int $formId): int
    {
        $result = $this->db->queryPrepared(
            'SELECT COUNT(*) as cnt FROM `' . self::TABLE . '` WHERE form_id = :fid AND is_trash = 0',
            ['fid' => $formId]
        );
        return (int)($result[0]['cnt'] ?? 0);
    }

    /**
     * Get total entry count.
     */
    public function getTotalCount(): int
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT COUNT(*) as cnt FROM `' . self::TABLE . '` WHERE is_trash = 0',
                []
            );
            return is_array($result) && !empty($result) ? (int)($result[0]['cnt'] ?? 0) : 0;
        } catch (\Exception $e) {
            return 0;
        }
    }

    /**
     * Get unread entry count.
     */
    public function getUnreadCount(): int
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT COUNT(*) as cnt FROM `' . self::TABLE . '` WHERE is_read = 0 AND is_trash = 0 AND is_spam = 0',
                []
            );
            return is_array($result) && !empty($result) ? (int)($result[0]['cnt'] ?? 0) : 0;
        } catch (\Exception $e) {
            return 0;
        }
    }

    /**
     * Get recent entries.
     */
    public function getRecent(int $limit = 10): array
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT e.*, f.title as form_title
                 FROM `' . self::TABLE . '` e
                 LEFT JOIN `bbf_formbuilder_forms` f ON e.form_id = f.id
                 WHERE e.is_trash = 0 AND e.is_spam = 0
                 ORDER BY e.created_at DESC
                 LIMIT ' . (int)$limit,
                []
            );
            return is_array($result) ? $result : [];
        } catch (\Exception $e) {
            return [];
        }
    }

    /**
     * Delete entries older than X days.
     */
    public function deleteOlderThan(int $days): int
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE created_at < DATE_SUB(NOW(), INTERVAL :days DAY)',
            ['days' => $days]
        );
        // Return affected rows count (approximate)
        $result = $this->db->queryPrepared('SELECT ROW_COUNT() as cnt', []);
        return (int)($result[0]['cnt'] ?? 0);
    }

    /**
     * Get files for an entry.
     */
    public function getFiles(int $entryId): array
    {
        try {
            $result = $this->db->queryPrepared(
                'SELECT * FROM `' . self::TABLE_FILES . '` WHERE entry_id = :eid',
                ['eid' => $entryId]
            );
            return is_array($result) ? $result : [];
        } catch (\Throwable $e) {
            return [];
        }
    }

    /**
     * Save an uploaded file record.
     */
    public function saveFile(array $data): int
    {
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE_FILES . '` (entry_id, field_id, original_name, stored_name, file_path, mime_type, file_size)
             VALUES (:entry_id, :field_id, :original_name, :stored_name, :file_path, :mime_type, :file_size)',
            $data
        );
        $result = $this->db->queryPrepared('SELECT LAST_INSERT_ID() as id', []);
        return (int)($result[0]['id'] ?? 0);
    }
}
