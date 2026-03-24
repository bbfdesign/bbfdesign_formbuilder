{* Dashboard - Übersicht *}

<div class="bbf-stats-grid">
    <div class="bbf-stat-card">
        <div class="bbf-stat-card-icon" style="background: rgba(99, 102, 241, 0.1); color: #6366f1;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
            </svg>
        </div>
        <div class="bbf-stat-card-content">
            <div class="bbf-stat-card-value">{$totalForms|default:0}</div>
            <div class="bbf-stat-card-label">Formulare gesamt</div>
        </div>
    </div>

    <div class="bbf-stat-card">
        <div class="bbf-stat-card-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
            </svg>
        </div>
        <div class="bbf-stat-card-content">
            <div class="bbf-stat-card-value">{$totalEntries|default:0}</div>
            <div class="bbf-stat-card-label">Einträge gesamt</div>
        </div>
    </div>

    <div class="bbf-stat-card">
        <div class="bbf-stat-card-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
        </div>
        <div class="bbf-stat-card-content">
            <div class="bbf-stat-card-value">{$unreadEntries|default:0}</div>
            <div class="bbf-stat-card-label">Ungelesen</div>
        </div>
    </div>

    <div class="bbf-stat-card">
        <div class="bbf-stat-card-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
            </svg>
        </div>
        <div class="bbf-stat-card-content">
            <div class="bbf-stat-card-value">{$spamBlocked|default:0}</div>
            <div class="bbf-stat-card-label">Spam blockiert</div>
        </div>
    </div>
</div>

{* Letzte Einträge *}
<div class="bbf-card" style="margin-top: 24px;">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Letzte Einträge</h4>
        <a href="#" onclick="bbfNavigate('entries'); return false;" class="bbf-btn bbf-btn-sm bbf-btn-outline">
            Alle anzeigen
        </a>
    </div>
    <div class="bbf-card-body p-0">
        <div class="table-responsive">
            <table class="bbf-table">
                <thead>
                    <tr>
                        <th>Formular</th>
                        <th>Absender</th>
                        <th>Datum</th>
                        <th>Status</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    {if $recentEntries && $recentEntries|@count > 0}
                        {foreach $recentEntries as $entry}
                            <tr>
                                <td>{$entry.form_name|escape:'html'}</td>
                                <td>{$entry.sender|escape:'html'}</td>
                                <td>{$entry.created_at|date_format:"%d.%m.%Y %H:%M"}</td>
                                <td>
                                    {if $entry.is_read}
                                        <span class="bbf-badge bbf-badge-success">Gelesen</span>
                                    {else}
                                        <span class="bbf-badge bbf-badge-warning">Ungelesen</span>
                                    {/if}
                                </td>
                                <td>
                                    <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-icon" onclick="bbfNavigate('entry-detail', {ldelim}entry_id: {$entry.id}{rdelim});" title="Anzeigen">
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
                            <td colspan="5" class="text-center" style="padding: 40px 0; color: var(--bbf-text-light);">
                                Noch keine Einträge vorhanden.
                            </td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>
</div>
