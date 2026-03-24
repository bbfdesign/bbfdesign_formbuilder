<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

class ConditionalLogicService
{
    /**
     * Evaluate conditional logic rules against submitted values.
     *
     * @param array $logic ['match' => 'all'|'any', 'rules' => [...]]
     * @param array $values Submitted field values
     * @return bool Whether the conditions are met
     */
    public function evaluate(array $logic, array $values): bool
    {
        $matchType = $logic['match'] ?? 'all';
        $rules = $logic['rules'] ?? [];

        if (empty($rules)) {
            return true;
        }

        foreach ($rules as $rule) {
            $fieldValue = $values[$rule['field_id']] ?? '';
            $result = $this->evaluateRule($rule, $fieldValue);

            if ($matchType === 'any' && $result) {
                return true;
            }
            if ($matchType === 'all' && !$result) {
                return false;
            }
        }

        return $matchType === 'all';
    }

    /**
     * Determine which fields should be visible based on conditional logic.
     */
    public function getVisibleFieldIds(array $fields, array $values): array
    {
        $visible = [];

        foreach ($fields as $field) {
            if (empty($field['conditional_logic'])) {
                $visible[] = $field['id'];
                continue;
            }

            $logic = $field['conditional_logic'];
            $action = $logic['action'] ?? 'show';
            $conditionsMet = $this->evaluate($logic, $values);

            if ($action === 'show') {
                if ($conditionsMet) {
                    $visible[] = $field['id'];
                }
            } elseif ($action === 'hide') {
                if (!$conditionsMet) {
                    $visible[] = $field['id'];
                }
            }
        }

        return $visible;
    }

    private function evaluateRule(array $rule, $fieldValue): bool
    {
        $operator = $rule['operator'] ?? 'is';
        $compareValue = $rule['value'] ?? '';

        if (is_array($fieldValue)) {
            $fieldValue = implode(',', $fieldValue);
        }
        $fieldValue = (string)$fieldValue;

        switch ($operator) {
            case 'is':
                return $fieldValue === $compareValue;
            case 'is_not':
                return $fieldValue !== $compareValue;
            case 'contains':
                return mb_stripos($fieldValue, $compareValue) !== false;
            case 'does_not_contain':
                return mb_stripos($fieldValue, $compareValue) === false;
            case 'starts_with':
                return mb_stripos($fieldValue, $compareValue) === 0;
            case 'ends_with':
                return mb_substr($fieldValue, -mb_strlen($compareValue)) === $compareValue;
            case 'is_empty':
                return trim($fieldValue) === '';
            case 'is_not_empty':
                return trim($fieldValue) !== '';
            case 'greater_than':
                return is_numeric($fieldValue) && is_numeric($compareValue) && (float)$fieldValue > (float)$compareValue;
            case 'less_than':
                return is_numeric($fieldValue) && is_numeric($compareValue) && (float)$fieldValue < (float)$compareValue;
            case 'is_checked':
                return !empty($fieldValue) && $fieldValue !== '0';
            case 'is_not_checked':
                return empty($fieldValue) || $fieldValue === '0';
            default:
                return false;
        }
    }
}
