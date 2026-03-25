/**
 * BBF Formbuilder – Custom Component Types & Traits
 */

export default function bbfFormTraits(editor) {
    const dc = editor.DomComponents;

    // ── bbf-field: Standard single-input form field ──────────
    dc.addType('bbf-field', {
        isComponent: (el) => el?.classList?.contains('bbf-field') && !el.classList.contains('bbf-field--name') && !el.classList.contains('bbf-field--address'),
        model: {
            defaults: {
                tagName: 'div',
                draggable: true,
                droppable: false,
                traits: [
                    {
                        type: 'text',
                        name: 'data-field-id',
                        label: 'Feld-ID',
                        placeholder: 'z.B. vorname, email',
                    },
                    {
                        type: 'text',
                        name: 'data-label',
                        label: 'Label',
                    },
                    {
                        type: 'text',
                        name: 'data-placeholder',
                        label: 'Platzhalter',
                    },
                    {
                        type: 'text',
                        name: 'data-description',
                        label: 'Beschreibung',
                    },
                    {
                        type: 'checkbox',
                        name: 'data-required',
                        label: 'Pflichtfeld',
                    },
                    {
                        type: 'select',
                        name: 'data-width',
                        label: 'Breite',
                        options: [
                            { id: 'full', name: '100%' },
                            { id: 'half', name: '50%' },
                            { id: 'third', name: '33%' },
                            { id: 'two-thirds', name: '66%' },
                        ],
                    },
                    {
                        type: 'text',
                        name: 'data-css-class',
                        label: 'CSS-Klasse',
                    },
                    {
                        type: 'text',
                        name: 'data-default-value',
                        label: 'Standardwert',
                    },
                    {
                        type: 'number',
                        name: 'data-min-length',
                        label: 'Min. Länge',
                    },
                    {
                        type: 'number',
                        name: 'data-max-length',
                        label: 'Max. Länge',
                    },
                    {
                        type: 'text',
                        name: 'data-pattern',
                        label: 'Validierungsmuster (Regex)',
                    },
                    {
                        type: 'text',
                        name: 'data-error-message',
                        label: 'Fehlermeldung',
                    },
                ],
            },
        },
    });

    // ── bbf-compound-field: Multi-input fields (name, address) ─
    dc.addType('bbf-compound-field', {
        isComponent: (el) => el?.classList?.contains('bbf-field--name') || el?.classList?.contains('bbf-field--address'),
        model: {
            defaults: {
                tagName: 'div',
                draggable: true,
                droppable: false,
                traits: [
                    {
                        type: 'text',
                        name: 'data-field-id',
                        label: 'Feld-ID',
                        placeholder: 'z.B. name, adresse',
                    },
                    {
                        type: 'text',
                        name: 'data-label',
                        label: 'Label',
                    },
                    {
                        type: 'checkbox',
                        name: 'data-required',
                        label: 'Pflichtfeld',
                    },
                    {
                        type: 'select',
                        name: 'data-width',
                        label: 'Breite',
                        options: [
                            { id: 'full', name: '100%' },
                            { id: 'half', name: '50%' },
                            { id: 'third', name: '33%' },
                            { id: 'two-thirds', name: '66%' },
                        ],
                    },
                    {
                        type: 'text',
                        name: 'data-css-class',
                        label: 'CSS-Klasse',
                    },
                    {
                        type: 'text',
                        name: 'data-description',
                        label: 'Beschreibung',
                    },
                    {
                        type: 'text',
                        name: 'data-error-message',
                        label: 'Fehlermeldung',
                    },
                ],
            },
        },
    });

    // ── bbf-submit: Submit button ────────────────────────────
    dc.addType('bbf-submit', {
        isComponent: (el) => el?.classList?.contains('bbf-field--submit'),
        model: {
            defaults: {
                tagName: 'div',
                draggable: true,
                droppable: false,
                traits: [
                    {
                        type: 'text',
                        name: 'data-button-text',
                        label: 'Button-Text',
                    },
                    {
                        type: 'text',
                        name: 'data-css-class',
                        label: 'CSS-Klasse',
                    },
                    {
                        type: 'select',
                        name: 'data-button-style',
                        label: 'Button-Stil',
                        options: [
                            { id: 'btn-primary', name: 'Primär' },
                            { id: 'btn-secondary', name: 'Sekundär' },
                            { id: 'btn-success', name: 'Erfolg' },
                            { id: 'btn-danger', name: 'Gefahr' },
                            { id: 'btn-warning', name: 'Warnung' },
                            { id: 'btn-info', name: 'Info' },
                            { id: 'btn-outline-primary', name: 'Primär (Outline)' },
                            { id: 'btn-outline-secondary', name: 'Sekundär (Outline)' },
                        ],
                    },
                    {
                        type: 'checkbox',
                        name: 'data-full-width',
                        label: 'Volle Breite',
                    },
                ],
            },
        },
    });

    // ── bbf-layout: Layout/structural elements ───────────────
    dc.addType('bbf-layout', {
        isComponent: (el) => {
            if (!el?.classList?.contains('bbf-field')) return false;
            const ft = el.getAttribute?.('data-field-type');
            return ['section_break', 'page_break', 'html_block', 'captcha'].includes(ft);
        },
        model: {
            defaults: {
                tagName: 'div',
                draggable: true,
                droppable: false,
                traits: [
                    {
                        type: 'text',
                        name: 'data-field-type',
                        label: 'Feldtyp',
                        changeProp: false,
                        attributes: { readonly: true },
                    },
                ],
            },
        },
    });
}

/**
 * Extracts field definitions from the GrapesJS component tree.
 * Traverses all components and collects bbf-field, bbf-compound-field,
 * and bbf-submit components into a flat array.
 *
 * @param {Object} editor - GrapesJS editor instance
 * @returns {Array} Array of field definition objects
 */
export function extractFieldDefinitions(editor) {
    const fields = [];
    const wrapper = editor.getWrapper();

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
