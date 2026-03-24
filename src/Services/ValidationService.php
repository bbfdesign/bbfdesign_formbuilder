<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

class ValidationService
{
    /**
     * Validate submitted data against form field definitions.
     *
     * @param array $fields The field definitions from fields_json
     * @param array $data   The submitted form data
     * @param array $visibleFieldIds IDs of currently visible fields (after conditional logic)
     * @return array Associative array of field_id => error message. Empty if valid.
     */
    public function validate(array $fields, array $data, array $visibleFieldIds = []): array
    {
        $errors = [];

        foreach ($fields as $field) {
            $fieldId = $field['id'];
            $type = $field['type'];

            // Skip hidden fields (conditional logic), layout fields, and captcha (validated separately)
            if (!empty($visibleFieldIds) && !in_array($fieldId, $visibleFieldIds, true)) {
                continue;
            }
            if (in_array($type, ['section_break', 'page_break', 'html_block', 'captcha'], true)) {
                continue;
            }

            $value = $data[$fieldId] ?? '';

            // Required check
            if (!empty($field['required']) && $this->isEmpty($value)) {
                $errors[$fieldId] = $this->getErrorMessage('required', $field);
                continue;
            }

            // Skip further validation if empty and not required
            if ($this->isEmpty($value)) {
                continue;
            }

            // Type-specific validation
            switch ($type) {
                case 'email':
                    if (!filter_var($value, FILTER_VALIDATE_EMAIL)) {
                        $errors[$fieldId] = $this->getErrorMessage('email', $field);
                    }
                    break;

                case 'url':
                    if (!filter_var($value, FILTER_VALIDATE_URL)) {
                        $errors[$fieldId] = $this->getErrorMessage('url', $field);
                    }
                    break;

                case 'number':
                    if (!is_numeric($value)) {
                        $errors[$fieldId] = $this->getErrorMessage('number', $field);
                    }
                    $validation = $field['validation'] ?? [];
                    if (isset($validation['min']) && (float)$value < (float)$validation['min']) {
                        $errors[$fieldId] = sprintf('Mindestens %s.', $validation['min']);
                    }
                    if (isset($validation['max']) && (float)$value > (float)$validation['max']) {
                        $errors[$fieldId] = sprintf('Maximal %s.', $validation['max']);
                    }
                    break;

                case 'phone':
                    if (!preg_match('/^[\d\s\-\+\(\)\/]{6,30}$/', $value)) {
                        $errors[$fieldId] = $this->getErrorMessage('phone', $field);
                    }
                    break;

                case 'text':
                case 'textarea':
                    $validation = $field['validation'] ?? [];
                    if (isset($validation['min_length']) && mb_strlen($value) < (int)$validation['min_length']) {
                        $errors[$fieldId] = sprintf('Mindestens %d Zeichen.', $validation['min_length']);
                    }
                    if (isset($validation['max_length']) && mb_strlen($value) > (int)$validation['max_length']) {
                        $errors[$fieldId] = sprintf('Maximal %d Zeichen.', $validation['max_length']);
                    }
                    break;

                case 'gdpr':
                    if (empty($value) || $value === '0') {
                        $errors[$fieldId] = $this->getErrorMessage('gdpr', $field);
                    }
                    break;
            }
        }

        return $errors;
    }

    private function isEmpty($value): bool
    {
        if (is_array($value)) {
            return empty($value);
        }
        return trim((string)$value) === '';
    }

    private function getErrorMessage(string $type, array $field): string
    {
        $messages = [
            'required' => 'Dieses Feld ist ein Pflichtfeld.',
            'email'    => 'Bitte geben Sie eine gültige E-Mail-Adresse ein.',
            'url'      => 'Bitte geben Sie eine gültige URL ein.',
            'number'   => 'Bitte geben Sie eine gültige Zahl ein.',
            'phone'    => 'Bitte geben Sie eine gültige Telefonnummer ein.',
            'gdpr'     => 'Bitte stimmen Sie der Datenschutzerklärung zu.',
        ];

        return $messages[$type] ?? 'Ungültige Eingabe.';
    }
}
