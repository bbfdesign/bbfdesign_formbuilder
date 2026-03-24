{* Einträge - Übersicht *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Einträge</h4>
        <div class="bbf-header-actions">
            {* Filter by form *}
            <select class="bbf-select bbf-select-sm" id="bbf-entry-form-filter" onchange="bbfFilterEntries();">
                <option value="">Alle Formulare</option>
                {if $forms}
                    {foreach $forms as $form}
                        <option value="{$form.id}" {if $selectedFormId == $form.id}selected{/if}>{$form.name|escape:'html'}</option>
                    {/foreach}
                {/if}
            </select>
        </div>
    </div>

    {* Bulk Actions *}
    <div class="bbf-bulk-actions" id="bbf-bulk-actions" style="display: none;">
        <span class="bbf-bulk-count"><span id="bbf-selected-count">0</span> ausgewählt</span>
        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfBulkAction('mark_read');">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
                <polyline points="20 6 9 17 4 12"></polyline>
            </svg>
            Als gelesen markieren
        </button>
        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfBulkAction('export');">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                <polyline points="7 10 12 15 17 10"></polyline>
                <line x1="12" y1="15" x2="12" y2="3"></line>
            </svg>
            Exportieren
        </button>
        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-danger" onclick="bbfBulkAction('delete');">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
            </svg>
            Löschen
        </button>
    </div>

    <div class="bbf-card-body p-0">
        <div class="table-responsive">
            <table class="bbf-table">
                <thead>
                    <tr>
                        <th style="width: 40px;">
                            <input type="checkbox" id="bbf-select-all" onchange="bbfToggleSelectAll(this);">
                        </th>
                        <th>Formular</th>
                        <th>Absender</th>
                        <th>Datum</th>
                        <th>Status</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    {if $entries && $entries|@count > 0}
                        {foreach $entries as $entry}
                            <tr class="{if !$entry.is_read}bbf-row-unread{/if}">
                                <td>
                                    <input type="checkbox" class="bbf-entry-checkbox" value="{$entry.id}" onchange="bbfUpdateBulkActions();">
                                </td>
                                <td>{$entry.form_name|escape:'html'}</td>
                                <td>{$entry.sender|escape:'html'}</td>
                                <td>{$entry.created_at|date_format:"%d.%m.%Y %H:%M"}</td>
                                <td>
                                    {if $entry.is_read}
                                        <span class="bbf-badge bbf-badge-success">Gelesen</span>
                                    {else}
                                        <span class="bbf-badge bbf-badge-warning">Ungelesen</span>
                                    {/if}
                                    {if $entry.is_spam}
                                        <span class="bbf-badge bbf-badge-danger">Spam</span>
                                    {/if}
                                </td>
                                <td>
                                    <div class="bbf-btn-group">
                                        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-icon" onclick="bbfNavigate('entry-detail', {ldelim}entry_id: {$entry.id}{rdelim});" title="Anzeigen">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                        </button>
                                        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-icon bbf-btn-danger" onclick="bbfDeleteEntry({$entry.id});" title="Löschen">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                                <polyline points="3 6 5 6 21 6"></polyline>
                                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                            </svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        {/foreach}
                    {else}
                        <tr>
                            <td colspan="6" class="text-center" style="padding: 40px 0; color: var(--bbf-text-light);">
                                Noch keine Einträge vorhanden.
                            </td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>

    {* Pagination *}
    {if $totalPages > 1}
        <div class="bbf-card-footer">
            <div class="bbf-pagination">
                {for $p=1 to $totalPages}
                    <button type="button" class="bbf-btn bbf-btn-sm {if $currentPage == $p}bbf-btn-primary{else}bbf-btn-outline{/if}" onclick="bbfNavigate('entries', {ldelim}page: {$p}, form_id: '{$selectedFormId}'{rdelim});">
                        {$p}
                    </button>
                {/for}
            </div>
        </div>
    {/if}
</div>
