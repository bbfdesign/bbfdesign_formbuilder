/**
 * BBF Formbuilder – Custom Component Types, Traits & Commands
 * isComponent MUST match the exact HTML from bbf-form-blocks.js
 */
export default function bbfFormTraits(editor) {
    const dc = editor.DomComponents;

    // ── Escape helper ─────────────────────────────────────────
    const esc = s => String(s || '').replace(/&/g, '&amp;').replace(/"/g, '&quot;')
        .replace(/</g, '&lt;').replace(/>/g, '&gt;');

    // ── Shared button traits ──────────────────────────────────
    const conditionsButtonTrait = {
        type: 'button', name: 'btn-conditions',
        label: 'Bedingte Anzeige', text: '🔀 Regeln konfigurieren',
        full: true, command: 'bbf:open-conditions-panel',
    };

    // ══════════════════════════════════════════════════════════
    //  COMMAND: Conditions Panel
    // ══════════════════════════════════════════════════════════
    editor.Commands.add('bbf:open-conditions-panel', {
        run(ed) {
            const sel = ed.getSelected();
            if (!sel) return;
            let conditions;
            try { conditions = JSON.parse(sel.getAttributes()['data-conditions'] || ''); } catch (e) { conditions = null; }
            if (!conditions) conditions = { enabled: false, action: 'show', match: 'all', rules: [] };

            const allFields = [];
            (function collect(comp) {
                const t = comp.get('type');
                if ((t === 'bbf-field' || t === 'bbf-compound-field') && comp !== sel) {
                    const a = comp.getAttributes();
                    allFields.push({ id: a['data-field-id'] || comp.getId(), label: a['data-label'] || a['data-field-type'] || t });
                }
                comp.components().each(c => collect(c));
            })(ed.getWrapper());

            const ops = [['is','ist gleich'],['is_not','ist nicht gleich'],['contains','enthält'],['does_not_contain','enthält nicht'],['is_empty','ist leer'],['is_not_empty','ist nicht leer'],['greater_than','größer als'],['less_than','kleiner als'],['is_checked','ist angehakt'],['is_not_checked','ist nicht angehakt']];
            const noVal = ['is_empty','is_not_empty','is_checked','is_not_checked'];
            const fOpts = allFields.map(f => `<option value="${esc(f.id)}">${esc(f.label)}</option>`).join('');
            const oOpts = ops.map(o => `<option value="${o[0]}">${o[1]}</option>`).join('');

            const renderRule = () => `<div class="bbf-cr" style="display:flex;gap:6px;align-items:center;margin-bottom:8px;flex-wrap:wrap;"><select data-r="f" style="flex:1;min-width:110px;padding:7px;border:1.5px solid #e5e7eb;border-radius:6px;font-size:13px;"><option value="">— Feld —</option>${fOpts}</select><select data-r="o" style="flex:1;min-width:110px;padding:7px;border:1.5px solid #e5e7eb;border-radius:6px;font-size:13px;">${oOpts}</select><input data-r="v" placeholder="Wert" style="flex:1;min-width:80px;padding:7px;border:1.5px solid #e5e7eb;border-radius:6px;font-size:13px;"><button data-r="x" style="background:none;border:none;color:#ef4444;cursor:pointer;font-size:18px;padding:4px;">×</button></div>`;

            const html = `<div style="padding:20px;min-width:520px;font-family:inherit;">
                <div style="display:flex;align-items:center;gap:12px;margin-bottom:16px;"><label style="font-size:13px;font-weight:600;">Bedingte Anzeige</label><input type="checkbox" id="ce" ${conditions.enabled?'checked':''} style="accent-color:#e8420a;width:18px;height:18px;"></div>
                <div id="cc" style="${conditions.enabled?'':'opacity:0.4;pointer-events:none;'}">
                    <div style="display:flex;gap:8px;margin-bottom:14px;align-items:center;flex-wrap:wrap;font-size:13px;"><span>Dieses Feld</span><select id="ca" style="padding:6px;border:1.5px solid #e5e7eb;border-radius:6px;font-size:13px;"><option value="show" ${conditions.action==='show'?'selected':''}>anzeigen</option><option value="hide" ${conditions.action==='hide'?'selected':''}>verbergen</option></select><span>wenn</span><select id="cm" style="padding:6px;border:1.5px solid #e5e7eb;border-radius:6px;font-size:13px;"><option value="all" ${conditions.match==='all'?'selected':''}>alle Bedingungen</option><option value="any" ${conditions.match==='any'?'selected':''}>eine Bedingung</option></select><span>erfüllt</span></div>
                    <div id="cr">${conditions.rules.length ? conditions.rules.map(() => renderRule()).join('') : '<p style="color:#9ca3af;font-size:13px;">Keine Regeln.</p>'}</div>
                    <button id="ca2" style="padding:7px 16px;border-radius:6px;border:1.5px solid #e8420a;background:#fff;color:#e8420a;font-size:12px;font-weight:600;cursor:pointer;">+ Regel</button>
                </div>
                <div style="margin-top:18px;padding-top:14px;border-top:1px solid #f3f4f6;display:flex;gap:8px;justify-content:flex-end;"><button id="cx" style="padding:8px 20px;border-radius:6px;border:1.5px solid #e5e7eb;background:#fff;cursor:pointer;font-size:13px;">Abbrechen</button><button id="cs" style="padding:8px 20px;border-radius:6px;border:none;background:#e8420a;color:#fff;cursor:pointer;font-size:13px;font-weight:600;">Speichern</button></div>
            </div>`;

            const modal = ed.Modal; modal.setTitle('Bedingte Anzeige'); const w = document.createElement('div'); w.innerHTML = html; modal.setContent(w); modal.open();

            // Set existing rule values
            const rows = w.querySelectorAll('.bbf-cr');
            conditions.rules.forEach((r, i) => { if (!rows[i]) return; rows[i].querySelector('[data-r="f"]').value = r.field||''; rows[i].querySelector('[data-r="o"]').value = r.operator||'is'; const vi = rows[i].querySelector('[data-r="v"]'); vi.value = r.value||''; vi.style.display = noVal.includes(r.operator)?'none':''; });

            w.querySelector('#ce').addEventListener('change', function() { const c = w.querySelector('#cc'); c.style.opacity = this.checked?'':'0.4'; c.style.pointerEvents = this.checked?'':'none'; });
            w.addEventListener('change', e => { if (e.target.dataset.r === 'o') e.target.closest('.bbf-cr').querySelector('[data-r="v"]').style.display = noVal.includes(e.target.value)?'none':''; });
            w.querySelector('#ca2').addEventListener('click', () => { const cr = w.querySelector('#cr'); const p = cr.querySelector('p'); if (p) p.remove(); cr.insertAdjacentHTML('beforeend', renderRule()); });
            w.addEventListener('click', e => { if (e.target.dataset.r === 'x') e.target.closest('.bbf-cr').remove(); });
            w.querySelector('#cx').addEventListener('click', () => modal.close());
            w.querySelector('#cs').addEventListener('click', () => {
                const rules = []; w.querySelectorAll('.bbf-cr').forEach(r => { const f = r.querySelector('[data-r="f"]').value; if (f) rules.push({ field: f, operator: r.querySelector('[data-r="o"]').value, value: r.querySelector('[data-r="v"]').value }); });
                sel.addAttributes({ 'data-conditions': JSON.stringify({ enabled: w.querySelector('#ce').checked, action: w.querySelector('#ca').value, match: w.querySelector('#cm').value, rules }) });
                modal.close();
            });
        },
    });

    // ══════════════════════════════════════════════════════════
    //  COMMAND: Options Editor (Select, Radio, Checkbox)
    // ══════════════════════════════════════════════════════════
    editor.Commands.add('bbf:open-options-editor', {
        run(ed) {
            const sel = ed.getSelected(); if (!sel) return;
            const fieldType = sel.getAttributes()['data-field-type'];
            let options = [];
            try { options = JSON.parse(sel.getAttributes()['data-options'] || ''); } catch(e) {}
            if (!options.length) options = fieldType === 'select'
                ? [{label:'Option 1',value:'option_1'},{label:'Option 2',value:'option_2'},{label:'Option 3',value:'option_3'}]
                : [{label:'Option A',value:'option_a'},{label:'Option B',value:'option_b'}];

            const renderRows = opts => opts.length ? opts.map(o => `<div class="bbf-opt-row" style="display:grid;grid-template-columns:1fr 1fr auto;gap:6px;align-items:center;margin-bottom:6px;"><input data-role="label" value="${esc(o.label)}" placeholder="Angezeigter Text" style="padding:7px 10px;border:1.5px solid #e5e7eb;border-radius:6px;font-size:13px;width:100%;outline:none;"><input data-role="value" value="${esc(o.value)}" placeholder="Wert (intern)" style="padding:7px 10px;border:1.5px solid #e5e7eb;border-radius:6px;font-size:13px;width:100%;outline:none;"><button data-role="del" style="background:none;border:none;color:#ef4444;cursor:pointer;font-size:18px;padding:4px 8px;line-height:1;" title="Entfernen">×</button></div>`).join('') : '<p style="color:#9ca3af;font-size:13px;margin:0;">Noch keine Optionen.</p>';

            const titles = {select:'Dropdown-Optionen',radio:'Radio-Optionen',checkbox:'Checkbox-Optionen'};
            const html = `<div style="padding:20px;min-width:520px;font-family:inherit;"><div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;"><div><div style="display:grid;grid-template-columns:1fr 1fr auto;gap:6px;font-size:11px;font-weight:600;color:#6b7280;"><span>Angezeigter Text</span><span>Wert (intern)</span><span></span></div></div><button id="bbf-opt-add" style="padding:7px 16px;border-radius:6px;border:1.5px solid #e8420a;background:#fff;color:#e8420a;font-size:12px;font-weight:600;cursor:pointer;">+ Option</button></div><div id="bbf-opt-list" style="margin-bottom:16px;">${renderRows(options)}</div><div style="padding-top:14px;border-top:1px solid #f3f4f6;display:flex;gap:8px;justify-content:flex-end;"><button id="bbf-opt-cancel" style="padding:8px 20px;border-radius:6px;border:1.5px solid #e5e7eb;background:#fff;cursor:pointer;font-size:13px;">Abbrechen</button><button id="bbf-opt-save" style="padding:8px 20px;border-radius:6px;border:none;background:#e8420a;color:#fff;cursor:pointer;font-size:13px;font-weight:600;">Speichern</button></div></div>`;

            const modal = ed.Modal; modal.setTitle(titles[fieldType]||'Optionen'); const w = document.createElement('div'); w.innerHTML = html; modal.setContent(w); modal.open();

            w.querySelector('#bbf-opt-add').addEventListener('click', () => { const l = w.querySelector('#bbf-opt-list'); const p = l.querySelector('p'); if (p) p.remove(); l.insertAdjacentHTML('beforeend', renderRows([{label:'',value:''}])); });
            w.addEventListener('click', e => { if (e.target.dataset.role === 'del') { e.target.closest('.bbf-opt-row').remove(); if (!w.querySelector('.bbf-opt-row')) w.querySelector('#bbf-opt-list').innerHTML = '<p style="color:#9ca3af;font-size:13px;margin:0;">Noch keine Optionen.</p>'; }});
            w.querySelector('#bbf-opt-cancel').addEventListener('click', () => modal.close());
            w.querySelector('#bbf-opt-save').addEventListener('click', () => {
                const newOpts = []; w.querySelectorAll('.bbf-opt-row').forEach(r => { const l = r.querySelector('[data-role="label"]').value.trim(), v = r.querySelector('[data-role="value"]').value.trim(); if (l||v) newOpts.push({label:l||v,value:v||l}); });
                sel.addAttributes({'data-options':JSON.stringify(newOpts)});
                // Canvas live update
                try {
                    if (fieldType === 'select') {
                        sel.components().each(c => { if (c.get('tagName')==='select'||c.getClasses().includes('form-control')) { c.components().reset([{tagName:'option',attributes:{value:''},content:'— Bitte wählen —'}].concat(newOpts.map(o=>({tagName:'option',attributes:{value:o.value},content:o.label})))); }});
                    } else {
                        const inputType = fieldType==='radio'?'radio':'checkbox', gid = sel.getAttributes()['data-field-id']||sel.getId(), rm = [];
                        sel.components().each(c => { if (c.getClasses().includes('form-check')) rm.push(c); }); rm.forEach(c => c.remove());
                        newOpts.forEach(o => { const uid = 'o_'+Math.random().toString(36).slice(2,7); sel.components().add({tagName:'div',classes:['form-check'],components:[{tagName:'input',attributes:{type:inputType,class:'form-check-input',name:gid,value:o.value,id:uid}},{tagName:'label',attributes:{class:'form-check-label',for:uid},content:o.label}]}); });
                    }
                } catch(e) { console.warn('BBF: canvas update failed', e); }
                modal.close();
            });
        },
    });

    // ══════════════════════════════════════════════════════════
    //  COMMAND: Translations / Mehrsprachigkeit
    // ══════════════════════════════════════════════════════════
    editor.Commands.add('bbf:open-translations', {
        run(ed) {
            const sel = ed.getSelected(); if (!sel) return;
            const attrs = sel.getAttributes();
            const LANGS = [{code:'ger',flag:'🇩🇪',name:'Deutsch'},{code:'eng',flag:'🇬🇧',name:'Englisch'},{code:'fra',flag:'🇫🇷',name:'Französisch'},{code:'ita',flag:'🇮🇹',name:'Italienisch'},{code:'spa',flag:'🇪🇸',name:'Spanisch'},{code:'nld',flag:'🇳🇱',name:'Niederländisch'},{code:'pol',flag:'🇵🇱',name:'Polnisch'},{code:'ces',flag:'🇨🇿',name:'Tschechisch'}];
            let active = ['ger']; try { active = JSON.parse(attrs['data-languages']||'["ger"]'); } catch(e) {}
            const FIELDS = [{key:'label',label:'Label'},{key:'placeholder',label:'Platzhalter'},{key:'description',label:'Hinweistext'}];

            const renderSec = l => `<div class="bbf-lang-sec" data-lang="${l.code}" style="background:#f9fafb;border:1.5px solid #e5e7eb;border-radius:8px;padding:14px 16px;margin-bottom:10px;"><div style="font-size:13px;font-weight:700;color:#1f2937;margin-bottom:12px;">${l.flag} ${l.name}</div>${FIELDS.map(f => `<div style="margin-bottom:10px;"><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;letter-spacing:.05em;display:block;margin-bottom:4px;">${f.label}</label><input data-lang="${l.code}" data-field="${f.key}" value="${esc(attrs['data-'+f.key+'-'+l.code]||(l.code==='ger'?attrs['data-'+f.key]||'':''))}" placeholder="${esc(attrs['data-'+f.key]||f.label)}" style="width:100%;padding:8px 10px;border:1.5px solid #e5e7eb;border-radius:6px;font-size:13px;outline:none;font-family:inherit;"></div>`).join('')}</div>`;

            const html = `<div style="padding:20px;min-width:560px;font-family:inherit;"><div style="margin-bottom:16px;"><div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;letter-spacing:.06em;margin-bottom:8px;">Aktive Sprachen</div><div style="display:flex;flex-wrap:wrap;gap:8px;">${LANGS.map(l => `<label style="display:flex;align-items:center;gap:5px;font-size:13px;cursor:pointer;padding:5px 10px;border:1.5px solid ${active.includes(l.code)?'#e8420a':'#e5e7eb'};border-radius:6px;background:${active.includes(l.code)?'#fff8f6':'#fff'};user-select:none;"><input type="checkbox" data-lt="${l.code}" ${active.includes(l.code)?'checked':''} style="accent-color:#e8420a;"> ${l.flag} ${l.name}</label>`).join('')}</div></div><div id="bls">${LANGS.filter(l=>active.includes(l.code)).map(l=>renderSec(l)).join('')}</div><div style="padding-top:14px;border-top:1px solid #f3f4f6;display:flex;gap:8px;justify-content:flex-end;margin-top:4px;"><button id="btc" style="padding:8px 20px;border-radius:6px;border:1.5px solid #e5e7eb;background:#fff;cursor:pointer;font-size:13px;">Abbrechen</button><button id="bts" style="padding:8px 20px;border-radius:6px;border:none;background:#e8420a;color:#fff;cursor:pointer;font-size:13px;font-weight:600;">Speichern</button></div></div>`;

            const modal = ed.Modal; modal.setTitle('Mehrsprachigkeit'); const w = document.createElement('div'); w.innerHTML = html; modal.setContent(w); modal.open();

            w.addEventListener('change', e => { const t = e.target.dataset.lt; if (!t) return; const l = LANGS.find(x=>x.code===t), lbl = e.target.closest('label'), s = w.querySelector('#bls');
                if (e.target.checked) { lbl.style.borderColor='#e8420a'; lbl.style.background='#fff8f6'; s.insertAdjacentHTML('beforeend', renderSec(l)); }
                else { lbl.style.borderColor='#e5e7eb'; lbl.style.background='#fff'; const sec = s.querySelector(`[data-lang="${t}"]`); if (sec) sec.remove(); }});

            w.querySelector('#btc').addEventListener('click', () => modal.close());
            w.querySelector('#bts').addEventListener('click', () => {
                const na = {}, al = []; w.querySelectorAll('[data-lt]:checked').forEach(cb => al.push(cb.dataset.lt)); na['data-languages'] = JSON.stringify(al);
                w.querySelectorAll('[data-lang][data-field]').forEach(inp => { const l=inp.dataset.lang, f=inp.dataset.field, v=inp.value.trim(); if (v) { na[`data-${f}-${l}`]=v; if (l===al[0]) na[`data-${f}`]=v; }});
                sel.addAttributes(na);
                const nl = na['data-label']; if (nl) { try { sel.components().each(c => { if (c.getClasses().some(x=>['bbf-label','form-label'].includes(x))) c.set('content',nl); }); } catch(e){} }
                modal.close();
            });
        },
    });

    // ══════════════════════════════════════════════════════════
    //  COMMAND: Change Field Type
    // ══════════════════════════════════════════════════════════
    editor.Commands.add('bbf:change-field-type', {
        run(ed) {
            const sel = ed.getSelected(); if (!sel) return;
            const cur = sel.getAttributes()['data-field-type']||'';
            const TYPES = [['text','Textfeld','fa-font'],['email','E-Mail','fa-envelope'],['textarea','Textbereich','fa-align-left'],['phone','Telefon','fa-phone'],['number','Zahl','fa-hashtag'],['url','URL','fa-link'],['password','Passwort','fa-lock'],['date','Datum','fa-calendar'],['time','Uhrzeit','fa-clock-o'],['select','Dropdown','fa-chevron-down'],['radio','Radio','fa-dot-circle-o'],['checkbox','Checkbox','fa-check-square'],['file_upload','Datei-Upload','fa-upload'],['rating','Bewertung','fa-star'],['hidden','Versteckt','fa-eye-slash']];

            const html = `<div style="padding:20px;min-width:480px;font-family:inherit;"><p style="font-size:13px;color:#6b7280;margin:0 0 14px;">Aktuell: <strong style="color:#1f2937;">${cur}</strong></p><div style="display:grid;grid-template-columns:repeat(4,1fr);gap:8px;margin-bottom:16px;">${TYPES.map(t=>`<button data-type="${t[0]}" style="display:flex;flex-direction:column;align-items:center;gap:5px;padding:12px 6px;border-radius:8px;cursor:pointer;border:1.5px solid ${t[0]===cur?'#e8420a':'#e5e7eb'};background:${t[0]===cur?'#fff8f6':'#fff'};font-size:11px;font-weight:600;color:#374151;transition:all .12s;"><i class="fa ${t[2]}" style="font-size:18px;color:${t[0]===cur?'#e8420a':'#6b7280'};"></i>${t[1]}</button>`).join('')}</div><div style="padding-top:12px;border-top:1px solid #f3f4f6;display:flex;justify-content:flex-end;"><button id="btx" style="padding:8px 20px;border-radius:6px;border:1.5px solid #e5e7eb;background:#fff;cursor:pointer;font-size:13px;">Abbrechen</button></div></div>`;

            const modal = ed.Modal; modal.setTitle('Feldtyp ändern'); const w = document.createElement('div'); w.innerHTML = html; modal.setContent(w); modal.open();
            w.querySelectorAll('[data-type]').forEach(b => b.addEventListener('click', () => { sel.addAttributes({'data-field-type':b.dataset.type}); modal.close(); if (['select','radio','checkbox'].includes(b.dataset.type)) setTimeout(()=>ed.Commands.run('bbf:open-options-editor'),100); }));
            w.querySelector('#btx').addEventListener('click', () => modal.close());
        },
    });

    // ══════════════════════════════════════════════════════════
    //  Component Types
    // ══════════════════════════════════════════════════════════

    dc.addType('bbf-field', {
        isComponent: el => el?.getAttribute?.('data-gjs-type') === 'bbf-field' || (el?.classList?.contains('bbf-field') && el?.getAttribute('data-field-type')),
        model: { defaults: { draggable: true, droppable: false, traits: [
            { type: 'text', name: 'data-field-id', label: 'Feld-ID', placeholder: 'z.B. vorname' },
            { type: 'text', name: 'data-label', label: 'Label / Bezeichnung' },
            { type: 'text', name: 'data-placeholder', label: 'Platzhalter' },
            { type: 'text', name: 'data-description', label: 'Hinweistext (unter dem Feld)' },
            { type: 'text', name: 'data-default-value', label: 'Standardwert' },
            { type: 'checkbox', name: 'data-required', label: 'Pflichtfeld' },
            { type: 'select', name: 'data-width', label: 'Feldbreite', options: [
                { id: 'full', name: '100 % — volle Breite' }, { id: 'half', name: '50 % — halbe Breite' },
                { id: 'third', name: '33 % — ein Drittel' }, { id: 'two-thirds', name: '66 % — zwei Drittel' },
            ]},
            { type: 'number', name: 'data-min-length', label: 'Min. Zeichen' },
            { type: 'number', name: 'data-max-length', label: 'Max. Zeichen' },
            { type: 'text', name: 'data-pattern', label: 'Validierung (Regex)', placeholder: 'z.B. [0-9]+' },
            { type: 'text', name: 'data-error-message', label: 'Fehlermeldung' },
            { type: 'number', name: 'data-tabindex', label: 'Tab-Reihenfolge' },
            { type: 'text', name: 'data-aria-label', label: 'ARIA-Label (Screenreader)' },
            { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
            { type: 'button', name: 'btn-type', label: 'Feldtyp', text: '🔄 Feldtyp ändern', full: true, command: 'bbf:change-field-type' },
            { type: 'button', name: 'btn-opts', label: 'Auswahloptionen', text: '⚙ Optionen bearbeiten', full: true,
              command: ed => { const s=ed.getSelected(),t=s?.getAttributes()['data-field-type']; if(['select','radio','checkbox'].includes(t)) ed.Commands.run('bbf:open-options-editor'); else alert('Nur für Dropdown, Radio und Checkbox.'); }},
            { type: 'button', name: 'btn-trans', label: 'Mehrsprachigkeit', text: '🌐 Übersetzungen konfigurieren', full: true, command: 'bbf:open-translations' },
            conditionsButtonTrait,
        ]}},
    });

    dc.addType('bbf-compound-field', {
        isComponent: el => el?.getAttribute?.('data-gjs-type') === 'bbf-compound-field',
        model: { defaults: { draggable: true, droppable: false, traits: [
            { type: 'text', name: 'data-field-id', label: 'Feld-ID' },
            { type: 'text', name: 'data-label', label: 'Label' },
            { type: 'checkbox', name: 'data-required', label: 'Pflichtfeld' },
            { type: 'select', name: 'data-width', label: 'Breite', options: [{ id:'full',name:'100 %' },{ id:'half',name:'50 %' }] },
            { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
            { type: 'text', name: 'data-error-message', label: 'Fehlermeldung' },
            { type: 'number', name: 'data-tabindex', label: 'Tab-Reihenfolge' },
            { type: 'text', name: 'data-aria-label', label: 'ARIA-Label' },
            conditionsButtonTrait,
        ]}},
    });

    dc.addType('bbf-submit', {
        isComponent: el => el?.getAttribute?.('data-gjs-type') === 'bbf-submit',
        model: { defaults: { draggable: true, droppable: false, traits: [
            { type: 'text', name: 'data-button-text', label: 'Button-Text' },
            { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
            { type: 'select', name: 'data-button-style', label: 'Button-Stil', options: [
                { id:'btn-primary',name:'Primär' },{ id:'btn-secondary',name:'Sekundär' },
                { id:'btn-success',name:'Erfolg' },{ id:'btn-outline-primary',name:'Outline' },
            ]},
            { type: 'checkbox', name: 'data-full-width', label: 'Volle Breite' },
            { type: 'select', name: 'data-align', label: 'Ausrichtung', options: [
                { id:'left',name:'Links' },{ id:'center',name:'Zentriert' },{ id:'right',name:'Rechts' },
            ]},
            { type: 'text', name: 'data-icon', label: 'Icon-Klasse (z.B. fa-paper-plane)' },
        ]}},
    });

    dc.addType('bbf-layout', {
        isComponent: el => el?.getAttribute?.('data-gjs-type') === 'bbf-layout',
        model: { defaults: { draggable: true, droppable: true, traits: [
            { type: 'text', name: 'data-field-type', label: 'Typ', attributes: { readonly: true } },
            { type: 'text', name: 'data-css-class', label: 'CSS-Klasse' },
        ]}},
    });
}

export function extractFieldDefinitions(editor) {
    const fields = [];
    function traverse(c) {
        const t = c.get('type');
        if (['bbf-field','bbf-compound-field','bbf-submit'].includes(t)) {
            const a = c.getAttributes();
            fields.push({
                field_id: a['data-field-id']||'', field_type: a['data-field-type']||t,
                label: a['data-label']||'', placeholder: a['data-placeholder']||'',
                description: a['data-description']||'',
                required: a['data-required']==='true'||a['data-required']===true,
                width: a['data-width']||'full', css_class: a['data-css-class']||'',
                default_value: a['data-default-value']||'',
                min_length: a['data-min-length']||'', max_length: a['data-max-length']||'',
                pattern: a['data-pattern']||'', error_message: a['data-error-message']||'',
                conditions: a['data-conditions']||'', options: a['data-options']||'',
                languages: a['data-languages']||'',
                tabindex: a['data-tabindex']||'', aria_label: a['data-aria-label']||'',
            });
        }
        c.components().each(x => traverse(x));
    }
    traverse(editor.getWrapper());
    return fields;
}
