<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use JTL\Language\LanguageHelper;
use JTL\Shop;

class LocaleService
{
    /**
     * Get the current frontend language ISO code.
     */
    public static function getCurrentLangIso(): string
    {
        $lang = Shop::getLanguageCode();
        return !empty($lang) ? $lang : 'ger';
    }

    /**
     * Get all available shop languages.
     */
    public static function getAllLanguages(): array
    {
        return LanguageHelper::getAllLanguages(0, true, true);
    }

    /**
     * Get the default language ISO.
     */
    public static function getDefaultLangIso(): string
    {
        $default = LanguageHelper::getDefaultLanguage();
        return $default->getIso();
    }
}
