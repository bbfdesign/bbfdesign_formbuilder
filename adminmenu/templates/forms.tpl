{* Alle Formulare *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Alle Formulare</h4>
        <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfNavigate('templates');">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            Neues Formular
        </button>
    </div>
    <div class="bbf-card-body p-0">
        <div class="table-responsive">
            <table class="bbf-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Slug</th>
                        <th>Status</th>
                        <th>Einträge</th>
                        <th>Erstellt</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    {if $forms && $forms|@count > 0}
                        {foreach $forms as $form}
                            <tr>
                                <td>
                                    <strong>{$form.name|escape:'html'}</strong>
                                </td>
                                <td>
                                    <code class="bbf-code">{$form.slug|escape:'html'}</code>
                                </td>
                                <td>
                                    {if $form.is_active}
                                        <span class="bbf-badge bbf-badge-success">Aktiv</span>
                                    {else}
                                        <span class="bbf-badge bbf-badge-secondary">Inaktiv</span>
                                    {/if}
                                </td>
                                <td>{$form.entry_count|default:0}</td>
                                <td>{$form.created_at|date_format:"%d.%m.%Y"}</td>
                                <td>
                                    <div class="bbf-btn-group">
                                        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-icon" onclick="bbfNavigate('form-builder', {ldelim}form_id: {$form.id}{rdelim});" title="Bearbeiten">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                            </svg>
                                        </button>
                                        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-icon" onclick="bbfDuplicateForm({$form.id});" title="Duplizieren">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                                                <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                                                <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                                            </svg>
                                        </button>
                                        <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-icon bbf-btn-danger" onclick="bbfDeleteForm({$form.id}, '{$form.name|escape:'javascript'}');" title="Löschen">
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
                                <p>Noch keine Formulare erstellt.</p>
                                <button type="button" class="bbf-btn bbf-btn-primary bbf-btn-sm" onclick="bbfNavigate('templates');" style="margin-top: 12px;">
                                    Erstes Formular erstellen
                                </button>
                            </td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>
</div>
