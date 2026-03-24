{* Eintrag - Detailansicht *}

<div class="bbf-entry-detail">
    {* Action Bar *}
    <div class="bbf-entry-actions" style="margin-bottom: 24px; display: flex; gap: 8px; align-items: center;">
        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfNavigate('entries');">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                <line x1="19" y1="12" x2="5" y2="12"></line>
                <polyline points="12 19 5 12 12 5"></polyline>
            </svg>
            Zurück
        </button>

        {if !$entry->is_read}
            <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfMarkEntryRead({$entry->id});">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
                Als gelesen markieren
            </button>
        {/if}

        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="window.print();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                <polyline points="6 9 6 2 18 2 18 9"></polyline>
                <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                <rect x="6" y="14" width="12" height="8"></rect>
            </svg>
            Drucken
        </button>

        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-danger" onclick="bbfDeleteEntry({$entry->id});" style="margin-left: auto;">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
            </svg>
            Löschen
        </button>
    </div>

    {* Entry Meta *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">
                {$entry->form_title|escape:'html'}
                {if !$entry->is_read}
                    <span class="bbf-badge bbf-badge-warning" style="margin-left: 8px;">Ungelesen</span>
                {/if}
            </h4>
        </div>
        <div class="bbf-card-body">
            <div class="bbf-entry-meta" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">Eintrags-ID:</span>
                    <span class="bbf-entry-meta-value">#{$entry->id}</span>
                </div>
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">Eingegangen am:</span>
                    <span class="bbf-entry-meta-value">{$entry->created_at|date_format:"%d.%m.%Y %H:%M:%S"}</span>
                </div>
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">IP-Adresse:</span>
                    <span class="bbf-entry-meta-value">{$entry->ip_address|default:'Anonymisiert'}</span>
                </div>
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">User-Agent:</span>
                    <span class="bbf-entry-meta-value">{$entry->user_agent|escape:'html'|default:'-'}</span>
                </div>
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">Seiten-URL:</span>
                    <span class="bbf-entry-meta-value">{if $entry->page_url}<a href="{$entry->page_url|escape:'html'}" target="_blank" class="bbf-link">{$entry->page_url|escape:'html'|truncate:60:'...'}</a>{else}-{/if}</span>
                </div>
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">Referrer:</span>
                    <span class="bbf-entry-meta-value">{if $entry->referrer_url}<a href="{$entry->referrer_url|escape:'html'}" target="_blank" class="bbf-link">{$entry->referrer_url|escape:'html'|truncate:60:'...'}</a>{else}-{/if}</span>
                </div>
            </div>
        </div>
    </div>

    {* Field Values *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Eingaben</h4>
        </div>
        <div class="bbf-card-body p-0">
            {if $entryFields && $entryFields|@count > 0}
                <div class="bbf-entry-fields">
                    {foreach $entryFields as $field}
                        {if in_array($field.type, ['section_break', 'page_break', 'html_block', 'captcha'])}{continue}{/if}
                        <div class="bbf-entry-field" style="display: flex; border-bottom: 1px solid var(--bbf-border); padding: 12px 16px;">
                            <div class="bbf-entry-field-label" style="width: 200px; min-width: 200px; font-weight: 600; color: var(--bbf-text-light);">{$field.label|escape:'html'}</div>
                            <div class="bbf-entry-field-value" style="flex: 1;">
                                {assign var="fieldId" value=$field.id}
                                {if isset($entryValues[$fieldId])}
                                    {if $field.type == 'file' && $entryValues[$fieldId]}
                                        <a href="{$entryValues[$fieldId]}" target="_blank" class="bbf-link">{$entryValues[$fieldId]|escape:'html'}</a>
                                    {elseif $field.type == 'checkbox'}
                                        {if $entryValues[$fieldId]}
                                            <span class="bbf-badge bbf-badge-success">Ja</span>
                                        {else}
                                            <span class="bbf-badge bbf-badge-secondary">Nein</span>
                                        {/if}
                                    {elseif $entryValues[$fieldId]}
                                        {$entryValues[$fieldId]|escape:'html'|nl2br}
                                    {else}
                                        <span style="color: var(--bbf-text-light);">-</span>
                                    {/if}
                                {else}
                                    <span style="color: var(--bbf-text-light);">-</span>
                                {/if}
                            </div>
                        </div>
                    {/foreach}
                </div>
            {else}
                <p style="padding: 16px; color: var(--bbf-text-light);">Keine Felddaten vorhanden.</p>
            {/if}
        </div>
    </div>

    {* Attached Files *}
    {if $files && $files|@count > 0}
        <div class="bbf-card">
            <div class="bbf-card-header">
                <h4 class="bbf-card-title">Anhänge</h4>
            </div>
            <div class="bbf-card-body">
                <div class="bbf-file-list">
                    {foreach $files as $file}
                        <div class="bbf-file-item" style="display: flex; align-items: center; gap: 8px; padding: 8px 0; border-bottom: 1px solid var(--bbf-border);">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                <path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"></path>
                            </svg>
                            <a href="{$file.url|escape:'html'}" target="_blank" class="bbf-link">{$file.name|escape:'html'}</a>
                            {if $file.size}
                                <span style="color: var(--bbf-text-light); font-size: 0.85em;">({$file.size})</span>
                            {/if}
                        </div>
                    {/foreach}
                </div>
            </div>
        </div>
    {/if}
</div>

<script>
function bbfMarkEntryRead(entryId) {
    bbfAjaxAction({ action: 'markEntryRead', entry_id: entryId }, function() {
        bbfNavigate('entry-detail', { entry_id: entryId });
    });
}

function bbfDeleteEntry(entryId) {
    if (!confirm('Eintrag wirklich löschen?')) return;
    bbfAjaxAction({ action: 'trashEntry', entry_id: entryId }, function() {
        bbfNavigate('entries');
    });
}
</script>
