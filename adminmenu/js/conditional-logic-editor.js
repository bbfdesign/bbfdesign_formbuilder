/**
 * BBF Formbuilder – Conditional Logic Editor
 * Will be fully implemented in Phase 5
 */
document.addEventListener('alpine:init', () => {
    Alpine.data('conditionalLogicEditor', () => ({
        rules: [],
        matchType: 'all', // 'all' or 'any'

        addRule() {
            this.rules.push({
                field_id: '',
                operator: 'is',
                value: '',
            });
        },

        removeRule(index) {
            this.rules.splice(index, 1);
        },

        getOperators() {
            return [
                { value: 'is', label: 'ist' },
                { value: 'is_not', label: 'ist nicht' },
                { value: 'contains', label: 'enthält' },
                { value: 'does_not_contain', label: 'enthält nicht' },
                { value: 'starts_with', label: 'beginnt mit' },
                { value: 'ends_with', label: 'endet mit' },
                { value: 'is_empty', label: 'ist leer' },
                { value: 'is_not_empty', label: 'ist nicht leer' },
                { value: 'greater_than', label: 'größer als' },
                { value: 'less_than', label: 'kleiner als' },
                { value: 'is_checked', label: 'ist ausgewählt' },
                { value: 'is_not_checked', label: 'ist nicht ausgewählt' },
            ];
        },
    }));
});
