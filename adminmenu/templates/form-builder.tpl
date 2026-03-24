{* Form Builder - Drag & Drop Editor *}

<link rel="stylesheet" href="{$adminUrl}css/form-builder.css">

<div x-data="formBuilder" x-init="init()" class="bbf-form-builder" id="bbf-form-builder"
     data-form-id="{$formId|default:0}"
     data-template-id="{if isset($template) && $template}{$template->id}{else}0{/if}">

    {* ═════ Toolbar ═════ *}
    <div class="bbf-builder-toolbar">
        <div class="bbf-builder-toolbar-left">
            <button type="button" class="bbf-btn-secondary bbf-btn-sm" onclick="bbfNavigate('forms');" title="Zurück">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Zurück
            </button>
            <div class="bbf-builder-title-wrap">
                <input type="text" x-model="formName" class="bbf-builder-title-input" placeholder="Formularname eingeben..." @input="markDirty()">
                <span class="bbf-builder-status" x-show="isDirty" style="color:var(--bbf-warning);font-size:11px;">Ungespeichert</span>
            </div>
        </div>
        <div class="bbf-builder-toolbar-right">
            <select x-model="formStatus" @change="markDirty()" class="bbf-builder-status-select" style="padding:6px 10px;border-radius:6px;border:1px solid var(--bbf-border);font-size:12px;">
                <option value="draft">Entwurf</option>
                <option value="active">Aktiv</option>
                <option value="inactive">Inaktiv</option>
            </select>
            <button type="button" class="bbf-btn-secondary bbf-btn-sm" @click="previewForm()" title="Vorschau">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                    <circle cx="12" cy="12" r="3"></circle>
                </svg>
                Vorschau
            </button>
            <button type="button" class="bbf-btn-secondary bbf-btn-sm" @click="openFormSettings()" title="Einstellungen">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                    <circle cx="12" cy="12" r="3"></circle>
                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                </svg>
            </button>
            <button type="button" class="bbf-btn-primary bbf-btn-sm" @click="saveForm()" :disabled="saving">
                <template x-if="saving">
                    <span class="bbf-spinner" style="width:14px;height:14px;border-width:2px;"></span>
                </template>
                <template x-if="!saving">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                        <polyline points="17 21 17 13 7 13 7 21"></polyline>
                        <polyline points="7 3 7 8 15 8"></polyline>
                    </svg>
                </template>
                Speichern
            </button>
        </div>
    </div>

    {* ═════ Three-Column Layout ═════ *}
    <div class="bbf-builder-layout">

        {* ─── Left: Field Palette ─── *}
        <div class="bbf-field-palette" id="bbf-field-palette">
            <div class="bbf-palette-header">Felder</div>
            <div class="bbf-palette-search">
                <input type="text" x-model="fieldSearch" placeholder="Feld suchen...">
            </div>
            <div class="bbf-palette-content">
                {* Standard Fields *}
                <div class="bbf-palette-group">
                    <div class="bbf-palette-group-title">Standard</div>
                    <div class="bbf-palette-grid">
                        <template x-for="ft in standardFields" :key="ft.type">
                            <div x-show="!fieldSearch || ft.label.toLowerCase().includes(fieldSearch.toLowerCase())"
                                 class="bbf-palette-item"
                                 draggable="true"
                                 @dragstart="onDragStart($event, ft)"
                                 @click="addField(ft)">
                                <span x-html="iconSvg[ft.icon] || ''"></span>
                                <span class="bbf-palette-item-label" x-text="ft.label"></span>
                            </div>
                        </template>
                    </div>
                </div>

                {* Advanced Fields *}
                <div class="bbf-palette-group">
                    <div class="bbf-palette-group-title">Erweitert</div>
                    <div class="bbf-palette-grid">
                        <template x-for="ft in advancedFields" :key="ft.type">
                            <div x-show="!fieldSearch || ft.label.toLowerCase().includes(fieldSearch.toLowerCase())"
                                 class="bbf-palette-item"
                                 draggable="true"
                                 @dragstart="onDragStart($event, ft)"
                                 @click="addField(ft)">
                                <span x-html="iconSvg[ft.icon] || ''"></span>
                                <span class="bbf-palette-item-label" x-text="ft.label"></span>
                            </div>
                        </template>
                    </div>
                </div>

                {* Layout & Special Fields *}
                <div class="bbf-palette-group">
                    <div class="bbf-palette-group-title">Layout &amp; Spezial</div>
                    <div class="bbf-palette-grid">
                        <template x-for="ft in layoutFields" :key="ft.type">
                            <div x-show="!fieldSearch || ft.label.toLowerCase().includes(fieldSearch.toLowerCase())"
                                 class="bbf-palette-item"
                                 draggable="true"
                                 @dragstart="onDragStart($event, ft)"
                                 @click="addField(ft)">
                                <span x-html="iconSvg[ft.icon] || ''"></span>
                                <span class="bbf-palette-item-label" x-text="ft.label"></span>
                            </div>
                        </template>
                    </div>
                </div>
            </div>
        </div>

        {* ─── Center: Drop Zone / Canvas ─── *}
        <div class="bbf-drop-zone" id="bbf-builder-canvas">
            <div class="bbf-drop-zone-header">
                <span class="bbf-drop-zone-title" x-text="formFields.length + ' Felder'"></span>
                <div class="bbf-drop-zone-actions">
                    <span style="font-size:11px;color:var(--bbf-text-light);" x-show="formId">
                        ID: <span x-text="formId"></span>
                    </span>
                </div>
            </div>
            <div class="bbf-drop-zone-content"
                 :class="formFields.length === 0 ? 'is-empty' : ''"
                 id="bbf-drop-zone"
                 @dragover.prevent="onDragOver($event)"
                 @drop.prevent="onDrop($event)">

                {* Empty State *}
                <template x-if="formFields.length === 0">
                    <div class="bbf-drop-zone-empty">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="48" height="48">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <p>Felder hierher ziehen oder in der Palette klicken</p>
                    </div>
                </template>

                {* Field Cards *}
                <template x-for="(field, index) in formFields" :key="field.id">
                    <div class="bbf-field-card"
                         :class="selectedFieldId === field.id ? 'is-selected' : ''"
                         :data-field-id="field.id"
                         @click="selectField(field.id)">
                        <div class="bbf-field-card-header">
                            <span class="bbf-canvas-field-drag-handle bbf-field-card-drag">
                                <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14"><circle cx="9" cy="6" r="1.5"/><circle cx="15" cy="6" r="1.5"/><circle cx="9" cy="12" r="1.5"/><circle cx="15" cy="12" r="1.5"/><circle cx="9" cy="18" r="1.5"/><circle cx="15" cy="18" r="1.5"/></svg>
                            </span>
                            <span class="bbf-field-card-icon" x-html="iconSvg[standardFields.concat(advancedFields, layoutFields).find(t => t.type === field.type)?.icon] || ''"></span>
                            <div class="bbf-field-card-info">
                                <div class="bbf-field-card-name" x-text="field.label"></div>
                                <div class="bbf-field-card-type" x-text="field.type + (field.required ? ' *' : '') + (field.width !== 'full' ? ' · ' + field.width : '')"></div>
                            </div>
                            <div class="bbf-field-card-actions">
                                <button type="button" @click.stop="duplicateField(index)" title="Duplizieren">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                                </button>
                                <button type="button" class="bbf-field-delete" @click.stop="removeField(index)" title="Entfernen">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                </button>
                            </div>
                        </div>
                        <div class="bbf-field-card-preview" x-html="renderFieldPreview(field)"></div>
                    </div>
                </template>
            </div>
        </div>

        {* ─── Right: Field Settings Panel ─── *}
        <div class="bbf-field-settings" id="bbf-field-settings">

            {* No field selected *}
            <template x-if="!selectedFieldId">
                <div class="bbf-settings-empty">
                    <p>Wähle ein Feld aus, um die Einstellungen zu bearbeiten.</p>
                </div>
            </template>

            {* Field selected *}
            <template x-if="selectedFieldId && selectedField">
                <div>
                    <div class="bbf-settings-header">
                        <span class="bbf-settings-title">Feld-Einstellungen</span>
                        <button type="button" class="bbf-settings-close" @click="selectedFieldId = null" title="Schließen">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                        </button>
                    </div>

                    {* Tabs *}
                    <div style="display:flex;border-bottom:2px solid #dee2e6;background:#fff;">
                        <button type="button" style="flex:1;padding:10px;font-size:12px;font-weight:600;border:none;background:none;cursor:pointer;"
                                :style="settingsTab === 'general' ? 'color:var(--bbf-primary);border-bottom:2px solid var(--bbf-primary);margin-bottom:-2px;' : 'color:#6c757d;'"
                                @click="settingsTab = 'general'">Allgemein</button>
                        <button type="button" style="flex:1;padding:10px;font-size:12px;font-weight:600;border:none;background:none;cursor:pointer;"
                                :style="settingsTab === 'validation' ? 'color:var(--bbf-primary);border-bottom:2px solid var(--bbf-primary);margin-bottom:-2px;' : 'color:#6c757d;'"
                                @click="settingsTab = 'validation'">Validierung</button>
                        <button type="button" style="flex:1;padding:10px;font-size:12px;font-weight:600;border:none;background:none;cursor:pointer;"
                                :style="settingsTab === 'advanced' ? 'color:var(--bbf-primary);border-bottom:2px solid var(--bbf-primary);margin-bottom:-2px;' : 'color:#6c757d;'"
                                @click="settingsTab = 'advanced'">Erweitert</button>
                    </div>

                    <div class="bbf-settings-content">

                        {* ═══ General Tab ═══ *}
                        <div x-show="settingsTab === 'general'">
                            <div class="bbf-settings-group">
                                <div class="bbf-settings-group-title">Grundeinstellungen</div>

                                <div class="bbf-settings-field">
                                    <label>Bezeichnung</label>
                                    <input type="text" x-model="selectedField.label" @input="markDirty()">
                                </div>

                                <div class="bbf-settings-field" x-show="!['section_break','page_break','html_block','captcha'].includes(selectedField.type)">
                                    <label>Platzhalter</label>
                                    <input type="text" x-model="selectedField.placeholder" @input="markDirty()">
                                </div>

                                <div class="bbf-settings-field" x-show="!['section_break','page_break','html_block','captcha','hidden'].includes(selectedField.type)">
                                    <label>Beschreibung</label>
                                    <input type="text" x-model="selectedField.description" @input="markDirty()">
                                    <div class="bbf-settings-hint">Hilfetext unter dem Feld</div>
                                </div>

                                <div class="bbf-settings-field" x-show="!['section_break','page_break','html_block','captcha','gdpr','file_upload'].includes(selectedField.type)">
                                    <label>Standardwert</label>
                                    <input type="text" x-model="selectedField.default_value" @input="markDirty()">
                                </div>

                                {* Required toggle *}
                                <div class="bbf-settings-field" x-show="!['section_break','page_break','html_block','captcha'].includes(selectedField.type)" style="display:flex;align-items:center;gap:8px;">
                                    <label class="switch" style="margin:0;">
                                        <input type="checkbox" x-model="selectedField.required" @change="markDirty()">
                                        <span class="slider"></span>
                                    </label>
                                    <span style="font-size:13px;">Pflichtfeld</span>
                                </div>
                            </div>

                            {* ═══ Choices Editor ═══ *}
                            <div class="bbf-settings-group" x-show="selectedFieldHasChoices">
                                <div class="bbf-settings-group-title">Auswahloptionen</div>
                                <template x-for="(choice, ci) in (selectedField.choices || [])" :key="ci">
                                    <div style="display:flex;gap:6px;margin-bottom:6px;align-items:center;">
                                        <input type="text" x-model="choice.label" @input="markDirty()" style="flex:1;" placeholder="Label">
                                        <input type="text" x-model="choice.value" @input="markDirty()" style="width:80px;" placeholder="Wert">
                                        <button type="button" @click="removeChoice(ci)" style="background:none;border:none;color:var(--bbf-danger);cursor:pointer;padding:4px;">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                        </button>
                                    </div>
                                </template>
                                <button type="button" class="bbf-btn-secondary" style="width:100%;padding:6px;font-size:12px;" @click="addChoice()">
                                    + Option hinzufügen
                                </button>
                            </div>

                            {* ═══ Width Selector ═══ *}
                            <div class="bbf-settings-group" x-show="!['page_break','captcha'].includes(selectedField.type)">
                                <div class="bbf-settings-group-title">Feldbreite</div>
                                <div class="bbf-field-width-selector">
                                    <template x-for="wo in widthOptions" :key="wo.value">
                                        <div class="bbf-field-width-option"
                                             :class="selectedField.width === wo.value ? 'is-active' : ''"
                                             @click="setFieldWidth(wo.value)">
                                            <div class="bbf-field-width-preview">
                                                <div class="bbf-width-fill" :style="'width:' + wo.percent + '%'"></div>
                                            </div>
                                            <span class="bbf-field-width-label" x-text="wo.label"></span>
                                        </div>
                                    </template>
                                </div>
                            </div>

                            {* ═══ Type-Specific: HTML Block ═══ *}
                            <div class="bbf-settings-group" x-show="selectedField.type === 'html_block'">
                                <div class="bbf-settings-group-title">HTML-Inhalt</div>
                                <div class="bbf-settings-field">
                                    <textarea x-model="selectedField.html_content" @input="markDirty()" rows="6" style="font-family:monospace;font-size:12px;"></textarea>
                                </div>
                            </div>

                            {* ═══ Type-Specific: Section Break ═══ *}
                            <div class="bbf-settings-group" x-show="selectedField.type === 'section_break'">
                                <div class="bbf-settings-group-title">Abschnitts-Titel</div>
                                <div class="bbf-settings-field">
                                    <input type="text" x-model="selectedField.section_title" @input="markDirty()">
                                </div>
                            </div>

                            {* ═══ Type-Specific: Rating ═══ *}
                            <div class="bbf-settings-group" x-show="selectedField.type === 'rating'">
                                <div class="bbf-settings-group-title">Bewertung</div>
                                <div class="bbf-settings-field">
                                    <label>Maximale Sterne</label>
                                    <input type="number" x-model="selectedField.max_stars" @input="markDirty()" min="3" max="10">
                                </div>
                            </div>

                            {* ═══ Type-Specific: Slider ═══ *}
                            <div class="bbf-settings-group" x-show="selectedField.type === 'slider'">
                                <div class="bbf-settings-group-title">Slider</div>
                                <div class="bbf-settings-field">
                                    <label>Minimum</label>
                                    <input type="number" x-model="selectedField.min_value" @input="markDirty()">
                                </div>
                                <div class="bbf-settings-field">
                                    <label>Maximum</label>
                                    <input type="number" x-model="selectedField.max_value" @input="markDirty()">
                                </div>
                                <div class="bbf-settings-field">
                                    <label>Schrittweite</label>
                                    <input type="number" x-model="selectedField.step_value" @input="markDirty()">
                                </div>
                            </div>

                            {* ═══ Type-Specific: File Upload ═══ *}
                            <div class="bbf-settings-group" x-show="selectedField.type === 'file_upload'">
                                <div class="bbf-settings-group-title">Datei-Upload</div>
                                <div class="bbf-settings-field">
                                    <label>Max. Dateigröße (MB)</label>
                                    <input type="number" x-model="selectedField.max_file_size" @input="markDirty()">
                                </div>
                                <div class="bbf-settings-field">
                                    <label>Erlaubte Dateitypen</label>
                                    <input type="text" x-model="selectedField.allowed_extensions" @input="markDirty()" placeholder="pdf,jpg,png,doc">
                                    <div class="bbf-settings-hint">Kommagetrennt, z.B. pdf,jpg,png</div>
                                </div>
                            </div>

                            {* ═══ Type-Specific: GDPR ═══ *}
                            <div class="bbf-settings-group" x-show="selectedField.type === 'gdpr'">
                                <div class="bbf-settings-group-title">DSGVO-Text</div>
                                <div class="bbf-settings-field">
                                    <textarea x-model="selectedField.gdpr_text" @input="markDirty()" rows="3"></textarea>
                                    <div class="bbf-settings-hint">HTML erlaubt (z.B. Links)</div>
                                </div>
                            </div>
                        </div>

                        {* ═══ Validation Tab ═══ *}
                        <div x-show="settingsTab === 'validation'">
                            <div class="bbf-settings-group">
                                <div class="bbf-settings-group-title">Validierungsregeln</div>

                                <div class="bbf-settings-field" x-show="['text','textarea','password'].includes(selectedField.type)">
                                    <label>Min. Länge</label>
                                    <input type="number" x-model="selectedField.min_length" @input="markDirty()" min="0">
                                </div>

                                <div class="bbf-settings-field" x-show="['text','textarea','password'].includes(selectedField.type)">
                                    <label>Max. Länge</label>
                                    <input type="number" x-model="selectedField.max_length" @input="markDirty()" min="0">
                                </div>

                                <div class="bbf-settings-field" x-show="['number','slider'].includes(selectedField.type)">
                                    <label>Minimalwert</label>
                                    <input type="number" x-model="selectedField.min_value" @input="markDirty()">
                                </div>

                                <div class="bbf-settings-field" x-show="['number','slider'].includes(selectedField.type)">
                                    <label>Maximalwert</label>
                                    <input type="number" x-model="selectedField.max_value" @input="markDirty()">
                                </div>

                                <div class="bbf-settings-field" x-show="selectedField.type === 'text'">
                                    <label>Pattern (Regex)</label>
                                    <input type="text" x-model="selectedField.pattern" @input="markDirty()" placeholder="z.B. [A-Za-z]+">
                                </div>

                                <div class="bbf-settings-field">
                                    <label>Eigene Fehlermeldung</label>
                                    <input type="text" x-model="selectedField.error_message" @input="markDirty()" placeholder="Optional">
                                    <div class="bbf-settings-hint">Überschreibt die Standard-Fehlermeldung</div>
                                </div>
                            </div>
                        </div>

                        {* ═══ Advanced Tab ═══ *}
                        <div x-show="settingsTab === 'advanced'">
                            <div class="bbf-settings-group">
                                <div class="bbf-settings-group-title">Technisch</div>

                                <div class="bbf-settings-field">
                                    <label>Feld-ID</label>
                                    <input type="text" x-model="selectedField.id" readonly style="opacity:0.6;cursor:not-allowed;">
                                    <div class="bbf-settings-hint">Automatisch generiert, nicht ändern</div>
                                </div>

                                <div class="bbf-settings-field">
                                    <label>CSS-Klassen</label>
                                    <input type="text" x-model="selectedField.css_class" @input="markDirty()" placeholder="z.B. my-custom-class">
                                </div>
                            </div>

                            {* Conditional Logic Editor *}
                            <div class="bbf-settings-group">
                                <div class="bbf-settings-group-title">Bedingte Logik</div>

                                <div x-data="conditionalLogicEditor({
                                    fieldLogic: selectedField.conditional_logic || null,
                                    formFields: formFields,
                                    currentFieldId: selectedField.id,
                                    onChange(cfg) {
                                        selectedField.conditional_logic = cfg;
                                        markDirty();
                                    }
                                })" x-effect="
                                    /* Re-init when selected field changes */
                                    let fl = selectedField.conditional_logic;
                                    if (fl) { enabled = true; action = fl.action || 'show'; matchType = fl.match || 'all'; rules = JSON.parse(JSON.stringify(fl.rules || [])); }
                                    else { enabled = false; action = 'show'; matchType = 'all'; rules = []; }
                                ">

                                    {* Enable toggle *}
                                    <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px;">
                                        <label class="switch" style="margin:0;">
                                            <input type="checkbox" x-model="enabled" @change="emitChange()">
                                            <span class="slider"></span>
                                        </label>
                                        <span style="font-size:13px;">Aktivieren</span>
                                    </div>

                                    {* Logic configuration (shown only when enabled) *}
                                    <template x-if="enabled">
                                        <div>
                                            {* Action & Match type *}
                                            <div style="display:flex;gap:8px;margin-bottom:10px;">
                                                <select x-model="action" @change="emitChange()" style="flex:1;padding:6px 8px;border:1px solid var(--bbf-border);border-radius:6px;font-size:12px;">
                                                    <option value="show">Feld anzeigen wenn</option>
                                                    <option value="hide">Feld ausblenden wenn</option>
                                                </select>
                                                <select x-model="matchType" @change="emitChange()" style="flex:1;padding:6px 8px;border:1px solid var(--bbf-border);border-radius:6px;font-size:12px;">
                                                    <option value="all">Alle Bedingungen</option>
                                                    <option value="any">Mind. eine Bedingung</option>
                                                </select>
                                            </div>

                                            {* Rule rows *}
                                            <template x-for="(rule, ri) in rules" :key="ri">
                                                <div style="display:flex;flex-wrap:wrap;gap:6px;margin-bottom:8px;padding:8px;background:var(--bbf-bg-light, #f8f9fa);border-radius:6px;align-items:center;">
                                                    {* Field selector *}
                                                    <select x-model="rule.field_id" @change="onRuleFieldChange(ri)" style="flex:2;min-width:0;padding:6px 8px;border:1px solid var(--bbf-border);border-radius:4px;font-size:12px;">
                                                        <option value="">– Feld wählen –</option>
                                                        <template x-for="af in availableFields" :key="af.id">
                                                            <option :value="af.id" x-text="af.label + ' (' + af.type + ')'"></option>
                                                        </template>
                                                    </select>

                                                    {* Operator selector *}
                                                    <select x-model="rule.operator" @change="onOperatorChange(ri)" style="flex:2;min-width:0;padding:6px 8px;border:1px solid var(--bbf-border);border-radius:4px;font-size:12px;">
                                                        <template x-for="op in operators" :key="op.value">
                                                            <option :value="op.value" x-text="op.label"></option>
                                                        </template>
                                                    </select>

                                                    {* Value input – show dropdown if target field has choices, otherwise text *}
                                                    <template x-if="operatorNeedsValue(rule.operator) && getChoicesForField(rule.field_id).length > 0">
                                                        <select x-model="rule.value" @change="emitChange()" style="flex:2;min-width:0;padding:6px 8px;border:1px solid var(--bbf-border);border-radius:4px;font-size:12px;">
                                                            <option value="">– Wert –</option>
                                                            <template x-for="ch in getChoicesForField(rule.field_id)" :key="ch.value">
                                                                <option :value="ch.value" x-text="ch.label"></option>
                                                            </template>
                                                        </select>
                                                    </template>
                                                    <template x-if="operatorNeedsValue(rule.operator) && getChoicesForField(rule.field_id).length === 0">
                                                        <input type="text" x-model="rule.value" @input="emitChange()" placeholder="Wert" style="flex:2;min-width:0;padding:6px 8px;border:1px solid var(--bbf-border);border-radius:4px;font-size:12px;">
                                                    </template>

                                                    {* Remove rule *}
                                                    <button type="button" @click="removeRule(ri)" style="background:none;border:none;color:var(--bbf-danger);cursor:pointer;padding:4px;flex-shrink:0;" title="Bedingung entfernen">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                                    </button>
                                                </div>
                                            </template>

                                            {* Add rule button *}
                                            <button type="button" class="bbf-btn-secondary" style="width:100%;padding:6px;font-size:12px;" @click="addRule()">
                                                + Bedingung hinzufügen
                                            </button>
                                        </div>
                                    </template>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
        </div>
    </div>
</div>

{* Preview Styles *}
<style>
.bbf-builder-toolbar { display:flex; align-items:center; justify-content:space-between; padding:12px 16px; background:#fff; border-bottom:1px solid var(--bbf-border); gap:12px; flex-wrap:wrap; }
.bbf-builder-toolbar-left, .bbf-builder-toolbar-right { display:flex; align-items:center; gap:8px; }
.bbf-builder-title-wrap { display:flex; align-items:center; gap:8px; }
.bbf-builder-title-input { border:none; border-bottom:2px solid transparent; font-size:16px; font-weight:600; padding:6px 4px; background:transparent; min-width:200px; outline:none; transition:border-color 0.2s; }
.bbf-builder-title-input:focus { border-bottom-color:var(--bbf-primary); }
.bbf-btn-sm { padding:6px 14px; font-size:12px; display:inline-flex; align-items:center; gap:6px; border-radius:6px; cursor:pointer; font-weight:500; transition:all 0.2s; }
.bbf-btn-icon-sm { background:none; border:none; cursor:pointer; padding:4px; border-radius:4px; display:flex; align-items:center; transition:all 0.2s; }
.bbf-btn-icon-sm:hover { background:var(--bbf-bg-hover); }
.bbf-preview-input { width:100%; padding:6px 10px; border:1px solid #ddd; border-radius:4px; font-size:12px; background:#f9f9f9; color:#999; }
.bbf-preview-textarea { width:100%; padding:6px 10px; border:1px solid #ddd; border-radius:4px; font-size:12px; background:#f9f9f9; color:#999; height:40px; resize:none; }
.bbf-preview-select { width:100%; padding:6px 10px; border:1px solid #ddd; border-radius:4px; font-size:12px; background:#f9f9f9; color:#999; }
.bbf-preview-radio, .bbf-preview-checkbox { display:inline-flex; align-items:center; gap:4px; font-size:12px; color:#666; margin-right:12px; }
.bbf-preview-file { padding:8px; background:#f0f8ff; border:1px dashed #b0d4f1; border-radius:4px; font-size:11px; color:#4a90d9; text-align:center; }
.bbf-preview-rating { font-size:16px; }
.bbf-preview-slider { width:100%; }
</style>

<script src="{$adminUrl}js/vendor/sortable.min.js"></script>
<script src="{$adminUrl}js/vendor/alpine.min.js" defer></script>
<script src="{$adminUrl}js/conditional-logic-editor.js" defer></script>
<script src="{$adminUrl}js/form-builder.js" defer></script>
