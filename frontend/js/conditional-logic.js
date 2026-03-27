/**
 * BBF Formbuilder – Conditional Logic (Frontend)
 *
 * Evaluiert Bedingungs-Regeln und zeigt/versteckt Felder dynamisch.
 * Arbeitet unabhängig von Alpine.js — funktioniert auf jeder Seite
 * die BBF-Formulare mit data-bbf-conditions Attributen enthält.
 */
var BbfConditions = /** @class */ (function () {

    function BbfConditions(formEl) {
        this.form = formEl;
        this.fields = {};
        this.init();
    }

    BbfConditions.prototype.init = function () {
        var self = this;

        // Alle Felder mit Bedingungen registrieren
        this.form.querySelectorAll('[data-bbf-conditions]').forEach(function (fieldWrap) {
            try {
                var conditions = JSON.parse(fieldWrap.dataset.bbfConditions);
                if (conditions && conditions.enabled) {
                    self.registerField(fieldWrap, conditions);
                }
            } catch (e) {
                // Ungültiges JSON ignorieren
            }
        });

        // Initiale Auswertung
        this.evaluateAll();

        // Bei jeder Eingabe neu auswerten
        this.form.addEventListener('input', function () { self.evaluateAll(); });
        this.form.addEventListener('change', function () { self.evaluateAll(); });
    };

    BbfConditions.prototype.registerField = function (el, conditions) {
        var fieldId = el.dataset.bbfFieldId;
        if (fieldId) {
            this.fields[fieldId] = { el: el, conditions: conditions };
        }
    };

    BbfConditions.prototype.evaluateAll = function () {
        var self = this;
        Object.keys(this.fields).forEach(function (key) {
            var entry = self.fields[key];
            var visible = self.evaluate(entry.conditions);
            entry.el.style.display = visible ? '' : 'none';
            // Deaktivierte Felder aus Validierung ausschließen
            entry.el.querySelectorAll('input, select, textarea').forEach(function (input) {
                input.disabled = !visible;
            });
        });
    };

    BbfConditions.prototype.evaluate = function (conditions) {
        var self = this;
        if (!conditions.rules || !conditions.rules.length) {
            return conditions.action === 'show';
        }

        var results = conditions.rules.map(function (rule) {
            return self.evaluateRule(rule);
        });

        var match = conditions.match === 'all'
            ? results.every(Boolean)
            : results.some(Boolean);

        return conditions.action === 'show' ? match : !match;
    };

    BbfConditions.prototype.evaluateRule = function (rule) {
        // Feld im Formular finden
        var fieldWrap = this.form.querySelector('[data-bbf-field-id="' + rule.field + '"]');
        if (!fieldWrap) return false;

        var input = fieldWrap.querySelector('input, select, textarea');
        if (!input) return false;

        // Für Radio/Checkbox-Gruppen: den markierten Wert finden
        var value;
        if (input.type === 'checkbox' && !input.name) {
            value = input.checked;
        } else if (input.type === 'radio') {
            var checked = fieldWrap.querySelector('input[type="radio"]:checked');
            value = checked ? checked.value : '';
        } else if (input.type === 'checkbox') {
            var checkedBoxes = fieldWrap.querySelectorAll('input[type="checkbox"]:checked');
            value = Array.prototype.map.call(checkedBoxes, function (cb) { return cb.value; }).join(',');
        } else {
            value = input.value.trim();
        }

        switch (rule.operator) {
            case 'is':               return value == rule.value;
            case 'is_not':           return value != rule.value;
            case 'contains':         return String(value).indexOf(rule.value) !== -1;
            case 'does_not_contain': return String(value).indexOf(rule.value) === -1;
            case 'is_empty':         return value === '' || value === false;
            case 'is_not_empty':     return value !== '' && value !== false;
            case 'greater_than':     return parseFloat(value) > parseFloat(rule.value);
            case 'less_than':        return parseFloat(value) < parseFloat(rule.value);
            case 'is_checked':       return value === true || value === 'true' || value === '1';
            case 'is_not_checked':   return value === false || value === '' || value === '0';
            default:                 return false;
        }
    };

    return BbfConditions;
})();

// Auto-Init für alle BBF-Formulare auf der Seite
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.bbf-form-wrap, [data-bbf-form]').forEach(function (form) {
        new BbfConditions(form);
    });
});
