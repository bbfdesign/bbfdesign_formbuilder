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

        {if !$entry.is_read}
            <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfMarkEntryRead({$entry.id});">
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

        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-danger" onclick="bbfDeleteEntry({$entry.id}, true);" style="margin-left: auto;">
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
                {$entry.form_name|escape:'html'}
                {if !$entry.is_read}
                    <span class="bbf-badge bbf-badge-warning" style="margin-left: 8px;">Ungelesen</span>
                {/if}
            </h4>
        </div>
        <div class="bbf-card-body">
            <div class="bbf-entry-meta">
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">Eintrags-ID:</span>
                    <span class="bbf-entry-meta-value">#{$entry.id}</span>
                </div>
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">Eingegangen am:</span>
                    <span class="bbf-entry-meta-value">{$entry.created_at|date_format:"%d.%m.%Y %H:%M:%S"}</span>
                </div>
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">IP-Adresse:</span>
                    <span class="bbf-entry-meta-value">{$entry.ip_address|default:'Anonymisiert'}</span>
                </div>
                <div class="bbf-entry-meta-item">
                    <span class="bbf-entry-meta-label">User-Agent:</span>
                    <span class="bbf-entry-meta-value">{$entry.user_agent|escape:'html'|default:'-'}</span>
                </div>
            </div>
        </div>
    </div>

    {* Field Values *}
    <div class="bbf-card">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Eingaben</h4>
        </div>
        <div class="bbf-card-body">
            {if $entry.fields && $entry.fields|@count > 0}
                <div class="bbf-entry-fields">
                    {foreach $entry.fields as $field}
                        <div class="bbf-entry-field">
                            <div class="bbf-entry-field-label">{$field.label|escape:'html'}</div>
                            <div class="bbf-entry-field-value">
                                {if $field.type == 'file' && $field.value}
                                    <a href="{$field.value}" target="_blank" class="bbf-link">{$field.filename|escape:'html'}</a>
                                {elseif $field.type == 'checkbox'}
                                    {if $field.value}
                                        <span class="bbf-badge bbf-badge-success">Ja</span>
                                    {else}
                                        <span class="bbf-badge bbf-badge-secondary">Nein</span>
                                    {/if}
                                {elseif $field.value}
                                    {$field.value|escape:'html'|nl2br}
                                {else}
                                    <span style="color: var(--bbf-text-light);">-</span>
                                {/if}
                            </div>
                        </div>
                    {/foreach}
                </div>
            {else}
                <p style="color: var(--bbf-text-light);">Keine Felddaten vorhanden.</p>
            {/if}
        </div>
    </div>
</div>
