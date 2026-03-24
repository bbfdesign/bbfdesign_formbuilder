<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder;

use BbfdesignFormbuilder\Controllers\Frontend\SubmitController;
use BbfdesignFormbuilder\SpamProtection\AltchaProtector;
use JTL\Plugin\PluginInterface;

class Route
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

    /**
     * Register frontend routes.
     */
    public function register(): void
    {
        $requestUri = $_SERVER['REQUEST_URI'] ?? '';
        $path = parse_url($requestUri, PHP_URL_PATH);

        // Form submission endpoint
        if ($path === '/bbf-formbuilder/submit' && $_SERVER['REQUEST_METHOD'] === 'POST') {
            $controller = new SubmitController();
            $controller->handle();
            // handle() calls exit
        }

        // ALTCHA challenge endpoint
        if ($path === '/bbf-formbuilder/altcha/challenge' && $_SERVER['REQUEST_METHOD'] === 'GET') {
            $this->handleAltchaChallenge();
        }
    }

    /**
     * Generate and return ALTCHA PoW challenge.
     */
    private function handleAltchaChallenge(): void
    {
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-cache, no-store');

        $altcha = new AltchaProtector();
        echo json_encode($altcha->generateChallenge());
        exit;
    }
}
