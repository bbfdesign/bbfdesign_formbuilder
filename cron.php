<?php

/**
 * bbfdesign Formbuilder – DSGVO Auto-Löschung Cron
 *
 * Löscht Formulareinträge die älter sind als die konfigurierte Aufbewahrungsfrist.
 *
 * Aufruf per System-Cronjob:
 *   php /pfad/zum/shop/plugins/bbfdesign_formbuilder/cron.php
 *
 * Empfohlener Crontab-Eintrag (einmal täglich):
 *   0 3 * * * php /var/www/shop/plugins/bbfdesign_formbuilder/cron.php >> /var/log/bbfdesign-formbuilder.log 2>&1
 */

declare(strict_types=1);

// Boot JTL Shop
$shopRoot = null;
$candidates = [
    realpath(__DIR__ . '/../../'),
    realpath(__DIR__ . '/../../../'),
];
foreach ($candidates as $candidate) {
    if ($candidate && file_exists($candidate . '/includes/globalinclude.php')) {
        $shopRoot = $candidate;
        break;
    }
}

if ($shopRoot === null) {
    fwrite(STDERR, "Shop root not found.\n");
    exit(1);
}

// Minimal JTL bootstrap
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_HOST'] ?? 'localhost';
$_SERVER['REQUEST_URI'] = $_SERVER['REQUEST_URI'] ?? '/';

require_once $shopRoot . '/includes/globalinclude.php';

// Load plugin autoloader
require_once __DIR__ . '/vendor/autoload.php';

use BbfdesignFormbuilder\Models\FormEntry;
use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;

echo "[" . date('Y-m-d H:i:s') . "] BBF Formbuilder DSGVO Cron gestartet\n";

// Get auto-delete setting
$autoDeleteDays = (int)(PluginHelper::getSetting(Setting::AUTO_DELETE_DAYS) ?: 0);

if ($autoDeleteDays <= 0) {
    echo "Auto-Löschung deaktiviert (0 Tage).\n";
    exit(0);
}

$entryModel = new FormEntry();
$deleted = $entryModel->deleteOlderThan($autoDeleteDays);

echo "Einträge älter als {$autoDeleteDays} Tage gelöscht: {$deleted}\n";

// Also clean up spam log entries older than 90 days
$db = JTL\Shop::Container()->getDB();
$db->queryPrepared(
    'DELETE FROM bbf_formbuilder_spam_log WHERE created_at < DATE_SUB(NOW(), INTERVAL 90 DAY)',
    []
);

echo "[" . date('Y-m-d H:i:s') . "] Cron abgeschlossen.\n";
