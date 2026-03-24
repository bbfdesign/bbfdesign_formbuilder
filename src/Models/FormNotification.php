<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class FormNotification
{
    public const TABLE = 'bbf_formbuilder_notifications';
    public const TABLE_LANG = 'bbf_formbuilder_notification_lang';

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
            'INSERT INTO `' . self::TABLE . '` (form_id, name, is_active, recipient_type, recipient_email, recipient_field, reply_to_field, subject, message, email_template, custom_template_id, sender_name, sender_email, cc, bcc, attach_uploads, conditional_logic_json, sort_order)
             VALUES (:form_id, :name, :is_active, :recipient_type, :recipient_email, :recipient_field, :reply_to_field, :subject, :message, :email_template, :custom_template_id, :sender_name, :sender_email, :cc, :bcc, :attach_uploads, :conditional_logic_json, :sort_order)',
            [
                'form_id'              => $data['form_id'],
                'name'                 => $data['name'],
                'is_active'            => $data['is_active'] ?? 1,
                'recipient_type'       => $data['recipient_type'] ?? 'fixed',
                'recipient_email'      => $data['recipient_email'] ?? null,
                'recipient_field'      => $data['recipient_field'] ?? null,
                'reply_to_field'       => $data['reply_to_field'] ?? null,
                'subject'              => $data['subject'],
                'message'              => $data['message'],
                'email_template'       => $data['email_template'] ?? 'standard',
                'custom_template_id'   => $data['custom_template_id'] ?? null,
                'sender_name'          => $data['sender_name'] ?? null,
                'sender_email'         => $data['sender_email'] ?? null,
                'cc'                   => $data['cc'] ?? null,
                'bcc'                  => $data['bcc'] ?? null,
                'attach_uploads'       => $data['attach_uploads'] ?? 0,
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

    public function saveLang(int $notificationId, string $langIso, array $data): void
    {
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE_LANG . '` (notification_id, lang_iso, subject, message)
             VALUES (:nid, :lang, :subject, :message)
             ON DUPLICATE KEY UPDATE subject = VALUES(subject), message = VALUES(message)',
            [
                'nid'     => $notificationId,
                'lang'    => $langIso,
                'subject' => $data['subject'] ?? null,
                'message' => $data['message'] ?? null,
            ]
        );
    }
}
