/**
 * BBF Formbuilder – Custom GrapesJS Form Block Types
 */

export default function bbfFormBlocks(editor) {
    const bm = editor.BlockManager;

    // ── BBF Standard-Felder ──────────────────────────────────

    bm.add('bbf-text', {
        label: 'Textfeld',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-font' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--text'],
            attributes: { 'data-field-type': 'text', 'data-field-id': '', 'data-label': 'Textfeld', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Textfeld' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'text', placeholder: 'Text eingeben...' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-email', {
        label: 'E-Mail',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-envelope' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--email'],
            attributes: { 'data-field-type': 'email', 'data-field-id': '', 'data-label': 'E-Mail', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'E-Mail' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'email', placeholder: 'name@beispiel.de' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-textarea', {
        label: 'Textbereich',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-align-left' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--textarea'],
            attributes: { 'data-field-type': 'textarea', 'data-field-id': '', 'data-label': 'Textbereich', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Textbereich' },
                { tagName: 'textarea', classes: ['bbf-field__input', 'form-control'], attributes: { rows: '4', placeholder: 'Ihre Nachricht...' }, content: '' },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-phone', {
        label: 'Telefon',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-phone' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--phone'],
            attributes: { 'data-field-type': 'phone', 'data-field-id': '', 'data-label': 'Telefon', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Telefon' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'tel', placeholder: '+49 123 456789' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-number', {
        label: 'Zahl',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-hashtag' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--number'],
            attributes: { 'data-field-type': 'number', 'data-field-id': '', 'data-label': 'Zahl', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Zahl' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'number', placeholder: '0' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-select', {
        label: 'Dropdown',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-chevron-down' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--select'],
            attributes: { 'data-field-type': 'select', 'data-field-id': '', 'data-label': 'Dropdown', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Dropdown' },
                {
                    tagName: 'select', classes: ['bbf-field__input', 'form-select'],
                    components: [
                        { tagName: 'option', attributes: { value: '' }, content: 'Bitte wählen...' },
                        { tagName: 'option', attributes: { value: 'option_1' }, content: 'Option 1' },
                        { tagName: 'option', attributes: { value: 'option_2' }, content: 'Option 2' },
                        { tagName: 'option', attributes: { value: 'option_3' }, content: 'Option 3' },
                    ],
                },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-checkbox', {
        label: 'Checkbox',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-check-square' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--checkbox'],
            attributes: { 'data-field-type': 'checkbox', 'data-field-id': '', 'data-label': 'Checkbox', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Checkbox' },
                {
                    tagName: 'div', classes: ['bbf-field__options'],
                    components: [
                        {
                            tagName: 'div', classes: ['form-check'],
                            components: [
                                { tagName: 'input', void: true, classes: ['form-check-input'], attributes: { type: 'checkbox', value: 'option_1' } },
                                { tagName: 'label', classes: ['form-check-label'], content: 'Option 1' },
                            ],
                        },
                        {
                            tagName: 'div', classes: ['form-check'],
                            components: [
                                { tagName: 'input', void: true, classes: ['form-check-input'], attributes: { type: 'checkbox', value: 'option_2' } },
                                { tagName: 'label', classes: ['form-check-label'], content: 'Option 2' },
                            ],
                        },
                    ],
                },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-radio', {
        label: 'Radio',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-dot-circle' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--radio'],
            attributes: { 'data-field-type': 'radio', 'data-field-id': '', 'data-label': 'Radio', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Radio' },
                {
                    tagName: 'div', classes: ['bbf-field__options'],
                    components: [
                        {
                            tagName: 'div', classes: ['form-check'],
                            components: [
                                { tagName: 'input', void: true, classes: ['form-check-input'], attributes: { type: 'radio', name: 'radio_group', value: 'option_1' } },
                                { tagName: 'label', classes: ['form-check-label'], content: 'Option 1' },
                            ],
                        },
                        {
                            tagName: 'div', classes: ['form-check'],
                            components: [
                                { tagName: 'input', void: true, classes: ['form-check-input'], attributes: { type: 'radio', name: 'radio_group', value: 'option_2' } },
                                { tagName: 'label', classes: ['form-check-label'], content: 'Option 2' },
                            ],
                        },
                    ],
                },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-date', {
        label: 'Datum',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-calendar-alt' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--date'],
            attributes: { 'data-field-type': 'date', 'data-field-id': '', 'data-label': 'Datum', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Datum' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'date' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-time', {
        label: 'Uhrzeit',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-clock' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--time'],
            attributes: { 'data-field-type': 'time', 'data-field-id': '', 'data-label': 'Uhrzeit', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Uhrzeit' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'time' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-password', {
        label: 'Passwort',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-lock' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--password'],
            attributes: { 'data-field-type': 'password', 'data-field-id': '', 'data-label': 'Passwort', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Passwort' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'password', placeholder: 'Passwort eingeben...' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-url', {
        label: 'URL',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-link' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--url'],
            attributes: { 'data-field-type': 'url', 'data-field-id': '', 'data-label': 'URL', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'URL' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'url', placeholder: 'https://www.beispiel.de' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-hidden', {
        label: 'Versteckt',
        category: 'BBF Standard-Felder',
        attributes: { class: 'fa fa-eye-slash' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--hidden'],
            attributes: { 'data-field-type': 'hidden', 'data-field-id': '', 'data-label': 'Verstecktes Feld', 'data-required': 'false' },
            components: [
                {
                    tagName: 'div', classes: ['bbf-field__hidden-placeholder'],
                    content: '<span style="font-size:12px;color:#94a3b8;"><i class="fa fa-eye-slash"></i> Verstecktes Feld</span>',
                },
                { tagName: 'input', void: true, attributes: { type: 'hidden' } },
            ],
        },
    });

    // ── BBF Erweiterte Felder ────────────────────────────────

    bm.add('bbf-name', {
        label: 'Name',
        category: 'BBF Erweiterte Felder',
        attributes: { class: 'fa fa-user' },
        content: {
            type: 'bbf-compound-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--name'],
            attributes: { 'data-field-type': 'name', 'data-field-id': '', 'data-label': 'Name', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Name' },
                {
                    tagName: 'div', classes: ['row', 'g-2'],
                    components: [
                        {
                            tagName: 'div', classes: ['col-md-6'],
                            components: [
                                { tagName: 'input', void: true, classes: ['form-control'], attributes: { type: 'text', placeholder: 'Vorname' } },
                            ],
                        },
                        {
                            tagName: 'div', classes: ['col-md-6'],
                            components: [
                                { tagName: 'input', void: true, classes: ['form-control'], attributes: { type: 'text', placeholder: 'Nachname' } },
                            ],
                        },
                    ],
                },
            ],
        },
    });

    bm.add('bbf-address', {
        label: 'Adresse',
        category: 'BBF Erweiterte Felder',
        attributes: { class: 'fa fa-map-marker-alt' },
        content: {
            type: 'bbf-compound-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--address'],
            attributes: { 'data-field-type': 'address', 'data-field-id': '', 'data-label': 'Adresse', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Adresse' },
                {
                    tagName: 'div', classes: ['bbf-address-fields'],
                    components: [
                        { tagName: 'input', void: true, classes: ['form-control', 'mb-2'], attributes: { type: 'text', placeholder: 'Straße und Hausnummer' } },
                        {
                            tagName: 'div', classes: ['row', 'g-2', 'mb-2'],
                            components: [
                                {
                                    tagName: 'div', classes: ['col-md-4'],
                                    components: [
                                        { tagName: 'input', void: true, classes: ['form-control'], attributes: { type: 'text', placeholder: 'PLZ' } },
                                    ],
                                },
                                {
                                    tagName: 'div', classes: ['col-md-8'],
                                    components: [
                                        { tagName: 'input', void: true, classes: ['form-control'], attributes: { type: 'text', placeholder: 'Ort' } },
                                    ],
                                },
                            ],
                        },
                        {
                            tagName: 'select', classes: ['form-select'],
                            components: [
                                { tagName: 'option', attributes: { value: '' }, content: 'Land wählen...' },
                                { tagName: 'option', attributes: { value: 'DE' }, content: 'Deutschland' },
                                { tagName: 'option', attributes: { value: 'AT' }, content: 'Österreich' },
                                { tagName: 'option', attributes: { value: 'CH' }, content: 'Schweiz' },
                            ],
                        },
                    ],
                },
            ],
        },
    });

    bm.add('bbf-file-upload', {
        label: 'Datei-Upload',
        category: 'BBF Erweiterte Felder',
        attributes: { class: 'fa fa-upload' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--file-upload'],
            attributes: { 'data-field-type': 'file_upload', 'data-field-id': '', 'data-label': 'Datei-Upload', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Datei-Upload' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-control'], attributes: { type: 'file' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: 'Max. 10 MB. Erlaubte Formate: PDF, JPG, PNG, DOC, DOCX' },
            ],
        },
    });

    bm.add('bbf-rating', {
        label: 'Bewertung',
        category: 'BBF Erweiterte Felder',
        attributes: { class: 'fa fa-star' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--rating'],
            attributes: { 'data-field-type': 'rating', 'data-field-id': '', 'data-label': 'Bewertung', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Bewertung' },
                {
                    tagName: 'div', classes: ['bbf-rating-stars'],
                    content: '<span class="bbf-star" data-value="1">&#9733;</span><span class="bbf-star" data-value="2">&#9733;</span><span class="bbf-star" data-value="3">&#9733;</span><span class="bbf-star" data-value="4">&#9733;</span><span class="bbf-star" data-value="5">&#9733;</span>',
                },
                { tagName: 'input', void: true, attributes: { type: 'hidden', name: 'rating', value: '' } },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    bm.add('bbf-slider', {
        label: 'Slider',
        category: 'BBF Erweiterte Felder',
        attributes: { class: 'fa fa-sliders-h' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--slider'],
            attributes: { 'data-field-type': 'slider', 'data-field-id': '', 'data-label': 'Slider', 'data-required': 'false' },
            components: [
                { tagName: 'label', classes: ['bbf-field__label'], content: 'Slider' },
                { tagName: 'input', void: true, classes: ['bbf-field__input', 'form-range'], attributes: { type: 'range', min: '0', max: '100', step: '1' } },
                {
                    tagName: 'div', classes: ['bbf-slider-labels', 'd-flex', 'justify-content-between'],
                    components: [
                        { tagName: 'span', content: '0' },
                        { tagName: 'span', content: '100' },
                    ],
                },
                { tagName: 'small', classes: ['bbf-field__description', 'form-text'], content: '' },
            ],
        },
    });

    // ── BBF Layout ───────────────────────────────────────────

    bm.add('bbf-section-break', {
        label: 'Abschnitt',
        category: 'BBF Layout',
        attributes: { class: 'fa fa-minus' },
        content: {
            type: 'bbf-layout',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--section-break'],
            attributes: { 'data-field-type': 'section_break' },
            components: [
                { tagName: 'h4', classes: ['bbf-section-break__title'], content: 'Abschnitt' },
                { tagName: 'p', classes: ['bbf-section-break__description', 'text-muted'], content: 'Beschreibung des Abschnitts' },
                { tagName: 'hr' },
            ],
        },
    });

    bm.add('bbf-page-break', {
        label: 'Seitenumbruch',
        category: 'BBF Layout',
        attributes: { class: 'fa fa-columns' },
        content: {
            type: 'bbf-layout',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--page-break'],
            attributes: { 'data-field-type': 'page_break' },
            droppable: false,
            content: `<div class="bbf-page-break-placeholder" style="padding:1rem;background:#e3f2fd;border:2px dashed #90caf9;border-radius:0.5rem;text-align:center;">
                <i class="fa fa-columns" style="font-size:1.5rem;color:#1565c0;display:block;margin-bottom:0.5rem;"></i>
                <strong style="color:#1565c0;">Seitenumbruch</strong><br>
                <small style="color:#64748b;">Trennt das Formular in mehrere Schritte</small>
            </div>`,
        },
    });

    bm.add('bbf-html-block', {
        label: 'HTML-Block',
        category: 'BBF Layout',
        attributes: { class: 'fa fa-code' },
        content: {
            type: 'bbf-layout',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--html-block'],
            attributes: { 'data-field-type': 'html_block' },
            content: '<div class="bbf-html-content"><p>HTML-Inhalt hier eingeben</p></div>',
        },
    });

    // ── BBF Spezial ──────────────────────────────────────────

    bm.add('bbf-gdpr', {
        label: 'DSGVO',
        category: 'BBF Spezial',
        attributes: { class: 'fa fa-shield-alt' },
        content: {
            type: 'bbf-field',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--gdpr'],
            attributes: { 'data-field-type': 'gdpr', 'data-field-id': '', 'data-label': 'DSGVO-Zustimmung', 'data-required': 'true' },
            components: [
                {
                    tagName: 'div', classes: ['form-check'],
                    components: [
                        { tagName: 'input', void: true, classes: ['form-check-input'], attributes: { type: 'checkbox', required: 'true' } },
                        {
                            tagName: 'label', classes: ['form-check-label'],
                            content: 'Ich stimme der Verarbeitung meiner Daten gemäß der <a href="/datenschutz">Datenschutzerklärung</a> zu.',
                        },
                    ],
                },
            ],
        },
    });

    bm.add('bbf-captcha', {
        label: 'CAPTCHA',
        category: 'BBF Spezial',
        attributes: { class: 'fa fa-robot' },
        content: {
            type: 'bbf-layout',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--captcha'],
            attributes: { 'data-field-type': 'captcha' },
            droppable: false,
            content: `<div class="bbf-captcha-placeholder" style="padding:1.5rem;background:#f0f0f0;border:2px dashed #94a3b8;border-radius:0.5rem;text-align:center;">
                <i class="fa fa-robot" style="font-size:2rem;color:#64748b;display:block;margin-bottom:0.5rem;"></i>
                <strong>CAPTCHA</strong><br>
                <small style="color:#64748b;">Wird beim Rendern durch das CAPTCHA-Widget ersetzt</small>
            </div>`,
        },
    });

    bm.add('bbf-submit', {
        label: 'Absenden',
        category: 'BBF Spezial',
        attributes: { class: 'fa fa-paper-plane' },
        content: {
            type: 'bbf-submit',
            tagName: 'div',
            classes: ['bbf-field', 'bbf-field--submit'],
            attributes: { 'data-field-type': 'submit', 'data-button-text': 'Absenden' },
            components: [
                {
                    tagName: 'button', classes: ['btn', 'btn-primary', 'bbf-submit-btn'],
                    attributes: { type: 'submit' },
                    content: 'Absenden',
                },
            ],
        },
    });
}
