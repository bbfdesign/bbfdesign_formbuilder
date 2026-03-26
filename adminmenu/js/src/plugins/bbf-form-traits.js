/**
 * BBF Formbuilder – Custom Component Types & Traits
 * isComponent MUST match the exact HTML from bbf-form-blocks.js
 */
export default function bbfFormTraits(editor) {
    const dc = editor.DomComponents;

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
                ],
            },
        },
    });

    // ── bbf-submit ───────────────────────────────────────────
    dc.addType('bbf-submit', {
        isComponent: (el) => {
            if (!el) return false;
            return !!el.querySelector?.('.bbf-submit-btn')
                || el.classList?.contains('bbf-submit-btn');
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
            });
        }
        component.components().each(c => traverse(c));
    }
    traverse(editor.getWrapper());
    return fields;
}
