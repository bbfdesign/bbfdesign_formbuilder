{* DSGVO-Einstellungen *}

<form id="bbf-gdpr-settings" action="savePluginSetting">

    <div class="bbf-card">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">DSGVO / Datenschutz</h4>
        </div>
        <div class="bbf-card-body">

            <div class="bbf-alert bbf-alert-info" style="margin-bottom: 24px;">
                <strong>Hinweis:</strong> Diese Einstellungen helfen Ihnen, die Anforderungen der DSGVO zu erf&uuml;llen.
                Bitte konsultieren Sie Ihren Datenschutzbeauftragten f&uuml;r eine vollst&auml;ndige Compliance-Pr&uuml;fung.
            </div>

            {* IP Anonymization *}
            <div class="bbf-form-group">
                <label class="bbf-label" for="ip_anonymization">IP-Anonymisierung</label>
                <select class="bbf-select" id="ip_anonymization" name="ip_anonymization" style="max-width: 300px;">
                    <option value="none" {if ($settings.ip_anonymization|default:'last_octet') == 'none'}selected{/if}>Keine Anonymisierung</option>
                    <option value="last_octet" {if ($settings.ip_anonymization|default:'last_octet') == 'last_octet'}selected{/if}>Letztes Oktett entfernen (empfohlen)</option>
                    <option value="hash" {if ($settings.ip_anonymization|default:'last_octet') == 'hash'}selected{/if}>IP-Adresse hashen</option>
                </select>
                <small class="bbf-help-text">Bestimmt, wie IP-Adressen in der Datenbank gespeichert werden.</small>
            </div>

            <hr class="bbf-divider">

            {* Auto-Delete *}
            <div class="bbf-form-group">
                <label class="bbf-label" for="auto_delete_days">Automatische L&ouml;schung nach Tagen</label>
                <input type="number" class="bbf-input" id="auto_delete_days" name="auto_delete_days" value="{$settings.auto_delete_days|default:0}" min="0" max="3650" style="max-width: 150px;">
                <small class="bbf-help-text">Eintr&auml;ge werden nach dieser Anzahl Tagen automatisch gel&ouml;scht. 0 = keine automatische L&ouml;schung.</small>
            </div>

            <hr class="bbf-divider">

            {* GDPR Checkbox Text *}
            <div class="bbf-form-group">
                <label class="bbf-label" for="gdpr_checkbox_text">DSGVO-Checkbox Text</label>
                <textarea class="bbf-textarea" id="gdpr_checkbox_text" name="gdpr_checkbox_text" rows="4">{$settings.gdpr_checkbox_text|default:'Ich stimme der Verarbeitung meiner Daten gem&auml;&szlig; der <a href="/datenschutz" target="_blank">Datenschutzerkl&auml;rung</a> zu.'}</textarea>
                <small class="bbf-help-text">Dieser Text wird neben der DSGVO-Checkbox in Formularen angezeigt. HTML ist erlaubt.</small>
            </div>

            <hr class="bbf-divider">

            {* Encryption *}
            <div class="bbf-form-group">
                <label class="bbf-label">Daten-Verschl&uuml;sselung</label>
                <div class="bbf-toggle-switch">
                    <label class="switch">
                        <input type="checkbox" name="encryption_enabled" value="1" {if $settings.encryption_enabled == '1'}checked{/if}>
                        <span class="slider"></span>
                    </label>
                    <span class="bbf-toggle-text">Formular-Eintr&auml;ge verschl&uuml;sseln</span>
                </div>
                <div class="bbf-alert bbf-alert-warning" style="margin-top: 12px;">
                    <strong>WARNUNG:</strong> Wenn die Verschl&uuml;sselung aktiviert ist, werden alle neuen Formular-Eintr&auml;ge verschl&uuml;sselt in der Datenbank gespeichert.
                    Bereits vorhandene Eintr&auml;ge werden nicht nachtr&auml;glich verschl&uuml;sselt.
                    Stellen Sie sicher, dass der Verschl&uuml;sselungsschl&uuml;ssel sicher aufbewahrt wird &mdash; bei Verlust k&ouml;nnen die Daten nicht wiederhergestellt werden.
                </div>
            </div>

        </div>
    </div>

    <div style="margin-top: 24px;">
        <button type="button" class="bbf-btn bbf-btn-primary" onclick="saveSetting('bbf-gdpr-settings', 'gdpr');">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                <polyline points="17 21 17 13 7 13 7 21"></polyline>
                <polyline points="7 3 7 8 15 8"></polyline>
            </svg>
            Einstellungen speichern
        </button>
    </div>

</form>
