{* Dashboard - Übersicht *}

<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px;">
    {* Formulare *}
    <div style="background: #fff; border-radius: 10px; padding: 20px; display: flex; align-items: center; gap: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <div style="width: 48px; height: 48px; border-radius: 10px; background: rgba(99, 102, 241, 0.1); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
            <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
            </svg>
        </div>
        <div>
            <div style="font-size: 24px; font-weight: 700; color: #1f2937; line-height: 1.2;">{$totalForms|default:0}</div>
            <div style="font-size: 13px; color: #6b7280; margin-top: 2px;">Formulare gesamt</div>
        </div>
    </div>

    {* Einträge *}
    <div style="background: #fff; border-radius: 10px; padding: 20px; display: flex; align-items: center; gap: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <div style="width: 48px; height: 48px; border-radius: 10px; background: rgba(16, 185, 129, 0.1); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
            <svg viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
            </svg>
        </div>
        <div>
            <div style="font-size: 24px; font-weight: 700; color: #1f2937; line-height: 1.2;">{$totalEntries|default:0}</div>
            <div style="font-size: 13px; color: #6b7280; margin-top: 2px;">Einträge gesamt</div>
        </div>
    </div>

    {* Ungelesen *}
    <div style="background: #fff; border-radius: 10px; padding: 20px; display: flex; align-items: center; gap: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <div style="width: 48px; height: 48px; border-radius: 10px; background: rgba(245, 158, 11, 0.1); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
            <svg viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
        </div>
        <div>
            <div style="font-size: 24px; font-weight: 700; color: #1f2937; line-height: 1.2;">{$unreadEntries|default:0}</div>
            <div style="font-size: 13px; color: #6b7280; margin-top: 2px;">Ungelesen</div>
        </div>
    </div>

    {* Spam *}
    <div style="background: #fff; border-radius: 10px; padding: 20px; display: flex; align-items: center; gap: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <div style="width: 48px; height: 48px; border-radius: 10px; background: rgba(239, 68, 68, 0.1); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
            <svg viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
            </svg>
        </div>
        <div>
            <div style="font-size: 24px; font-weight: 700; color: #1f2937; line-height: 1.2;">{$spamBlocked|default:0}</div>
            <div style="font-size: 13px; color: #6b7280; margin-top: 2px;">Spam blockiert</div>
        </div>
    </div>
</div>

{* Quick Action + Letzte Einträge *}
<div style="margin-bottom: 16px;">
    <button type="button" onclick="bbfNavigate('form-editor', {ldelim}form_id: 'new'{rdelim});" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #6366f1; color: #fff; border: none; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer;">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        Neues Formular
    </button>
</div>

<div style="background: #fff; border-radius: 10px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb; overflow: hidden;">
    <div style="padding: 16px 20px; border-bottom: 1px solid #e5e7eb; display: flex; align-items: center; justify-content: space-between;">
        <h4 style="margin: 0; font-size: 15px; font-weight: 600; color: #1f2937;">Letzte Einträge</h4>
        <a href="#" onclick="bbfNavigate('entries'); return false;" style="display: inline-flex; align-items: center; gap: 4px; padding: 5px 12px; font-size: 12px; font-weight: 500; color: #6366f1; background: rgba(99,102,241,0.08); border: 1px solid rgba(99,102,241,0.2); border-radius: 5px; text-decoration: none; cursor: pointer;">
            Alle anzeigen
        </a>
    </div>
    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr>
                    <th style="background: #f8f9fa; padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Formular</th>
                    <th style="background: #f8f9fa; padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Vorschau</th>
                    <th style="background: #f8f9fa; padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Datum</th>
                    <th style="background: #f8f9fa; padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Status</th>
                    <th style="background: #f8f9fa; padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Aktionen</th>
                </tr>
            </thead>
            <tbody>
                {if $recentEntries && $recentEntries|@count > 0}
                    {foreach $recentEntries as $entry}
                        <tr style="border-bottom: 1px solid #f3f4f6;{if !$entry.is_read} font-weight: bold;{/if}">
                            <td style="padding: 12px 16px; font-size: 13px; color: #1f2937;">{$entry.form_title|escape:'html'}</td>
                            <td style="padding: 12px 16px; font-size: 13px; color: #6b7280;">{$entry.first_value|escape:'html'|truncate:60:'...'}</td>
                            <td style="padding: 12px 16px; font-size: 13px; color: #6b7280; white-space: nowrap;">{$entry.created_at|date_format:"%d.%m.%Y %H:%M"}</td>
                            <td style="padding: 12px 16px;">
                                {if $entry.is_read}
                                    <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(16,185,129,0.1); color: #059669;">Gelesen</span>
                                {else}
                                    <span style="display: inline-block; padding: 2px 8px; font-size: 11px; font-weight: 600; border-radius: 9999px; background: rgba(245,158,11,0.1); color: #d97706;">Ungelesen</span>
                                {/if}
                            </td>
                            <td style="padding: 12px 16px;">
                                <button type="button" onclick="bbfNavigate('entry-detail', {ldelim}entry_id: {$entry.id}{rdelim});" title="Anzeigen" style="display: inline-flex; align-items: center; justify-content: center; width: 30px; height: 30px; border: 1px solid #e5e7eb; border-radius: 6px; background: #fff; cursor: pointer; color: #6b7280;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                </button>
                            </td>
                        </tr>
                    {/foreach}
                {else}
                    <tr>
                        <td colspan="5" style="padding: 40px 0; text-align: center; color: #9ca3af; font-size: 13px;">
                            Noch keine Einträge vorhanden.
                        </td>
                    </tr>
                {/if}
            </tbody>
        </table>
    </div>
</div>
