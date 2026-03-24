<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder;

require_once __DIR__ . '/vendor/autoload.php';

use BbfdesignFormbuilder\Controllers\Admin\AdminController;
use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;
use BbfdesignFormbuilder\Hooks\IncludeJsCssAssets;
use BbfdesignFormbuilder\Hooks\AfterSmartyInitialize;
use BbfdesignFormbuilder\Route;
use JTL\Events\Dispatcher;
use JTL\Plugin\Bootstrapper;
use JTL\Shop;
use JTL\Smarty\JTLSmarty;
use JTL\Helpers\Form;
use Exception;

class Bootstrap extends Bootstrapper
{
    /**
     * @inheritdoc
     */
    public function boot(Dispatcher $dispatcher): void
    {
        parent::boot($dispatcher);
        $plugin = $this->getPlugin();

        $pluginHelper = new PluginHelper($plugin);
        $pluginSettings = $pluginHelper->getSettings();

        if (Shop::isFrontend()) {
            if (!empty($pluginSettings[Setting::PLUGIN_STATUS])) {
                $dispatcher->listen('shop.hook.' . \HOOK_LETZTERINCLUDE_CSS_JS, static function (array $args) use ($plugin, $pluginSettings) {
                    $hook = new IncludeJsCssAssets($args, $plugin, $pluginSettings);
                    $hook->execute();
                });

                $dispatcher->listen('shop.hook.' . \HOOK_SMARTY_INC, static function (array $args) use ($plugin, $pluginSettings) {
                    $hook = new AfterSmartyInitialize($args, $plugin, $pluginSettings);
                    $hook->execute();
                });
            }
        }

        // Register frontend routes (submit endpoint, ALTCHA challenge)
        if (\defined('HOOK_ROUTER_PRE_DISPATCH')) {
            $dispatcher->listen('shop.hook.' . \HOOK_ROUTER_PRE_DISPATCH, function (array $args) use ($plugin, $pluginSettings) {
                $route = new Route($args, $plugin, $pluginSettings);
                $route->register();
            });
        }

        // Register with BBF Suchplugin (if available)
        $dispatcher->listen('shop.hook.' . \HOOK_LETZTERINCLUDE_INC, function () {
            if (class_exists('\\Plugin\\bbfdesign_search\\Search\\SearchProviderRegistry')) {
                $registry = \Plugin\bbfdesign_search\Search\SearchProviderRegistry::getInstance();
                $registry->register(new \BbfdesignFormbuilder\Search\FormBuilderSearchProvider());
            }
        });
    }

    public function installed()
    {
        parent::installed();
        $settingObj = new Setting();
        $settingObj->saveDefaultSettings();
    }

    public function updated($oldVersion, $newVersion)
    {
        parent::updated($oldVersion, $newVersion);
        $settingObj = new Setting();
        $settingObj->addMissingSettings();
    }

    public function renderAdminMenuTab(string $tabName, int $menuID, JTLSmarty $smarty): string
    {
        $plugin = $this->getPlugin();
        $adminLang = $_SESSION['AdminAccount']->language ?? 'de-DE';
        $adminLang = ($adminLang === 'de-DE') ? 'ger' : 'eng';

        $tplPath = $plugin->getPaths()->getAdminPath() . 'templates/';
        $smarty->assign([
            'plugin'        => $plugin,
            'langVars'      => $plugin->getLocalization(),
            'postURL'       => $plugin->getPaths()->getBackendURL(),
            'tplPath'       => $tplPath,
            'ShopURL'       => Shop::getURL(),
            'adminUrl'      => $plugin->getPaths()->getAdminURL(),
            'pluginVersion' => $plugin->getCurrentVersion(),
            'activePageName' => '',
            'adminLang'     => $adminLang,
        ]);

        if ($tabName === 'Einstellungen') {
            if (isset($_REQUEST['is_ajax']) && (int)$_REQUEST['is_ajax'] === 1) {
                try {
                    $csrf = $_REQUEST['jtl_token'] ?? '';
                    if (empty($csrf) || !Form::validateToken($csrf)) {
                        \header('Content-Type: application/json');
                        die(\json_encode([
                            'flag'   => false,
                            'errors' => ['Missing or wrong CSRF token']
                        ]));
                    }

                    $controller = new AdminController($this->getPlugin());
                    \header('Content-Type: application/json');
                    die(\json_encode($controller->handleAjax(), JSON_THROW_ON_ERROR));
                } catch (Exception $ex) {
                    \header('Content-Type: application/json');
                    die(\json_encode([
                        'flag'   => false,
                        'errors' => [$ex->getMessage()]
                    ]));
                }
            }

            return $smarty->fetch($tplPath . 'index.tpl');
        }

        return parent::renderAdminMenuTab($tabName, $menuID, $smarty);
    }
}
