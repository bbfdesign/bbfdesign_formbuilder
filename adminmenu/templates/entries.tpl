{* Einträge - Übersicht *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Einträge</h4>
        <div class="bbf-header-actions" style="display: flex; gap: 8px; align-items: center;">
            {* Filter by form *}
            <select class="bbf-select bbf-select-sm" id="bbf-entry-form-filter" onchange="bbfFilterEntries();">
                <option value="">Alle Formulare</option>
                {if $forms}
                    {foreach $forms as $form}
                        <option value="{$form.id}" {if $filterFormId == $form.id}selected{/if}>{$form.title|escape:'html'}</option>
                    {/foreach}
                {/if}
            </select>
            {* CSV Export *}
            <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfExportEntries(document.getElementById('bbf-entry-form-filter').value);" title="CSV exportieren">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="7 10 12 15 17 10"></polyline>
                    <line x1="12" y1="15" x2="12" y2="3"></line>
                </svg>
                CSV Export
            </button>
        </div>
    </div>

    {* Bulk Actions *}
    <div class="bbf-bulk-actions" id="bbf-bulk-actions" style="display:none; align-items:center; gap:8px; padding:10px 16px; background:#f8f9fa; border-bottom:1px solid var(--bbf-border);">
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
                        <th>Vorschau</th>
                        <th>Datum</th>
                        <th>Status</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    {if $entries && $entries|@count > 0}
                        {foreach $entries as $entry}
                            <tr class="{if !$entry.is_read}bbf-row-unread{/if}" {if !$entry.is_read}style="font-weight: bold;"{/if}>
                                <td>
                                    <input type="checkbox" class="bbf-entry-checkbox" value="{$entry.id}" onchange="bbfUpdateBulkActions();">
                                </td>
                                <td>{$entry.form_title|escape:'html'}</td>
                                <td>{$entry.first_value|escape:'html'|truncate:80:'...'}</td>
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
                    <button type="button" class="bbf-btn bbf-btn-sm {if $currentPage == $p}bbf-btn-primary{else}bbf-btn-outline{/if}" onclick="bbfNavigate('entries', {ldelim}page: {$p}, filter_form_id: '{$filterFormId}'{rdelim});">
                        {$p}
                    </button>
                {/for}
            </div>
        </div>
    {/if}
</div>

<script>
{literal}
function bbfFilterEntries() {
    var formId = document.getElementById('bbf-entry-form-filter').value;
    bbfNavigate('entries', { filter_form_id: formId });
}

function bbfToggleSelectAll(checkbox) {
    document.querySelectorAll('.bbf-entry-checkbox').forEach(function(cb) {
        cb.checked = checkbox.checked;
    });
    bbfUpdateBulkActions();
}

function bbfUpdateBulkActions() {
    var checked = document.querySelectorAll('.bbf-entry-checkbox:checked');
    var bulkBar = document.getElementById('bbf-bulk-actions');
    var countEl = document.getElementById('bbf-selected-count');
    if (checked.length > 0) {
        bulkBar.style.display = 'flex';
        countEl.textContent = checked.length;
    } else {
        bulkBar.style.display = 'none';
    }
}

function bbfBulkAction(action) {
    var ids = [];
    document.querySelectorAll('.bbf-entry-checkbox:checked').forEach(function(cb) {
        ids.push(cb.value);
    });
    if (ids.length === 0) return;

    if (action === 'delete' && !confirm('Wirklich ' + ids.length + ' Einträge löschen?')) return;

    if (action === 'export') {
        bbfExportEntries(document.getElementById('bbf-entry-form-filter').value);
        return;
    }

    bbfAjaxAction({
        action: 'bulkEntryAction',
        bulk_action: action,
        entry_ids: ids.join(','),
    }, function() {
        bbfNavigate('entries');
    });
}

function bbfDeleteEntry(entryId) {
    if (!confirm('Eintrag wirklich löschen?')) return;
    bbfAjaxAction({ action: 'trashEntry', entry_id: entryId }, function() {
        bbfNavigate('entries');
    });
}

function bbfExportEntries(formId) {
    // Trigger CSV download via form POST
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = postURL;
    form.target = '_blank';
    var fields = { action: 'exportEntriesCsv', form_id: formId || '', is_ajax: 1, jtl_token: document.querySelector('[name="jtl_token"]').value };
    for (var key in fields) {
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = fields[key];
        form.appendChild(input);
    }
    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
}
{/literal}
</script>
