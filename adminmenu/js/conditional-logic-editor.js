/**
 * BBF Formbuilder – Conditional Logic Editor
 * Alpine.js component for configuring field visibility rules.
 *
 * Usage:
 *   <div x-data="conditionalLogicEditor({
 *       fieldLogic: <object|null>,
 *       formFields: <array>,
 *       currentFieldId: <string>,
 *       onChange: <function>
 *   })"> ... </div>
 */
document.addEventListener('alpine:init', () => {
    Alpine.data('conditionalLogicEditor', (config) => ({
        enabled: false,
        action: 'show',   // 'show' or 'hide'
        matchType: 'all', // 'all' or 'any'
        rules: [],
        formFields: config.formFields || [],
        currentFieldId: config.currentFieldId || null,

        // ─── Operators ───
        operators: [
            { value: 'is',                label: 'ist' },
            { value: 'is_not',            label: 'ist nicht' },
            { value: 'contains',          label: 'enthält' },
            { value: 'does_not_contain',  label: 'enthält nicht' },
            { value: 'starts_with',       label: 'beginnt mit' },
            { value: 'ends_with',         label: 'endet mit' },
            { value: 'is_empty',          label: 'ist leer' },
            { value: 'is_not_empty',      label: 'ist nicht leer' },
            { value: 'greater_than',      label: 'größer als' },
            { value: 'less_than',         label: 'kleiner als' },
            { value: 'is_checked',        label: 'ist ausgewählt' },
            { value: 'is_not_checked',    label: 'ist nicht ausgewählt' },
        ],

        // Operators that don't need a value input
        noValueOperators: ['is_empty', 'is_not_empty', 'is_checked', 'is_not_checked'],

        // ─── Init ───
        init() {
            if (config.fieldLogic) {
                this.enabled = true;
                this.action = config.fieldLogic.action || 'show';
                this.matchType = config.fieldLogic.match || 'all';
                this.rules = JSON.parse(JSON.stringify(config.fieldLogic.rules || []));
            }
        },

        // ─── Available fields (exclude the current field) ───
        get availableFields() {
            return this.formFields.filter(f => f.id !== this.currentFieldId);
        },

        // ─── Check if a given field has predefined choices ───
        getChoicesForField(fieldId) {
            var field = this.formFields.find(f => f.id === fieldId);
            if (!field) return [];
            if (Array.isArray(field.choices) && field.choices.length > 0) {
                return field.choices;
            }
            return [];
        },

        // ─── Check if operator needs a value ───
        operatorNeedsValue(operator) {
            return !this.noValueOperators.includes(operator);
        },

        // ─── Add a new empty rule ───
        addRule() {
            this.rules.push({
                field_id: '',
                operator: 'is',
                value: '',
            });
            this.emitChange();
        },

        // ─── Remove a rule by index ───
        removeRule(index) {
            this.rules.splice(index, 1);
            this.emitChange();
        },

        // ─── When rule field changes, reset value if target has choices ───
        onRuleFieldChange(index) {
            this.rules[index].value = '';
            this.emitChange();
        },

        // ─── When operator changes, clear value if no longer needed ───
        onOperatorChange(index) {
            if (!this.operatorNeedsValue(this.rules[index].operator)) {
                this.rules[index].value = '';
            }
            this.emitChange();
        },

        // ─── Build the config object ───
        getConfig() {
            if (!this.enabled || this.rules.length === 0) return null;
            return {
                action: this.action,
                match: this.matchType,
                rules: this.rules.map(function(r) {
                    return {
                        field_id: r.field_id,
                        operator: r.operator,
                        value: r.value,
                    };
                }),
            };
        },

        // ─── Emit change to parent ───
        emitChange() {
            if (config.onChange) {
                config.onChange(this.getConfig());
            }
        },
    }));
});
