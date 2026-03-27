/**
 * BBF Formbuilder – Custom Component Types & Traits
 * isComponent MUST match the exact HTML from bbf-form-blocks.js
 */
export default function bbfFormTraits(editor) {
    const dc = editor.DomComponents;

    // ── Conditions button trait (shared by all field types) ────
    const conditionsButtonTrait = {
        type: 'button',
        name: 'data-conditions-btn',
        label: 'Bedingte Anzeige',
        text: 'Regeln konfigurieren',
        full: true,
        command: 'bbf:open-conditions-panel',
    };

    // ── Register conditions command ───────────────────────────
    editor.Commands.add('bbf:open-conditions-panel', {
        run(ed) {
            const selected = ed.getSelected();
            if (!selected) return;

            const currentJson = selected.getAttributes()['data-conditions'] || '';
            let conditions;
            try {
                conditions = currentJson ? JSON.parse(currentJson) : null;
            } catch (e) {
                conditions = null;
            }
            if (!conditions) {
                conditions = { enabled: false, action: 'show', match: 'all', rules: [] };
            }

            // Alle Felder im Formular sammeln (für Dropdown)
            const allFields = [];
            function collectFields(comp) {
                const type = comp.get('type');
                if ((type === 'bbf-field' || type === 'bbf-compound-field') && comp !== selected) {
                    const a = comp.getAttributes();
                    allFields.push({
                        id: a['data-field-id'] || comp.getId(),
                        label: a['data-label'] || a['data-field-type'] || type,
                    });
                }
                comp.components().each(c => collectFields(c));
            }
            collectFields(ed.getWrapper());

            // Operators
            const operators = [
                { id: 'is', name: 'ist gleich' },
                { id: 'is_not', name: 'ist nicht gleich' },
                { id: 'contains', name: 'enthält' },
                { id: 'does_not_contain', name: 'enthält nicht' },
                { id: 'is_empty', name: 'ist leer' },
                { id: 'is_not_empty', name: 'ist nicht leer' },
                { id: 'greater_than', name: 'größer als' },
                { id: 'less_than', name: 'kleiner als' },
                { id: 'is_checked', name: 'ist angehakt' },
                { id: 'is_not_checked', name: 'ist nicht angehakt' },
            ];
            const noValueOps = ['is_empty', 'is_not_empty', 'is_checked', 'is_not_checked'];

            const esc = (s) => {
                const d = document.createElement('div');
                d.textContent = s;
                return d.innerHTML;
            };

            // Modal HTML bauen
            const fieldOpts = allFields.map(f =>
                `<option value="${esc(f.id)}">${esc(f.label)} (${esc(f.id)})</option>`
            ).join('');

            const operatorOpts = operators.map(o =>
                `<option value="${esc(o.id)}">${esc(o.name)}</option>`
            ).join('');

            function renderRules(rules) {
                if (!rules.length) return '<p style="color:#6c757d;font-size:13px;">Keine Regeln definiert.</p>';
                return rules.map((rule, i) => `
                    <div class="bbf-cond-rule" data-idx="${i}" style="display:flex;gap:6px;align-items:center;margin-bottom:8px;flex-wrap:wrap;">
                        <select data-role="field" style="flex:1;min-width:120px;padding:6px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;">
                            <option value="">— Feld —</option>
                            ${fieldOpts}
                        </select>
                        <select data-role="operator" style="flex:1;min-width:120px;padding:6px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;">
                            ${operatorOpts}
                        </select>
                        <input data-role="value" type="text" placeholder="Wert"
                               style="flex:1;min-width:80px;padding:6px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;">
                        <button type="button" data-role="remove" style="background:none;border:none;color:#dc3545;cursor:pointer;font-size:16px;padding:4px;" title="Entfernen">&times;</button>
                    </div>
                `).join('');
            }

            const html = `
                <div style="padding:16px;min-width:500px;">
                    <div style="display:flex;align-items:center;gap:12px;margin-bottom:16px;">
                        <label style="font-size:13px;font-weight:600;">Bedingte Anzeige</label>
                        <label class="switch" style="margin:0;">
                            <input type="checkbox" id="bbf-cond-enabled" ${conditions.enabled ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div id="bbf-cond-config" style="${conditions.enabled ? '' : 'opacity:0.4;pointer-events:none;'}">
                        <div style="display:flex;gap:8px;margin-bottom:16px;align-items:center;flex-wrap:wrap;">
                            <span style="font-size:13px;">Dieses Feld</span>
                            <select id="bbf-cond-action" style="padding:6px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;">
                                <option value="show" ${conditions.action === 'show' ? 'selected' : ''}>anzeigen</option>
                                <option value="hide" ${conditions.action === 'hide' ? 'selected' : ''}>verbergen</option>
                            </select>
                            <span style="font-size:13px;">wenn</span>
                            <select id="bbf-cond-match" style="padding:6px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;">
                                <option value="all" ${conditions.match === 'all' ? 'selected' : ''}>alle Bedingungen</option>
                                <option value="any" ${conditions.match === 'any' ? 'selected' : ''}>eine Bedingung</option>
                            </select>
                            <span style="font-size:13px;">erfüllt ist</span>
                        </div>
                        <div id="bbf-cond-rules" style="margin-bottom:12px;">
                            ${renderRules(conditions.rules)}
                        </div>
                        <button type="button" id="bbf-cond-add" style="padding:6px 14px;border-radius:4px;border:1px solid var(--bbf-primary,#db2e87);background:transparent;color:var(--bbf-primary,#db2e87);font-size:12px;cursor:pointer;">
                            + Regel hinzufügen
                        </button>
                    </div>
                    <div style="margin-top:20px;display:flex;gap:8px;justify-content:flex-end;">
                        <button type="button" id="bbf-cond-cancel" style="padding:8px 18px;border-radius:6px;border:1px solid #dee2e6;background:#fff;cursor:pointer;font-size:13px;">Abbrechen</button>
                        <button type="button" id="bbf-cond-save" style="padding:8px 18px;border-radius:6px;border:none;background:var(--bbf-primary,#db2e87);color:#fff;cursor:pointer;font-size:13px;font-weight:600;">Speichern</button>
                    </div>
                </div>
            `;

            const modal = ed.Modal;
            modal.setTitle('Bedingte Anzeige konfigurieren');
            const container = document.createElement('div');
            container.innerHTML = html;
            modal.setContent(container);
            modal.open();

            // Werte der bestehenden Regeln setzen
            const ruleEls = container.querySelectorAll('.bbf-cond-rule');
            conditions.rules.forEach((rule, i) => {
                if (!ruleEls[i]) return;
                const fieldSel = ruleEls[i].querySelector('[data-role="field"]');
                const opSel = ruleEls[i].querySelector('[data-role="operator"]');
                const valInput = ruleEls[i].querySelector('[data-role="value"]');
                if (fieldSel) fieldSel.value = rule.field || '';
                if (opSel) opSel.value = rule.operator || 'is';
                if (valInput) {
                    valInput.value = rule.value || '';
                    valInput.style.display = noValueOps.includes(rule.operator) ? 'none' : '';
                }
            });

            // Toggle enabled
            container.querySelector('#bbf-cond-enabled').addEventListener('change', function () {
                const cfg = container.querySelector('#bbf-cond-config');
                cfg.style.opacity = this.checked ? '' : '0.4';
                cfg.style.pointerEvents = this.checked ? '' : 'none';
            });

            // Operator change: hide value for is_empty etc.
            container.addEventListener('change', function (e) {
                if (e.target.dataset.role === 'operator') {
                    const row = e.target.closest('.bbf-cond-rule');
                    const valInput = row.querySelector('[data-role="value"]');
                    valInput.style.display = noValueOps.includes(e.target.value) ? 'none' : '';
                }
            });

            // Add rule
            container.querySelector('#bbf-cond-add').addEventListener('click', function () {
                const rulesDiv = container.querySelector('#bbf-cond-rules');
                const p = rulesDiv.querySelector('p');
                if (p) p.remove();
                const idx = rulesDiv.querySelectorAll('.bbf-cond-rule').length;
                const div = document.createElement('div');
                div.innerHTML = renderRules([{ field: '', operator: 'is', value: '' }]);
                const newRule = div.firstElementChild;
                newRule.dataset.idx = idx;
                rulesDiv.appendChild(newRule);
            });

            // Remove rule
            container.addEventListener('click', function (e) {
                if (e.target.dataset.role === 'remove') {
                    e.target.closest('.bbf-cond-rule').remove();
                }
            });

            // Cancel
            container.querySelector('#bbf-cond-cancel').addEventListener('click', function () {
                modal.close();
            });

            // Save
            container.querySelector('#bbf-cond-save').addEventListener('click', function () {
                const enabled = container.querySelector('#bbf-cond-enabled').checked;
                const action = container.querySelector('#bbf-cond-action').value;
                const match = container.querySelector('#bbf-cond-match').value;
                const rules = [];

                container.querySelectorAll('.bbf-cond-rule').forEach(function (row) {
                    const field = row.querySelector('[data-role="field"]').value;
                    const operator = row.querySelector('[data-role="operator"]').value;
                    const value = row.querySelector('[data-role="value"]').value;
                    if (field) {
                        rules.push({ field, operator, value });
                    }
                });

                const condJson = JSON.stringify({ enabled, action, match, rules });
                selected.addAttributes({ 'data-conditions': condJson });
                modal.close();
            });
        },
    });

    // ── bbf-field ────────────────────────────────────────────
    dc.addType('bbf-field', {
        isComponent: (el) => {
            if (!el || !el.getAttribute) return false;
            return el.getAttribute('data-gjs-type') === 'bbf-field'
                || (el.classList?.contains('bbf-field') && el.getAttribute('data-field-type'));
        },
        model: {
            defaults: {
                draggable: true,
                droppable: false,
                traits: [
                    { type: 'text', name: 'data-field-id', label: 'Feld-ID', placeholder: 'z.B. vorname' },
                    { type: 'text', name: 'data-label', label: 'Label' },
                    { type: 'text', name: 'data-placeholder', label: 'Platzhalter' },
                    { type: 'text', name: 'data-description', label: 'Beschreibung' },
                    { type: 'checkbox', name: 'data-required', label: 'Pflichtfeld' },
                    {
                        type: 'select', name: 'data-width', label: 'Breite',
                        options: [
                            { id: 'full', name: '100 %' },
                            { id: 'half', name: '50 %' },
                            { id: 'third', name: '33 %' },
                            { id: 'two-thirds', name: '66 %' },
                        ],
                    },
                    { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
                    { type: 'text', name: 'data-default-value', label: 'Standardwert' },
                    { type: 'number', name: 'data-min-length', label: 'Min. Länge' },
                    { type: 'number', name: 'data-max-length', label: 'Max. Länge' },
                    { type: 'text', name: 'data-pattern', label: 'Validierungsmuster (Regex)' },
                    { type: 'text', name: 'data-error-message', label: 'Fehlermeldung' },
                    conditionsButtonTrait,
                ],
            },
        },
    });

    // ── bbf-compound-field ───────────────────────────────────
    dc.addType('bbf-compound-field', {
        isComponent: (el) => {
            if (!el || !el.getAttribute) return false;
            return el.getAttribute('data-gjs-type') === 'bbf-compound-field';
        },
        model: {
            defaults: {
                draggable: true,
                droppable: false,
                traits: [
                    { type: 'text', name: 'data-field-id', label: 'Feld-ID' },
                    { type: 'text', name: 'data-label', label: 'Label' },
                    { type: 'checkbox', name: 'data-required', label: 'Pflichtfeld' },
                    {
                        type: 'select', name: 'data-width', label: 'Breite',
                        options: [
                            { id: 'full', name: '100 %' },
                            { id: 'half', name: '50 %' },
                        ],
                    },
                    { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
                    { type: 'text', name: 'data-error-message', label: 'Fehlermeldung' },
                    conditionsButtonTrait,
                ],
            },
        },
    });

    // ── bbf-submit ───────────────────────────────────────────
    dc.addType('bbf-submit', {
        isComponent: (el) => {
            if (!el || !el.getAttribute) return false;
            return el.getAttribute('data-gjs-type') === 'bbf-submit';
        },
        model: {
            defaults: {
                draggable: true,
                droppable: false,
                traits: [
                    { type: 'text', name: 'data-button-text', label: 'Button-Text' },
                    { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
                    {
                        type: 'select', name: 'data-button-style', label: 'Button-Stil',
                        options: [
                            { id: 'btn-primary', name: 'Primär' },
                            { id: 'btn-secondary', name: 'Sekundär' },
                            { id: 'btn-success', name: 'Erfolg' },
                            { id: 'btn-outline-primary', name: 'Primär (Outline)' },
                        ],
                    },
                    { type: 'checkbox', name: 'data-full-width', label: 'Volle Breite' },
                ],
            },
        },
    });

    // ── bbf-layout ───────────────────────────────────────────
    dc.addType('bbf-layout', {
        isComponent: (el) => {
            if (!el || !el.getAttribute) return false;
            return el.getAttribute('data-gjs-type') === 'bbf-layout';
        },
        model: {
            defaults: {
                draggable: true,
                droppable: true,
                traits: [
                    { type: 'text', name: 'data-field-type', label: 'Typ', attributes: { readonly: true } },
                    { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
                ],
            },
        },
    });
}

export function extractFieldDefinitions(editor) {
    const fields = [];
    function traverse(component) {
        const type = component.get('type');
        if (type === 'bbf-field' || type === 'bbf-compound-field' || type === 'bbf-submit') {
            const a = component.getAttributes();
            fields.push({
                field_id: a['data-field-id'] || '',
                field_type: a['data-field-type'] || type,
                label: a['data-label'] || '',
                placeholder: a['data-placeholder'] || '',
                description: a['data-description'] || '',
                required: a['data-required'] === 'true' || a['data-required'] === true,
                width: a['data-width'] || 'full',
                css_class: a['data-css-class'] || '',
                default_value: a['data-default-value'] || '',
                min_length: a['data-min-length'] || '',
                max_length: a['data-max-length'] || '',
                pattern: a['data-pattern'] || '',
                error_message: a['data-error-message'] || '',
                conditions: a['data-conditions'] || '',
            });
        }
        component.components().each(c => traverse(c));
    }
    traverse(editor.getWrapper());
    return fields;
}
