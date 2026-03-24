/**
 * BBF Formbuilder – Drag & Drop Form Builder
 * Alpine.js + SortableJS
 */
document.addEventListener('alpine:init', () => {
    Alpine.data('formBuilder', () => ({
        // ─── State ───
        formId: null,
        formName: '',
        formSlug: '',
        formDescription: '',
        formStatus: 'draft',
        submitButtonText: 'Absenden',
        isMultiStep: false,
        formFields: [],
        selectedFieldId: null,
        settingsTab: 'general',
        fieldSearch: '',
        isDirty: false,
        saving: false,
        sortableInstance: null,

        // ─── SVG Icon Map ───
        iconSvg: {
            'type':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><polyline points="4 7 4 4 20 4 20 7"/><line x1="9" y1="20" x2="15" y2="20"/><line x1="12" y1="4" x2="12" y2="20"/></svg>',
            'align-left':   '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><line x1="17" y1="10" x2="3" y2="10"/><line x1="21" y1="6" x2="3" y2="6"/><line x1="21" y1="14" x2="3" y2="14"/><line x1="17" y1="18" x2="3" y2="18"/></svg>',
            'mail':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>',
            'phone':        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>',
            'hash':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><line x1="4" y1="9" x2="20" y2="9"/><line x1="4" y1="15" x2="20" y2="15"/><line x1="10" y1="3" x2="8" y2="21"/><line x1="16" y1="3" x2="14" y2="21"/></svg>',
            'link':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg>',
            'lock':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>',
            'eye-off':      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>',
            'chevron-down': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><polyline points="6 9 12 15 18 9"/></svg>',
            'circle':       '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><circle cx="12" cy="12" r="10"/></svg>',
            'check-square': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>',
            'list':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>',
            'user':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>',
            'map-pin':      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>',
            'calendar':     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>',
            'clock':        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>',
            'upload':       '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><polyline points="16 16 12 12 8 16"/><line x1="12" y1="12" x2="12" y2="21"/><path d="M20.39 18.39A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.3"/></svg>',
            'star':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>',
            'sliders':      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><line x1="4" y1="21" x2="4" y2="14"/><line x1="4" y1="10" x2="4" y2="3"/><line x1="12" y1="21" x2="12" y2="12"/><line x1="12" y1="8" x2="12" y2="3"/><line x1="20" y1="21" x2="20" y2="16"/><line x1="20" y1="12" x2="20" y2="3"/></svg>',
            'minus':        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><line x1="5" y1="12" x2="19" y2="12"/></svg>',
            'columns':      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M12 3h7a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-7m0-18H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7m0-18v18"/></svg>',
            'code':         '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>',
            'shield':       '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>',
        },

        // ─── Field Type Definitions ───
        standardFields: [
            { type: 'text',     label: 'Text',      icon: 'type' },
            { type: 'textarea', label: 'Textarea',   icon: 'align-left' },
            { type: 'email',    label: 'E-Mail',     icon: 'mail' },
            { type: 'phone',    label: 'Telefon',    icon: 'phone' },
            { type: 'number',   label: 'Zahl',       icon: 'hash' },
            { type: 'url',      label: 'URL',        icon: 'link' },
            { type: 'password', label: 'Passwort',   icon: 'lock' },
            { type: 'hidden',   label: 'Versteckt',  icon: 'eye-off' },
            { type: 'select',   label: 'Dropdown',   icon: 'chevron-down' },
            { type: 'radio',    label: 'Radio',      icon: 'circle' },
            { type: 'checkbox', label: 'Checkbox',   icon: 'check-square' },
        ],
        advancedFields: [
            { type: 'name',        label: 'Name',         icon: 'user' },
            { type: 'address',     label: 'Adresse',      icon: 'map-pin' },
            { type: 'date',        label: 'Datum',        icon: 'calendar' },
            { type: 'time',        label: 'Uhrzeit',      icon: 'clock' },
            { type: 'file_upload', label: 'Datei-Upload', icon: 'upload' },
            { type: 'rating',      label: 'Bewertung',    icon: 'star' },
            { type: 'slider',      label: 'Slider',       icon: 'sliders' },
        ],
        layoutFields: [
            { type: 'section_break', label: 'Abschnitt',     icon: 'minus' },
            { type: 'page_break',    label: 'Seitenumbruch', icon: 'columns' },
            { type: 'html_block',    label: 'HTML-Block',    icon: 'code' },
            { type: 'gdpr',          label: 'DSGVO',         icon: 'shield' },
            { type: 'captcha',       label: 'CAPTCHA',       icon: 'lock' },
        ],

        // ─── Computed: selected field object ───
        get selectedField() {
            if (!this.selectedFieldId) return null;
            return this.formFields.find(f => f.id === this.selectedFieldId) || null;
        },

        // ─── Has choices (select, radio, checkbox) ───
        get selectedFieldHasChoices() {
            if (!this.selectedField) return false;
            return ['select', 'radio', 'checkbox', 'multiselect'].includes(this.selectedField.type);
        },

        // ─── Init ───
        init() {
            // Parse formId from template data or URL params
            var builderEl = document.getElementById('bbf-form-builder');
            if (builderEl) {
                var fid = builderEl.getAttribute('data-form-id');
                if (fid && fid !== '0') {
                    this.formId = parseInt(fid, 10);
                }
                var tplId = builderEl.getAttribute('data-template-id');
                if (tplId && tplId !== '0' && !this.formId) {
                    this.createFromTemplate(parseInt(tplId, 10));
                    return;
                }
            }

            if (this.formId) {
                this.loadForm(this.formId);
            }

            this.$nextTick(() => {
                this.initSortable();
            });
        },

        // ─── SortableJS Initialization ───
        initSortable() {
            var dropZone = document.getElementById('bbf-drop-zone');
            if (!dropZone || typeof Sortable === 'undefined') return;

            var self = this;

            this.sortableInstance = Sortable.create(dropZone, {
                animation: 200,
                ghostClass: 'sortable-ghost',
                dragClass: 'sortable-drag',
                chosenClass: 'sortable-chosen',
                handle: '.bbf-canvas-field-drag-handle',
                filter: '.bbf-canvas-empty',
                onEnd: function(evt) {
                    if (evt.oldIndex === evt.newIndex) return;
                    // Reorder in Alpine data
                    var item = self.formFields.splice(evt.oldIndex, 1)[0];
                    self.formFields.splice(evt.newIndex, 0, item);
                    self.updateSortOrders();
                    self.markDirty();
                },
            });
        },

        // ─── Generate unique field ID ───
        generateFieldId() {
            return 'field_' + Math.random().toString(36).substr(2, 9);
        },

        // ─── Create a new field from a type definition ───
        createField(fieldDef) {
            var hasChoices = ['select', 'radio', 'checkbox', 'multiselect'].includes(fieldDef.type);
            return {
                id: this.generateFieldId(),
                type: fieldDef.type,
                label: fieldDef.label,
                name: '',
                placeholder: '',
                description: '',
                required: false,
                css_class: '',
                default_value: '',
                width: 'full',
                validation: {},
                conditional_logic: null,
                sort_order: this.formFields.length,
                step: 0,
                min_length: null,
                max_length: null,
                pattern: '',
                error_message: '',
                choices: hasChoices
                    ? [
                        { label: 'Option 1', value: 'option_1' },
                        { label: 'Option 2', value: 'option_2' },
                        { label: 'Option 3', value: 'option_3' },
                    ]
                    : null,
                // Type-specific defaults
                html_content: fieldDef.type === 'html_block' ? '<p>HTML-Inhalt hier eingeben</p>' : null,
                section_title: fieldDef.type === 'section_break' ? 'Abschnitt' : null,
                min_value: ['number', 'slider'].includes(fieldDef.type) ? 0 : null,
                max_value: fieldDef.type === 'slider' ? 100 : null,
                step_value: fieldDef.type === 'slider' ? 1 : null,
                max_stars: fieldDef.type === 'rating' ? 5 : null,
                max_file_size: fieldDef.type === 'file_upload' ? 10 : null, // MB
                allowed_extensions: fieldDef.type === 'file_upload' ? 'pdf,jpg,png,doc,docx' : null,
                gdpr_text: fieldDef.type === 'gdpr' ? 'Ich stimme der Verarbeitung meiner Daten gemäß der <a href="/datenschutz">Datenschutzerklärung</a> zu.' : null,
            };
        },

        // ─── Drag from Palette ───
        onDragStart(event, fieldDef) {
            event.dataTransfer.setData('text/plain', JSON.stringify(fieldDef));
            event.dataTransfer.effectAllowed = 'copy';
        },

        onDragOver(event) {
            event.dataTransfer.dropEffect = 'copy';
        },

        onDrop(event) {
            try {
                var data = JSON.parse(event.dataTransfer.getData('text/plain'));
                if (data && data.type) {
                    this.addField(data);
                }
            } catch (e) {
                // Not a palette drag — ignore
            }
        },

        onFieldDragStart(event, index) {
            // SortableJS handles this, but we need it for native drag compat
            event.dataTransfer.setData('text/plain', '');
            event.dataTransfer.effectAllowed = 'move';
        },

        // ─── Add / Remove / Duplicate / Select ───
        addField(fieldDef) {
            var field = this.createField(fieldDef);
            this.formFields.push(field);
            this.selectedFieldId = field.id;
            this.settingsTab = 'general';
            this.markDirty();

            // Re-init sortable after DOM update
            this.$nextTick(() => {
                if (!this.sortableInstance) {
                    this.initSortable();
                }
            });
        },

        selectField(fieldId) {
            this.selectedFieldId = fieldId;
            this.settingsTab = 'general';
        },

        removeField(index) {
            var removedId = this.formFields[index].id;
            this.formFields.splice(index, 1);
            if (this.selectedFieldId === removedId) {
                this.selectedFieldId = this.formFields.length > 0
                    ? this.formFields[Math.min(index, this.formFields.length - 1)].id
                    : null;
            }
            this.updateSortOrders();
            this.markDirty();
        },

        duplicateField(index) {
            var original = JSON.parse(JSON.stringify(this.formFields[index]));
            original.id = this.generateFieldId();
            original.label += ' (Kopie)';
            this.formFields.splice(index + 1, 0, original);
            this.selectedFieldId = original.id;
            this.updateSortOrders();
            this.markDirty();
        },

        updateSortOrders() {
            this.formFields.forEach(function(f, i) { f.sort_order = i; });
        },

        markDirty() {
            this.isDirty = true;
        },

        // ─── Choices Management ───
        addChoice() {
            if (!this.selectedField || !this.selectedField.choices) return;
            var num = this.selectedField.choices.length + 1;
            this.selectedField.choices.push({
                label: 'Option ' + num,
                value: 'option_' + num,
            });
            this.markDirty();
        },

        removeChoice(choiceIndex) {
            if (!this.selectedField || !this.selectedField.choices) return;
            this.selectedField.choices.splice(choiceIndex, 1);
            this.markDirty();
        },

        // ─── Field Preview Rendering ───
        renderFieldPreview(field) {
            switch (field.type) {
                case 'text':
                case 'email':
                case 'phone':
                case 'url':
                case 'password':
                case 'number':
                    return '<input type="text" disabled class="bbf-preview-input" placeholder="' +
                        this.escHtml(field.placeholder || field.label) + '">';

                case 'textarea':
                    return '<textarea disabled class="bbf-preview-textarea" placeholder="' +
                        this.escHtml(field.placeholder || field.label) + '"></textarea>';

                case 'select':
                    var opts = (field.choices || []).map(function(c) {
                        return '<option>' + c.label + '</option>';
                    }).join('');
                    return '<select disabled class="bbf-preview-select"><option>' +
                        (field.placeholder || 'Bitte wählen') + '</option>' + opts + '</select>';

                case 'radio':
                    return (field.choices || []).map(function(c) {
                        return '<label class="bbf-preview-radio"><input type="radio" disabled> ' + c.label + '</label>';
                    }).join(' ');

                case 'checkbox':
                    return (field.choices || []).map(function(c) {
                        return '<label class="bbf-preview-checkbox"><input type="checkbox" disabled> ' + c.label + '</label>';
                    }).join(' ');

                case 'date':
                    return '<input type="date" disabled class="bbf-preview-input">';

                case 'time':
                    return '<input type="time" disabled class="bbf-preview-input">';

                case 'file_upload':
                    return '<div class="bbf-preview-file">📁 Datei-Upload (max. ' + (field.max_file_size || 10) + ' MB)</div>';

                case 'rating':
                    var stars = '';
                    for (var i = 0; i < (field.max_stars || 5); i++) stars += '⭐';
                    return '<div class="bbf-preview-rating">' + stars + '</div>';

                case 'slider':
                    return '<input type="range" disabled class="bbf-preview-slider" min="' +
                        (field.min_value || 0) + '" max="' + (field.max_value || 100) + '">';

                case 'section_break':
                    return '<hr style="margin:4px 0;"><span style="font-size:11px;color:#999;">' +
                        this.escHtml(field.section_title || 'Abschnitt') + '</span>';

                case 'page_break':
                    return '<div style="text-align:center;padding:4px;background:#e3f2fd;border-radius:4px;font-size:11px;color:#1565c0;">↓ Seitenumbruch ↓</div>';

                case 'html_block':
                    return '<div style="font-size:11px;color:#999;font-style:italic;">HTML-Block</div>';

                case 'gdpr':
                    return '<label class="bbf-preview-checkbox"><input type="checkbox" disabled> ' +
                        (field.gdpr_text ? field.gdpr_text.replace(/<[^>]*>/g, '') .substring(0, 60) + '...' : 'DSGVO-Zustimmung') + '</label>';

                case 'captcha':
                    return '<div style="text-align:center;padding:4px;background:#f0f0f0;border-radius:4px;font-size:11px;">🔒 CAPTCHA</div>';

                case 'name':
                    return '<div style="display:flex;gap:8px;"><input type="text" disabled class="bbf-preview-input" placeholder="Vorname" style="flex:1"><input type="text" disabled class="bbf-preview-input" placeholder="Nachname" style="flex:1"></div>';

                case 'address':
                    return '<div style="font-size:11px;color:#999;">Adressfelder (Straße, PLZ, Ort, Land)</div>';

                case 'hidden':
                    return '<div style="font-size:11px;color:#999;font-style:italic;">Verstecktes Feld</div>';

                default:
                    return '<div style="font-size:11px;color:#999;">' + field.type + '</div>';
            }
        },

        escHtml(str) {
            var div = document.createElement('div');
            div.textContent = str || '';
            return div.innerHTML;
        },

        // ─── Width Helpers ───
        widthOptions: [
            { value: 'full',       label: '100%',  percent: 100 },
            { value: 'half',       label: '50%',   percent: 50 },
            { value: 'third',      label: '33%',   percent: 33 },
            { value: 'two-thirds', label: '66%',   percent: 66 },
            { value: 'quarter',    label: '25%',   percent: 25 },
        ],

        setFieldWidth(width) {
            if (this.selectedField) {
                this.selectedField.width = width;
                this.markDirty();
            }
        },

        // ─── AJAX: Load Form ───
        loadForm(formId) {
            var self = this;
            $.ajax({
                url: postURL,
                method: 'POST',
                data: {
                    action: 'getFormData',
                    form_id: formId,
                    is_ajax: 1,
                    jtl_token: document.querySelector('[name="jtl_token"]').value,
                },
                dataType: 'json',
                success: function(response) {
                    if (response && response.flag && response.form) {
                        var form = response.form;
                        self.formId = parseInt(form.id, 10);
                        self.formName = form.title || '';
                        self.formSlug = form.slug || '';
                        self.formDescription = form.description || '';
                        self.formStatus = form.status || 'draft';
                        self.submitButtonText = form.submit_button_text || 'Absenden';
                        self.isMultiStep = parseInt(form.is_multi_step, 10) === 1;

                        try {
                            self.formFields = JSON.parse(form.fields_json || '[]');
                        } catch (e) {
                            self.formFields = [];
                        }

                        self.isDirty = false;

                        self.$nextTick(function() {
                            self.initSortable();
                        });
                    } else if (response && response.errors) {
                        response.errors.forEach(function(err) {
                            bbdNotify('Fehler', err, 'danger', 'fa fa-exclamation-triangle');
                        });
                    }
                },
                error: function() {
                    bbdNotify('Fehler', 'Formular konnte nicht geladen werden.', 'danger', 'fa fa-exclamation-triangle');
                },
            });
        },

        // ─── AJAX: Save Form ───
        saveForm() {
            var self = this;
            if (this.saving) return;
            this.saving = true;

            // If no formId yet, create the form first
            if (!this.formId) {
                if (!this.formName.trim()) {
                    bbdNotify('Fehler', 'Bitte einen Formularnamen eingeben.', 'danger', 'fa fa-exclamation-triangle');
                    this.saving = false;
                    return;
                }
                this.createAndSave();
                return;
            }

            // Update form metadata + fields
            $.ajax({
                url: postURL,
                method: 'POST',
                data: {
                    action: 'updateForm',
                    form_id: self.formId,
                    title: self.formName,
                    description: self.formDescription,
                    status: self.formStatus,
                    submit_button_text: self.submitButtonText,
                    is_ajax: 1,
                    jtl_token: document.querySelector('[name="jtl_token"]').value,
                },
                dataType: 'json',
                success: function() {
                    // Now save fields
                    self.saveFields();
                },
                error: function() {
                    bbdNotify('Fehler', 'Speichern fehlgeschlagen.', 'danger', 'fa fa-exclamation-triangle');
                    self.saving = false;
                },
            });
        },

        saveFields() {
            var self = this;
            this.updateSortOrders();

            // Check if multi-step
            var hasPageBreak = this.formFields.some(function(f) { return f.type === 'page_break'; });
            this.isMultiStep = hasPageBreak;

            // Assign step numbers based on page breaks
            var currentStep = 0;
            this.formFields.forEach(function(f) {
                if (f.type === 'page_break') {
                    currentStep++;
                }
                f.step = currentStep;
            });

            $.ajax({
                url: postURL,
                method: 'POST',
                data: {
                    action: 'saveFormFields',
                    form_id: self.formId,
                    fields_json: JSON.stringify(self.formFields),
                    is_multi_step: self.isMultiStep ? 1 : 0,
                    is_ajax: 1,
                    jtl_token: document.querySelector('[name="jtl_token"]').value,
                },
                dataType: 'json',
                success: function(response) {
                    if (response && response.flag) {
                        self.isDirty = false;
                        bbdNotify('Gespeichert', 'Formular erfolgreich gespeichert.', 'success', 'fa fa-check-circle');
                    } else if (response && response.errors) {
                        response.errors.forEach(function(err) {
                            bbdNotify('Fehler', err, 'danger', 'fa fa-exclamation-triangle');
                        });
                    }
                    self.saving = false;
                },
                error: function() {
                    bbdNotify('Fehler', 'Felder konnten nicht gespeichert werden.', 'danger', 'fa fa-exclamation-triangle');
                    self.saving = false;
                },
            });
        },

        // ─── AJAX: Create new form then save fields ───
        createAndSave() {
            var self = this;
            $.ajax({
                url: postURL,
                method: 'POST',
                data: {
                    action: 'createForm',
                    title: self.formName,
                    description: self.formDescription,
                    fields_json: JSON.stringify(self.formFields),
                    is_ajax: 1,
                    jtl_token: document.querySelector('[name="jtl_token"]').value,
                },
                dataType: 'json',
                success: function(response) {
                    if (response && response.flag && response.form_id) {
                        self.formId = response.form_id;
                        // Now save the full fields
                        self.saveFields();
                    } else if (response && response.errors) {
                        response.errors.forEach(function(err) {
                            bbdNotify('Fehler', err, 'danger', 'fa fa-exclamation-triangle');
                        });
                        self.saving = false;
                    }
                },
                error: function() {
                    bbdNotify('Fehler', 'Formular konnte nicht erstellt werden.', 'danger', 'fa fa-exclamation-triangle');
                    self.saving = false;
                },
            });
        },

        // ─── Create from template ───
        createFromTemplate(templateId) {
            var self = this;
            $.ajax({
                url: postURL,
                method: 'POST',
                data: {
                    action: 'createFromTemplate',
                    template_id: templateId,
                    is_ajax: 1,
                    jtl_token: document.querySelector('[name="jtl_token"]').value,
                },
                dataType: 'json',
                success: function(response) {
                    if (response && response.flag && response.form_id) {
                        self.formId = response.form_id;
                        self.loadForm(response.form_id);
                    } else if (response && response.errors) {
                        response.errors.forEach(function(err) {
                            bbdNotify('Fehler', err, 'danger', 'fa fa-exclamation-triangle');
                        });
                    }
                },
                error: function() {
                    bbdNotify('Fehler', 'Vorlage konnte nicht geladen werden.', 'danger', 'fa fa-exclamation-triangle');
                },
            });
        },

        // ─── Navigation helpers ───
        previewForm() {
            if (this.formId) {
                window.open(ShopURL + '/bbf-form/' + (this.formSlug || this.formId), '_blank');
            } else {
                bbdNotify('Hinweis', 'Bitte zuerst speichern.', 'info', 'fa fa-info-circle');
            }
        },

        openFormSettings() {
            if (this.formId) {
                bbfNavigate('form-settings', { form_id: this.formId });
            } else {
                bbdNotify('Hinweis', 'Bitte zuerst speichern.', 'info', 'fa fa-info-circle');
            }
        },
    }));
});
