/**
 * BBF Formbuilder – Admin JavaScript
 * jQuery-based AJAX navigation with sidebar
 */

$(document).ready(function () {
    // Sidebar toggle
    $('#bbf-sidebar-toggle').on('click', function () {
        $('.bbf-sidebar').toggleClass('collapsed');
        $('.bbf-content-area').toggleClass('expanded');
    });

    // Initial page load
    bbfNavigate('dashboard');
});

/**
 * Page title mapping (German)
 */
var bbfPageTitles = {
    'dashboard':        'Dashboard',
    'forms':            'Alle Formulare',
    'form-builder':     'Formular-Builder',
    'form-settings':    'Formular-Einstellungen',
    'templates':        'Vorlagen',
    'entries':          'Einträge',
    'entry-detail':     'Eintrags-Details',
    'settings':         'Einstellungen',
    'spam-protection':  'Spam-Schutz',
    'gdpr':             'DSGVO',
    'email-templates':  'E-Mail-Templates',
    'css-editor':       'CSS-Editor',
    'documentation':    'Dokumentation',
    'changelog':        'Changelog'
};

/**
 * Navigate to a page via AJAX
 *
 * @param {string} page   - Page identifier
 * @param {object} params - Optional extra parameters
 */
function bbfNavigate(page, params) {
    var title = bbfPageTitles[page] || page;

    // Update active nav item
    $('.bbf-nav-item').removeClass('active');
    $('.bbf-nav-item[data-page="' + page + '"]').addClass('active');

    // Update header title
    $('.bbf-header-title').text('BBF Formbuilder: ' + title);

    // Show loading spinner
    $('#bbf-page-content').html(
        '<div class="bbf-loading text-center p-5">' +
        '<div class="spinner-border text-primary" role="status">' +
        '<span class="sr-only">Laden...</span>' +
        '</div></div>'
    );

    // Build AJAX data
    var data = $.extend({
        action:    'getPage',
        page:      page,
        is_ajax:   1,
        jtl_token: typeof jtl_token !== 'undefined' ? jtl_token : ''
    }, params || {});

    $.ajax({
        url:      postURL,
        type:     'POST',
        data:     data,
        dataType: 'html',
        success: function (response) {
            $('#bbf-page-content').html(response);

            // Try to initialise select2 on any select elements
            try {
                $('#bbf-page-content select.select2').select2();
            } catch (e) {
                // select2 not available – silently ignore
            }
        },
        error: function (xhr, status, error) {
            $('#bbf-page-content').html(
                '<div class="alert alert-danger m-3">' +
                '<strong>Fehler:</strong> Die Seite konnte nicht geladen werden.<br>' +
                '<small>' + error + '</small>' +
                '</div>'
            );
        }
    });
}

/**
 * Legacy wrapper
 *
 * @param {string} page
 * @param {string} type
 */
function getPage(page, type) {
    bbfNavigate(page, type ? { type: type } : {});
}

/**
 * Save a settings form via AJAX
 *
 * @param {string} formId     - The ID / selector of the form element
 * @param {string} calledPage - Page to reload after save
 */
function saveSetting(formId, calledPage) {
    var $form = $(formId);
    var formData = new FormData($form[0]);

    // Ensure unchecked checkboxes are sent as 0
    $form.find('input[type="checkbox"]').each(function () {
        var name = $(this).attr('name');
        if (name) {
            formData.set(name, this.checked ? '1' : '0');
        }
    });

    // Append file inputs
    $form.find('input[type="file"]').each(function () {
        var name = $(this).attr('name');
        if (name && this.files.length > 0) {
            formData.append(name, this.files[0]);
        }
    });

    // Append token
    if (typeof jtl_token !== 'undefined') {
        formData.append('jtl_token', jtl_token);
    }

    $.ajax({
        url:         postURL,
        type:        'POST',
        data:        formData,
        processData: false,
        contentType: false,
        success: function (response) {
            try {
                var res = typeof response === 'string' ? JSON.parse(response) : response;
                if (res.success) {
                    bbdNotify('Erfolg', res.message || 'Einstellungen gespeichert.', 'success', 'fa fa-check');
                } else {
                    bbdNotify('Fehler', res.message || 'Beim Speichern ist ein Fehler aufgetreten.', 'danger', 'fa fa-exclamation-triangle');
                }
            } catch (e) {
                bbdNotify('Erfolg', 'Einstellungen gespeichert.', 'success', 'fa fa-check');
            }

            // Reload the originating page
            if (calledPage) {
                setTimeout(function () {
                    bbfNavigate(calledPage);
                }, 800);
            }
        },
        error: function (xhr, status, error) {
            bbdNotify('Fehler', 'Beim Speichern ist ein Fehler aufgetreten: ' + error, 'danger', 'fa fa-exclamation-triangle');
        }
    });
}

/**
 * Show a notification via bootstrap-notify
 *
 * @param {string} title
 * @param {string} message
 * @param {string} type   - Bootstrap alert type (success, danger, warning, info)
 * @param {string} icon   - Icon class
 * @param {string} from   - Notification origin (top, bottom)
 * @param {string} align  - Notification alignment (left, center, right)
 */
function bbdNotify(title, message, type, icon, from, align) {
    from  = from  || 'top';
    align = align || 'right';
    type  = type  || 'info';
    icon  = icon  || 'fa fa-info-circle';

    $.notify({
        icon:    icon,
        title:   '<strong>' + title + '</strong> ',
        message: message
    }, {
        type:   type,
        timer:  3000,
        placement: {
            from:  from,
            align: align
        },
        animate: {
            enter: 'animated fadeInDown',
            exit:  'animated fadeOutUp'
        }
    });
}

/**
 * Bootstrap tab switching via nav-links
 */
$(document).on('click', '.nav-link[data-toggle="tab"], .nav-link[data-bs-toggle="tab"]', function (e) {
    e.preventDefault();
    var target = $(this).attr('href') || $(this).data('target') || $(this).data('bs-target');
    if (!target) return;

    // Deactivate siblings
    $(this).closest('.nav').find('.nav-link').removeClass('active');
    $(this).addClass('active');

    // Show target pane
    $(target).closest('.tab-content').find('.tab-pane').removeClass('show active');
    $(target).addClass('show active');
});

/**
 * Auto-save when a parent-setting field changes
 */
$(document).on('change', '.parent-setting', function () {
    var $form = $(this).closest('form');
    if ($form.length) {
        var formId     = '#' + $form.attr('id');
        var calledPage = $form.data('page') || null;
        saveSetting(formId, calledPage);
    }
});
