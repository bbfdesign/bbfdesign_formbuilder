{* Formular-Vorlagen *}

<div class="row">
    <div class="col-md-12">
        <div class="card-title d-flex align-items-center justify-content-between" style="margin-bottom:20px;">
            <h3>Formular erstellen</h3>
        </div>
        <p style="color:var(--bbf-text-light);margin-bottom:24px;">Wähle eine Vorlage als Ausgangspunkt oder starte mit einem leeren Formular.</p>
    </div>
</div>

<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:16px;">

    {* Leeres Formular *}
    <div class="bbf-stat-card" style="cursor:pointer;text-align:center;padding:32px 20px;transition:all 0.2s;" onclick="bbfNavigate('form-builder');" onmouseover="this.style.borderColor='var(--bbf-primary)'" onmouseout="this.style.borderColor='var(--bbf-border-light)'">
        <div style="margin-bottom:12px;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="40" height="40" style="color:var(--bbf-primary);">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
        </div>
        <h5 style="font-size:15px;font-weight:600;margin-bottom:6px;">Leeres Formular</h5>
        <p style="font-size:12px;color:var(--bbf-text-light);margin:0;">Starte mit einem leeren Formular und füge eigene Felder hinzu.</p>
    </div>

    {* System-Vorlagen aus DB *}
    {if !empty($templates)}
        {foreach $templates as $tpl}
            <div class="bbf-stat-card" style="cursor:pointer;text-align:center;padding:32px 20px;transition:all 0.2s;"
                 onclick="bbfCreateFromTemplate({$tpl.id});"
                 onmouseover="this.style.borderColor='var(--bbf-primary)'" onmouseout="this.style.borderColor='var(--bbf-border-light)'">
                <div style="margin-bottom:12px;">
                    {if $tpl.icon === 'mail'}
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="40" height="40" style="color:var(--bbf-text-light);">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                            <polyline points="22,6 12,13 2,6"></polyline>
                        </svg>
                    {elseif $tpl.icon === 'mail-plus'}
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="40" height="40" style="color:var(--bbf-text-light);">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                            <polyline points="22,6 12,13 2,6"></polyline>
                        </svg>
                    {elseif $tpl.icon === 'phone'}
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="40" height="40" style="color:var(--bbf-text-light);">
                            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                        </svg>
                    {else}
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="40" height="40" style="color:var(--bbf-text-light);">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                        </svg>
                    {/if}
                </div>
                <h5 style="font-size:15px;font-weight:600;margin-bottom:6px;">{$tpl.name|escape}</h5>
                <p style="font-size:12px;color:var(--bbf-text-light);margin:0;">{$tpl.description|escape|truncate:80}</p>
                {if $tpl.category}
                    <span class="bbf-badge bbf-badge-info" style="margin-top:8px;">{$tpl.category|escape}</span>
                {/if}
            </div>
        {/foreach}
    {/if}
</div>

<script>
function bbfCreateFromTemplate(templateId) {
    bbfAjaxAction({
        action: 'createFromTemplate',
        template_id: templateId,
    }, function(response) {
        if (response.form_id) {
            bbfNavigate('form-builder', { form_id: response.form_id });
        }
    });
}
</script>
