{* Formular-Einstellungen *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Formular-Einstellungen</h4>
        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfNavigate('form-builder', {ldelim}form_id: '{$formId}'{rdelim});">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                <line x1="19" y1="12" x2="5" y2="12"></line>
                <polyline points="12 19 5 12 12 5"></polyline>
            </svg>
            Zurück zum Builder
        </button>
    </div>
    <div class="bbf-card-body">
        {* Tab Navigation *}
        <ul class="bbf-tabs" id="bbf-form-settings-tabs">
            <li class="bbf-tab active" data-tab="notifications">
                <a href="#" onclick="bbfSwitchSettingsTab('notifications'); return false;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    Benachrichtigungen
                </a>
            </li>
            <li class="bbf-tab" data-tab="confirmations">
                <a href="#" onclick="bbfSwitchSettingsTab('confirmations'); return false;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    Bestätigungen
                </a>
            </li>
            <li class="bbf-tab" data-tab="settings">
                <a href="#" onclick="bbfSwitchSettingsTab('settings'); return false;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9c.26.604.852.997 1.51 1H21a2 2 0 0 1 0 4h-.09c-.658.003-1.25.396-1.51 1z"></path>
                    </svg>
                    Einstellungen
                </a>
            </li>
        </ul>

        {* Tab Content: Notifications *}
        <div class="bbf-tab-content" id="bbf-tab-notifications">
            <div class="bbf-form-group">
                <label class="bbf-label">Empfänger E-Mail</label>
                <input type="email" class="bbf-input" id="notification_email" value="{$formSettings.notification_email|default:''}" placeholder="admin@example.com">
                <small class="bbf-help-text">Mehrere Empfänger mit Komma trennen.</small>
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label">E-Mail Betreff</label>
                <input type="text" class="bbf-input" id="notification_subject" value="{$formSettings.notification_subject|default:'Neue Formular-Einsendung'}" placeholder="Neue Formular-Einsendung">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label">Absender Name</label>
                <input type="text" class="bbf-input" id="notification_from_name" value="{$formSettings.notification_from_name|default:''}" placeholder="Mein Shop">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label">Absender E-Mail</label>
                <input type="email" class="bbf-input" id="notification_from_email" value="{$formSettings.notification_from_email|default:''}" placeholder="noreply@example.com">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-toggle-label">
                    <input type="checkbox" id="notification_enabled" {if $formSettings.notification_enabled|default:true}checked{/if}>
                    <span>E-Mail-Benachrichtigung aktiviert</span>
                </label>
            </div>
        </div>

        {* Tab Content: Confirmations *}
        <div class="bbf-tab-content" id="bbf-tab-confirmations" style="display: none;">
            <div class="bbf-form-group">
                <label class="bbf-label">Bestätigungstyp</label>
                <select class="bbf-select" id="confirmation_type">
                    <option value="message" {if ($formSettings.confirmation_type|default:'message') == 'message'}selected{/if}>Nachricht anzeigen</option>
                    <option value="redirect" {if ($formSettings.confirmation_type|default:'message') == 'redirect'}selected{/if}>Weiterleitung</option>
                </select>
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label">Bestätigungsnachricht</label>
                <textarea class="bbf-textarea" id="confirmation_message" rows="4">{$formSettings.confirmation_message|default:'Vielen Dank für Ihre Nachricht. Wir werden uns schnellstmöglich bei Ihnen melden.'}</textarea>
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label">Weiterleitungs-URL</label>
                <input type="url" class="bbf-input" id="confirmation_redirect" value="{$formSettings.confirmation_redirect|default:''}" placeholder="https://...">
            </div>
        </div>

        {* Tab Content: Settings *}
        <div class="bbf-tab-content" id="bbf-tab-settings" style="display: none;">
            <div class="bbf-form-group">
                <label class="bbf-label">CSS-Klassen (Formular)</label>
                <input type="text" class="bbf-input" id="form_css_class" value="{$formSettings.css_class|default:''}" placeholder="Zusätzliche CSS-Klassen...">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label">Submit-Button Text</label>
                <input type="text" class="bbf-input" id="form_submit_text" value="{$formSettings.submit_text|default:'Absenden'}" placeholder="Absenden">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-toggle-label">
                    <input type="checkbox" id="form_store_entries" {if $formSettings.store_entries|default:true}checked{/if}>
                    <span>Einträge in Datenbank speichern</span>
                </label>
            </div>
            <div class="bbf-form-group">
                <label class="bbf-toggle-label">
                    <input type="checkbox" id="form_ajax_submit" {if $formSettings.ajax_submit|default:true}checked{/if}>
                    <span>AJAX-Submit verwenden</span>
                </label>
            </div>
        </div>

        <div class="bbf-form-actions" style="margin-top: 24px;">
            <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveFormSettings();">
                Einstellungen speichern
            </button>
        </div>
    </div>
</div>
