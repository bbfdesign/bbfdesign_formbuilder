<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Hooks;

use BbfdesignFormbuilder\Smarty\FormBuilderSmartyPlugin;
use JTL\Plugin\PluginInterface;
use JTL\Shop;

class AfterSmartyInitialize
{
    private array $args;
    private PluginInterface $plugin;
    private array $settings;

    public function __construct(array $args, PluginInterface $plugin, array $settings)
    {
        $this->args = $args;
        $this->plugin = $plugin;
        $this->settings = $settings;
    }

    public function execute(): void
    {
        $smarty = $this->args['smarty'] ?? Shop::Smarty();

        // Register the {bbf_form} Smarty plugin
        if ($smarty !== null && method_exists($smarty, 'registerPlugin')) {
            $smarty->registerPlugin('function', 'bbf_form', [FormBuilderSmartyPlugin::class, 'render']);
        }
    }
}
