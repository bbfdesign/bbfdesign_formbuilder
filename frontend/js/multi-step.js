/**
 * BBF Formbuilder – Multi-Step Form Navigation
 *
 * Utility object used by the Alpine.js bbfForm component to handle
 * multi-step logic: step detection via page_break fields, progress
 * tracking, step titles, and direct navigation.
 */
var BbfMultiStep = {

    /**
     * Scan the flat field list for page_break entries and split
     * fields into ordered steps. Each step gets a title derived
     * from a preceding section_break label, the page_break label,
     * or a generic "Schritt N".
     *
     * @param {Array} fields – full field list from the form config
     * @returns {Array} steps – [{title: String, fields: Array}, …]
     */
    computeSteps: function (fields) {
        var steps = [{ title: 'Schritt 1', fields: [] }];
        var currentStep = 0;
        var lastSectionTitle = null;

        fields.forEach(function (field) {
            if (field.type === 'section_break') {
                lastSectionTitle = field.section_title || field.label || null;
            }

            if (field.type === 'page_break') {
                // Assign a better title to the step we just finished if we
                // encountered a section_break inside it
                if (lastSectionTitle && steps[currentStep].title === ('Schritt ' + (currentStep + 1))) {
                    steps[currentStep].title = lastSectionTitle;
                }
                lastSectionTitle = null;

                currentStep++;
                var title = field.label || ('Schritt ' + (currentStep + 1));
                steps.push({ title: title, fields: [] });
            } else {
                steps[currentStep].fields.push(field);
            }
        });

        // If the first step still has the generic title but a section_break
        // provided a better one, apply it
        if (lastSectionTitle && steps[currentStep].title === ('Schritt ' + (currentStep + 1))) {
            steps[currentStep].title = lastSectionTitle;
        }

        return steps;
    },

    /**
     * Return the title for a given step index.
     *
     * @param {Array}  steps     – result of computeSteps()
     * @param {Number} stepIndex – zero-based step index
     * @returns {String}
     */
    getStepTitle: function (steps, stepIndex) {
        if (steps[stepIndex] && steps[stepIndex].title) {
            return steps[stepIndex].title;
        }
        return 'Schritt ' + (stepIndex + 1);
    },

    /**
     * Check whether every required and visible field in the given step
     * has a non-empty value.
     *
     * @param {Array}    steps     – result of computeSteps()
     * @param {Number}   stepIndex – zero-based step index
     * @param {Object}   values    – current form values keyed by field id
     * @param {Function} isVisible – visibility predicate (field) => Boolean
     * @returns {Boolean}
     */
    isStepComplete: function (steps, stepIndex, values, isVisible) {
        if (!steps[stepIndex]) return false;

        var fields = steps[stepIndex].fields;
        for (var i = 0; i < fields.length; i++) {
            var field = fields[i];
            if (!field.required) continue;
            if (!isVisible(field)) continue;

            var val = values[field.id];
            if (val === undefined || val === null || val === '') return false;
            if (typeof val === 'string' && val.trim() === '') return false;
            if (Array.isArray(val) && val.length === 0) return false;
        }
        return true;
    },

    /**
     * Determine whether navigation to a target step is allowed.
     * Users may jump to any already-completed step, the current step,
     * or the first incomplete step (i.e. one past the last completed).
     *
     * @param {Number} targetIndex  – zero-based target step
     * @param {Number} currentStep  – zero-based current step
     * @param {Array}  steps        – result of computeSteps()
     * @param {Object} values       – current form values
     * @param {Function} isVisible  – visibility predicate
     * @returns {Boolean}
     */
    canGoToStep: function (targetIndex, currentStep, steps, values, isVisible) {
        if (targetIndex < 0 || targetIndex >= steps.length) return false;
        if (targetIndex <= currentStep) return true;

        // Allow navigating forward only if every preceding step is complete
        for (var i = 0; i < targetIndex; i++) {
            if (!this.isStepComplete(steps, i, values, isVisible)) {
                return false;
            }
        }
        return true;
    },

    /**
     * Return the progress percentage (0–100) based on the current step
     * relative to total steps.
     *
     * @param {Number} currentStep – zero-based index
     * @param {Number} totalSteps  – total number of steps
     * @returns {Number}
     */
    getProgressPercent: function (currentStep, totalSteps) {
        if (totalSteps <= 1) return 100;
        return Math.round((currentStep / (totalSteps - 1)) * 100);
    },

    /**
     * Return the fields belonging to a specific step.
     *
     * @param {Array}  steps     – result of computeSteps()
     * @param {Number} stepIndex – zero-based step index
     * @returns {Array}
     */
    stepFields: function (steps, stepIndex) {
        if (!steps[stepIndex]) return [];
        return steps[stepIndex].fields;
    }
};
