{* Allgemeine Einstellungen *}

<form id="bbf-general-settings" action="savePluginSetting">

    <div class="bbf-card">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Allgemeine Einstellungen</h4>
        </div>
        <div class="bbf-card-body">

            <div class="bbf-form-group">
                <label class="bbf-label">Plugin Status</label>
                <div class="bbf-toggle-switch">
                    <label class="switch">
                        <input type="checkbox" name="plugin_status" value="1" {if $settings.plugin_status == '1'}checked{/if}>
                        <span class="slider"></span>
                    </label>
                    <span class="bbf-toggle-text">Plugin aktiviert</span>
                </div>
                <small class="bbf-help-text">Wenn deaktiviert, werden keine Formulare im Frontend angezeigt.</small>
            </div>

            <hr class="bbf-divider">

            <div class="bbf-form-group">
                <label class="bbf-label" for="default_from_email">Standard Absender-E-Mail</label>
                <input type="email" class="bbf-input" id="default_from_email" name="default_from_email" value="{$settings.default_from_email|default:''}" placeholder="noreply@mein-shop.de">
                <small class="bbf-help-text">Wird als Standard-Absender f&uuml;r alle E-Mail-Benachrichtigungen verwendet.</small>
            </div>

            <div class="bbf-form-group">
                <label class="bbf-label" for="default_from_name">Standard Absender-Name</label>
                <input type="text" class="bbf-input" id="default_from_name" name="default_from_name" value="{$settings.default_from_name|default:''}" placeholder="Mein Shop">
                <small class="bbf-help-text">Wird als Absendername in E-Mail-Benachrichtigungen angezeigt.</small>
            </div>

        </div>
    </div>

    <div style="margin-top: 24px;">
        <button type="button" class="bbf-btn bbf-btn-primary" onclick="saveSetting('bbf-general-settings', 'settings');">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                <polyline points="17 21 17 13 7 13 7 21"></polyline>
                <polyline points="7 3 7 8 15 8"></polyline>
            </svg>
            Einstellungen speichern
        </button>
    </div>

</form>
