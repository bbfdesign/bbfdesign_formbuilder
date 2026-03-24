/**
 * BBF Formbuilder – Frontend Form Logic
 * Handles AJAX submission, client-side validation, conditional logic
 */
document.addEventListener('alpine:init', () => {
    Alpine.data('bbfForm', (config) => ({
        formId: config.formId,
        fields: config.fields || [],
        values: {},
        errors: {},
        isSubmitting: false,
        isSuccess: false,
        successMessage: '',
        currentStep: 0,
        totalSteps: 1,
        csrfToken: config.csrfToken,
        ajaxUrl: config.ajaxUrl,

        init() {
            // Initialize values from defaults
            this.fields.forEach(field => {
                this.values[field.id] = field.default_value || '';
            });
            // Calculate total steps
            const steps = this.fields.map(f => (f.step || 0) + 1);
            this.totalSteps = steps.length > 0 ? Math.max(...steps) : 1;
        },

        /**
         * Check if a field should be visible (conditional logic)
         */
        isFieldVisible(field) {
            if (!field.conditional_logic) return true;

            const logic = field.conditional_logic;
            const action = logic.action || 'show';
            const match = logic.match || 'all';
            const rules = logic.rules || [];

            if (rules.length === 0) return true;

            const results = rules.map(rule => this.evaluateRule(rule));
            const conditionsMet = match === 'all'
                ? results.every(r => r)
                : results.some(r => r);

            return action === 'show' ? conditionsMet : !conditionsMet;
        },

        /**
         * Evaluate a single conditional logic rule
         */
        evaluateRule(rule) {
            const value = String(this.values[rule.field_id] || '');
            const compare = String(rule.value || '');

            switch (rule.operator) {
                case 'is':
                    return value === compare;
                case 'is_not':
                    return value !== compare;
                case 'contains':
                    return value.toLowerCase().includes(compare.toLowerCase());
                case 'does_not_contain':
                    return !value.toLowerCase().includes(compare.toLowerCase());
                case 'is_empty':
                    return value.trim() === '';
                case 'is_not_empty':
                    return value.trim() !== '';
                case 'greater_than':
                    return parseFloat(value) > parseFloat(compare);
                case 'less_than':
                    return parseFloat(value) < parseFloat(compare);
                case 'is_checked':
                    return !!value && value !== '0';
                case 'is_not_checked':
                    return !value || value === '0';
                default:
                    return true;
            }
        },

        /**
         * Get fields for current step
         */
        get currentStepFields() {
            return this.fields.filter(f => (f.step || 0) === this.currentStep);
        },

        /**
         * Navigate to next step
         */
        nextStep() {
            if (this.validateCurrentStep()) {
                this.currentStep = Math.min(this.currentStep + 1, this.totalSteps - 1);
            }
        },

        /**
         * Navigate to previous step
         */
        prevStep() {
            this.currentStep = Math.max(this.currentStep - 1, 0);
        },

        /**
         * Client-side validation for current step
         */
        validateCurrentStep() {
            this.errors = {};
            let valid = true;

            this.currentStepFields.forEach(field => {
                if (!this.isFieldVisible(field)) return;
                const error = this.validateField(field);
                if (error) {
                    this.errors[field.id] = error;
                    valid = false;
                }
            });

            if (!valid) {
                this.$nextTick(() => {
                    const firstError = this.$el.querySelector('[aria-invalid="true"]');
                    if (firstError) firstError.focus();
                });
            }

            return valid;
        },

        /**
         * Validate a single field
         */
        validateField(field) {
            const value = this.values[field.id];

            // Required check
            if (field.required && (!value || (typeof value === 'string' && !value.trim()))) {
                return config.messages?.required || 'Dieses Feld ist ein Pflichtfeld.';
            }

            // Email format
            if (field.type === 'email' && value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                return config.messages?.email || 'Bitte geben Sie eine gültige E-Mail-Adresse ein.';
            }

            // URL format
            if (field.type === 'url' && value && !/^https?:\/\/.+/.test(value)) {
                return config.messages?.url || 'Bitte geben Sie eine gültige URL ein.';
            }

            // Phone format
            if (field.type === 'phone' && value && !/^[\d\s\-+()\/]{6,30}$/.test(value)) {
                return config.messages?.phone || 'Bitte geben Sie eine gültige Telefonnummer ein.';
            }

            // Min length
            if (field.min_length && value && String(value).length < field.min_length) {
                return (config.messages?.minLength || 'Mindestens {min} Zeichen erforderlich.')
                    .replace('{min}', field.min_length);
            }

            // Max length
            if (field.max_length && value && String(value).length > field.max_length) {
                return (config.messages?.maxLength || 'Maximal {max} Zeichen erlaubt.')
                    .replace('{max}', field.max_length);
            }

            return null;
        },

        /**
         * Submit form via AJAX
         */
        async submitForm() {
            // Validate all visible fields
            this.errors = {};
            let valid = true;

            this.fields.forEach(field => {
                if (!this.isFieldVisible(field)) return;
                const error = this.validateField(field);
                if (error) {
                    this.errors[field.id] = error;
                    valid = false;
                }
            });

            if (!valid) {
                this.$nextTick(() => {
                    const firstError = this.$el.querySelector('[aria-invalid="true"]');
                    if (firstError) firstError.focus();
                });
                return;
            }

            this.isSubmitting = true;

            const formData = new FormData();
            formData.append('form_id', this.formId);
            formData.append('bbf_csrf_token', this.csrfToken);

            // Append visible field values
            this.fields.forEach(field => {
                if (!this.isFieldVisible(field)) return;
                const val = this.values[field.id];
                if (Array.isArray(val)) {
                    val.forEach(v => formData.append(field.id + '[]', v));
                } else {
                    formData.append(field.id, val || '');
                }
            });

            // Append file inputs
            this.$el.querySelectorAll('input[type="file"]').forEach(input => {
                if (input.files.length > 0) {
                    Array.from(input.files).forEach(file => {
                        formData.append(input.name, file);
                    });
                }
            });

            try {
                const response = await fetch(this.ajaxUrl, {
                    method: 'POST',
                    body: formData,
                });
                const result = await response.json();

                if (result.success) {
                    this.isSuccess = true;
                    this.successMessage = result.message || 'Vielen Dank!';
                    // Scroll to top of form
                    this.$el.scrollIntoView({ behavior: 'smooth', block: 'start' });
                } else {
                    if (result.errors) {
                        this.errors = result.errors;
                        this.$nextTick(() => {
                            const firstError = this.$el.querySelector('[aria-invalid="true"]');
                            if (firstError) firstError.focus();
                        });
                    }
                }
            } catch (e) {
                this.errors._form = 'Ein Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';
            } finally {
                this.isSubmitting = false;
            }
        },
    }));
});
