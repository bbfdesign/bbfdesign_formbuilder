/**
 * BBF Formbuilder – GrapesJS Form Builder
 * Main entry point for Vite bundling.
 */

import grapesjs from 'grapesjs';
import grapesjsPluginForms from 'grapesjs-plugin-forms';
import bbfFormBlocks from './plugins/bbf-form-blocks.js';
import bbfFormTraits from './plugins/bbf-form-traits.js';

window.BbfFormbuilder = {
    init(config) {
        const {
            container = '#bbf-gjs-editor',
            formId,
            csrfToken = '',
            postURL = '',
            canvasStyles = [],
        } = config;

        const editor = grapesjs.init({
            container,
            fromElement: false,
            height: '100vh',
            width: 'auto',
            storageManager: false,

            canvas: {
                styles: [
                    ...canvasStyles,
                ],
            },

            panels: { defaults: [] },

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
                        properties: [
                            'width', 'min-width', 'max-width',
                            'height', 'min-height',
                            'padding', 'margin',
                        ],
                    },
                    {
                        name: 'Typografie',
                        properties: [
                            'font-family', 'font-size', 'font-weight',
                            'letter-spacing', 'line-height',
                            'color', 'text-align', 'text-transform',
                        ],
                    },
                    {
                        name: 'Hintergrund',
                        properties: [
                            'background-color', 'background-image',
                            'background-size', 'background-position',
                        ],
                    },
                    {
                        name: 'Rahmen & Ecken',
                        properties: [
                            'border', 'border-radius', 'box-shadow',
                        ],
                    },
                ],
            },

            traitManager: {
                appendTo: '#bbf-gjs-traits',
            },

            plugins: [
                grapesjsPluginForms,
                bbfFormBlocks,
                bbfFormTraits,
            ],
            pluginsOpts: {
                [grapesjsPluginForms]: {},
                [bbfFormBlocks]: {},
                [bbfFormTraits]: {},
            },
        });

        // ── Toolbar ───────────────────────────────────────────
        setupToolbar(editor);

        // ── Keyboard Shortcuts ────────────────────────────────
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                e.preventDefault();
                saveForm();
            }
        });

        // ── Save Button ───────────────────────────────────────
        const saveBtn = document.getElementById('bbf-save-form');
        if (saveBtn) {
            saveBtn.addEventListener('click', () => saveForm());
        }

        // ── Save ──────────────────────────────────────────────
        async function saveForm() {
            const gjsData = JSON.stringify(editor.getProjectData());
            const html = editor.getHtml();
            const css = editor.getCss();
            const fields = extractFieldDefinitions(editor);

            try {
                const formData = new FormData();
                formData.append('action', 'saveFormBuilder');
                formData.append('form_id', formId);
                formData.append('gjs_data', gjsData);
                formData.append('html_rendered', html);
                formData.append('css_rendered', css);
                formData.append('fields_json', JSON.stringify(fields));
                formData.append('is_ajax', '1');
                formData.append('jtl_token', csrfToken);

                const response = await fetch(postURL, { method: 'POST', body: formData });
                const data = await response.json();

                if (data.flag) {
                    showNotification('Formular gespeichert', 'success');
                } else {
                    const msg = data.errors ? data.errors.join(', ') : 'Unbekannter Fehler';
                    showNotification('Fehler beim Speichern: ' + msg, 'error');
                }
            } catch (err) {
                showNotification('Fehler beim Speichern', 'error');
                console.error('BBF Formbuilder: Save failed', err);
            }
        }

        // ── Load ──────────────────────────────────────────────
        async function loadForm() {
            try {
                const formData = new FormData();
                formData.append('action', 'getFormData');
                formData.append('form_id', formId);
                formData.append('is_ajax', '1');
                formData.append('jtl_token', csrfToken);

                const response = await fetch(postURL, { method: 'POST', body: formData });
                const data = await response.json();

                if (data.flag && data.form) {
                    if (data.form.gjs_data) {
                        editor.loadProjectData(JSON.parse(data.form.gjs_data));
                    }
                }
            } catch (err) {
                console.warn('BBF Formbuilder: Could not load form data', err);
            }
        }

        // ── Extract Field Definitions ─────────────────────────
        function extractFieldDefinitions(ed) {
            const fields = [];
            const wrapper = ed.getWrapper();

            function traverse(component) {
                const type = component.get('type');
                if (type === 'bbf-field' || type === 'bbf-compound-field' || type === 'bbf-submit') {
                    const attrs = component.getAttributes();
                    fields.push({
                        field_id: attrs['data-field-id'] || '',
                        field_type: attrs['data-field-type'] || type,
                        label: attrs['data-label'] || '',
                        placeholder: attrs['data-placeholder'] || '',
                        description: attrs['data-description'] || '',
                        required: attrs['data-required'] === 'true' || attrs['data-required'] === true,
                        width: attrs['data-width'] || 'full',
                        css_class: attrs['data-css-class'] || '',
                        default_value: attrs['data-default-value'] || '',
                        min_length: attrs['data-min-length'] || '',
                        max_length: attrs['data-max-length'] || '',
                        pattern: attrs['data-pattern'] || '',
                        error_message: attrs['data-error-message'] || '',
                    });
                }

                component.components().each((child) => traverse(child));
            }

            traverse(wrapper);
            return fields;
        }

        // Initial load
        if (formId) {
            loadForm();
        }

        return editor;
    },
};

// ── Toolbar Setup ─────────────────────────────────────────────
function setupToolbar(editor) {
    // Main toolbar
    editor.Panels.addPanel({
        id: 'bbf-toolbar',
        el: '#bbf-toolbar',
        buttons: [
            { id: 'undo', className: 'fa fa-undo', command: 'core:undo', attributes: { title: 'Rückgängig' } },
            { id: 'redo', className: 'fa fa-redo', command: 'core:redo', attributes: { title: 'Wiederholen' } },
            { id: 'preview', className: 'fa fa-eye', command: 'core:preview', attributes: { title: 'Vorschau' } },
            { id: 'code', className: 'fa fa-code', command: 'bbf:open-code', attributes: { title: 'HTML-Editor' } },
            { id: 'fullscreen', className: 'fa fa-expand', command: 'core:fullscreen', attributes: { title: 'Vollbild' } },
            { id: 'clear', className: 'fa fa-trash', command: 'core:canvas-clear', attributes: { title: 'Canvas leeren' } },
        ],
    });

    // Responsive toggle
    editor.Panels.addPanel({
        id: 'bbf-devices',
        el: '#bbf-devices',
        buttons: [
            { id: 'desktop', command: 'set-device-desktop', active: true, className: 'fa fa-desktop', attributes: { title: 'Desktop' } },
            { id: 'tablet', command: 'set-device-tablet', className: 'fa fa-tablet-alt', attributes: { title: 'Tablet' } },
            { id: 'mobile', command: 'set-device-mobile', className: 'fa fa-mobile-alt', attributes: { title: 'Mobile' } },
        ],
    });

    editor.Commands.add('set-device-desktop', { run: (ed) => ed.setDevice('Desktop') });
    editor.Commands.add('set-device-tablet', { run: (ed) => ed.setDevice('Tablet') });
    editor.Commands.add('set-device-mobile', { run: (ed) => ed.setDevice('Mobile') });

    // HTML/CSS Code Editor
    editor.Commands.add('bbf:open-code', {
        run(editor) {
            const html = editor.getHtml();
            const css = editor.getCss();
            openCodeEditorModal(editor, html, css);
        },
    });
}

// ── Code Editor Modal ─────────────────────────────────────────
function openCodeEditorModal(editor, html, css) {
    const modal = editor.Modal;
    modal.setTitle('HTML & CSS Editor');

    const content = document.createElement('div');
    content.className = 'bbf-code-editor';
    content.innerHTML = `
        <div class="bbf-code-editor__tabs" style="display:flex;gap:0.5rem;margin-bottom:1rem;">
            <button class="btn btn-sm btn-primary active" data-tab="html">HTML</button>
            <button class="btn btn-sm btn-outline-secondary" data-tab="css">CSS</button>
        </div>
        <div class="bbf-code-editor__panel" data-panel="html">
            <textarea id="bbf-code-html" style="width:100%;height:400px;font-family:monospace;font-size:13px;border:1px solid #dee2e6;border-radius:4px;padding:0.75rem;">${escapeHtml(html)}</textarea>
        </div>
        <div class="bbf-code-editor__panel" data-panel="css" style="display:none;">
            <textarea id="bbf-code-css" style="width:100%;height:400px;font-family:monospace;font-size:13px;border:1px solid #dee2e6;border-radius:4px;padding:0.75rem;">${escapeHtml(css)}</textarea>
        </div>
        <div style="margin-top:1rem;display:flex;gap:0.5rem;">
            <button class="btn btn-primary" id="bbf-code-apply">Übernehmen</button>
            <button class="btn btn-secondary" id="bbf-code-cancel">Abbrechen</button>
        </div>
    `;

    modal.setContent(content);
    modal.open();

    // Tab switching
    content.querySelectorAll('[data-tab]').forEach((btn) => {
        btn.addEventListener('click', () => {
            content.querySelectorAll('[data-tab]').forEach((b) => {
                b.classList.remove('btn-primary', 'active');
                b.classList.add('btn-outline-secondary');
            });
            btn.classList.add('btn-primary', 'active');
            btn.classList.remove('btn-outline-secondary');

            content.querySelectorAll('[data-panel]').forEach((p) => {
                p.style.display = p.dataset.panel === btn.dataset.tab ? '' : 'none';
            });
        });
    });

    content.querySelector('#bbf-code-apply').addEventListener('click', () => {
        const newHtml = content.querySelector('#bbf-code-html').value;
        const newCss = content.querySelector('#bbf-code-css').value;
        editor.setComponents(newHtml);
        editor.setStyle(newCss);
        modal.close();
    });

    content.querySelector('#bbf-code-cancel').addEventListener('click', () => {
        modal.close();
    });
}

// ── Helpers ───────────────────────────────────────────────────
function escapeHtml(str) {
    const div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
}

function showNotification(message, type = 'info') {
    const container = document.getElementById('bbf-notifications') || document.body;
    const el = document.createElement('div');
    el.className = `bbf-notification bbf-notification--${type}`;
    el.style.cssText = `
        position: fixed; bottom: 1rem; right: 1rem; z-index: 10000;
        padding: 0.75rem 1.25rem; border-radius: 0.5rem;
        font-size: 0.875rem; font-weight: 500;
        background: ${type === 'success' ? '#059669' : type === 'error' ? '#DC2626' : '#2563EB'};
        color: #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        transition: opacity 0.3s; opacity: 1;
    `;
    el.textContent = message;
    container.appendChild(el);

    setTimeout(() => {
        el.style.opacity = '0';
        setTimeout(() => el.remove(), 300);
    }, 3000);
}
