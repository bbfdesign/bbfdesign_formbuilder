<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Helpers;

class SanitizerHelper
{
    /**
     * Sanitize a single input value based on field type.
     */
    public static function sanitize(string $value, string $fieldType): string
    {
        $value = trim($value);

        switch ($fieldType) {
            case 'email':
                return filter_var($value, FILTER_SANITIZE_EMAIL) ?: '';

            case 'url':
                return filter_var($value, FILTER_SANITIZE_URL) ?: '';

            case 'number':
                return is_numeric($value) ? $value : '';

            case 'phone':
                return preg_replace('/[^\d\s\-\+\(\)\/]/', '', $value);

            case 'textarea':
            case 'html_block':
                // Allow line breaks but strip tags
                return strip_tags($value);

            default:
                // Strip tags and encode special chars
                return htmlspecialchars(strip_tags($value), ENT_QUOTES, 'UTF-8');
        }
    }

    /**
     * Sanitize all submitted values.
     */
    public static function sanitizeAll(array $values, array $fields): array
    {
        $fieldTypeMap = [];
        foreach ($fields as $field) {
            $fieldTypeMap[$field['id']] = $field['type'];
        }

        $sanitized = [];
        foreach ($values as $fieldId => $value) {
            $type = $fieldTypeMap[$fieldId] ?? 'text';

            if (is_array($value)) {
                $sanitized[$fieldId] = array_map(function ($v) use ($type) {
                    return self::sanitize((string)$v, $type);
                }, $value);
            } else {
                $sanitized[$fieldId] = self::sanitize((string)$value, $type);
            }
        }

        return $sanitized;
    }
}
