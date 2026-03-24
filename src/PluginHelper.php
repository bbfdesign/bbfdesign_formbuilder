<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder;

use BbfdesignFormbuilder\Models\Setting;
use JTL\Plugin\Helper;
use JTL\Plugin\PluginInterface;
use JTL\Shop;
use JTL\Language\LanguageHelper;

class PluginHelper
{
    public const PLUGIN_ID = 'bbfdesign_formbuilder';

    private $db;
    public $plugin;

    public function __construct(?PluginInterface $plugin = null)
    {
        $this->db = Shop::Container()->getDB();
        $this->plugin = $plugin ?? Helper::getPluginById(self::PLUGIN_ID);
    }

    /**
     * Get all settings as key => value array.
     */
    public static function getSettings(array $keys = []): array
    {
        $settingObj = new Setting();
        $settings = $settingObj->getAll($keys);
        $result = [];
        foreach ($settings as $setting) {
            $result[$setting['setting_key']] = $setting['setting_value'];
        }
        return $result;
    }

    /**
     * Get a single setting by key.
     */
    public static function getSetting(string $key): ?string
    {
        $settingObj = new Setting();
        return $settingObj->get($key);
    }

    public function getAllLanguages(): array
    {
        return LanguageHelper::getAllLanguages(0, true, true);
    }

    public function getAllLanguagesAsArray(): array
    {
        $languages = [];
        foreach ($this->getAllLanguages() as $lang) {
            $languages[] = [
                'id'      => $lang->getId(),
                'iso'     => $lang->getIso(),
                'iso639'  => $lang->getIso639(),
                'name'    => $lang->getDisplayLanguage(),
            ];
        }
        return $languages;
    }

    public function defaultLanguage(): array
    {
        $defaultLanguage = LanguageHelper::getDefaultLanguage();
        return [
            'id'     => $defaultLanguage->getId(),
            'iso'    => $defaultLanguage->getIso(),
            'iso639' => $defaultLanguage->getIso639(),
            'name'   => $defaultLanguage->getDisplayLanguage(),
        ];
    }

    public function getActiveLanguage(): array
    {
        $languages = [];
        foreach ($this->getAllLanguages() as $lang) {
            if ($lang->cStandard === 'N') {
                $languages[] = [
                    'id'     => $lang->getId(),
                    'iso'    => $lang->getIso(),
                    'iso639' => $lang->getIso639(),
                    'name'   => $lang->getDisplayLanguage(),
                ];
            }
        }
        return $languages;
    }
}
