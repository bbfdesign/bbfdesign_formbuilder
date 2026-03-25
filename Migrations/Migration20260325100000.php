<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

/**
 * Add GrapesJS columns to forms table.
 */
class Migration20260325100000 extends Migration implements IMigration
{
    public function up(): void
    {
        // Add GrapesJS data columns if they don't exist
        $cols = $this->getDB()->queryPrepared(
            "SELECT COLUMN_NAME FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bbf_formbuilder_forms'
             AND COLUMN_NAME = 'gjs_data'", []
        );

        if (empty($cols) || !is_array($cols)) {
            $this->execute("ALTER TABLE bbf_formbuilder_forms
                ADD COLUMN gjs_data LONGTEXT NULL AFTER fields_json,
                ADD COLUMN html_rendered LONGTEXT NULL AFTER gjs_data,
                ADD COLUMN css_rendered LONGTEXT NULL AFTER html_rendered
            ");
        }
    }

    public function down(): void
    {
        $this->execute("ALTER TABLE bbf_formbuilder_forms
            DROP COLUMN IF EXISTS gjs_data,
            DROP COLUMN IF EXISTS html_rendered,
            DROP COLUMN IF EXISTS css_rendered
        ");
    }
}
