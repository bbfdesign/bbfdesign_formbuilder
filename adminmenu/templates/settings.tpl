{* Allgemeine Einstellungen *}

<form id="bbf-general-settings" action="savePluginSetting">

    {* Card 1: Allgemein *}
    <div style="background:#fff;border-radius:8px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <h4 style="font-weight:700;margin:0 0 20px;">Allgemein</h4>

        <div style="display:flex;align-items:center;gap:10px;margin-bottom:20px;">
            <label class="switch">
                <input type="checkbox" name="plugin_status" value="1" {if ($settings.plugin_status|default:'1') == '1'}checked{/if}>
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
                <input type="email" name="default_from_email" value="{$settings.default_from_email|default:''|escape}" class="form-control" placeholder="noreply@mein-shop.de">
            </div>
            <div>
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Standard Absender-Name</label>
                <input type="text" name="default_from_name" value="{$settings.default_from_name|default:''|escape}" class="form-control" placeholder="Mein Shop">
            </div>
        </div>
        <p style="font-size:12px;color:var(--bbf-text-light);margin:0 0 16px;">Wird als Standard-Absender für alle E-Mail-Benachrichtigungen verwendet, wenn im Formular nichts anderes eingestellt ist.</p>
    </div>

    {* Card 2: Datei-Upload *}
    <div style="background:#fff;border-radius:8px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <h4 style="font-weight:700;margin:0 0 16px;">Datei-Upload</h4>

        <div style="padding:12px 16px;background:#f8f9fa;border:1px solid var(--bbf-border-light);border-radius:6px;color:var(--bbf-text-light);font-size:13px;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16" style="vertical-align:middle;margin-right:6px;opacity:0.6;">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="16" x2="12" y2="12"></line>
                <line x1="12" y1="8" x2="12.01" y2="8"></line>
            </svg>
            Datei-Upload Einstellungen werden pro Feld im Formular-Builder konfiguriert (max. Dateigröße, erlaubte Typen).
        </div>
    </div>

    {* Card 3: Integration *}
    <div style="background:#fff;border-radius:8px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <h4 style="font-weight:700;margin:0 0 16px;">Integration</h4>

        <div style="padding:12px 16px;background:#f8f9fa;border:1px solid var(--bbf-border-light);border-radius:6px;color:var(--bbf-text-light);font-size:13px;margin-bottom:12px;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16" style="vertical-align:middle;margin-right:6px;opacity:0.6;">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="16" x2="12" y2="12"></line>
                <line x1="12" y1="8" x2="12.01" y2="8"></line>
            </svg>
            Formulare können über <code>{ldelim}bbf_form id=1{rdelim}</code>, <code>{ldelim}bbf_form slug='kontakt'{rdelim}</code> oder das OPC Portlet eingebunden werden.
        </div>

        <div style="padding:12px 16px;background:#f8f9fa;border:1px solid var(--bbf-border-light);border-radius:6px;color:var(--bbf-text-light);font-size:13px;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16" style="vertical-align:middle;margin-right:6px;opacity:0.6;">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            Wenn das BBF Suchplugin aktiv ist, erscheinen Formulare mit <code>is_searchable=1</code> in den Suchergebnissen.
        </div>
    </div>

    <button type="button" class="bbf-btn-primary" style="padding:10px 24px;border-radius:8px;border:none;font-size:14px;cursor:pointer;" onclick="saveSetting('bbf-general-settings', 'settings');">
        Einstellungen speichern
    </button>

</form>
