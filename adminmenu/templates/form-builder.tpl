{* Form Builder - Drag & Drop Editor *}

<link rel="stylesheet" href="{$adminUrl}css/form-builder.css">

<div x-data="formBuilder" x-init="init()" class="bbf-form-builder" id="bbf-form-builder">

    {* Toolbar *}
    <div class="bbf-builder-toolbar">
        <div class="bbf-builder-toolbar-left">
            <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" onclick="bbfNavigate('forms');" title="Zurück">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Zurück
            </button>
            <div class="bbf-builder-title-input">
                <input type="text" x-model="formName" class="bbf-input bbf-input-inline" placeholder="Formularname eingeben..." @change="markDirty()">
            </div>
        </div>
        <div class="bbf-builder-toolbar-right">
            <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" @click="previewForm()" title="Vorschau">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                    <circle cx="12" cy="12" r="3"></circle>
                </svg>
                Vorschau
            </button>
            <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-outline" @click="openFormSettings()" title="Einstellungen">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                    <circle cx="12" cy="12" r="3"></circle>
                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                </svg>
                Einstellungen
            </button>
            <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-primary" @click="saveForm()" :disabled="saving">
                <template x-if="saving">
                    <span class="bbf-spinner bbf-spinner-sm"></span>
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

    {* Three-column layout *}
    <div class="bbf-builder-layout">

        {* Left: Field Palette *}
        <div class="bbf-builder-palette" id="bbf-field-palette">
            <div class="bbf-palette-header">
                <h5>Felder</h5>
                <input type="text" x-model="fieldSearch" class="bbf-input bbf-input-sm" placeholder="Feld suchen...">
            </div>
            <div class="bbf-palette-content">
                <div class="bbf-palette-section">
                    <div class="bbf-palette-section-title">Standard</div>
                    <div class="bbf-palette-fields">
                        <template x-for="field in standardFields" :key="field.type">
                            <div class="bbf-palette-field" draggable="true"
                                 @dragstart="onDragStart($event, field)"
                                 :data-type="field.type">
                                <span class="bbf-palette-field-icon" x-html="field.icon"></span>
                                <span class="bbf-palette-field-label" x-text="field.label"></span>
                            </div>
                        </template>
                    </div>
                </div>
                <div class="bbf-palette-section">
                    <div class="bbf-palette-section-title">Erweitert</div>
                    <div class="bbf-palette-fields">
                        <template x-for="field in advancedFields" :key="field.type">
                            <div class="bbf-palette-field" draggable="true"
                                 @dragstart="onDragStart($event, field)"
                                 :data-type="field.type">
                                <span class="bbf-palette-field-icon" x-html="field.icon"></span>
                                <span class="bbf-palette-field-label" x-text="field.label"></span>
                            </div>
                        </template>
                    </div>
                </div>
                <div class="bbf-palette-section">
                    <div class="bbf-palette-section-title">Layout</div>
                    <div class="bbf-palette-fields">
                        <template x-for="field in layoutFields" :key="field.type">
                            <div class="bbf-palette-field" draggable="true"
                                 @dragstart="onDragStart($event, field)"
                                 :data-type="field.type">
                                <span class="bbf-palette-field-icon" x-html="field.icon"></span>
                                <span class="bbf-palette-field-label" x-text="field.label"></span>
                            </div>
                        </template>
                    </div>
                </div>
            </div>
        </div>

        {* Center: Drop Zone *}
        <div class="bbf-builder-canvas" id="bbf-builder-canvas">
            <div class="bbf-canvas-inner"
                 id="bbf-drop-zone"
                 @dragover.prevent="onDragOver($event)"
                 @drop.prevent="onDrop($event)">

                <template x-if="formFields.length === 0">
                    <div class="bbf-canvas-empty">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="48" height="48" style="opacity: 0.3;">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <p>Felder hierher ziehen oder aus der Palette klicken</p>
                    </div>
                </template>

                <template x-for="(field, index) in formFields" :key="field.id">
                    <div class="bbf-canvas-field"
                         :class="{ 'is-selected': selectedFieldId === field.id }"
                         :data-field-id="field.id"
                         @click="selectField(field.id)"
                         draggable="true"
                         @dragstart="onFieldDragStart($event, index)">
                        <div class="bbf-canvas-field-header">
                            <span class="bbf-canvas-field-drag-handle">
                                <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14"><circle cx="9" cy="6" r="1.5"></circle><circle cx="15" cy="6" r="1.5"></circle><circle cx="9" cy="12" r="1.5"></circle><circle cx="15" cy="12" r="1.5"></circle><circle cx="9" cy="18" r="1.5"></circle><circle cx="15" cy="18" r="1.5"></circle></svg>
                            </span>
                            <span class="bbf-canvas-field-type" x-text="field.type"></span>
                            <span class="bbf-canvas-field-label" x-text="field.label"></span>
                            <div class="bbf-canvas-field-actions">
                                <button type="button" class="bbf-btn-icon-sm" @click.stop="duplicateField(index)" title="Duplizieren">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
                                </button>
                                <button type="button" class="bbf-btn-icon-sm bbf-btn-danger" @click.stop="removeField(index)" title="Entfernen">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                </button>
                            </div>
                        </div>
                        <div class="bbf-canvas-field-preview" x-html="renderFieldPreview(field)"></div>
                    </div>
                </template>
            </div>
        </div>

        {* Right: Field Settings *}
        <div class="bbf-builder-settings" id="bbf-field-settings">
            <template x-if="selectedFieldId">
                <div class="bbf-settings-panel">
                    <div class="bbf-settings-header">
                        <h5>Feld-Einstellungen</h5>
                        <button type="button" class="bbf-btn-icon-sm" @click="selectedFieldId = null" title="Schließen">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                        </button>
                    </div>
                    <div class="bbf-settings-body">
                        {* Tabs *}
                        <div class="bbf-settings-tabs">
                            <button type="button" class="bbf-settings-tab" :class="{ active: settingsTab === 'general' }" @click="settingsTab = 'general'">Allgemein</button>
                            <button type="button" class="bbf-settings-tab" :class="{ active: settingsTab === 'validation' }" @click="settingsTab = 'validation'">Validierung</button>
                            <button type="button" class="bbf-settings-tab" :class="{ active: settingsTab === 'logic' }" @click="settingsTab = 'logic'">Logik</button>
                        </div>

                        {* General Tab *}
                        <div x-show="settingsTab === 'general'" class="bbf-settings-tab-content">
                            <div class="bbf-form-group">
                                <label class="bbf-label">Bezeichnung</label>
                                <input type="text" class="bbf-input" x-model="selectedField.label" @input="markDirty()">
                            </div>
                            <div class="bbf-form-group">
                                <label class="bbf-label">Name / ID</label>
                                <input type="text" class="bbf-input" x-model="selectedField.name" @input="markDirty()">
                            </div>
                            <div class="bbf-form-group">
                                <label class="bbf-label">Platzhalter</label>
                                <input type="text" class="bbf-input" x-model="selectedField.placeholder" @input="markDirty()">
                            </div>
                            <div class="bbf-form-group">
                                <label class="bbf-label">Standardwert</label>
                                <input type="text" class="bbf-input" x-model="selectedField.default_value" @input="markDirty()">
                            </div>
                            <div class="bbf-form-group">
                                <label class="bbf-label">CSS-Klassen</label>
                                <input type="text" class="bbf-input" x-model="selectedField.css_class" @input="markDirty()">
                            </div>
                            <div class="bbf-form-group">
                                <label class="bbf-toggle-label">
                                    <input type="checkbox" x-model="selectedField.required" @change="markDirty()">
                                    <span>Pflichtfeld</span>
                                </label>
                            </div>
                        </div>

                        {* Validation Tab *}
                        <div x-show="settingsTab === 'validation'" class="bbf-settings-tab-content">
                            <div class="bbf-form-group">
                                <label class="bbf-label">Min. Länge</label>
                                <input type="number" class="bbf-input" x-model="selectedField.min_length" @input="markDirty()">
                            </div>
                            <div class="bbf-form-group">
                                <label class="bbf-label">Max. Länge</label>
                                <input type="number" class="bbf-input" x-model="selectedField.max_length" @input="markDirty()">
                            </div>
                            <div class="bbf-form-group">
                                <label class="bbf-label">Pattern (Regex)</label>
                                <input type="text" class="bbf-input" x-model="selectedField.pattern" @input="markDirty()">
                            </div>
                            <div class="bbf-form-group">
                                <label class="bbf-label">Fehlermeldung</label>
                                <input type="text" class="bbf-input" x-model="selectedField.error_message" @input="markDirty()">
                            </div>
                        </div>

                        {* Conditional Logic Tab *}
                        <div x-show="settingsTab === 'logic'" class="bbf-settings-tab-content">
                            <div id="bbf-conditional-logic-editor"></div>
                        </div>
                    </div>
                </div>
            </template>
            <template x-if="!selectedFieldId">
                <div class="bbf-settings-empty">
                    <p>Wähle ein Feld aus, um die Einstellungen zu bearbeiten.</p>
                </div>
            </template>
        </div>
    </div>
</div>

<script src="{$adminUrl}js/vendor/alpine.min.js" defer></script>
<script src="{$adminUrl}js/vendor/sortable.min.js"></script>
<script src="{$adminUrl}js/form-builder.js"></script>
<script src="{$adminUrl}js/conditional-logic-editor.js"></script>
