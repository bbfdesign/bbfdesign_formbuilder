{* Formular-Einstellungen *}

{if $form}
<div style="margin-bottom:16px;display:flex;align-items:center;gap:8px;">
    <button type="button" class="bbf-btn-secondary" style="padding:6px 14px;border-radius:6px;border:1px solid var(--bbf-border);font-size:12px;cursor:pointer;display:inline-flex;align-items:center;gap:6px;background:transparent;" onclick="bbfNavigate('form-builder', {ldelim}form_id: {$form->id}{rdelim});">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
        Zurück zum Builder
    </button>
    <h4 style="margin:0;font-weight:600;">{$form->title|escape} — Einstellungen</h4>
</div>

{* Tabs *}
<div style="display:flex;border-bottom:2px solid #dee2e6;margin-bottom:20px;">
    <button type="button" class="bbf-settings-tab-btn" onclick="bbfSwitchSettingsTab('notifications', this)" style="padding:10px 20px;font-size:13px;font-weight:600;border:none;background:none;cursor:pointer;color:var(--bbf-primary);border-bottom:2px solid var(--bbf-primary);margin-bottom:-2px;">Benachrichtigungen</button>
    <button type="button" class="bbf-settings-tab-btn" onclick="bbfSwitchSettingsTab('confirmations', this)" style="padding:10px 20px;font-size:13px;font-weight:600;border:none;background:none;cursor:pointer;color:#6c757d;">Bestätigungen</button>
    <button type="button" class="bbf-settings-tab-btn" onclick="bbfSwitchSettingsTab('formsettings', this)" style="padding:10px 20px;font-size:13px;font-weight:600;border:none;background:none;cursor:pointer;color:#6c757d;">Formular</button>
</div>

{* ═══ Notifications Tab ═══ *}
<div id="bbf-tab-notifications" class="bbf-settings-tab-panel">
    <div class="row">
        <div class="col-md-12">
            <div class="card-title d-flex align-items-center justify-content-between" style="margin-bottom:16px;">
                <h3 style="font-size:16px;">E-Mail-Benachrichtigungen</h3>
                <button type="button" class="bbf-btn-primary" style="padding:6px 16px;border-radius:6px;border:none;font-size:12px;cursor:pointer;" onclick="bbfAddNotification({$form->id});">+ Hinzufügen</button>
            </div>

            {if !empty($notifications)}
                {foreach $notifications as $notif}
                    <div class="bbf-stat-card" style="margin-bottom:12px;padding:16px;">
                        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;">
                            <strong>{$notif.name|escape}</strong>
                            <div style="display:flex;gap:4px;">
                                {if $notif.is_active}
                                    <span class="bbf-badge bbf-badge-success">Aktiv</span>
                                {else}
                                    <span class="bbf-badge bbf-badge-inactive">Inaktiv</span>
                                {/if}
                            </div>
                        </div>
                        <div style="font-size:12px;color:var(--bbf-text-light);">
                            An: {$notif.recipient_email|escape|default:'(Feld)'} &middot;
                            Betreff: {$notif.subject|escape|truncate:40}
                        </div>
                    </div>
                {/foreach}
            {else}
                <div class="bbf-msg bbf-msg-info">
                    Keine Benachrichtigungen konfiguriert. Klicke auf "Hinzufügen" um eine E-Mail-Benachrichtigung einzurichten.
                </div>
            {/if}
        </div>
    </div>
</div>

{* ═══ Confirmations Tab ═══ *}
<div id="bbf-tab-confirmations" class="bbf-settings-tab-panel" style="display:none;">
    <div class="row">
        <div class="col-md-12">
            <div class="card-title d-flex align-items-center justify-content-between" style="margin-bottom:16px;">
                <h3 style="font-size:16px;">Bestätigungsaktionen</h3>
            </div>

            {if !empty($confirmations)}
                {foreach $confirmations as $conf}
                    <div class="bbf-stat-card" style="margin-bottom:12px;padding:16px;">
                        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;">
                            <strong>{$conf.name|escape}</strong>
                            <span class="bbf-badge bbf-badge-info">{$conf.type|escape}</span>
                        </div>
                        <div style="font-size:12px;color:var(--bbf-text-light);">
                            {if $conf.type === 'message'}
                                {$conf.message|escape|truncate:80}
                            {elseif $conf.type === 'redirect'}
                                Weiterleitung: {$conf.redirect_url|escape}
                            {/if}
                        </div>
                    </div>
                {/foreach}
            {else}
                <div class="bbf-msg bbf-msg-info">
                    Keine Bestätigungen konfiguriert. Die Standard-Bestätigungsnachricht wird verwendet.
                </div>
            {/if}
        </div>
    </div>
</div>

{* ═══ Form Settings Tab ═══ *}
<div id="bbf-tab-formsettings" class="bbf-settings-tab-panel" style="display:none;">
    <form id="bbf-formsettings-form" action="updateForm">
        <input type="hidden" name="form_id" value="{$form->id}">

        <div class="row">
            <div class="col-md-6">
                <div style="margin-bottom:16px;">
                    <label style="display:block;font-size:12px;font-weight:600;color:var(--bbf-text-light);margin-bottom:6px;">Formularname</label>
                    <input type="text" name="title" value="{$form->title|escape}" class="form-control">
                </div>
            </div>
            <div class="col-md-6">
                <div style="margin-bottom:16px;">
                    <label style="display:block;font-size:12px;font-weight:600;color:var(--bbf-text-light);margin-bottom:6px;">Slug</label>
                    <input type="text" name="slug" value="{$form->slug|escape}" class="form-control">
                </div>
            </div>
        </div>

        <div style="margin-bottom:16px;">
            <label style="display:block;font-size:12px;font-weight:600;color:var(--bbf-text-light);margin-bottom:6px;">Beschreibung</label>
            <textarea name="description" class="form-control" rows="3">{$form->description|escape}</textarea>
        </div>

        <div class="row">
            <div class="col-md-4">
                <div style="margin-bottom:16px;">
                    <label style="display:block;font-size:12px;font-weight:600;color:var(--bbf-text-light);margin-bottom:6px;">Submit-Button Text</label>
                    <input type="text" name="submit_button_text" value="{$form->submit_button_text|escape}" class="form-control">
                </div>
            </div>
            <div class="col-md-4">
                <div style="margin-bottom:16px;">
                    <label style="display:block;font-size:12px;font-weight:600;color:var(--bbf-text-light);margin-bottom:6px;">CSS-Klassen</label>
                    <input type="text" name="css_classes" value="{$form->css_classes|escape}" class="form-control" placeholder="z.B. my-form compact">
                </div>
            </div>
            <div class="col-md-4">
                <div style="margin-bottom:16px;">
                    <label style="display:block;font-size:12px;font-weight:600;color:var(--bbf-text-light);margin-bottom:6px;">Status</label>
                    <select name="status" class="form-control">
                        <option value="draft" {if $form->status === 'draft'}selected{/if}>Entwurf</option>
                        <option value="active" {if $form->status === 'active'}selected{/if}>Aktiv</option>
                        <option value="inactive" {if $form->status === 'inactive'}selected{/if}>Inaktiv</option>
                    </select>
                </div>
            </div>
        </div>

        <div style="display:flex;align-items:center;gap:16px;margin-bottom:16px;">
            <label class="switch">
                <input type="checkbox" name="is_searchable" value="1" {if $form->is_searchable}checked{/if}>
                <span class="slider"></span>
            </label>
            <span style="font-size:13px;">Im Suchplugin indexieren</span>
        </div>

        <div style="margin-bottom:16px;padding:12px;background:#f8f9fa;border-radius:6px;">
            <strong style="font-size:12px;color:var(--bbf-text-light);">Einbindung:</strong><br>
            <code style="font-size:12px;">&#123;bbf_form id={$form->id}&#125;</code> oder
            <code style="font-size:12px;">&#123;bbf_form slug="{$form->slug}"&#125;</code>
        </div>

        <button type="button" class="bbf-btn-primary" style="padding:10px 24px;border-radius:8px;border:none;font-size:14px;cursor:pointer;" onclick="saveSetting('bbf-formsettings-form', 'form-settings');">
            Speichern
        </button>
    </form>
</div>

{else}
    <div class="bbf-msg bbf-msg-danger">Formular nicht gefunden.</div>
{/if}

<script>var bbfFormId = {$form->id};</script>
<script>
{literal}
function bbfSwitchSettingsTab(tabName, btnEl) {
    document.querySelectorAll('.bbf-settings-tab-panel').forEach(function(el) {
        el.style.display = 'none';
    });
    document.getElementById('bbf-tab-' + tabName).style.display = 'block';

    document.querySelectorAll('.bbf-settings-tab-btn').forEach(function(btn) {
        btn.style.color = '#6c757d';
        btn.style.borderBottom = '2px solid transparent';
    });
    if (btnEl) {
        btnEl.style.color = 'var(--bbf-primary)';
        btnEl.style.borderBottom = '2px solid var(--bbf-primary)';
    }
}

function bbfAddNotification(formId) {
    bbdNotify('Hinweis', 'Notification-Editor wird in einer zukünftigen Version verfügbar.', 'info', 'fa fa-info-circle');
}
{/literal}
</script>
