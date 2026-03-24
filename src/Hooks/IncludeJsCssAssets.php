<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Hooks;

use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;
use JTL\Plugin\PluginInterface;

class IncludeJsCssAssets
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
        $frontendUrl = $this->plugin->getPaths()->getFrontendURL();

        // CSS
        $css = '<link rel="stylesheet" href="' . $frontendUrl . 'css/formbuilder.css">' . "\n";

        // Custom CSS
        $customCss = PluginHelper::getSetting(Setting::CUSTOM_CSS);
        if (!empty($customCss)) {
            $css .= '<style>' . $customCss . '</style>' . "\n";
        }

        // JS
        $js = '<script src="' . $frontendUrl . 'js/formbuilder.js" defer></script>' . "\n";
        $js .= '<script src="' . $frontendUrl . 'js/validation.js" defer></script>' . "\n";

        // Append to head/body
        if (isset($this->args['cCSS_arr'])) {
            $this->args['cCSS_arr'][] = $css;
        }
        pq('head')->append($css);
        pq('body')->append($js);
    }
}
