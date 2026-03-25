{* DSGVO-Einstellungen *}

<form id="bbf-gdpr-settings" action="savePluginSetting">

    <div style="background:#fff;border-radius:8px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <h4 style="font-weight:700;margin:0 0 16px;">DSGVO / Datenschutz</h4>

        <div style="padding:12px 16px;background:#eef6fc;border:1px solid #b8d8f0;border-radius:6px;color:#1a3a5c;font-size:13px;margin-bottom:24px;">
            Diese Einstellungen helfen bei der Einhaltung der DSGVO. Bitte konsultieren Sie Ihren Datenschutzbeauftragten für eine vollständige Compliance-Prüfung.
        </div>

        {* IP Anonymisierung *}
        <div style="margin-bottom:20px;">
            <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">IP-Anonymisierung</label>
            <select name="ip_anonymization" class="form-control" style="max-width:300px;">
                <option value="none" {if $settings.ip_anonymization == 'none'}selected{/if}>Keine Anonymisierung</option>
                <option value="last_octet" {if $settings.ip_anonymization == 'last_octet' || !$settings.ip_anonymization}selected{/if}>Letztes Oktett entfernen (empfohlen)</option>
                <option value="hash" {if $settings.ip_anonymization == 'hash'}selected{/if}>IP-Adresse hashen</option>
            </select>
            <p style="font-size:12px;color:var(--bbf-text-light);margin:4px 0 0;">Bestimmt, wie IP-Adressen in der Datenbank gespeichert werden.</p>
        </div>

        <hr style="border:0;border-top:1px solid var(--bbf-border-light);margin:16px 0;">

        {* Auto-Löschung *}
        <div style="margin-bottom:20px;">
            <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Automatische Löschung nach Tagen</label>
            <input type="number" name="auto_delete_days" value="{$settings.auto_delete_days|default:365}" min="0" max="3650" class="form-control" style="max-width:150px;">
            <p style="font-size:12px;color:var(--bbf-text-light);margin:4px 0 0;">Einträge werden automatisch gelöscht. 0 = keine automatische Löschung. Cron-Job erforderlich.</p>
        </div>

        <hr style="border:0;border-top:1px solid var(--bbf-border-light);margin:16px 0;">

        {* DSGVO Checkbox Text *}
        <div style="margin-bottom:20px;">
            <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">DSGVO-Checkbox Text</label>
            <textarea name="gdpr_checkbox_text" class="form-control" rows="3" style="font-family:monospace;font-size:13px;">{$settings.gdpr_checkbox_text|default:'Ich stimme der Verarbeitung meiner Daten gemäß der <a href="/datenschutz">Datenschutzerklärung</a> zu.'}</textarea>
            <p style="font-size:12px;color:var(--bbf-text-light);margin:4px 0 0;">Wird neben der DSGVO-Checkbox angezeigt. HTML ist erlaubt (z.B. Links zur Datenschutzerklärung).</p>
        </div>

        <hr style="border:0;border-top:1px solid var(--bbf-border-light);margin:16px 0;">

        {* Verschlüsselung *}
        <div style="margin-bottom:8px;">
            <div style="display:flex;align-items:center;gap:10px;margin-bottom:8px;">
                <label class="switch">
                    <input type="checkbox" name="encryption_enabled" value="1" {if $settings.encryption_enabled == '1'}checked{/if}>
                    <span class="slider"></span>
                </label>
                <span style="font-weight:500;">Formular-Einträge verschlüsseln</span>
            </div>
            <div style="padding:12px 16px;background:#fefbf0;border:1px solid #f0dca0;border-radius:6px;color:#5c4a1a;font-size:13px;margin-left:54px;">
                <strong>Warnung:</strong> Bei Verlust des Verschlüsselungsschlüssels sind alle verschlüsselten Daten unwiederbringlich verloren. Erstellen Sie vorher ein Backup. Bereits vorhandene Einträge werden nicht nachträglich verschlüsselt.
            </div>
        </div>
    </div>

    <button type="button" class="bbf-btn-primary" style="padding:10px 24px;border-radius:8px;border:none;font-size:14px;cursor:pointer;" onclick="saveSetting('bbf-gdpr-settings', 'gdpr');">
        Einstellungen speichern
    </button>

</form>
