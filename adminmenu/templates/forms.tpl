{* Alle Formulare *}

<div class="row">
    <div class="col-md-12">
        <div class="card-title d-flex align-items-center justify-content-between">
            <h3>Alle Formulare</h3>
            <button type="button" class="bbf-btn-primary" style="padding:10px 24px;border-radius:10px;border:none;font-size:14px;font-weight:500;cursor:pointer;display:inline-flex;align-items:center;gap:8px;" onclick="bbfNavigate('templates');">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                Neues Formular
            </button>
        </div>
    </div>
</div>

<div class="row" style="margin-top:16px;">
    <div class="col-md-12">
        <table class="table" style="background:#fff;border-radius:8px;">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Slug</th>
                    <th>Status</th>
                    <th>Einträge</th>
                    <th>Erstellt</th>
                    <th style="width:140px;">Aktionen</th>
                </tr>
            </thead>
            <tbody>
                {if !empty($forms)}
                    {foreach $forms as $form}
                        <tr>
                            <td>
                                <a href="#" onclick="bbfNavigate('form-builder', {ldelim}form_id: {$form.id}{rdelim}); return false;" style="font-weight:600;color:var(--bbf-text-dark);text-decoration:none;">
                                    {$form.title|escape}
                                </a>
                            </td>
                            <td>
                                <span class="bbf-slug">{$form.slug|escape}</span>
                            </td>
                            <td>
                                {if $form.status === 'active'}
                                    <span class="bbf-badge bbf-badge-success">Aktiv</span>
                                {elseif $form.status === 'draft'}
                                    <span class="bbf-badge bbf-badge-warning">Entwurf</span>
                                {else}
                                    <span class="bbf-badge bbf-badge-inactive">Inaktiv</span>
                                {/if}
                            </td>
                            <td>
                                <span class="bbf-count">{$form.entry_count|default:0}</span>
                            </td>
                            <td style="font-size:13px;color:var(--bbf-text-light);">
                                {$form.created_at|date_format:"%d.%m.%Y"}
                            </td>
                            <td>
                                <div class="bbf-actions">
                                    <button type="button" class="btn btn-outline-secondary" onclick="bbfNavigate('form-builder', {ldelim}form_id: {$form.id}{rdelim});" title="Bearbeiten">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="bbfDuplicateForm({$form.id});" title="Duplizieren">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger" onclick="bbfDeleteForm({$form.id}, '{$form.title|escape:'javascript'}');" title="Löschen">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    {/foreach}
                {else}
                    <tr>
                        <td colspan="6" class="text-center" style="padding: 48px 0; color: var(--bbf-text-light);">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="40" height="40" style="margin-bottom:12px;opacity:0.3;"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                            <p style="margin-bottom:12px;">Noch keine Formulare erstellt.</p>
                            <button type="button" class="bbf-btn-primary" style="padding:8px 20px;border-radius:8px;border:none;font-size:13px;cursor:pointer;" onclick="bbfNavigate('templates');">
                                Erstes Formular erstellen
                            </button>
                        </td>
                    </tr>
                {/if}
            </tbody>
        </table>
    </div>
</div>

<script>
function bbfDuplicateForm(formId) {
    if (!confirm('Formular wirklich duplizieren?')) return;
    bbfAjaxAction({ action: 'duplicateForm', form_id: formId }, function() {
        bbfNavigate('forms');
    });
}

function bbfDeleteForm(formId, formName) {
    if (!confirm('Formular "' + formName + '" wirklich löschen? Alle Einträge gehen verloren!')) return;
    bbfAjaxAction({ action: 'deleteForm', form_id: formId }, function() {
        bbfNavigate('forms');
    });
}
</script>
