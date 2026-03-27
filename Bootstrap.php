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

        // Frontend hooks — settings loaded lazily inside the hook closures
        // to avoid querying the DB before tables exist (pre-install)
        if (Shop::isFrontend()) {
            $dispatcher->listen('shop.hook.' . \HOOK_LETZTERINCLUDE_CSS_JS, static function (array $args) use ($plugin) {
                $settings = PluginHelper::getSettings();
                if (!empty($settings[Setting::PLUGIN_STATUS])) {
                    $hook = new IncludeJsCssAssets($args, $plugin, $settings);
                    $hook->execute();
                }
            });

            $dispatcher->listen('shop.hook.' . \HOOK_SMARTY_INC, static function (array $args) use ($plugin) {
                $settings = PluginHelper::getSettings();
                if (!empty($settings[Setting::PLUGIN_STATUS])) {
                    $hook = new AfterSmartyInitialize($args, $plugin, $settings);
                    $hook->execute();
                }
            });
        }

        // [bbf_form] Shortcode im HTML-Output ersetzen
        if (Shop::isFrontend()) {
            $dispatcher->listen('shop.hook.' . \HOOK_SMARTY_OUTPUTFILTER, static function (array $args) {
                if (!isset($args['output'])) {
                    return;
                }
                // Nur verarbeiten wenn [bbf_form im Output vorkommt
                if (strpos($args['output'], '[bbf_form') === false) {
                    return;
                }
                $args['output'] = preg_replace_callback(
                    '/\[bbf_form\s+id=["\']?(\d+)["\']?(?:\s+([^\]]*))?\]/',
                    static function (array $matches): string {
                        $formId = (int)$matches[1];
                        $attribs = $matches[2] ?? '';
                        $params = [];
                        if (preg_match_all('/(\w+)=["\']([^"\']*)["\']/', $attribs, $attrMatches, PREG_SET_ORDER)) {
                            foreach ($attrMatches as $am) {
                                $params[$am[1]] = $am[2];
                            }
                        }
                        try {
                            $renderer = new \BbfdesignFormbuilder\Services\FormRenderService();
                            return $renderer->renderById($formId, [
                                'class' => $params['class'] ?? '',
                            ]);
                        } catch (\Throwable $e) {
                            return '<!-- BBF Formbuilder: ' . htmlspecialchars($e->getMessage()) . ' -->';
                        }
                    },
                    $args['output']
                );
            });
        }

        // Register frontend routes (submit endpoint, ALTCHA challenge)
        if (\defined('HOOK_ROUTER_PRE_DISPATCH')) {
            $dispatcher->listen('shop.hook.' . \HOOK_ROUTER_PRE_DISPATCH, function (array $args) use ($plugin) {
                $settings = PluginHelper::getSettings();
                $route = new Route($args, $plugin, $settings);
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
                \ob_start();
                try {
                    $csrf = $_REQUEST['jtl_token'] ?? '';
                    if (empty($csrf) || !Form::validateToken($csrf)) {
                        \ob_end_clean();
                        \header('Content-Type: application/json');
                        die(\json_encode([
                            'flag'   => false,
                            'errors' => ['Missing or wrong CSRF token']
                        ]));
                    }

                    $controller = new AdminController($this->getPlugin());
                    $result = $controller->handleAjax();
                    \ob_end_clean();
                    \header('Content-Type: application/json');
                    die(\json_encode($result, JSON_THROW_ON_ERROR));
                } catch (\Throwable $ex) {
                    \ob_end_clean();
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
