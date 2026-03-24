{* Allgemeine Einstellungen *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Allgemeine Einstellungen</h4>
    </div>
    <div class="bbf-card-body">
        <form id="bbf-settings-form" onsubmit="return false;">

            <div class="bbf-form-group">
                <label class="bbf-label">Plugin Status</label>
                <div class="bbf-toggle-switch">
                    <label class="bbf-switch">
                        <input type="checkbox" id="setting_plugin_active" {if $settings.plugin_active|default:true}checked{/if} onchange="bbfSaveSetting('plugin_active', this.checked);">
                        <span class="bbf-switch-slider"></span>
                    </label>
                    <span class="bbf-toggle-text">Plugin aktiviert</span>
                </div>
                <small class="bbf-help-text">Wenn deaktiviert, werden keine Formulare im Frontend angezeigt.</small>
            </div>

            <hr class="bbf-divider">

            <div class="bbf-form-group">
                <label class="bbf-label" for="setting_default_sender_email">Standard Absender-E-Mail</label>
                <input type="email" class="bbf-input" id="setting_default_sender_email" value="{$settings.default_sender_email|default:''}" placeholder="noreply@mein-shop.de" onchange="bbfSaveSetting('default_sender_email', this.value);">
                <small class="bbf-help-text">Wird als Standard-Absender für alle E-Mail-Benachrichtigungen verwendet.</small>
            </div>

            <div class="bbf-form-group">
                <label class="bbf-label" for="setting_default_sender_name">Standard Absender-Name</label>
                <input type="text" class="bbf-input" id="setting_default_sender_name" value="{$settings.default_sender_name|default:''}" placeholder="Mein Shop" onchange="bbfSaveSetting('default_sender_name', this.value);">
                <small class="bbf-help-text">Wird als Absendername in E-Mail-Benachrichtigungen angezeigt.</small>
            </div>

            <hr class="bbf-divider">

            <div class="bbf-form-group">
                <label class="bbf-label">Einträge in Datenbank speichern</label>
                <div class="bbf-toggle-switch">
                    <label class="bbf-switch">
                        <input type="checkbox" id="setting_store_entries" {if $settings.store_entries|default:true}checked{/if} onchange="bbfSaveSetting('store_entries', this.checked);">
                        <span class="bbf-switch-slider"></span>
                    </label>
                    <span class="bbf-toggle-text">Formular-Einträge speichern</span>
                </div>
                <small class="bbf-help-text">Formular-Einsendungen werden in der Datenbank gespeichert und können im Admin eingesehen werden.</small>
            </div>

            <div class="bbf-form-group">
                <label class="bbf-label">AJAX-Formularversand</label>
                <div class="bbf-toggle-switch">
                    <label class="bbf-switch">
                        <input type="checkbox" id="setting_ajax_submit" {if $settings.ajax_submit|default:true}checked{/if} onchange="bbfSaveSetting('ajax_submit', this.checked);">
                        <span class="bbf-switch-slider"></span>
                    </label>
                    <span class="bbf-toggle-text">Formulare per AJAX absenden</span>
                </div>
                <small class="bbf-help-text">Formulare werden ohne Seitenneuladen versendet (empfohlen).</small>
            </div>

        </form>
    </div>
</div>
