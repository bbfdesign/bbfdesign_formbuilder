{* DSGVO-Einstellungen *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">DSGVO / Datenschutz</h4>
    </div>
    <div class="bbf-card-body">

        <div class="bbf-alert bbf-alert-info" style="margin-bottom: 24px;">
            <strong>Hinweis:</strong> Diese Einstellungen helfen Ihnen, die Anforderungen der DSGVO zu erfüllen.
            Bitte konsultieren Sie Ihren Datenschutzbeauftragten für eine vollständige Compliance-Prüfung.
        </div>

        {* IP Anonymization *}
        <div class="bbf-form-group">
            <label class="bbf-label" for="gdpr_ip_anonymization">IP-Anonymisierung</label>
            <select class="bbf-select" id="gdpr_ip_anonymization" onchange="bbfSaveSetting('ip_anonymization', this.value);" style="max-width: 300px;">
                <option value="none" {if ($gdprSettings.ip_anonymization|default:'last_octet') == 'none'}selected{/if}>Keine Anonymisierung</option>
                <option value="last_octet" {if ($gdprSettings.ip_anonymization|default:'last_octet') == 'last_octet'}selected{/if}>Letztes Oktett entfernen (empfohlen)</option>
                <option value="hash" {if ($gdprSettings.ip_anonymization|default:'last_octet') == 'hash'}selected{/if}>IP-Adresse hashen</option>
            </select>
            <small class="bbf-help-text">Bestimmt, wie IP-Adressen in der Datenbank gespeichert werden.</small>
        </div>

        <hr class="bbf-divider">

        {* Auto-Delete *}
        <div class="bbf-form-group">
            <label class="bbf-label" for="gdpr_auto_delete_days">Automatische Löschung nach Tagen</label>
            <input type="number" class="bbf-input" id="gdpr_auto_delete_days" value="{$gdprSettings.auto_delete_days|default:0}" min="0" max="3650" style="max-width: 150px;" onchange="bbfSaveSetting('auto_delete_days', this.value);">
            <small class="bbf-help-text">Einträge werden nach dieser Anzahl Tagen automatisch gelöscht. 0 = keine automatische Löschung.</small>
        </div>

        <hr class="bbf-divider">

        {* GDPR Checkbox Text *}
        <div class="bbf-form-group">
            <label class="bbf-label" for="gdpr_checkbox_text">DSGVO-Checkbox Text</label>
            <textarea class="bbf-textarea" id="gdpr_checkbox_text" rows="4" onchange="bbfSaveSetting('checkbox_text', this.value);">{$gdprSettings.checkbox_text|default:'Ich stimme der Verarbeitung meiner Daten gemäß der <a href="/datenschutz" target="_blank">Datenschutzerklärung</a> zu.'}</textarea>
            <small class="bbf-help-text">Dieser Text wird neben der DSGVO-Checkbox in Formularen angezeigt. HTML ist erlaubt.</small>
        </div>

        <hr class="bbf-divider">

        {* Encryption *}
        <div class="bbf-form-group">
            <label class="bbf-label">Daten-Verschlüsselung</label>
            <div class="bbf-toggle-switch">
                <label class="bbf-switch">
                    <input type="checkbox" id="gdpr_encryption_enabled" {if $gdprSettings.encryption_enabled|default:false}checked{/if} onchange="bbfSaveSetting('encryption_enabled', this.checked);">
                    <span class="bbf-switch-slider"></span>
                </label>
                <span class="bbf-toggle-text">Formular-Einträge verschlüsseln</span>
            </div>
            <div class="bbf-alert bbf-alert-warning" style="margin-top: 12px;">
                <strong>Achtung:</strong> Wenn die Verschlüsselung aktiviert ist, werden alle neuen Formular-Einträge verschlüsselt in der Datenbank gespeichert.
                Bereits vorhandene Einträge werden nicht nachträglich verschlüsselt.
                Stellen Sie sicher, dass der Verschlüsselungsschlüssel sicher aufbewahrt wird -- bei Verlust können die Daten nicht wiederhergestellt werden.
            </div>
        </div>

    </div>
</div>
