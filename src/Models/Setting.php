<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Models;

use JTL\Shop;

class Setting
{
    public const TABLE = 'bbf_formbuilder_settings';

    public const PLUGIN_STATUS            = 'plugin_status';
    public const DEFAULT_FROM_EMAIL       = 'default_from_email';
    public const DEFAULT_FROM_NAME        = 'default_from_name';
    public const CAPTCHA_PROVIDER         = 'captcha_provider';
    public const HONEYPOT_ENABLED         = 'honeypot_enabled';
    public const TIMING_ENABLED           = 'timing_enabled';
    public const TIMING_MIN_SECONDS       = 'timing_min_seconds';
    public const RATE_LIMIT_ENABLED       = 'rate_limit_enabled';
    public const RATE_LIMIT_MAX           = 'rate_limit_max';
    public const RATE_LIMIT_WINDOW        = 'rate_limit_window';
    public const RECAPTCHA_SITE_KEY       = 'recaptcha_site_key';
    public const RECAPTCHA_SECRET_KEY     = 'recaptcha_secret_key';
    public const TURNSTILE_SITE_KEY       = 'turnstile_site_key';
    public const TURNSTILE_SECRET_KEY     = 'turnstile_secret_key';
    public const FRIENDLY_CAPTCHA_SITE_KEY = 'friendly_captcha_site_key';
    public const FRIENDLY_CAPTCHA_SECRET  = 'friendly_captcha_secret';
    public const ALTCHA_HMAC_KEY          = 'altcha_hmac_key';
    public const ENCRYPTION_ENABLED       = 'encryption_enabled';
    public const IP_ANONYMIZATION         = 'ip_anonymization';
    public const AUTO_DELETE_DAYS         = 'auto_delete_days';
    public const CUSTOM_CSS               = 'custom_css';
    public const GDPR_CHECKBOX_TEXT       = 'gdpr_checkbox_text';

    private $db;
    private static ?bool $tableExists = null;

    public function __construct()
    {
        $this->db = Shop::Container()->getDB();
    }

    /**
     * Check if the settings table exists (cached).
     */
    private function tableExists(): bool
    {
        if (self::$tableExists !== null) {
            return self::$tableExists;
        }
        try {
            $result = $this->db->queryPrepared(
                "SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = :tbl LIMIT 1",
                ['tbl' => self::TABLE]
            );
            self::$tableExists = is_array($result) && !empty($result);
        } catch (\Throwable $e) {
            self::$tableExists = false;
        }
        return self::$tableExists;
    }

    /**
     * Default settings with their initial values and groups.
     */
    public static function getDefaults(): array
    {
        return [
            self::PLUGIN_STATUS            => ['value' => '1', 'group' => 'general'],
            self::DEFAULT_FROM_EMAIL       => ['value' => '', 'group' => 'email'],
            self::DEFAULT_FROM_NAME        => ['value' => '', 'group' => 'email'],
            self::CAPTCHA_PROVIDER         => ['value' => 'altcha', 'group' => 'spam'],
            self::HONEYPOT_ENABLED         => ['value' => '1', 'group' => 'spam'],
            self::TIMING_ENABLED           => ['value' => '1', 'group' => 'spam'],
            self::TIMING_MIN_SECONDS       => ['value' => '3', 'group' => 'spam'],
            self::RATE_LIMIT_ENABLED       => ['value' => '1', 'group' => 'spam'],
            self::RATE_LIMIT_MAX           => ['value' => '10', 'group' => 'spam'],
            self::RATE_LIMIT_WINDOW        => ['value' => '3600', 'group' => 'spam'],
            self::RECAPTCHA_SITE_KEY       => ['value' => '', 'group' => 'spam'],
            self::RECAPTCHA_SECRET_KEY     => ['value' => '', 'group' => 'spam'],
            self::TURNSTILE_SITE_KEY       => ['value' => '', 'group' => 'spam'],
            self::TURNSTILE_SECRET_KEY     => ['value' => '', 'group' => 'spam'],
            self::FRIENDLY_CAPTCHA_SITE_KEY => ['value' => '', 'group' => 'spam'],
            self::FRIENDLY_CAPTCHA_SECRET  => ['value' => '', 'group' => 'spam'],
            self::ALTCHA_HMAC_KEY          => ['value' => '', 'group' => 'spam'],
            self::ENCRYPTION_ENABLED       => ['value' => '0', 'group' => 'security'],
            self::IP_ANONYMIZATION         => ['value' => 'last_octet', 'group' => 'gdpr'],
            self::AUTO_DELETE_DAYS         => ['value' => '365', 'group' => 'gdpr'],
            self::CUSTOM_CSS               => ['value' => '', 'group' => 'appearance'],
            self::GDPR_CHECKBOX_TEXT       => [
                'value' => 'Ich stimme der Verarbeitung meiner Daten gemäß der <a href="/datenschutz">Datenschutzerklärung</a> zu.',
                'group' => 'gdpr',
            ],
        ];
    }

    /**
     * Save default settings on install.
     */
    public function saveDefaultSettings(): void
    {
        foreach (self::getDefaults() as $key => $config) {
            $value = $config['value'];
            if ($key === self::ALTCHA_HMAC_KEY && empty($value)) {
                $value = bin2hex(random_bytes(32));
            }
            $this->db->queryPrepared(
                'INSERT IGNORE INTO `' . self::TABLE . '` (setting_key, setting_value, setting_group) VALUES (:key, :val, :grp)',
                ['key' => $key, 'val' => $value, 'grp' => $config['group']]
            );
        }
    }

    /**
     * Add any missing settings (on update).
     */
    public function addMissingSettings(): void
    {
        $existing = $this->db->queryPrepared(
            'SELECT setting_key FROM `' . self::TABLE . '`',
            []
        );
        $existingKeys = array_column($existing, 'setting_key');

        foreach (self::getDefaults() as $key => $config) {
            if (!in_array($key, $existingKeys, true)) {
                $value = $config['value'];
                if ($key === self::ALTCHA_HMAC_KEY && empty($value)) {
                    $value = bin2hex(random_bytes(32));
                }
                $this->db->queryPrepared(
                    'INSERT INTO `' . self::TABLE . '` (setting_key, setting_value, setting_group) VALUES (:key, :val, :grp)',
                    ['key' => $key, 'val' => $value, 'grp' => $config['group']]
                );
            }
        }
    }

    /**
     * Get all settings, optionally filtered by keys.
     */
    public function getAll(array $keys = []): array
    {
        if (!$this->tableExists()) {
            return [];
        }
        try {
            if (!empty($keys)) {
                $placeholders = implode(',', array_fill(0, count($keys), '?'));
                $result = $this->db->queryPrepared(
                    'SELECT setting_key, setting_value FROM `' . self::TABLE . '` WHERE setting_key IN (' . $placeholders . ')',
                    $keys
                );
            } else {
                $result = $this->db->queryPrepared(
                    'SELECT setting_key, setting_value FROM `' . self::TABLE . '`',
                    []
                );
            }
            return is_array($result) ? $result : [];
        } catch (\Throwable $e) {
            return [];
        }
    }

    /**
     * Get a single setting value.
     */
    public function get(string $key): ?string
    {
        if (!$this->tableExists()) {
            return null;
        }
        try {
            $row = $this->db->queryPrepared(
                'SELECT setting_value FROM `' . self::TABLE . '` WHERE setting_key = :key LIMIT 1',
                ['key' => $key]
            );
            return is_array($row) && !empty($row) ? $row[0]['setting_value'] : null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    /**
     * Set a setting value.
     */
    public function set(string $key, string $value): void
    {
        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET setting_value = :val WHERE setting_key = :key',
            ['val' => $value, 'key' => $key]
        );
    }
}
