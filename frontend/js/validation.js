/**
 * BBF Formbuilder – Client-side Validation Helpers
 * Standalone validation utilities (non-Alpine fallback)
 */
var BbfValidation = {
    email: function (value) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
    },

    phone: function (value) {
        return /^[\d\s\-+()\/]{6,30}$/.test(value);
    },

    url: function (value) {
        return /^https?:\/\/.+/.test(value);
    },

    required: function (value) {
        return value !== null && value !== undefined && String(value).trim() !== '';
    },

    maxLength: function (value, max) {
        return String(value).length <= max;
    },

    minLength: function (value, min) {
        return String(value).length >= min;
    },

    numeric: function (value) {
        return !isNaN(parseFloat(value)) && isFinite(value);
    },

    between: function (value, min, max) {
        var num = parseFloat(value);
        return !isNaN(num) && num >= min && num <= max;
    },
};
