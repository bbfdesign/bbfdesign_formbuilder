{* E-Mail-Templates *}

<div style="background: #fff; border-radius: 10px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb; overflow: hidden;">
    <div style="padding: 16px 20px; border-bottom: 1px solid #e5e7eb;">
        <h4 style="margin: 0; font-size: 15px; font-weight: 600; color: #1f2937;">E-Mail-Templates</h4>
        <p style="margin: 4px 0 0 0; font-size: 13px; color: #6b7280;">Verwalte die E-Mail-Vorlagen für Benachrichtigungen und Bestätigungen.</p>
    </div>
    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr>
                    <th style="background: #f8f9fa; padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Name</th>
                    <th style="background: #f8f9fa; padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Typ</th>
                    <th style="background: #f8f9fa; padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Aktionen</th>
                </tr>
            </thead>
            <tbody>
                {if $emailTemplates && $emailTemplates|@count > 0}
                    {foreach $emailTemplates as $template}
                        <tr style="border-bottom: 1px solid #f3f4f6;">
                            <td style="padding: 12px 16px; font-size: 13px; color: #1f2937; font-weight: 600;">{$template.name|escape:'html'}</td>
                            <td style="padding: 12px 16px;">
                                {if $template.type == 'standard'}
                                    <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(99,102,241,0.1); color: #6366f1;">standard</span>
                                {elseif $template.type == 'fancy'}
                                    <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(139,92,246,0.1); color: #8b5cf6;">fancy</span>
                                {elseif $template.type == 'custom'}
                                    <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(16,185,129,0.1); color: #059669;">custom</span>
                                {else}
                                    <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(107,114,128,0.1); color: #6b7280;">{$template.type|escape:'html'}</span>
                                {/if}
                            </td>
                            <td style="padding: 12px 16px;">
                                <button type="button" onclick="bbfEditEmailTemplate('{$template.id}');" title="Bearbeiten" style="display: inline-flex; align-items: center; gap: 5px; padding: 5px 12px; font-size: 12px; font-weight: 500; color: #6366f1; background: rgba(99,102,241,0.08); border: 1px solid rgba(99,102,241,0.2); border-radius: 5px; cursor: pointer;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
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
                    <tr style="border-bottom: 1px solid #f3f4f6;">
                        <td style="padding: 12px 16px; font-size: 13px; color: #1f2937; font-weight: 600;">Admin-Benachrichtigung</td>
                        <td style="padding: 12px 16px;">
                            <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(99,102,241,0.1); color: #6366f1;">standard</span>
                        </td>
                        <td style="padding: 12px 16px;">
                            <button type="button" onclick="bbfEditEmailTemplate('admin_notification');" title="Bearbeiten" style="display: inline-flex; align-items: center; gap: 5px; padding: 5px 12px; font-size: 12px; font-weight: 500; color: #6366f1; background: rgba(99,102,241,0.08); border: 1px solid rgba(99,102,241,0.2); border-radius: 5px; cursor: pointer;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                </svg>
                                Bearbeiten
                            </button>
                        </td>
                    </tr>
                    <tr style="border-bottom: 1px solid #f3f4f6;">
                        <td style="padding: 12px 16px; font-size: 13px; color: #1f2937; font-weight: 600;">Benutzer-Bestätigung</td>
                        <td style="padding: 12px 16px;">
                            <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(99,102,241,0.1); color: #6366f1;">standard</span>
                        </td>
                        <td style="padding: 12px 16px;">
                            <button type="button" onclick="bbfEditEmailTemplate('user_confirmation');" title="Bearbeiten" style="display: inline-flex; align-items: center; gap: 5px; padding: 5px 12px; font-size: 12px; font-weight: 500; color: #6366f1; background: rgba(99,102,241,0.08); border: 1px solid rgba(99,102,241,0.2); border-radius: 5px; cursor: pointer;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                </svg>
                                Bearbeiten
                            </button>
                        </td>
                    </tr>
                    <tr style="border-bottom: 1px solid #f3f4f6;">
                        <td style="padding: 12px 16px; font-size: 13px; color: #1f2937; font-weight: 600;">Auto-Responder</td>
                        <td style="padding: 12px 16px;">
                            <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(99,102,241,0.1); color: #6366f1;">standard</span>
                        </td>
                        <td style="padding: 12px 16px;">
                            <button type="button" onclick="bbfEditEmailTemplate('auto_responder');" title="Bearbeiten" style="display: inline-flex; align-items: center; gap: 5px; padding: 5px 12px; font-size: 12px; font-weight: 500; color: #6366f1; background: rgba(99,102,241,0.08); border: 1px solid rgba(99,102,241,0.2); border-radius: 5px; cursor: pointer;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
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

{literal}
<script>
function bbfEditEmailTemplate(templateId) {
    alert('E-Mail-Template Editor wird in einer zukünftigen Version verfügbar.');
}
</script>
{/literal}
