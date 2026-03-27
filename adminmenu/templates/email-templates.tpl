{* E-Mail-Templates *}

<div style="display:flex;gap:20px;align-items:flex-start;">

    {* ═══ Linke Spalte: Template-Liste ═══ *}
    <div style="width:320px;flex-shrink:0;">
        <div style="background:#fff;border-radius:10px;box-shadow:0 1px 3px rgba(0,0,0,0.08);border:1px solid #e5e7eb;overflow:hidden;">
            <div style="padding:14px 16px;border-bottom:1px solid #e5e7eb;display:flex;justify-content:space-between;align-items:center;">
                <h4 style="margin:0;font-size:14px;font-weight:600;">E-Mail-Templates</h4>
            </div>
            <div style="max-height:70vh;overflow-y:auto;" id="bbf-email-template-list">
                {if $emailTemplates && $emailTemplates|@count > 0}
                    {foreach $emailTemplates as $template}
                        <div class="bbf-email-tpl-item" data-id="{$template.id}" onclick="bbfSelectEmailTemplate({$template.id});"
                             style="padding:12px 16px;cursor:pointer;border-bottom:1px solid #f3f4f6;transition:background 0.1s;">
                            <div style="font-weight:600;font-size:13px;color:#1f2937;">{$template.name|escape:'html'}</div>
                            <div style="font-size:11px;color:#6b7280;margin-top:2px;">
                                {if $template.type == 'standard'}
                                    <span class="bbf-badge bbf-badge-info">Standard</span>
                                {elseif $template.type == 'fancy'}
                                    <span class="bbf-badge" style="background:rgba(139,92,246,0.1);color:#8b5cf6;">Modern</span>
                                {else}
                                    <span class="bbf-badge bbf-badge-success">Custom</span>
                                {/if}
                            </div>
                        </div>
                    {/foreach}
                {else}
                    <div style="padding:24px 16px;text-align:center;color:#6b7280;font-size:13px;">
                        Keine E-Mail-Templates vorhanden.
                    </div>
                {/if}
            </div>
        </div>
    </div>

    {* ═══ Rechte Spalte: Template-Editor ═══ *}
    <div style="flex:1;min-width:0;">
        <div id="bbf-email-editor" style="background:#fff;border-radius:10px;box-shadow:0 1px 3px rgba(0,0,0,0.08);border:1px solid #e5e7eb;overflow:hidden;">
            <div style="padding:40px;text-align:center;color:#9ca3af;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="48" height="48" style="margin-bottom:12px;opacity:0.3;">
                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/>
                </svg>
                <p style="font-size:14px;">Wähle ein Template aus der Liste um es zu bearbeiten.</p>
            </div>
        </div>

        {* ─── Merge-Tags Referenz ─── *}
        <div style="background:#fff;border-radius:10px;box-shadow:0 1px 3px rgba(0,0,0,0.08);border:1px solid #e5e7eb;margin-top:16px;padding:16px;">
            <h5 style="margin:0 0 10px;font-size:13px;font-weight:600;color:#6b7280;">Verfügbare Merge-Tags</h5>
            <div style="display:flex;flex-wrap:wrap;gap:6px;">
                <code style="padding:2px 8px;background:#f3f4f6;border-radius:4px;font-size:11px;cursor:pointer;" onclick="navigator.clipboard.writeText(this.textContent)" title="Klicken zum Kopieren">{literal}{{all_fields}}{/literal}</code>
                <code style="padding:2px 8px;background:#f3f4f6;border-radius:4px;font-size:11px;cursor:pointer;" onclick="navigator.clipboard.writeText(this.textContent)" title="Klicken zum Kopieren">{literal}{{form_name}}{/literal}</code>
                <code style="padding:2px 8px;background:#f3f4f6;border-radius:4px;font-size:11px;cursor:pointer;" onclick="navigator.clipboard.writeText(this.textContent)" title="Klicken zum Kopieren">{literal}{{entry_id}}{/literal}</code>
                <code style="padding:2px 8px;background:#f3f4f6;border-radius:4px;font-size:11px;cursor:pointer;" onclick="navigator.clipboard.writeText(this.textContent)" title="Klicken zum Kopieren">{literal}{{date}}{/literal}</code>
                <code style="padding:2px 8px;background:#f3f4f6;border-radius:4px;font-size:11px;cursor:pointer;" onclick="navigator.clipboard.writeText(this.textContent)" title="Klicken zum Kopieren">{literal}{{time}}{/literal}</code>
                <code style="padding:2px 8px;background:#f3f4f6;border-radius:4px;font-size:11px;cursor:pointer;" onclick="navigator.clipboard.writeText(this.textContent)" title="Klicken zum Kopieren">{literal}{{shop_name}}{/literal}</code>
                <code style="padding:2px 8px;background:#f3f4f6;border-radius:4px;font-size:11px;cursor:pointer;" onclick="navigator.clipboard.writeText(this.textContent)" title="Klicken zum Kopieren">{literal}{{shop_url}}{/literal}</code>
                <code style="padding:2px 8px;background:#f3f4f6;border-radius:4px;font-size:11px;cursor:pointer;" onclick="navigator.clipboard.writeText(this.textContent)" title="Klicken zum Kopieren">{literal}{{field:FELD_ID}}{/literal}</code>
            </div>
        </div>
    </div>
</div>

<script>
{literal}
function bbfSelectEmailTemplate(id) {
    document.querySelectorAll('.bbf-email-tpl-item').forEach(function(el) {
        el.style.background = el.dataset.id == id ? '#f0f5ff' : '';
    });

    var editorEl = document.getElementById('bbf-email-editor');
    editorEl.innerHTML = '<div style="padding:40px;text-align:center;"><div class="bbf-spinner" style="width:30px;height:30px;border-width:3px;margin:0 auto;"></div></div>';

    bbfAjaxAction({ action: 'getEmailTemplate', template_id: id }, function(resp) {
        if (!resp.template) {
            editorEl.innerHTML = '<div style="padding:20px;color:#dc3545;">Template nicht gefunden.</div>';
            return;
        }
        var t = resp.template;
        editorEl.innerHTML =
            '<div style="padding:16px;border-bottom:1px solid #e5e7eb;">' +
            '<h4 style="margin:0;font-size:15px;font-weight:600;">' + (t.name || 'Template') + '</h4>' +
            '</div>' +
            '<div style="padding:20px;">' +
            '<div style="margin-bottom:14px;">' +
            '<label style="display:block;font-size:12px;font-weight:600;margin-bottom:4px;">Name</label>' +
            '<input type="text" id="bbf-et-name" class="form-control" value="' + (t.name || '') + '">' +
            '</div>' +
            '<div style="margin-bottom:14px;">' +
            '<label style="display:block;font-size:12px;font-weight:600;margin-bottom:4px;">Typ</label>' +
            '<select id="bbf-et-type" class="form-control">' +
            '<option value="standard"' + (t.type==='standard'?' selected':'') + '>Standard</option>' +
            '<option value="fancy"' + (t.type==='fancy'?' selected':'') + '>Modern (Fancy)</option>' +
            '<option value="custom"' + (t.type==='custom'?' selected':'') + '>Custom</option>' +
            '</select>' +
            '</div>' +
            '<div style="margin-bottom:14px;">' +
            '<label style="display:block;font-size:12px;font-weight:600;margin-bottom:4px;">HTML-Inhalt</label>' +
            '<textarea id="bbf-et-html" class="form-control" rows="12" style="font-family:monospace;font-size:12px;">' + (t.html_template || '') + '</textarea>' +
            '</div>' +
            '<button type="button" class="bbf-btn-primary" style="padding:8px 20px;border-radius:6px;border:none;cursor:pointer;" onclick="bbfSaveEmailTemplate(' + t.id + ');">Speichern</button>' +
            '</div>';
    });
}

function bbfSaveEmailTemplate(id) {
    bbfAjaxAction({
        action: 'saveEmailTemplate',
        template_id: id,
        name: document.getElementById('bbf-et-name').value,
        type: document.getElementById('bbf-et-type').value,
        html_template: document.getElementById('bbf-et-html').value
    }, function() {
        bbfNavigate('email-templates');
    });
}
{/literal}
</script>
