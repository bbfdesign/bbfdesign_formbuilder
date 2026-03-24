{* E-Mail-Templates *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">E-Mail-Templates</h4>
        <p class="bbf-card-subtitle">Verwalte die E-Mail-Vorlagen für Benachrichtigungen und Bestätigungen.</p>
    </div>
    <div class="bbf-card-body p-0">
        <div class="table-responsive">
            <table class="bbf-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Beschreibung</th>
                        <th>Typ</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    {if $emailTemplates && $emailTemplates|@count > 0}
                        {foreach $emailTemplates as $template}
                            <tr>
                                <td><strong>{$template.name|escape:'html'}</strong></td>
                                <td>{$template.description|escape:'html'}</td>
                                <td>
                                    {if $template.type == 'admin'}
                                        <span class="bbf-badge bbf-badge-info">Admin</span>
                                    {else}
                                        <span class="bbf-badge bbf-badge-success">Benutzer</span>
                                    {/if}
                                </td>
                                <td>
                                    <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfEditEmailTemplate('{$template.id}');" title="Bearbeiten">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                        </svg>
                                        Bearbeiten
                                    </button>
                                </td>
                            </tr>
                        {/foreach}
                    {else}
                        {* Default Templates *}
                        <tr>
                            <td><strong>Admin-Benachrichtigung</strong></td>
                            <td>E-Mail an den Administrator bei neuen Formular-Einsendungen</td>
                            <td><span class="bbf-badge bbf-badge-info">Admin</span></td>
                            <td>
                                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfEditEmailTemplate('admin_notification');">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                    </svg>
                                    Bearbeiten
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Benutzer-Bestätigung</strong></td>
                            <td>Bestätigungs-E-Mail an den Absender des Formulars</td>
                            <td><span class="bbf-badge bbf-badge-success">Benutzer</span></td>
                            <td>
                                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfEditEmailTemplate('user_confirmation');">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                    </svg>
                                    Bearbeiten
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td><strong>Auto-Responder</strong></td>
                            <td>Automatische Antwort mit benutzerdefinierbarem Inhalt</td>
                            <td><span class="bbf-badge bbf-badge-success">Benutzer</span></td>
                            <td>
                                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfEditEmailTemplate('auto_responder');">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                    </svg>
                                    Bearbeiten
                                </button>
                            </td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>
</div>

{* Email Template Editor Modal *}
<div class="bbf-modal" id="bbf-email-template-modal" style="display: none;">
    <div class="bbf-modal-backdrop" onclick="bbfCloseEmailTemplateModal();"></div>
    <div class="bbf-modal-dialog bbf-modal-lg">
        <div class="bbf-modal-header">
            <h4 class="bbf-modal-title" id="bbf-email-template-modal-title">E-Mail-Template bearbeiten</h4>
            <button type="button" class="bbf-btn-icon-sm" onclick="bbfCloseEmailTemplateModal();">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
        </div>
        <div class="bbf-modal-body">
            <div class="bbf-form-group">
                <label class="bbf-label">Betreff</label>
                <input type="text" class="bbf-input" id="email_template_subject">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label">Inhalt (HTML)</label>
                <textarea class="bbf-textarea custom-code-editor" id="email_template_body" rows="15"></textarea>
            </div>
            <div class="bbf-alert bbf-alert-info">
                <strong>Verfügbare Platzhalter:</strong><br>
                <code>{literal}{form_name}{/literal}</code> - Formularname,
                <code>{literal}{entry_data}{/literal}</code> - Alle Felddaten,
                <code>{literal}{entry_id}{/literal}</code> - Eintrags-ID,
                <code>{literal}{sender_name}{/literal}</code> - Name des Absenders,
                <code>{literal}{sender_email}{/literal}</code> - E-Mail des Absenders,
                <code>{literal}{shop_name}{/literal}</code> - Shopname,
                <code>{literal}{shop_url}{/literal}</code> - Shop-URL
            </div>
        </div>
        <div class="bbf-modal-footer">
            <button type="button" class="bbf-btn bbf-btn-outline" onclick="bbfCloseEmailTemplateModal();">Abbrechen</button>
            <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveEmailTemplate();">Speichern</button>
        </div>
    </div>
</div>
