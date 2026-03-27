{* API-Verbindungen *}

{* Tabs *}
<div style="display:flex;border-bottom:2px solid #dee2e6;margin-bottom:20px;">
    <button type="button" class="bbf-settings-tab-btn bbf-api-tab" onclick="bbfSwitchApiTab('connections', this)" style="padding:10px 20px;font-size:13px;font-weight:600;border:none;background:none;cursor:pointer;color:var(--bbf-primary);border-bottom:2px solid var(--bbf-primary);margin-bottom:-2px;">Verbindungen</button>
    <button type="button" class="bbf-settings-tab-btn bbf-api-tab" onclick="bbfSwitchApiTab('endpoints', this)" style="padding:10px 20px;font-size:13px;font-weight:600;border:none;background:none;cursor:pointer;color:#6c757d;">Endpunkte</button>
    <button type="button" class="bbf-settings-tab-btn bbf-api-tab" onclick="bbfSwitchApiTab('logs', this)" style="padding:10px 20px;font-size:13px;font-weight:600;border:none;background:none;cursor:pointer;color:#6c757d;">API-Log</button>
</div>

{* ═══ Verbindungen Tab ═══ *}
<div id="bbf-api-tab-connections" class="bbf-api-tab-panel">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <h3 style="font-size:16px;margin:0;">API-Verbindungen</h3>
        <button type="button" class="bbf-btn-primary" style="padding:6px 16px;border-radius:6px;border:none;font-size:12px;cursor:pointer;" onclick="bbfShowConnectionForm(0);">+ Neue Verbindung</button>
    </div>

    {if !empty($connections)}
        {foreach $connections as $conn}
            <div class="bbf-stat-card" style="margin-bottom:12px;padding:16px;">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;">
                    <div>
                        <strong>{$conn.name|escape}</strong>
                        <span class="bbf-badge {if $conn.active}bbf-badge-success{else}bbf-badge-inactive{/if}" style="margin-left:8px;">{if $conn.active}Aktiv{else}Inaktiv{/if}</span>
                    </div>
                    <div style="display:flex;gap:6px;">
                        <button type="button" class="bbf-btn-secondary" style="padding:4px 10px;border-radius:4px;border:1px solid var(--bbf-border);font-size:11px;cursor:pointer;background:transparent;" onclick="bbfTestConnection('{$conn.base_url|escape:'javascript'}');">Testen</button>
                        <button type="button" class="bbf-btn-secondary" style="padding:4px 10px;border-radius:4px;border:1px solid var(--bbf-border);font-size:11px;cursor:pointer;background:transparent;" onclick="bbfShowConnectionForm({$conn.id});">Bearbeiten</button>
                        <button type="button" style="padding:4px 10px;border-radius:4px;border:1px solid #dc3545;color:#dc3545;font-size:11px;cursor:pointer;background:transparent;" onclick="if(confirm('Verbindung löschen?')) bbfAjaxAction({ldelim}action:'deleteApiConnection',connection_id:{$conn.id}{rdelim}, function() {ldelim} bbfNavigate('api-connections'); {rdelim});">Löschen</button>
                    </div>
                </div>
                <div style="font-size:12px;color:var(--bbf-text-light);">
                    <span>{$conn.base_url|escape}</span> &middot;
                    Auth: {$conn.auth_type|escape|default:'none'}
                </div>
            </div>
        {/foreach}
    {else}
        <div class="bbf-msg bbf-msg-info">
            Keine API-Verbindungen konfiguriert. Klicke auf "Neue Verbindung" um eine externe API anzubinden.
        </div>
    {/if}
</div>

{* ═══ Endpunkte Tab ═══ *}
<div id="bbf-api-tab-endpoints" class="bbf-api-tab-panel" style="display:none;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <h3 style="font-size:16px;margin:0;">API-Endpunkte</h3>
        <button type="button" class="bbf-btn-primary" style="padding:6px 16px;border-radius:6px;border:none;font-size:12px;cursor:pointer;" onclick="bbfShowEndpointForm(0);">+ Neuer Endpunkt</button>
    </div>

    {if !empty($endpoints)}
        {foreach $endpoints as $ep}
            <div class="bbf-stat-card" style="margin-bottom:12px;padding:16px;">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;">
                    <div>
                        <strong>{$ep.name|escape}</strong>
                        <span class="bbf-badge bbf-badge-info" style="margin-left:8px;">{$ep.method|escape}</span>
                        <span class="bbf-badge {if $ep.active}bbf-badge-success{else}bbf-badge-inactive{/if}" style="margin-left:4px;">{if $ep.active}Aktiv{else}Inaktiv{/if}</span>
                    </div>
                    <div style="display:flex;gap:6px;">
                        <button type="button" class="bbf-btn-secondary" style="padding:4px 10px;border-radius:4px;border:1px solid var(--bbf-border);font-size:11px;cursor:pointer;background:transparent;" onclick="bbfShowEndpointForm({$ep.id});">Bearbeiten</button>
                        <button type="button" style="padding:4px 10px;border-radius:4px;border:1px solid #dc3545;color:#dc3545;font-size:11px;cursor:pointer;background:transparent;" onclick="if(confirm('Endpunkt löschen?')) bbfAjaxAction({ldelim}action:'deleteApiEndpoint',endpoint_id:{$ep.id}{rdelim}, function() {ldelim} bbfNavigate('api-connections'); {rdelim});">Löschen</button>
                    </div>
                </div>
                <div style="font-size:12px;color:var(--bbf-text-light);">
                    {$ep.connection_name|escape|default:'?'} &middot; {$ep.path|escape} &middot; Trigger: {$ep.trigger_on|escape}
                </div>
            </div>
        {/foreach}
    {else}
        <div class="bbf-msg bbf-msg-info">
            Keine Endpunkte konfiguriert. Erstelle zuerst eine Verbindung, dann füge Endpunkte hinzu.
        </div>
    {/if}
</div>

{* ═══ API-Log Tab ═══ *}
<div id="bbf-api-tab-logs" class="bbf-api-tab-panel" style="display:none;">
    <h3 style="font-size:16px;margin-bottom:16px;">API-Log (letzte 50 Einträge)</h3>

    {if !empty($logs)}
        <div style="overflow-x:auto;">
            <table style="width:100%;font-size:13px;border-collapse:collapse;">
                <thead>
                    <tr style="background:#f1f3f5;text-align:left;">
                        <th style="padding:8px 12px;border-bottom:2px solid #dee2e6;">Datum</th>
                        <th style="padding:8px 12px;border-bottom:2px solid #dee2e6;">Endpunkt</th>
                        <th style="padding:8px 12px;border-bottom:2px solid #dee2e6;">Status</th>
                        <th style="padding:8px 12px;border-bottom:2px solid #dee2e6;">Dauer</th>
                        <th style="padding:8px 12px;border-bottom:2px solid #dee2e6;">Ergebnis</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $logs as $log}
                        <tr style="border-bottom:1px solid #e5e7eb;">
                            <td style="padding:8px 12px;">{$log.created_at|escape|truncate:16:''}</td>
                            <td style="padding:8px 12px;">{$log.endpoint_name|escape|default:'—'} <span style="color:#6c757d;">{$log.method|escape} {$log.path|escape}</span></td>
                            <td style="padding:8px 12px;">{$log.status_code|escape}</td>
                            <td style="padding:8px 12px;">{$log.duration_ms|escape} ms</td>
                            <td style="padding:8px 12px;">
                                {if $log.success}
                                    <span class="bbf-badge bbf-badge-success">OK</span>
                                {else}
                                    <span class="bbf-badge bbf-badge-danger" title="{$log.error_msg|escape}">Fehler</span>
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    {else}
        <div class="bbf-msg bbf-msg-info">Noch keine API-Aufrufe protokolliert.</div>
    {/if}
</div>

{* ═══ Connection Form Modal (inline, toggle via JS) ═══ *}
<div id="bbf-connection-form-wrap" style="display:none;position:fixed;inset:0;z-index:10000;background:rgba(0,0,0,0.4);display:none;align-items:center;justify-content:center;">
    <div style="background:#fff;border-radius:8px;padding:24px;width:100%;max-width:600px;max-height:80vh;overflow-y:auto;box-shadow:0 10px 40px rgba(0,0,0,0.15);">
        <h3 style="margin:0 0 16px;font-size:16px;" id="bbf-conn-form-title">Neue Verbindung</h3>
        <form id="bbf-connection-form">
            <input type="hidden" name="connection_id" id="bbf-conn-id" value="0">
            <div style="margin-bottom:12px;">
                <label style="display:block;font-size:12px;font-weight:600;margin-bottom:4px;">Name *</label>
                <input type="text" name="name" id="bbf-conn-name" class="form-control" required>
            </div>
            <div style="margin-bottom:12px;">
                <label style="display:block;font-size:12px;font-weight:600;margin-bottom:4px;">Base-URL *</label>
                <input type="url" name="base_url" id="bbf-conn-url" class="form-control" placeholder="https://api.beispiel.de" required>
            </div>
            <div style="margin-bottom:12px;">
                <label style="display:block;font-size:12px;font-weight:600;margin-bottom:4px;">Beschreibung</label>
                <textarea name="description" id="bbf-conn-desc" class="form-control" rows="2"></textarea>
            </div>
            <div class="row">
                <div class="col-md-6" style="margin-bottom:12px;">
                    <label style="display:block;font-size:12px;font-weight:600;margin-bottom:4px;">Auth-Typ</label>
                    <select name="auth_type" id="bbf-conn-auth" class="form-control">
                        <option value="none">Kein</option>
                        <option value="api_key">API-Key</option>
                        <option value="bearer">Bearer Token</option>
                        <option value="basic">HTTP Basic</option>
                    </select>
                </div>
                <div class="col-md-6" style="margin-bottom:12px;">
                    <label style="display:block;font-size:12px;font-weight:600;margin-bottom:4px;">Timeout (Sek.)</label>
                    <input type="number" name="timeout" id="bbf-conn-timeout" class="form-control" value="30" min="1" max="120">
                </div>
            </div>
            <div id="bbf-conn-auth-fields" style="margin-bottom:12px;"></div>
            <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:16px;">
                <button type="button" class="bbf-btn-secondary" style="padding:8px 18px;border-radius:6px;border:1px solid var(--bbf-border);cursor:pointer;background:transparent;" onclick="bbfCloseConnectionForm();">Abbrechen</button>
                <button type="button" class="bbf-btn-primary" style="padding:8px 18px;border-radius:6px;border:none;cursor:pointer;" onclick="bbfSaveConnection();">Speichern</button>
            </div>
        </form>
    </div>
</div>

<script>
{literal}
function bbfSwitchApiTab(tabName, btnEl) {
    document.querySelectorAll('.bbf-api-tab-panel').forEach(function(el) { el.style.display = 'none'; });
    document.getElementById('bbf-api-tab-' + tabName).style.display = 'block';
    document.querySelectorAll('.bbf-api-tab').forEach(function(btn) {
        btn.style.color = '#6c757d'; btn.style.borderBottom = '2px solid transparent';
    });
    if (btnEl) { btnEl.style.color = 'var(--bbf-primary)'; btnEl.style.borderBottom = '2px solid var(--bbf-primary)'; }
}

function bbfShowConnectionForm(id) {
    var wrap = document.getElementById('bbf-connection-form-wrap');
    wrap.style.display = 'flex';
    document.getElementById('bbf-conn-id').value = id;
    document.getElementById('bbf-conn-form-title').textContent = id > 0 ? 'Verbindung bearbeiten' : 'Neue Verbindung';
    if (id === 0) {
        document.getElementById('bbf-conn-name').value = '';
        document.getElementById('bbf-conn-url').value = '';
        document.getElementById('bbf-conn-desc').value = '';
        document.getElementById('bbf-conn-auth').value = 'none';
        document.getElementById('bbf-conn-timeout').value = '30';
    }
}

function bbfCloseConnectionForm() {
    document.getElementById('bbf-connection-form-wrap').style.display = 'none';
}

function bbfSaveConnection() {
    var form = document.getElementById('bbf-connection-form');
    var data = {
        action: 'saveApiConnection',
        connection_id: document.getElementById('bbf-conn-id').value,
        name: document.getElementById('bbf-conn-name').value,
        base_url: document.getElementById('bbf-conn-url').value,
        description: document.getElementById('bbf-conn-desc').value,
        auth_type: document.getElementById('bbf-conn-auth').value,
        timeout: document.getElementById('bbf-conn-timeout').value,
        active: 1
    };
    bbfAjaxAction(data, function() { bbfCloseConnectionForm(); bbfNavigate('api-connections'); });
}

function bbfTestConnection(url) {
    bbfAjaxAction({ action: 'testApiConnection', base_url: url });
}

function bbfShowEndpointForm(id) {
    bbdNotify('Hinweis', 'Endpunkt-Editor wird in einer zukünftigen Version als Wizard verfügbar.', 'info', 'fa fa-info-circle');
}
{/literal}
</script>
