<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

/**
 * Add allow_in_account column to forms table for Kundenkonto integration.
 */
class Migration20260327100000 extends Migration implements IMigration
{
    public function up(): void
    {
        // Add allow_in_account column if it doesn't exist
        $cols = $this->getDB()->queryPrepared(
            "SELECT COLUMN_NAME FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bbf_formbuilder_forms'
             AND COLUMN_NAME = 'allow_in_account'", []
        );

        if (empty($cols) || !is_array($cols)) {
            $this->execute("ALTER TABLE bbf_formbuilder_forms
                ADD COLUMN allow_in_account TINYINT(1) DEFAULT 1 AFTER is_searchable,
                ADD INDEX idx_allow_account (allow_in_account)
            ");
        }
    }

    public function down(): void
    {
        $this->execute("ALTER TABLE bbf_formbuilder_forms
            DROP INDEX IF EXISTS idx_allow_account,
            DROP COLUMN IF EXISTS allow_in_account
        ");
    }
}
