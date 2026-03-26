/**
 * BBF Formbuilder – Admin JS
 * Navigation, AJAX Page Loading, Notifications
 */

$(document).ready(function () {
    $('#bbf-sidebar-toggle').on('click', function () {
        $('#bbf-sidebar').toggleClass('bbf-sidebar-collapsed');
    });
    bbfNavigate('dashboard');
});

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

/**
 * Navigate to a page (AJAX)
 */
function bbfNavigate(page, extraParams) {
    $('.bbf-sidebar-nav a').removeClass('bbf-nav-active');
    $('.bbf-sidebar-nav a[data-page="' + page + '"]').addClass('bbf-nav-active');

    var title = bbfPageTitles[page] || 'BBF Formbuilder';
    $('#bbf-page-title').text('BBF Formbuilder: ' + title);

    var contentEl = $('#bbf-page-content');
    contentEl.html(
        '<div class="text-center" style="padding: 60px 0;">' +
        '<div class="bbf-spinner" style="width:40px; height:40px; border-width:3px; margin: 0 auto 16px;"></div>' +
        '<p style="color: var(--bbf-text-light);">Lade...</p>' +
        '</div>'
    );

    var requestData = $.extend({
        action: "getPage",
        page: page,
        is_ajax: 1,
        jtl_token: document.querySelector('[name="jtl_token"]') ? document.querySelector('[name="jtl_token"]').value : ''
    }, extraParams || {});

    // Timeout nach 15 Sekunden
    var loadTimeout = setTimeout(function () {
        contentEl.html(
            '<div style="margin:24px;padding:20px;background:#fdf0f0;border:1px solid #f0c0c0;border-radius:8px;color:#6b1a1a;">' +
            '<strong>Laden fehlgeschlagen</strong><br>' +
            '<p style="margin:8px 0;">Die Seite "' + title + '" konnte nicht geladen werden (Timeout).</p>' +
            '<button type="button" onclick="bbfNavigate(\'' + page + '\')" style="padding:6px 16px;border-radius:6px;border:1px solid #ccc;background:#fff;cursor:pointer;margin-right:8px;">Erneut versuchen</button>' +
            '<button type="button" onclick="location.reload()" style="padding:6px 16px;border-radius:6px;border:1px solid #ccc;background:#fff;cursor:pointer;">Seite neu laden</button>' +
            '</div>'
        );
    }, 15000);

    $.ajax({
        url: postURL,
        data: requestData,
        method: "POST",
        dataType: "json",
        success: function (response) {
            clearTimeout(loadTimeout);
            if (response && response.errors && response.errors.length) {
                var errorHtml = '<div style="margin:24px;padding:20px;background:#fdf0f0;border:1px solid #f0c0c0;border-radius:8px;color:#6b1a1a;">' +
                    '<strong>Fehler</strong><ul style="margin:8px 0;padding-left:20px;">';
                response.errors.forEach(function (err) {
                    errorHtml += '<li>' + err + '</li>';
                });
                errorHtml += '</ul></div>';
                contentEl.html(errorHtml);
                return;
            }
            if (response && response.content) {
                contentEl.html(response.content);
                try { $(".select2").select2(); } catch(e) {}
                // Load page-specific JS bundles FIRST, then execute inline scripts
                bbfAfterPageLoad(page, function () {
                    bbfExecInlineScripts(contentEl[0]);
                });
            } else {
                contentEl.html(
                    '<div style="margin:24px;padding:20px;background:#fefbf0;border:1px solid #f0dca0;border-radius:8px;color:#5c4a1a;">' +
                    '<strong>Kein Inhalt</strong><p style="margin:8px 0;">Die Seite hat keinen Inhalt zurückgegeben.</p></div>'
                );
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            clearTimeout(loadTimeout);
            console.error("BBF AJAX error:", textStatus, errorThrown);
            var responsePreview = (jqXHR.responseText || '').substring(0, 200);
            contentEl.html(
                '<div style="margin:24px;padding:20px;background:#fdf0f0;border:1px solid #f0c0c0;border-radius:8px;color:#6b1a1a;">' +
                '<strong>Laden fehlgeschlagen</strong>' +
                '<p style="margin:8px 0;">' + (errorThrown || textStatus) + '</p>' +
                (responsePreview ? '<details><summary style="cursor:pointer;font-size:12px;">Details</summary><pre style="font-size:11px;max-height:150px;overflow:auto;background:#f5f5f5;padding:8px;border-radius:4px;margin-top:8px;">' + $('<span>').text(responsePreview).html() + '</pre></details>' : '') +
                '<div style="margin-top:12px;">' +
                '<button type="button" onclick="bbfNavigate(\'' + page + '\')" style="padding:6px 16px;border-radius:6px;border:1px solid #ccc;background:#fff;cursor:pointer;margin-right:8px;">Erneut versuchen</button>' +
                '<button type="button" onclick="location.reload()" style="padding:6px 16px;border-radius:6px;border:1px solid #ccc;background:#fff;cursor:pointer;">Seite neu laden</button>' +
                '</div></div>'
            );
        }
    });
}

function getPage(page, type) {
    bbfNavigate(page);
}

/**
 * Save settings via AJAX
 */
function saveSetting(formId, calledPage) {
    calledPage = calledPage || "settings";
    var form = $("#" + formId);
    if (!form.length) return;

    var postsData = new FormData();
    postsData.append("action", form.attr("action") || "savePluginSetting");
    postsData.append("is_ajax", 1);
    var tokenEl = document.querySelector('[name="jtl_token"]');
    if (tokenEl) postsData.append("jtl_token", tokenEl.value);

    var checkboxNames = {};
    form.find('input[type="checkbox"]').each(function () {
        if (this.name) {
            checkboxNames[this.name] = true;
            postsData.append(this.name, this.checked ? 1 : 0);
        }
    });

    form.serializeArray().forEach(function (field) {
        if (!checkboxNames[field.name]) {
            postsData.append(field.name, field.value);
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
                bbdNotify("Erfolg", response.message || "Gespeichert", "success", "fa fa-check-circle");
                if (calledPage) {
                    setTimeout(function () { bbfNavigate(calledPage); }, 800);
                }
            } else if (response && response.errors) {
                response.errors.forEach(function (err) {
                    bbdNotify("Fehler", err, "danger", "fa fa-exclamation-triangle");
                });
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            bbdNotify("Fehler", "Speichern fehlgeschlagen: " + (errorThrown || textStatus), "danger", "fa fa-exclamation-triangle");
        }
    });
}

/**
 * Generic AJAX action helper
 */
function bbfAjaxAction(actionData, successCallback) {
    var tokenEl = document.querySelector('[name="jtl_token"]');
    var data = $.extend({
        is_ajax: 1,
        jtl_token: tokenEl ? tokenEl.value : ''
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
                response.errors.forEach(function (err) {
                    bbdNotify("Fehler", err, "danger", "fa fa-exclamation-triangle");
                });
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            bbdNotify("Fehler", "Aktion fehlgeschlagen: " + (errorThrown || textStatus), "danger", "fa fa-exclamation-triangle");
        }
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

/**
 * Execute inline <script> tags in AJAX-loaded content.
 * Browsers ignore scripts inserted via innerHTML — we must re-create them.
 */
function bbfExecInlineScripts(container) {
    var scripts = container.querySelectorAll('script');
    scripts.forEach(function (oldScript) {
        var newScript = document.createElement('script');
        if (oldScript.src) {
            // External script — skip, handled by bbfAfterPageLoad
            return;
        }
        // Inline script — copy content and execute
        newScript.textContent = oldScript.textContent;
        oldScript.parentNode.replaceChild(newScript, oldScript);
    });
}

/**
 * After AJAX page load: dynamically load page-specific JS bundles.
 */
function bbfAfterPageLoad(pageName, callback) {
    if (pageName === 'form-builder') {
        bbfLoadScript(adminUrl + 'js/dist/bbf-formbuilder.iife.js', function () {
            console.log('BBF FormBuilder IIFE loaded');
            if (callback) callback();
        });
    } else {
        // No bundle needed — execute inline scripts immediately
        if (callback) callback();
    }
}

/**
 * Dynamically load a JS file (skip if already loaded).
 */
function bbfLoadScript(src, callback) {
    if (document.querySelector('script[src="' + src + '"]')) {
        if (callback) callback();
        return;
    }
    var script = document.createElement('script');
    script.src = src;
    script.onload = function () {
        console.log('Loaded: ' + src);
        if (callback) callback();
    };
    script.onerror = function () {
        console.error('Failed to load: ' + src);
    };
    document.head.appendChild(script);
}
