/**
 * BBF Formbuilder – Custom Component Types & Traits
 * isComponent MUST match the exact HTML from bbf-form-blocks.js
 */
export default function bbfFormTraits(editor) {
    const dc = editor.DomComponents;

    // ── Shared traits ─────────────────────────────────────────
    const conditionsButtonTrait = {
        type: 'button', name: 'data-conditions-btn',
        label: 'Bedingte Anzeige', text: 'Regeln konfigurieren',
        full: true, command: 'bbf:open-conditions-panel',
    };

    const optionsButtonTrait = {
        type: 'button', name: 'data-options-btn',
        label: 'Optionen bearbeiten', text: 'Optionen / Auswahlwerte',
        full: true,
        command: (ed) => {
            const sel = ed.getSelected();
            const ft = sel?.getAttributes()['data-field-type'];
            if (['select', 'radio', 'checkbox'].includes(ft)) {
                ed.Commands.run('bbf:open-options-editor');
            }
        },
    };

    const translationsButtonTrait = {
        type: 'button', name: 'data-trans-btn',
        label: 'Übersetzungen', text: '🌐 Mehrsprachigkeit konfigurieren',
        full: true, command: 'bbf:open-translations-panel',
    };

    // ── Escape helper ─────────────────────────────────────────
    function escStr(s) {
        return String(s || '').replace(/&/g, '&amp;').replace(/"/g, '&quot;')
            .replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    // ══════════════════════════════════════════════════════════
    //  COMMAND: Conditions Panel
    // ══════════════════════════════════════════════════════════
    editor.Commands.add('bbf:open-conditions-panel', {
        run(ed) {
            const selected = ed.getSelected();
            if (!selected) return;

            const currentJson = selected.getAttributes()['data-conditions'] || '';
            let conditions;
            try { conditions = currentJson ? JSON.parse(currentJson) : null; } catch (e) { conditions = null; }
            if (!conditions) conditions = { enabled: false, action: 'show', match: 'all', rules: [] };

            const allFields = [];
            function collectFields(comp) {
                const type = comp.get('type');
                if ((type === 'bbf-field' || type === 'bbf-compound-field') && comp !== selected) {
                    const a = comp.getAttributes();
                    allFields.push({ id: a['data-field-id'] || comp.getId(), label: a['data-label'] || a['data-field-type'] || type });
                }
                comp.components().each(c => collectFields(c));
            }
            collectFields(ed.getWrapper());

            const operators = [
                { id: 'is', name: 'ist gleich' }, { id: 'is_not', name: 'ist nicht gleich' },
                { id: 'contains', name: 'enthält' }, { id: 'does_not_contain', name: 'enthält nicht' },
                { id: 'is_empty', name: 'ist leer' }, { id: 'is_not_empty', name: 'ist nicht leer' },
                { id: 'greater_than', name: 'größer als' }, { id: 'less_than', name: 'kleiner als' },
                { id: 'is_checked', name: 'ist angehakt' }, { id: 'is_not_checked', name: 'ist nicht angehakt' },
            ];
            const noValueOps = ['is_empty', 'is_not_empty', 'is_checked', 'is_not_checked'];

            const fieldOpts = allFields.map(f => `<option value="${escStr(f.id)}">${escStr(f.label)} (${escStr(f.id)})</option>`).join('');
            const operatorOpts = operators.map(o => `<option value="${escStr(o.id)}">${escStr(o.name)}</option>`).join('');

            function renderRules(rules) {
                if (!rules.length) return '<p style="color:#6c757d;font-size:13px;">Keine Regeln definiert.</p>';
                return rules.map((rule, i) => `
                    <div class="bbf-cond-rule" data-idx="${i}" style="display:flex;gap:6px;align-items:center;margin-bottom:8px;flex-wrap:wrap;">
                        <select data-role="field" style="flex:1;min-width:120px;padding:6px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;"><option value="">— Feld —</option>${fieldOpts}</select>
                        <select data-role="operator" style="flex:1;min-width:120px;padding:6px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;">${operatorOpts}</select>
                        <input data-role="value" type="text" placeholder="Wert" style="flex:1;min-width:80px;padding:6px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;">
                        <button type="button" data-role="remove" style="background:none;border:none;color:#dc3545;cursor:pointer;font-size:16px;padding:4px;" title="Entfernen">&times;</button>
                    </div>`).join('');
            }

            const html = `<div style="padding:16px;min-width:500px;">
                <div style="display:flex;align-items:center;gap:12px;margin-bottom:16px;">
                    <label style="font-size:13px;font-weight:600;">Bedingte Anzeige</label>
                    <label class="switch" style="margin:0;"><input type="checkbox" id="bbf-cond-enabled" ${conditions.enabled ? 'checked' : ''}><span class="slider"></span></label>
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
                    <div id="bbf-cond-rules" style="margin-bottom:12px;">${renderRules(conditions.rules)}</div>
                    <button type="button" id="bbf-cond-add" style="padding:6px 14px;border-radius:4px;border:1px solid #e8420a;background:transparent;color:#e8420a;font-size:12px;cursor:pointer;">+ Regel hinzufügen</button>
                </div>
                <div style="margin-top:20px;display:flex;gap:8px;justify-content:flex-end;">
                    <button type="button" id="bbf-cond-cancel" style="padding:8px 18px;border-radius:6px;border:1px solid #dee2e6;background:#fff;cursor:pointer;font-size:13px;">Abbrechen</button>
                    <button type="button" id="bbf-cond-save" style="padding:8px 18px;border-radius:6px;border:none;background:#e8420a;color:#fff;cursor:pointer;font-size:13px;font-weight:600;">Speichern</button>
                </div>
            </div>`;

            const modal = ed.Modal;
            modal.setTitle('Bedingte Anzeige konfigurieren');
            const container = document.createElement('div');
            container.innerHTML = html;
            modal.setContent(container);
            modal.open();

            const ruleEls = container.querySelectorAll('.bbf-cond-rule');
            conditions.rules.forEach((rule, i) => {
                if (!ruleEls[i]) return;
                ruleEls[i].querySelector('[data-role="field"]').value = rule.field || '';
                ruleEls[i].querySelector('[data-role="operator"]').value = rule.operator || 'is';
                const vi = ruleEls[i].querySelector('[data-role="value"]');
                vi.value = rule.value || '';
                vi.style.display = noValueOps.includes(rule.operator) ? 'none' : '';
            });

            container.querySelector('#bbf-cond-enabled').addEventListener('change', function () {
                const cfg = container.querySelector('#bbf-cond-config');
                cfg.style.opacity = this.checked ? '' : '0.4';
                cfg.style.pointerEvents = this.checked ? '' : 'none';
            });
            container.addEventListener('change', e => { if (e.target.dataset.role === 'operator') { e.target.closest('.bbf-cond-rule').querySelector('[data-role="value"]').style.display = noValueOps.includes(e.target.value) ? 'none' : ''; } });
            container.querySelector('#bbf-cond-add').addEventListener('click', () => { const rd = container.querySelector('#bbf-cond-rules'); const p = rd.querySelector('p'); if (p) p.remove(); const d = document.createElement('div'); d.innerHTML = renderRules([{ field: '', operator: 'is', value: '' }]); rd.appendChild(d.firstElementChild); });
            container.addEventListener('click', e => { if (e.target.dataset.role === 'remove') e.target.closest('.bbf-cond-rule').remove(); });
            container.querySelector('#bbf-cond-cancel').addEventListener('click', () => modal.close());
            container.querySelector('#bbf-cond-save').addEventListener('click', () => {
                const rules = [];
                container.querySelectorAll('.bbf-cond-rule').forEach(row => {
                    const f = row.querySelector('[data-role="field"]').value;
                    if (f) rules.push({ field: f, operator: row.querySelector('[data-role="operator"]').value, value: row.querySelector('[data-role="value"]').value });
                });
                selected.addAttributes({ 'data-conditions': JSON.stringify({ enabled: container.querySelector('#bbf-cond-enabled').checked, action: container.querySelector('#bbf-cond-action').value, match: container.querySelector('#bbf-cond-match').value, rules }) });
                modal.close();
            });
        },
    });

    // ══════════════════════════════════════════════════════════
    //  COMMAND: Options Editor (Select, Radio, Checkbox)
    // ══════════════════════════════════════════════════════════
    editor.Commands.add('bbf:open-options-editor', {
        run(ed) {
            const selected = ed.getSelected();
            if (!selected) return;
            const fieldType = selected.getAttributes()['data-field-type'];
            const currentJson = selected.getAttributes()['data-options'] || '';
            let options = [];
            try { options = currentJson ? JSON.parse(currentJson) : []; } catch (e) { options = []; }
            if (!options.length) {
                options = fieldType === 'select'
                    ? [{ value: 'option_1', label: 'Option 1' }, { value: 'option_2', label: 'Option 2' }, { value: 'option_3', label: 'Option 3' }]
                    : [{ value: 'option_a', label: 'Option A' }, { value: 'option_b', label: 'Option B' }];
            }

            function renderOpts(opts) {
                if (!opts.length) return '<p style="color:#6c757d;font-size:13px;padding:8px 0;">Keine Optionen.</p>';
                return opts.map((o, i) => `
                    <div class="bbf-opt-row" data-idx="${i}" style="display:grid;grid-template-columns:1fr 1fr auto;gap:6px;align-items:center;margin-bottom:6px;">
                        <input type="text" data-role="label" value="${escStr(o.label)}" placeholder="Angezeigter Text" style="padding:6px 8px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;width:100%;">
                        <input type="text" data-role="value" value="${escStr(o.value)}" placeholder="Wert (intern)" style="padding:6px 8px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;width:100%;">
                        <button type="button" data-role="remove-opt" style="background:none;border:none;color:#dc3545;cursor:pointer;font-size:16px;padding:4px 8px;" title="Entfernen">&times;</button>
                    </div>`).join('');
            }

            const title = fieldType === 'select' ? 'Dropdown-Optionen' : fieldType === 'radio' ? 'Radio-Optionen' : 'Checkbox-Optionen';
            const html = `<div style="padding:16px;min-width:500px;">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
                    <strong style="font-size:13px;">Optionen</strong>
                    <button type="button" id="bbf-opt-add" style="padding:5px 14px;border-radius:4px;border:1px solid #e8420a;background:transparent;color:#e8420a;font-size:12px;cursor:pointer;">+ Option hinzufügen</button>
                </div>
                <div style="display:grid;grid-template-columns:1fr 1fr auto;gap:6px;padding:6px 8px;margin-bottom:4px;">
                    <span style="font-size:11px;font-weight:600;color:#6c757d;">Angezeigter Text</span>
                    <span style="font-size:11px;font-weight:600;color:#6c757d;">Wert (intern)</span><span></span>
                </div>
                <div id="bbf-opt-list">${renderOpts(options)}</div>
                <div style="margin-top:16px;display:flex;gap:8px;justify-content:flex-end;">
                    <button type="button" id="bbf-opt-cancel" style="padding:8px 18px;border-radius:6px;border:1px solid #dee2e6;background:#fff;cursor:pointer;font-size:13px;">Abbrechen</button>
                    <button type="button" id="bbf-opt-save" style="padding:8px 18px;border-radius:6px;border:none;background:#e8420a;color:#fff;cursor:pointer;font-size:13px;font-weight:600;">Speichern</button>
                </div>
            </div>`;

            const modal = ed.Modal;
            modal.setTitle(title);
            const container = document.createElement('div');
            container.innerHTML = html;
            modal.setContent(container);
            modal.open();

            container.querySelector('#bbf-opt-add').addEventListener('click', () => {
                const list = container.querySelector('#bbf-opt-list');
                const p = list.querySelector('p'); if (p) p.remove();
                const d = document.createElement('div');
                d.innerHTML = renderOpts([{ label: '', value: '' }]);
                list.appendChild(d.firstElementChild);
            });
            container.addEventListener('click', e => { if (e.target.dataset.role === 'remove-opt') { e.target.closest('.bbf-opt-row').remove(); } });
            container.querySelector('#bbf-opt-cancel').addEventListener('click', () => modal.close());
            container.querySelector('#bbf-opt-save').addEventListener('click', () => {
                const newOpts = [];
                container.querySelectorAll('.bbf-opt-row').forEach(row => {
                    const l = row.querySelector('[data-role="label"]').value.trim();
                    const v = row.querySelector('[data-role="value"]').value.trim();
                    if (l || v) newOpts.push({ label: l || v, value: v || l });
                });
                selected.addAttributes({ 'data-options': JSON.stringify(newOpts) });
                updateCanvasOptions(selected, newOpts, fieldType);
                modal.close();
            });
        },
    });

    // ── Canvas options updater ────────────────────────────────
    function updateCanvasOptions(component, options, fieldType) {
        try {
            if (fieldType === 'select') {
                component.components().each(child => {
                    if (child.get('tagName') === 'select') {
                        child.components().reset();
                        const items = [{ tagName: 'option', attributes: { value: '' }, content: '— Bitte wählen —' }];
                        options.forEach(o => items.push({ tagName: 'option', attributes: { value: o.value }, content: o.label }));
                        child.components().add(items);
                    }
                });
            } else if (fieldType === 'radio' || fieldType === 'checkbox') {
                const inputType = fieldType === 'radio' ? 'radio' : 'checkbox';
                const groupName = 'bbf_' + (component.getAttributes()['data-field-id'] || component.getId());
                const inner = component.components();
                const toRemove = [];
                inner.each(c => { if (c.getClasses().includes('form-check')) toRemove.push(c); });
                toRemove.forEach(c => c.remove());
                options.forEach(o => {
                    const uid = 'bbf_' + Math.random().toString(36).slice(2, 7);
                    inner.add({ tagName: 'div', classes: ['form-check'], components: [
                        { tagName: 'input', attributes: { type: inputType, class: 'form-check-input', name: groupName, id: uid, value: o.value } },
                        { tagName: 'label', attributes: { class: 'form-check-label', for: uid }, content: o.label },
                    ] });
                });
            }
        } catch (e) { console.warn('BBF: Canvas options update failed', e); }
    }

    // ══════════════════════════════════════════════════════════
    //  COMMAND: Translations Panel
    // ══════════════════════════════════════════════════════════
    editor.Commands.add('bbf:open-translations-panel', {
        run(ed) {
            const selected = ed.getSelected();
            if (!selected) return;
            const attrs = selected.getAttributes();
            const langJson = attrs['data-languages'] || '["ger"]';
            let languages = [];
            try { languages = JSON.parse(langJson); } catch (e) { languages = ['ger']; }

            const langLabels = { ger: 'Deutsch', eng: 'Englisch', fra: 'Französisch', ita: 'Italienisch', spa: 'Spanisch', nld: 'Niederländisch', pol: 'Polnisch', ces: 'Tschechisch' };
            const allLangs = Object.entries(langLabels);
            const curLabel = attrs['data-label'] || '';
            const curPlaceholder = attrs['data-placeholder'] || '';
            const curDescription = attrs['data-description'] || '';

            function transRow(lang, field, value, ph) {
                return `<div style="margin-bottom:8px;"><label style="font-size:11px;font-weight:600;color:#6c757d;margin-bottom:3px;display:block;">${field === 'label' ? 'Label' : field === 'placeholder' ? 'Platzhalter' : 'Beschreibung'}</label><input type="text" data-trans-lang="${lang}" data-trans-field="${field}" value="${escStr(value)}" placeholder="${escStr(ph)}" style="width:100%;padding:6px 8px;border:1px solid #dee2e6;border-radius:4px;font-size:13px;"></div>`;
            }

            const html = `<div style="padding:16px;min-width:500px;">
                <div style="margin-bottom:16px;">
                    <strong style="font-size:12px;color:#6c757d;text-transform:uppercase;letter-spacing:.05em;">Aktive Sprachen</strong>
                    <div style="display:flex;flex-wrap:wrap;gap:8px;margin-top:8px;">
                        ${allLangs.map(([c, n]) => `<label style="display:flex;align-items:center;gap:5px;font-size:13px;cursor:pointer;"><input type="checkbox" data-lang-toggle="${c}" ${languages.includes(c) ? 'checked' : ''}> ${n}</label>`).join('')}
                    </div>
                </div>
                <div id="bbf-trans-fields">
                    ${languages.map(l => `<div class="bbf-lang-section" data-lang="${l}" style="background:#f8f9fa;border-radius:6px;padding:12px;margin-bottom:10px;">
                        <div style="font-size:13px;font-weight:700;margin-bottom:8px;">${langLabels[l] || l}</div>
                        ${transRow(l, 'label', attrs['data-label-' + l] || (l === 'ger' ? curLabel : ''), curLabel)}
                        ${transRow(l, 'placeholder', attrs['data-placeholder-' + l] || (l === 'ger' ? curPlaceholder : ''), curPlaceholder)}
                        ${transRow(l, 'description', attrs['data-description-' + l] || (l === 'ger' ? curDescription : ''), curDescription)}
                    </div>`).join('')}
                </div>
                <div style="margin-top:16px;display:flex;gap:8px;justify-content:flex-end;">
                    <button type="button" id="bbf-trans-cancel" style="padding:8px 18px;border-radius:6px;border:1px solid #dee2e6;background:#fff;cursor:pointer;font-size:13px;">Abbrechen</button>
                    <button type="button" id="bbf-trans-save" style="padding:8px 18px;border-radius:6px;border:none;background:#e8420a;color:#fff;cursor:pointer;font-size:13px;font-weight:600;">Speichern</button>
                </div>
            </div>`;

            const modal = ed.Modal;
            modal.setTitle('Übersetzungen / Mehrsprachigkeit');
            const container = document.createElement('div');
            container.innerHTML = html;
            modal.setContent(container);
            modal.open();

            container.addEventListener('change', e => {
                if (!e.target.dataset.langToggle) return;
                const lang = e.target.dataset.langToggle;
                const section = container.querySelector(`.bbf-lang-section[data-lang="${lang}"]`);
                if (e.target.checked && !section) {
                    const d = document.createElement('div');
                    d.innerHTML = `<div class="bbf-lang-section" data-lang="${lang}" style="background:#f8f9fa;border-radius:6px;padding:12px;margin-bottom:10px;"><div style="font-size:13px;font-weight:700;margin-bottom:8px;">${langLabels[lang] || lang}</div>${transRow(lang, 'label', '', curLabel)}${transRow(lang, 'placeholder', '', curPlaceholder)}${transRow(lang, 'description', '', curDescription)}</div>`;
                    container.querySelector('#bbf-trans-fields').appendChild(d.firstElementChild);
                } else if (!e.target.checked && section) { section.remove(); }
            });

            container.querySelector('#bbf-trans-cancel').addEventListener('click', () => modal.close());
            container.querySelector('#bbf-trans-save').addEventListener('click', () => {
                const newAttrs = {};
                const activeLangs = [];
                container.querySelectorAll('[data-lang-toggle]:checked').forEach(cb => activeLangs.push(cb.dataset.langToggle));
                newAttrs['data-languages'] = JSON.stringify(activeLangs);
                container.querySelectorAll('[data-trans-lang]').forEach(inp => {
                    const l = inp.dataset.transLang, f = inp.dataset.transField, v = inp.value.trim();
                    if (v) { newAttrs[`data-${f}-${l}`] = v; if (l === activeLangs[0]) newAttrs[`data-${f}`] = v; }
                });
                selected.addAttributes(newAttrs);
                // Update canvas label
                const newLabel = newAttrs['data-label'];
                if (newLabel) { try { selected.components().each(c => { if (c.getClasses().includes('bbf-label') || c.getClasses().includes('form-label')) c.set('content', newLabel); }); } catch (e) {} }
                modal.close();
            });
        },
    });

    // ══════════════════════════════════════════════════════════
    //  Component Types
    // ══════════════════════════════════════════════════════════

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
                    optionsButtonTrait,
                    { type: 'text', name: 'data-placeholder', label: 'Platzhalter' },
                    { type: 'text', name: 'data-description', label: 'Beschreibung' },
                    { type: 'checkbox', name: 'data-required', label: 'Pflichtfeld' },
                    {
                        type: 'select', name: 'data-width', label: 'Breite',
                        options: [
                            { id: 'full', name: '100 %' }, { id: 'half', name: '50 %' },
                            { id: 'third', name: '33 %' }, { id: 'two-thirds', name: '66 %' },
                        ],
                    },
                    { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
                    { type: 'text', name: 'data-default-value', label: 'Standardwert' },
                    { type: 'number', name: 'data-min-length', label: 'Min. Länge' },
                    { type: 'number', name: 'data-max-length', label: 'Max. Länge' },
                    { type: 'text', name: 'data-pattern', label: 'Validierungsmuster (Regex)' },
                    { type: 'text', name: 'data-error-message', label: 'Fehlermeldung' },
                    conditionsButtonTrait,
                    // Erweiterte Einstellungen
                    { type: 'number', name: 'data-tabindex', label: 'Taboreihenfolge (tabindex)', placeholder: 'z.B. 1, 2, 3...' },
                    { type: 'text', name: 'data-aria-label', label: 'ARIA-Label (Barrierefreiheit)' },
                    { type: 'text', name: 'data-aria-describedby', label: 'ARIA-Describedby (ID des Hinweistexts)' },
                    { type: 'checkbox', name: 'data-autocomplete-off', label: 'Autocomplete deaktivieren' },
                    translationsButtonTrait,
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
                        options: [{ id: 'full', name: '100 %' }, { id: 'half', name: '50 %' }],
                    },
                    { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
                    { type: 'text', name: 'data-error-message', label: 'Fehlermeldung' },
                    conditionsButtonTrait,
                    { type: 'number', name: 'data-tabindex', label: 'Taboreihenfolge' },
                    { type: 'text', name: 'data-aria-label', label: 'ARIA-Label' },
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
                            { id: 'btn-primary', name: 'Primär' }, { id: 'btn-secondary', name: 'Sekundär' },
                            { id: 'btn-success', name: 'Erfolg' }, { id: 'btn-outline-primary', name: 'Primär (Outline)' },
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
                options: a['data-options'] || '',
                languages: a['data-languages'] || '',
                tabindex: a['data-tabindex'] || '',
                aria_label: a['data-aria-label'] || '',
                aria_describedby: a['data-aria-describedby'] || '',
                autocomplete_off: a['data-autocomplete-off'] === 'true' || a['data-autocomplete-off'] === true,
            });
        }
        component.components().each(c => traverse(c));
    }
    traverse(editor.getWrapper());
    return fields;
}
