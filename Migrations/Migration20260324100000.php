<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

class Migration20260324100000 extends Migration implements IMigration
{
    public function up(): void
    {
        // 1. Main forms table
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_forms` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `title` VARCHAR(255) NOT NULL,
                `slug` VARCHAR(255) NOT NULL,
                `description` TEXT NULL DEFAULT NULL,
                `fields_json` LONGTEXT NOT NULL,
                `settings_json` TEXT NULL DEFAULT NULL,
                `css_classes` VARCHAR(500) NULL DEFAULT NULL,
                `status` ENUM('active','inactive','draft') NOT NULL DEFAULT 'draft',
                `is_multi_step` TINYINT(1) NOT NULL DEFAULT 0,
                `submit_button_text` VARCHAR(255) NOT NULL DEFAULT 'Absenden',
                `is_searchable` TINYINT(1) NOT NULL DEFAULT 0,
                `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                UNIQUE KEY `idx_slug` (`slug`),
                KEY `idx_status` (`status`),
                KEY `idx_created_at` (`created_at`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 2. Form translations
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_form_lang` (
                `form_id` INT UNSIGNED NOT NULL,
                `lang_iso` VARCHAR(5) NOT NULL,
                `title` VARCHAR(255) NULL DEFAULT NULL,
                `description` TEXT NULL DEFAULT NULL,
                `submit_button_text` VARCHAR(255) NULL DEFAULT NULL,
                `success_message` TEXT NULL DEFAULT NULL,
                `fields_lang_json` LONGTEXT NULL DEFAULT NULL,
                PRIMARY KEY (`form_id`, `lang_iso`),
                CONSTRAINT `fk_form_lang_form` FOREIGN KEY (`form_id`)
                    REFERENCES `bbf_formbuilder_forms` (`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 3. Form submissions / entries
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_entries` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `form_id` INT UNSIGNED NOT NULL,
                `values_json` LONGTEXT NOT NULL,
                `is_encrypted` TINYINT(1) NOT NULL DEFAULT 0,
                `ip_address` VARCHAR(45) NULL DEFAULT NULL,
                `user_agent` VARCHAR(500) NULL DEFAULT NULL,
                `referrer_url` VARCHAR(2048) NULL DEFAULT NULL,
                `page_url` VARCHAR(2048) NULL DEFAULT NULL,
                `customer_id` INT NULL DEFAULT NULL,
                `lang_iso` VARCHAR(5) NULL DEFAULT NULL,
                `is_read` TINYINT(1) NOT NULL DEFAULT 0,
                `is_starred` TINYINT(1) NOT NULL DEFAULT 0,
                `is_spam` TINYINT(1) NOT NULL DEFAULT 0,
                `is_trash` TINYINT(1) NOT NULL DEFAULT 0,
                `status` ENUM('new','read','replied','archived','trash') NOT NULL DEFAULT 'new',
                `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                KEY `idx_form_id` (`form_id`),
                KEY `idx_status` (`status`),
                KEY `idx_is_read` (`is_read`),
                KEY `idx_is_spam` (`is_spam`),
                KEY `idx_is_trash` (`is_trash`),
                KEY `idx_created_at` (`created_at`),
                KEY `idx_customer_id` (`customer_id`),
                CONSTRAINT `fk_entries_form` FOREIGN KEY (`form_id`)
                    REFERENCES `bbf_formbuilder_forms` (`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 4. Uploaded files
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_entry_files` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `entry_id` INT UNSIGNED NOT NULL,
                `field_id` VARCHAR(255) NOT NULL,
                `original_name` VARCHAR(500) NOT NULL,
                `stored_name` VARCHAR(500) NOT NULL,
                `file_path` VARCHAR(1024) NOT NULL,
                `mime_type` VARCHAR(255) NOT NULL,
                `file_size` INT UNSIGNED NOT NULL DEFAULT 0,
                `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                KEY `idx_entry_id` (`entry_id`),
                KEY `idx_field_id` (`field_id`),
                CONSTRAINT `fk_entry_files_entry` FOREIGN KEY (`entry_id`)
                    REFERENCES `bbf_formbuilder_entries` (`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 5. Email notifications
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_notifications` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `form_id` INT UNSIGNED NOT NULL,
                `name` VARCHAR(255) NOT NULL,
                `is_active` TINYINT(1) NOT NULL DEFAULT 1,
                `recipient_type` ENUM('custom','field','admin') NOT NULL DEFAULT 'admin',
                `recipient_email` VARCHAR(500) NULL DEFAULT NULL,
                `recipient_field` VARCHAR(255) NULL DEFAULT NULL,
                `reply_to_field` VARCHAR(255) NULL DEFAULT NULL,
                `subject` VARCHAR(500) NOT NULL,
                `message` TEXT NULL DEFAULT NULL,
                `email_template` ENUM('standard','fancy','custom') NOT NULL DEFAULT 'standard',
                `custom_template_id` INT UNSIGNED NULL DEFAULT NULL,
                `sender_name` VARCHAR(255) NULL DEFAULT NULL,
                `sender_email` VARCHAR(255) NULL DEFAULT NULL,
                `cc` VARCHAR(1000) NULL DEFAULT NULL,
                `bcc` VARCHAR(1000) NULL DEFAULT NULL,
                `attach_uploads` TINYINT(1) NOT NULL DEFAULT 0,
                `conditional_logic_json` TEXT NULL DEFAULT NULL,
                `sort_order` INT NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`),
                KEY `idx_form_id` (`form_id`),
                KEY `idx_is_active` (`is_active`),
                CONSTRAINT `fk_notifications_form` FOREIGN KEY (`form_id`)
                    REFERENCES `bbf_formbuilder_forms` (`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 6. Notification translations
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_notification_lang` (
                `notification_id` INT UNSIGNED NOT NULL,
                `lang_iso` VARCHAR(5) NOT NULL,
                `subject` VARCHAR(500) NULL DEFAULT NULL,
                `message` TEXT NULL DEFAULT NULL,
                PRIMARY KEY (`notification_id`, `lang_iso`),
                CONSTRAINT `fk_notification_lang_notification` FOREIGN KEY (`notification_id`)
                    REFERENCES `bbf_formbuilder_notifications` (`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 7. Confirmation actions
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_confirmations` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `form_id` INT UNSIGNED NOT NULL,
                `name` VARCHAR(255) NOT NULL,
                `type` ENUM('message','redirect','page') NOT NULL DEFAULT 'message',
                `message` TEXT NULL DEFAULT NULL,
                `redirect_url` VARCHAR(2048) NULL DEFAULT NULL,
                `page_id` INT NULL DEFAULT NULL,
                `is_default` TINYINT(1) NOT NULL DEFAULT 0,
                `conditional_logic_json` TEXT NULL DEFAULT NULL,
                `sort_order` INT NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`),
                KEY `idx_form_id` (`form_id`),
                KEY `idx_is_default` (`is_default`),
                CONSTRAINT `fk_confirmations_form` FOREIGN KEY (`form_id`)
                    REFERENCES `bbf_formbuilder_forms` (`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 8. Confirmation translations
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_confirmation_lang` (
                `confirmation_id` INT UNSIGNED NOT NULL,
                `lang_iso` VARCHAR(5) NOT NULL,
                `message` TEXT NULL DEFAULT NULL,
                `redirect_url` VARCHAR(2048) NULL DEFAULT NULL,
                PRIMARY KEY (`confirmation_id`, `lang_iso`),
                CONSTRAINT `fk_confirmation_lang_confirmation` FOREIGN KEY (`confirmation_id`)
                    REFERENCES `bbf_formbuilder_confirmations` (`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 9. Form templates
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_templates` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `name` VARCHAR(255) NOT NULL,
                `description` TEXT NULL DEFAULT NULL,
                `category` VARCHAR(100) NULL DEFAULT NULL,
                `icon` VARCHAR(100) NULL DEFAULT NULL,
                `fields_json` LONGTEXT NOT NULL,
                `settings_json` TEXT NULL DEFAULT NULL,
                `notifications_json` TEXT NULL DEFAULT NULL,
                `is_system` TINYINT(1) NOT NULL DEFAULT 0,
                `sort_order` INT NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`),
                KEY `idx_category` (`category`),
                KEY `idx_is_system` (`is_system`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 10. Email templates
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_email_templates` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `name` VARCHAR(255) NOT NULL,
                `type` ENUM('standard','fancy','custom') NOT NULL DEFAULT 'custom',
                `html_template` LONGTEXT NOT NULL,
                `is_system` TINYINT(1) NOT NULL DEFAULT 0,
                `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                KEY `idx_type` (`type`),
                KEY `idx_is_system` (`is_system`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 11. Plugin settings
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_settings` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `setting_key` VARCHAR(255) NOT NULL,
                `setting_value` TEXT NULL DEFAULT NULL,
                `setting_group` VARCHAR(100) NULL DEFAULT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY `idx_setting_key` (`setting_key`),
                KEY `idx_setting_group` (`setting_group`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // 12. Spam log
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_formbuilder_spam_log` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `form_id` INT UNSIGNED NULL DEFAULT NULL,
                `ip_address` VARCHAR(45) NULL DEFAULT NULL,
                `reason` VARCHAR(255) NOT NULL,
                `details` TEXT NULL DEFAULT NULL,
                `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                KEY `idx_form_id` (`form_id`),
                KEY `idx_ip_address` (`ip_address`),
                KEY `idx_created_at` (`created_at`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
    }

    public function down(): void
    {
        // Drop in reverse FK dependency order
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_spam_log`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_settings`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_email_templates`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_templates`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_confirmation_lang`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_confirmations`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_notification_lang`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_notifications`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_entry_files`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_entries`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_form_lang`');
        $this->execute('DROP TABLE IF EXISTS `bbf_formbuilder_forms`');
    }
}
