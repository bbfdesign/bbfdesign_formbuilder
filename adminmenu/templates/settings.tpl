{* Allgemeine Einstellungen *}

<form id="bbf-general-settings" action="savePluginSetting">

    <div style="background:#fff;border-radius:8px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <h4 style="font-weight:700;margin:0 0 20px;">Allgemein</h4>

        <div style="display:flex;align-items:center;gap:10px;margin-bottom:20px;">
            <label class="switch">
                <input type="checkbox" name="plugin_status" value="1" {if $settings.plugin_status == '1'}checked{/if}>
                <span class="slider"></span>
            </label>
            <div>
                <span style="font-weight:500;">Plugin aktiviert</span>
                <p style="font-size:12px;color:var(--bbf-text-light);margin:2px 0 0;">Wenn deaktiviert, werden keine Formulare im Frontend angezeigt.</p>
            </div>
        </div>

        <hr style="border:0;border-top:1px solid var(--bbf-border-light);margin:16px 0;">

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px;">
            <div>
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Standard Absender-E-Mail</label>
                <input type="email" name="default_from_email" value="{$settings.default_from_email|default:''}" class="form-control" placeholder="noreply@mein-shop.de">
            </div>
            <div>
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Standard Absender-Name</label>
                <input type="text" name="default_from_name" value="{$settings.default_from_name|default:''}" class="form-control" placeholder="Mein Shop">
            </div>
        </div>
        <p style="font-size:12px;color:var(--bbf-text-light);margin:0 0 16px;">Wird als Standard-Absender für alle E-Mail-Benachrichtigungen verwendet, wenn im Formular nichts anderes eingestellt ist.</p>
    </div>

    <button type="button" class="bbf-btn-primary" style="padding:10px 24px;border-radius:8px;border:none;font-size:14px;cursor:pointer;" onclick="saveSetting('bbf-general-settings', 'settings');">
        Einstellungen speichern
    </button>

</form>
