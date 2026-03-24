/**
 * BBF Formbuilder – Drag & Drop Form Builder
 * Uses Alpine.js + SortableJS
 */
document.addEventListener('alpine:init', () => {
    Alpine.data('formBuilder', () => ({
        // State
        formId: null,
        formTitle: '',
        formSlug: '',
        formDescription: '',
        formStatus: 'draft',
        submitButtonText: 'Absenden',
        isMultiStep: false,
        fields: [],
        selectedFieldIndex: null,
        isDirty: false,
        isSaving: false,

        // Field palette - available field types
        fieldTypes: {
            standard: [
                { type: 'text', label: 'Text', icon: 'type' },
                { type: 'textarea', label: 'Textarea', icon: 'align-left' },
                { type: 'email', label: 'E-Mail', icon: 'mail' },
                { type: 'phone', label: 'Telefon', icon: 'phone' },
                { type: 'number', label: 'Zahl', icon: 'hash' },
                { type: 'url', label: 'URL', icon: 'link' },
                { type: 'password', label: 'Passwort', icon: 'lock' },
                { type: 'hidden', label: 'Versteckt', icon: 'eye-off' },
            ],
            choice: [
                { type: 'select', label: 'Dropdown', icon: 'chevron-down' },
                { type: 'radio', label: 'Radio', icon: 'circle' },
                { type: 'checkbox', label: 'Checkbox', icon: 'check-square' },
                { type: 'multiselect', label: 'Mehrfachauswahl', icon: 'list' },
            ],
            complex: [
                { type: 'name', label: 'Name', icon: 'user' },
                { type: 'address', label: 'Adresse', icon: 'map-pin' },
                { type: 'date', label: 'Datum', icon: 'calendar' },
                { type: 'time', label: 'Uhrzeit', icon: 'clock' },
                { type: 'file_upload', label: 'Datei-Upload', icon: 'upload' },
                { type: 'rating', label: 'Bewertung', icon: 'star' },
                { type: 'slider', label: 'Slider', icon: 'sliders' },
            ],
            layout: [
                { type: 'section_break', label: 'Abschnitt', icon: 'minus' },
                { type: 'page_break', label: 'Seitenumbruch', icon: 'columns' },
                { type: 'html_block', label: 'HTML-Block', icon: 'code' },
            ],
            special: [
                { type: 'gdpr', label: 'DSGVO', icon: 'shield' },
                { type: 'captcha', label: 'CAPTCHA', icon: 'lock' },
            ],
        },

        // Initialize
        init() {
            // Will be implemented in Phase 2
            // - Load form data if formId exists
            // - Initialize SortableJS on drop zone
            // - Set up autosave
        },

        // Generate unique field ID
        generateFieldId() {
            return 'field_' + Math.random().toString(36).substr(2, 9);
        },

        // Create new field from type definition
        createField(fieldType) {
            return {
                id: this.generateFieldId(),
                type: fieldType.type,
                label: fieldType.label,
                placeholder: '',
                description: '',
                required: false,
                css_class: '',
                default_value: '',
                width: 'full',
                validation: {},
                conditional_logic: null,
                sort_order: this.fields.length,
                step: 0,
                choices: ['select', 'radio', 'checkbox', 'multiselect'].includes(fieldType.type)
                    ? [{ label: 'Option 1', value: 'option_1' }]
                    : null,
            };
        },

        // Add field to form
        addField(fieldType) {
            const field = this.createField(fieldType);
            this.fields.push(field);
            this.selectedFieldIndex = this.fields.length - 1;
            this.isDirty = true;
        },

        // Select field for editing
        selectField(index) {
            this.selectedFieldIndex = index;
        },

        // Remove field
        removeField(index) {
            this.fields.splice(index, 1);
            if (this.selectedFieldIndex >= this.fields.length) {
                this.selectedFieldIndex = this.fields.length > 0 ? this.fields.length - 1 : null;
            }
            this.isDirty = true;
        },

        // Duplicate field
        duplicateField(index) {
            const original = JSON.parse(JSON.stringify(this.fields[index]));
            original.id = this.generateFieldId();
            original.label += ' (Kopie)';
            this.fields.splice(index + 1, 0, original);
            this.selectedFieldIndex = index + 1;
            this.isDirty = true;
        },

        // Get selected field
        get selectedField() {
            if (this.selectedFieldIndex === null || this.selectedFieldIndex >= this.fields.length) return null;
            return this.fields[this.selectedFieldIndex];
        },

        // Save form via AJAX
        saveForm() {
            // Will be implemented in Phase 2
            this.isSaving = true;
            // AJAX call to save
        },

        // Load form data
        loadForm(formId) {
            // Will be implemented in Phase 2
        },
    }));
});
