/**
 * BBF Formbuilder – Admin JS
 * Navigation, AJAX Page Loading, Notifications
 */

$(document).ready(function () {
    // Sidebar toggle
    $('#bbf-sidebar-toggle').on('click', function () {
        $('#bbf-sidebar').toggleClass('bbf-sidebar-collapsed');
    });

    // Load initial page
    bbfNavigate('dashboard');
});

// Page title mapping
var bbfPageTitles = {
    'dashboard':       'Dashboard',
    'forms':           'Alle Formulare',
    'form-builder':    'Formular-Builder',
    'form-settings':   'Formular-Einstellungen',
    'templates':       'Vorlagen',
    'entries':         'Einträge',
    'entry-detail':    'Eintrags-Details',
    'settings':        'Einstellungen',
    'spam-protection': 'Spam-Schutz',
    'gdpr':            'DSGVO',
    'email-templates': 'E-Mail-Templates',
    'css-editor':      'CSS-Editor',
    'documentation':   'Dokumentation',
    'changelog':       'Changelog'
};

// Tab switching for Bootstrap nav-links
$(document).on("click", "a.nav-link", function () {
    if (typeof bootstrap !== "undefined") {
        var tab = new bootstrap.Tab(this);
        tab.show();
    } else {
        $(this).tab("show");
    }
});

// Auto-save on parent-setting change
$(document).on("change", ".parent-setting", function () {
    $(this).closest("form").find(".save-btn").click();
});

/**
 * Navigate to a page (AJAX)
 * @param {string} page
 * @param {object} extraParams
 */
function bbfNavigate(page, extraParams) {
    // Update active nav item
    $('.bbf-sidebar-nav a').removeClass('bbf-nav-active');
    $('.bbf-sidebar-nav a[data-page="' + page + '"]').addClass('bbf-nav-active');

    // Update header title
    var title = bbfPageTitles[page] || 'BBF Formbuilder';
    $('#bbf-page-title').text('BBF Formbuilder: ' + title);

    // Show loading spinner
    $('#bbf-page-content').html(
        '<div class="text-center" style="padding: 60px 0;">' +
        '<div class="bbf-spinner" style="width:40px; height:40px; border-width:3px; margin: 0 auto 16px;"></div>' +
        '<p style="color: var(--bbf-text-light);">Lade...</p>' +
        '</div>'
    );

    // Build request data
    var requestData = $.extend({
        action: "getPage",
        page: page,
        is_ajax: 1,
        jtl_token: document.querySelector('[name="jtl_token"]').value,
    }, extraParams || {});

    // AJAX load page
    $.ajax({
        url: postURL,
        data: requestData,
        method: "POST",
        dataType: "json",
        success: function (response) {
            if (response && response.errors && response.errors.length) {
                response.errors.forEach(function (error) {
                    bbdNotify("Fehler", error, "danger", "fa fa-exclamation-triangle");
                });
                return;
            }
            if (response && response.content) {
                $('#bbf-page-content').html(response.content);
                try { $(".select2").select2(); } catch(e) {}
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.error("BBF getPage error:", textStatus, errorThrown, (jqXHR.responseText||'').substring(0,300));
            $('#bbf-page-content').html(
                '<div class="bbf-msg bbf-msg-danger" style="margin: 24px;">' +
                '<i class="fa fa-exclamation-triangle"></i> Laden fehlgeschlagen: ' +
                (errorThrown || textStatus) + '</div>'
            );
        }
    });
}

/**
 * Legacy getPage function
 */
function getPage(page, type) {
    type = type || "page";
    if (type === "page") {
        bbfNavigate(page);
    }
}

/**
 * Save settings via AJAX
 */
function saveSetting(formId, calledPage) {
    calledPage = calledPage || "settings";
    var form = $("#" + formId);
    var postsData = new FormData();
    postsData.append("action", form.attr("action") || "savePluginSetting");
    postsData.append("is_ajax", 1);
    postsData.append("jtl_token", document.querySelector('[name="jtl_token"]').value);

    var checkboxNames = {};
    form.find('input[type="checkbox"]').each(function () {
        checkboxNames[this.name] = true;
        postsData.append(this.name, this.checked ? 1 : 0);
    });

    form.serializeArray().forEach(function (field) {
        if (!checkboxNames[field.name]) {
            postsData.append(field.name, field.value);
        }
    });

    form.find('input[type="file"]').each(function () {
        var fileInput = this;
        if (fileInput.files.length > 0) {
            Array.from(fileInput.files).forEach(function (file) {
                postsData.append(fileInput.name, file);
            });
        }
    });

    $.ajax({
        url: postURL,
        method: "POST",
        data: postsData,
        contentType: false,
        processData: false,
        dataType: "json",
        success: function (response) {
            if (response && response.flag) {
                if (response.message) {
                    bbdNotify("Erfolg", response.message, "success", "fa fa-check-circle");
                    if (calledPage) {
                        setTimeout(function () { bbfNavigate(calledPage); }, 1000);
                    }
                }
            } else {
                if (response && response.errors && response.errors.length) {
                    response.errors.forEach(function (error) {
                        bbdNotify("Fehler", error, "danger", "fa fa-exclamation-triangle");
                    });
                }
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            bbdNotify("Fehler", "Speichern fehlgeschlagen: " + (errorThrown || textStatus), "danger", "fa fa-exclamation-triangle");
        },
    });
}

/**
 * Generic AJAX action helper
 */
function bbfAjaxAction(actionData, successCallback) {
    var data = $.extend({
        is_ajax: 1,
        jtl_token: document.querySelector('[name="jtl_token"]').value,
    }, actionData);

    $.ajax({
        url: postURL,
        method: "POST",
        data: data,
        dataType: "json",
        success: function (response) {
            if (response && response.flag) {
                if (response.message) {
                    bbdNotify("Erfolg", response.message, "success", "fa fa-check-circle");
                }
                if (successCallback) successCallback(response);
            } else if (response && response.errors) {
                response.errors.forEach(function (error) {
                    bbdNotify("Fehler", error, "danger", "fa fa-exclamation-triangle");
                });
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            bbdNotify("Fehler", "Aktion fehlgeschlagen: " + (errorThrown || textStatus), "danger", "fa fa-exclamation-triangle");
        },
    });
}

/**
 * Bootstrap Notify wrapper
 */
function bbdNotify(title, message, type, icon, from, align) {
    type = type || "primary";
    icon = icon || "fa fa-bell";
    from = from || "top";
    align = align || "right";
    $.notify(
        { icon: icon, title: title, message: message },
        { type: type, placement: { from: from, align: align }, time: 1000, delay: 2000 }
    );
}
