<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

/**
 * Create API Connector tables: connections, endpoints, logs.
 */
class Migration20260327100001 extends Migration implements IMigration
{
    public function up(): void
    {
        $this->execute("
            CREATE TABLE IF NOT EXISTS bbf_formbuilder_api_connections (
                id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                name        VARCHAR(200) NOT NULL,
                description TEXT,
                base_url    VARCHAR(500) NOT NULL,
                auth_type   ENUM('none','api_key','bearer','basic','oauth2') DEFAULT 'none',
                auth_config JSON COMMENT 'Verschlüsselt: Keys, Tokens, Secrets',
                headers     JSON COMMENT 'Statische Headers',
                timeout     INT DEFAULT 30,
                active      TINYINT(1) DEFAULT 1,
                created_at  DATETIME DEFAULT NOW(),
                updated_at  DATETIME DEFAULT NOW() ON UPDATE NOW()
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ");

        $this->execute("
            CREATE TABLE IF NOT EXISTS bbf_formbuilder_api_endpoints (
                id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                connection_id INT UNSIGNED NOT NULL,
                name          VARCHAR(200) NOT NULL,
                method        ENUM('GET','POST','PUT','PATCH','DELETE') DEFAULT 'POST',
                path          VARCHAR(500) NOT NULL COMMENT 'z.B. /api/v1/returns',
                content_type  VARCHAR(100) DEFAULT 'application/json',
                trigger_on    ENUM('submit','conditional') DEFAULT 'submit',
                field_mapping JSON COMMENT 'Mapping Formularfeld → API-Feld',
                transformers  JSON COMMENT 'Transformer-Konfiguration',
                response_map  JSON COMMENT 'Response-Felder → Bestätigungstext',
                error_map     JSON COMMENT 'Fehler-Codes → Fehlermeldungen',
                active        TINYINT(1) DEFAULT 1,
                FOREIGN KEY (connection_id)
                    REFERENCES bbf_formbuilder_api_connections(id) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ");

        $this->execute("
            CREATE TABLE IF NOT EXISTS bbf_formbuilder_api_logs (
                id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                endpoint_id INT UNSIGNED,
                form_id     INT UNSIGNED,
                entry_id    INT UNSIGNED,
                request     JSON,
                response    JSON,
                status_code SMALLINT,
                duration_ms INT,
                success     TINYINT(1),
                error_msg   TEXT,
                created_at  DATETIME DEFAULT NOW(),
                INDEX idx_form (form_id),
                INDEX idx_endpoint (endpoint_id),
                INDEX idx_created (created_at)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ");
    }

    public function down(): void
    {
        $this->execute('DROP TABLE IF EXISTS bbf_formbuilder_api_logs');
        $this->execute('DROP TABLE IF EXISTS bbf_formbuilder_api_endpoints');
        $this->execute('DROP TABLE IF EXISTS bbf_formbuilder_api_connections');
    }
}
