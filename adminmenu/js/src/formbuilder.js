/**
 * BBF Formbuilder – GrapesJS Form Builder
 * Main entry point for Vite bundling.
 */

import grapesjs from 'grapesjs';
import grapesjsPluginForms from 'grapesjs-plugin-forms';
import bbfFormBlocks from './plugins/bbf-form-blocks.js';
import bbfFormTraits from './plugins/bbf-form-traits.js';

window.BbfFormbuilder = {
    editor: null,

    init(config) {
        const {
            container = '#bbf-gjs-editor',
            formId: initialFormId,
            csrfToken = '',
            postURL = '',
            canvasStyles = [],
        } = config;

        let formId = initialFormId;

        // Verify container exists
        const containerEl = document.querySelector(container);
        if (!containerEl) {
            console.error('BBF FormBuilder: Container not found:', container);
            return null;
        }

        // Force explicit height on container chain
        containerEl.style.height = '100%';
        const parent = containerEl.parentElement;
        if (parent) parent.style.height = '100%';
        const grandparent = parent?.parentElement;
        if (grandparent) grandparent.style.height = '100%';

        // Destroy previous instance
        if (this.editor) {
            try { this.editor.destroy(); } catch(e) {}
            this.editor = null;
        }

        console.log('BBF FormBuilder: Initializing in', container, 'height:', containerEl.offsetHeight);

        try {

        const editor = grapesjs.init({
            container,
            fromElement: false,
            height: '100%',
            width: 'auto',
            storageManager: false,

            canvas: {
                styles: [...canvasStyles],
            },

            // Keep default panels for D&D to work — hide via CSS
            // panels: { defaults: [] },  ← REMOVED: kills drag & drop

            deviceManager: {
                devices: [
                    { name: 'Desktop', width: '' },
                    { name: 'Tablet', width: '768px', widthMedia: '992px' },
                    { name: 'Mobile', width: '375px', widthMedia: '768px' },
                ],
            },

            blockManager: {
                appendTo: '#bbf-gjs-blocks',
            },

            styleManager: {
                appendTo: '#bbf-gjs-styles',
                sectors: [
                    {
                        name: 'Abmessungen',
                        open: true,
                        properties: [
                            { property: 'width', label: 'Breite' },
                            { property: 'max-width', label: 'Max. Breite' },
                            { property: 'height', label: 'Höhe' },
                            {
                                property: 'padding', label: 'Innenabstand',
                                properties: [
                                    { property: 'padding-top', label: 'Oben' },
                                    { property: 'padding-right', label: 'Rechts' },
                                    { property: 'padding-bottom', label: 'Unten' },
                                    { property: 'padding-left', label: 'Links' },
                                ],
                            },
                            {
                                property: 'margin', label: 'Außenabstand',
                                properties: [
                                    { property: 'margin-top', label: 'Oben' },
                                    { property: 'margin-right', label: 'Rechts' },
                                    { property: 'margin-bottom', label: 'Unten' },
                                    { property: 'margin-left', label: 'Links' },
                                ],
                            },
                        ],
                    },
                    {
                        name: 'Typografie',
                        open: false,
                        properties: [
                            { property: 'font-size', label: 'Schriftgröße' },
                            { property: 'font-weight', label: 'Schriftstärke' },
                            { property: 'color', label: 'Textfarbe' },
                            {
                                property: 'text-align', label: 'Ausrichtung', type: 'radio',
                                list: [
                                    { value: 'left', className: 'fa fa-align-left' },
                                    { value: 'center', className: 'fa fa-align-center' },
                                    { value: 'right', className: 'fa fa-align-right' },
                                ],
                            },
                        ],
                    },
                    {
                        name: 'Darstellung',
                        open: false,
                        properties: [
                            { property: 'background-color', label: 'Hintergrundfarbe' },
                            { property: 'border-radius', label: 'Eckenradius' },
                            {
                                property: 'border', label: 'Rahmen',
                                properties: [
                                    { property: 'border-width', label: 'Breite' },
                                    { property: 'border-style', label: 'Stil' },
                                    { property: 'border-color', label: 'Farbe' },
                                ],
                            },
                            // Kein box-shadow/opacity — dafür gibt es den CSS-Editor
                        ],
                    },
                ],
            },

            traitManager: {
                appendTo: '#bbf-gjs-traits',
            },

            i18n: {
                locale: 'de',
                detectLocale: false,
                messages: {
                    de: {
                        styleManager: {
                            empty: 'Element auswählen um Styles zu bearbeiten',
                        },
                        traitManager: {
                            empty: 'Element auswählen um Optionen zu bearbeiten',
                            label: 'Einstellungen',
                        },
                        blockManager: {
                            labels: {},
                            categories: {
                                'Forms': 'Formular-Elemente',
                                'BBF Standard-Felder': 'Standard-Felder',
                                'BBF Erweiterte Felder': 'Erweiterte Felder',
                                'BBF Layout': 'Layout',
                                'BBF Spezial': 'Spezial',
                            },
                        },
                        domComponents: {
                            names: { '': 'Box', wrapper: 'Body', text: 'Text', image: 'Bild', label: 'Label', link: 'Link' },
                        },
                    },
                },
            },

            plugins: [
                grapesjsPluginForms,
                bbfFormTraits,
                bbfFormBlocks,
            ],
            pluginsOpts: {
                [grapesjsPluginForms]: {
                    blocks: [],  // No sidebar blocks — we have our own BBF blocks
                },
                [bbfFormTraits]: {},
                [bbfFormBlocks]: {},
            },
        });

        // ── Remove generic Forms-plugin blocks (fallback if blocks:[] didn't work) ──
        const bm = editor.BlockManager;
        ['form', 'input', 'textarea', 'select', 'button', 'label', 'checkbox', 'radio'].forEach(id => {
            if (bm.get(id)) {
                bm.remove(id);
                console.log('BBF: Removed generic block:', id);
            }
        });

        // ── Fix Canvas Drop Events + Cleanup on load ─────────
        editor.on('load', () => {
            // Canvas iFrame drop events
            const frame = editor.Canvas.getFrameEl();
            if (frame?.contentDocument?.body) {
                frame.contentDocument.body.addEventListener('dragover', e => { e.preventDefault(); e.stopPropagation(); });
                frame.contentDocument.body.addEventListener('drop', e => e.preventDefault());
            }
            const canvasEl = editor.Canvas.getElement();
            if (canvasEl) canvasEl.addEventListener('dragover', e => e.preventDefault());

            // Remove unwanted Style Manager sectors (keep only German ones)
            try {
                const sm = editor.StyleManager;
                const keep = ['Abmessungen', 'Typografie', 'Darstellung'];
                const sectors = sm.getSectors();
                const toRemove = [];
                sectors.forEach(s => {
                    const name = s.get('name') || s.get('id') || '';
                    if (!keep.includes(name)) toRemove.push(s.get('id') || name);
                });
                toRemove.forEach(id => {
                    try { sm.removeSector(id); } catch(e) {}
                });
                if (toRemove.length) console.log('BBF: Removed SM sectors:', toRemove);
            } catch(e) { console.warn('BBF: SM cleanup error', e); }

            console.log('BBF: Editor load complete');
        });

        // ── Toolbar ──────────────────────────────────────────
        setupHtmlToolbar(editor);

        // ── Keyboard Shortcut: Ctrl+S ────────────────────────
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                e.preventDefault();
                saveForm();
            }
        });

        // ── Save Button ──────────────────────────────────────
        const saveBtn = document.getElementById('bbf-btn-save');
        if (saveBtn) saveBtn.addEventListener('click', () => saveForm());

        // ── Save ─────────────────────────────────────────────
        async function saveForm() {
            const gjsData = JSON.stringify(editor.getProjectData());
            const html = editor.getHtml();
            const css = editor.getCss();
            const fields = extractFieldDefinitions(editor);

            try {
                const titleEl = document.getElementById('bbf-form-title');
                const title = titleEl ? titleEl.value : '';

                const fd = new FormData();
                fd.append('action', 'saveFormBuilder');
                fd.append('form_id', formId || '');
                fd.append('title', title);
                fd.append('gjs_data', gjsData);
                fd.append('html_rendered', html);
                fd.append('css_rendered', css);
                fd.append('fields_json', JSON.stringify(fields));
                fd.append('is_ajax', '1');
                fd.append('jtl_token', csrfToken);

                const resp = await fetch(postURL, { method: 'POST', body: fd });
                const data = await resp.json();

                if (data.flag) {
                    if (data.form_id) formId = data.form_id;
                    showNotification('Formular gespeichert', 'success');
                } else {
                    showNotification('Fehler: ' + (data.errors ? data.errors.join(', ') : '?'), 'error');
                }
            } catch (err) {
                showNotification('Fehler beim Speichern', 'error');
                console.error('BBF Save failed', err);
            }
        }

        // ── Load ─────────────────────────────────────────────
        async function loadForm() {
            try {
                const fd = new FormData();
                fd.append('action', 'getFormData');
                fd.append('form_id', formId);
                fd.append('is_ajax', '1');
                fd.append('jtl_token', csrfToken);

                const resp = await fetch(postURL, { method: 'POST', body: fd });
                const data = await resp.json();

                if (data.flag && data.form) {
                    if (data.form.gjs_data) {
                        editor.loadProjectData(JSON.parse(data.form.gjs_data));
                    }
                    const titleEl = document.getElementById('bbf-form-title');
                    if (titleEl && data.form.title) titleEl.value = data.form.title;
                }
            } catch (err) {
                console.warn('BBF: Could not load form', err);
            }
        }

        // ── Extract Fields ───────────────────────────────────
        function extractFieldDefinitions(ed) {
            const fields = [];
            function traverse(comp) {
                const type = comp.get('type');
                if (type === 'bbf-field' || type === 'bbf-compound-field' || type === 'bbf-submit') {
                    const a = comp.getAttributes();
                    fields.push({
                        field_id: a['data-field-id'] || '',
                        field_type: a['data-field-type'] || type,
                        label: a['data-label'] || '',
                        placeholder: a['data-placeholder'] || '',
                        description: a['data-description'] || '',
                        required: a['data-required'] === 'true',
                        width: a['data-width'] || 'full',
                    });
                }
                comp.components().each(c => traverse(c));
            }
            traverse(ed.getWrapper());
            return fields;
        }

        // Initial load
        if (formId) loadForm();

        this.editor = editor;
        console.log('BBF FormBuilder: Initialized OK');
        return editor;

        } catch (err) {
            console.error('BBF FormBuilder init failed:', err);
            containerEl.innerHTML =
                '<div style="padding:40px;text-align:center;color:#dc3545;">' +
                '<p><strong>Editor-Fehler</strong></p>' +
                '<p style="font-size:13px;">' + err.message + '</p></div>';
            return null;
        }
    },

    destroy() {
        if (this.editor) {
            try { this.editor.destroy(); } catch(e) {}
            this.editor = null;
        }
    },
};

// ── Toolbar ──────────────────────────────────────────────────
function setupHtmlToolbar(editor) {
    editor.Commands.add('set-device-desktop', { run: (ed) => ed.setDevice('Desktop') });
    editor.Commands.add('set-device-tablet', { run: (ed) => ed.setDevice('Tablet') });
    editor.Commands.add('set-device-mobile', { run: (ed) => ed.setDevice('Mobile') });
    editor.Commands.add('bbf:open-code', {
        run(editor) { openCodeEditorModal(editor, editor.getHtml(), editor.getCss()); },
    });

    const bindings = {
        'bbf-btn-undo':    () => editor.runCommand('core:undo'),
        'bbf-btn-redo':    () => editor.runCommand('core:redo'),
        'bbf-btn-preview': () => editor.runCommand('core:preview'),
        'bbf-btn-code':    () => editor.runCommand('bbf:open-code'),
        'bbf-btn-clear':   () => { if (confirm('Canvas leeren?')) editor.runCommand('core:canvas-clear'); },
        'bbf-btn-desktop': () => editor.runCommand('set-device-desktop'),
        'bbf-btn-tablet':  () => editor.runCommand('set-device-tablet'),
        'bbf-btn-mobile':  () => editor.runCommand('set-device-mobile'),
    };
    Object.entries(bindings).forEach(([id, fn]) => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('click', fn);
    });
}

// ── Code Editor Modal ────────────────────────────────────────
function openCodeEditorModal(editor, html, css) {
    const modal = editor.Modal;
    modal.setTitle('HTML & CSS');
    const c = document.createElement('div');
    c.innerHTML = `
        <div style="display:flex;gap:.5rem;margin-bottom:1rem;">
            <button class="btn btn-sm btn-primary active" data-tab="html">HTML</button>
            <button class="btn btn-sm btn-outline-secondary" data-tab="css">CSS</button>
        </div>
        <div data-panel="html"><textarea id="bbf-code-html" style="width:100%;height:400px;font-family:monospace;font-size:13px;border:1px solid #dee2e6;border-radius:4px;padding:.75rem;">${escapeHtml(html)}</textarea></div>
        <div data-panel="css" style="display:none;"><textarea id="bbf-code-css" style="width:100%;height:400px;font-family:monospace;font-size:13px;border:1px solid #dee2e6;border-radius:4px;padding:.75rem;">${escapeHtml(css)}</textarea></div>
        <div style="margin-top:1rem;display:flex;gap:.5rem;">
            <button class="btn btn-primary" id="bbf-code-apply">Übernehmen</button>
            <button class="btn btn-secondary" id="bbf-code-cancel">Abbrechen</button>
        </div>`;
    modal.setContent(c);
    modal.open();

    c.querySelectorAll('[data-tab]').forEach(btn => {
        btn.addEventListener('click', () => {
            c.querySelectorAll('[data-tab]').forEach(b => { b.classList.remove('btn-primary','active'); b.classList.add('btn-outline-secondary'); });
            btn.classList.add('btn-primary','active'); btn.classList.remove('btn-outline-secondary');
            c.querySelectorAll('[data-panel]').forEach(p => { p.style.display = p.dataset.panel === btn.dataset.tab ? '' : 'none'; });
        });
    });
    c.querySelector('#bbf-code-apply').addEventListener('click', () => { editor.setComponents(c.querySelector('#bbf-code-html').value); editor.setStyle(c.querySelector('#bbf-code-css').value); modal.close(); });
    c.querySelector('#bbf-code-cancel').addEventListener('click', () => modal.close());
}

function escapeHtml(s) { const d = document.createElement('div'); d.textContent = s; return d.innerHTML; }

function showNotification(msg, type = 'info') {
    const el = document.createElement('div');
    el.style.cssText = `position:fixed;bottom:1rem;right:1rem;z-index:10000;padding:.75rem 1.25rem;border-radius:.5rem;font-size:.875rem;font-weight:500;color:#fff;box-shadow:0 4px 12px rgba(0,0,0,.2);opacity:1;transition:opacity .3s;background:${type==='success'?'#059669':type==='error'?'#DC2626':'#2563EB'};`;
    el.textContent = msg;
    document.body.appendChild(el);
    setTimeout(() => { el.style.opacity = '0'; setTimeout(() => el.remove(), 300); }, 3000);
}
