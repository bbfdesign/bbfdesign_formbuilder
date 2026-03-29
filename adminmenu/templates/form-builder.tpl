{* GrapesJS Form Builder *}

<style>
/* ── GrapesJS Light Theme — überschreibt das Standard-Dark-Theme ── */
:root {ldelim}
    --gjs-primary-color: #ffffff !important;
    --gjs-secondary-color: #f3f4f6 !important;
    --gjs-tertiary-color: #f9fafb !important;
    --gjs-quaternary-color: #e5e7eb !important;
    --gjs-font-color: #374151 !important;
    --gjs-font-color-active: #111827 !important;
    --gjs-main-color: #ffffff !important;
    --gjs-main-dark-color: rgba(0,0,0,0.04) !important;
    --gjs-secondary-dark-color: rgba(0,0,0,0.02) !important;
    --gjs-main-light-color: rgba(0,0,0,0.03) !important;
    --gjs-secondary-light-color: rgba(0,0,0,0.05) !important;
    --gjs-soft-light-color: rgba(0,0,0,0.01) !important;
    --gjs-color-highlight: #e8420a !important;
{rdelim}
.gjs-one-bg {ldelim} background-color: #ffffff !important; color: #374151 !important; {rdelim}
.gjs-two-color {ldelim} color: #374151 !important; {rdelim}
.gjs-three-bg {ldelim} background-color: #f9fafb !important; {rdelim}
.gjs-four-color, .gjs-four-color-h:hover {ldelim} color: #e8420a !important; {rdelim}
.gjs-pn-panel, .gjs-block-categories, .gjs-blocks-c, .gjs-sm-sectors, .gjs-trt-traits, .gjs-layer-manager, .gjs-editor {ldelim} background: #fff !important; {rdelim}

/* Kategorietitel */
.gjs-block-category > .gjs-title {ldelim} background: #f8f9fa !important; color: #6b7280 !important; font-size: 10px !important; font-weight: 700 !important; letter-spacing: .07em !important; text-transform: uppercase !important; padding: 8px 10px 5px !important; border-top: 1px solid #f0f0f0 !important; border-bottom: none !important; {rdelim}
.gjs-block-category:first-child > .gjs-title {ldelim} border-top: none !important; {rdelim}

.bbf-builder-wrap {ldelim} display:flex; flex-direction:column; height:calc(100vh - 160px); min-height:600px; background:#fff; border-radius:8px; overflow:hidden; box-shadow:0 1px 3px rgba(0,0,0,0.08); {rdelim}
.bbf-builder-toolbar {ldelim} display:flex; align-items:center; gap:8px; padding:8px 16px; background:#f8f9fa; border-bottom:1px solid #dee2e6; flex-shrink:0; flex-wrap:wrap; {rdelim}
.bbf-builder-toolbar-left {ldelim} display:flex; align-items:center; gap:8px; {rdelim}
.bbf-builder-toolbar-center {ldelim} display:flex; align-items:center; gap:4px; {rdelim}
.bbf-builder-toolbar-right {ldelim} display:flex; align-items:center; gap:8px; margin-left:auto; {rdelim}
.bbf-builder-title {ldelim} border:none; background:transparent; font-size:15px; font-weight:600; padding:6px 8px; border-bottom:2px solid transparent; outline:none; min-width:200px; {rdelim}
.bbf-builder-title:focus {ldelim} border-bottom-color:var(--bbf-primary); {rdelim}
.bbf-tb {ldelim} background:none; border:1px solid #dee2e6; border-radius:4px; padding:6px 10px; cursor:pointer; color:#495057; font-size:13px; display:inline-flex; align-items:center; gap:4px; transition:all 0.15s; {rdelim}
.bbf-tb:hover {ldelim} background:#e9ecef; {rdelim}
.bbf-tb.active {ldelim} background:var(--bbf-primary); color:#fff; border-color:var(--bbf-primary); {rdelim}
.bbf-builder-main {ldelim} display:flex; flex:1; min-height:0; {rdelim}
.bbf-builder-sidebar {ldelim} width:270px; flex-shrink:0; border-right:1px solid #e9ecef; overflow-y:auto; background:#fff; height:100%; {rdelim}
.bbf-builder-canvas {ldelim} flex:1; position:relative; height:100%; overflow:hidden; {rdelim}
.bbf-sidebar-tabs {ldelim} display:flex; border-bottom:1.5px solid #e9ecef; position:sticky; top:0; background:#fff; z-index:10; padding:0 4px; {rdelim}
.bbf-sidebar-tab {ldelim} flex:1; padding:10px 4px; text-align:center; font-size:11px; font-weight:700; border:none; background:none; cursor:pointer; color:#9ca3af; border-bottom:2px solid transparent; margin-bottom:-1.5px; letter-spacing:.03em; text-transform:uppercase; transition:color .15s; {rdelim}
.bbf-sidebar-tab:hover {ldelim} color:#374151; {rdelim}
.bbf-sidebar-tab.active {ldelim} color:var(--bbf-primary, #e8420a); border-bottom-color:var(--bbf-primary, #e8420a); {rdelim}
.bbf-sidebar-panel {ldelim} display:block !important; visibility:hidden; height:0; overflow:hidden; pointer-events:none; {rdelim}
.bbf-sidebar-panel.active {ldelim} visibility:visible; height:auto; overflow:visible; pointer-events:auto; {rdelim}

/* GrapesJS Canvas — height chain must be unbroken */
#bbf-gjs-editor {ldelim} height:100% !important; {rdelim}
#bbf-gjs-editor .gjs-editor {ldelim} height:100% !important; position:relative !important; {rdelim}
#bbf-gjs-editor .gjs-cv-canvas {ldelim} width:100% !important; height:100% !important; top:0 !important; left:0 !important; {rdelim}
#bbf-gjs-editor .gjs-frame-wrapper {ldelim} height:100% !important; {rdelim}
.gjs-frame {ldelim} height:100% !important; width:100% !important; {rdelim}

/* Drag & Drop must not be blocked */
.gjs-cv-canvas {ldelim} pointer-events:all !important; z-index:1 !important; {rdelim}
.gjs-frame-wrapper {ldelim} pointer-events:all !important; {rdelim}
.gjs-drag-helper {ldelim} z-index:10000 !important; pointer-events:none !important; {rdelim}

/* Hide default GrapesJS panels (we use our own sidebar) */
.gjs-pn-panels {ldelim} display:none !important; {rdelim}
.gjs-pn-views-container {ldelim} display:none !important; {rdelim}

/* ── GrapesJS Canvas-Hintergrund ── */
.gjs-cv-canvas__frames {ldelim} background: #f3f4f6 !important; {rdelim}

/* ── Block-Kacheln: kompakt ── */
.gjs-blocks-c {ldelim} display:grid !important; grid-template-columns:1fr 1fr !important; gap:5px !important; padding:8px !important; background:#fff !important; {rdelim}
.gjs-block {ldelim} border:1.5px solid #e9ecef !important; border-radius:8px !important; padding:8px 4px !important; margin:0 !important; min-height:58px !important; max-height:58px !important; display:flex !important; flex-direction:column !important; align-items:center !important; justify-content:center !important; gap:4px !important; width:auto !important; background:#fff !important; cursor:grab !important; transition:all .12s ease !important; overflow:hidden !important; {rdelim}
.gjs-block:hover {ldelim} border-color:var(--bbf-primary, #e8420a) !important; background:#fff8f6 !important; box-shadow:0 2px 6px rgba(232,66,10,.12) !important; transform:translateY(-1px) !important; {rdelim}
.gjs-block .fa, .gjs-block [class*="fa-"] {ldelim} font-size:16px !important; color:#4b5563 !important; line-height:1 !important; display:block !important; {rdelim}
.gjs-block:hover .fa, .gjs-block:hover [class*="fa-"] {ldelim} color:var(--bbf-primary, #e8420a) !important; {rdelim}
.gjs-block-label {ldelim} font-size:10px !important; font-weight:600 !important; color:#4b5563 !important; text-align:center !important; line-height:1.2 !important; white-space:nowrap !important; overflow:hidden !important; text-overflow:ellipsis !important; max-width:90% !important; {rdelim}
.gjs-block:hover .gjs-block-label {ldelim} color:var(--bbf-primary, #e8420a) !important; {rdelim}

/* ── Style Manager ── */
.gjs-sm-sector .gjs-sm-sector-title {ldelim} background:#f9fafb !important; font-weight:600 !important; font-size:12px !important; padding:8px 12px !important; border-bottom:1px solid #f0f0f0 !important; color:#374151 !important; {rdelim}

/* ── Selektion ── */
.gjs-selected {ldelim} outline:2px solid #e8420a !important; outline-offset:2px !important; {rdelim}
.gjs-hovered {ldelim} outline:1px dashed #fca5a5 !important; outline-offset:2px !important; {rdelim}

/* ── Toolbar ── */
.gjs-toolbar {ldelim} background:#1f2937 !important; border-radius:6px !important; padding:2px !important; {rdelim}
.gjs-toolbar .gjs-toolbar-item {ldelim} color:#fff !important; width:28px !important; height:28px !important; font-size:13px !important; {rdelim}
.gjs-toolbar .gjs-toolbar-item:hover {ldelim} background:rgba(255,255,255,.15) !important; border-radius:4px !important; {rdelim}

/* ── Modal ── */
.gjs-mdl-dialog {ldelim} border-radius:12px !important; box-shadow:0 20px 60px rgba(0,0,0,.15) !important; {rdelim}
.gjs-mdl-header {ldelim} background:#fff !important; border-bottom:1px solid #f0f0f0 !important; padding:16px 20px !important; {rdelim}
.gjs-mdl-title {ldelim} font-size:15px !important; font-weight:700 !important; color:#1f2937 !important; {rdelim}

/* ── Traits Panel ── */
.gjs-trt-trait {ldelim} padding:8px 12px !important; border-bottom:1px solid #f9fafb !important; {rdelim}
.gjs-trt-trait__label {ldelim} font-size:12px !important; font-weight:600 !important; color:#6b7280 !important; margin-bottom:4px !important; {rdelim}
.gjs-trt-trait input, .gjs-trt-trait select {ldelim} border:1.5px solid #e5e7eb !important; border-radius:5px !important; padding:6px 8px !important; font-size:13px !important; width:100% !important; {rdelim}
.gjs-trt-trait input:focus, .gjs-trt-trait select:focus {ldelim} border-color:#e8420a !important; outline:none !important; {rdelim}
</style>

<div class="bbf-builder-wrap" id="bbf-builder-wrap">
    {* Toolbar *}
    <div class="bbf-builder-toolbar">
        <div class="bbf-builder-toolbar-left">
            <button type="button" class="bbf-tb" onclick="bbfNavigate('forms');">
                <i class="fa fa-arrow-left"></i> Zurück
            </button>
            <input type="text" id="bbf-form-title" class="bbf-builder-title"
                   placeholder="Formularname..."
                   value="{if isset($form) && $form}{$form->title|escape}{/if}">
        </div>
        <div class="bbf-builder-toolbar-center">
            <button type="button" class="bbf-tb" id="bbf-btn-undo" title="Rückgängig"><i class="fa fa-undo"></i></button>
            <button type="button" class="bbf-tb" id="bbf-btn-redo" title="Wiederholen"><i class="fa fa-redo"></i></button>
            <span style="width:1px;height:20px;background:#dee2e6;margin:0 4px;"></span>
            <button type="button" class="bbf-tb" id="bbf-btn-desktop" title="Desktop"><i class="fa fa-desktop"></i></button>
            <button type="button" class="bbf-tb" id="bbf-btn-tablet" title="Tablet"><i class="fa fa-tablet-alt"></i></button>
            <button type="button" class="bbf-tb" id="bbf-btn-mobile" title="Mobile"><i class="fa fa-mobile-alt"></i></button>
        </div>
        <div class="bbf-builder-toolbar-right">
            <button type="button" class="bbf-tb" id="bbf-btn-preview" title="Vorschau"><i class="fa fa-eye"></i></button>
            <button type="button" class="bbf-tb" id="bbf-btn-code" title="HTML anzeigen"><i class="fa fa-code"></i></button>
            <button type="button" class="bbf-btn-primary" id="bbf-btn-save"
                    style="padding:6px 18px;border-radius:6px;border:none;font-size:13px;cursor:pointer;display:inline-flex;align-items:center;gap:6px;">
                <i class="fa fa-save"></i> Speichern
            </button>
        </div>
    </div>

    {* Main: Sidebar + Canvas *}
    <div class="bbf-builder-main">
        <div class="bbf-builder-sidebar">
            <div class="bbf-sidebar-tabs">
                <button type="button" class="bbf-sidebar-tab active" onclick="bbfSwitchTab(this,'blocks')"><i class="fa fa-th-large"></i> Blöcke</button>
                <button type="button" class="bbf-sidebar-tab" onclick="bbfSwitchTab(this,'styles')"><i class="fa fa-paint-brush"></i> Styles</button>
                <button type="button" class="bbf-sidebar-tab" onclick="bbfSwitchTab(this,'traits')"><i class="fa fa-cog"></i> Optionen</button>
            </div>
            <div id="bbf-gjs-blocks" class="bbf-sidebar-panel active"></div>
            <div id="bbf-gjs-styles" class="bbf-sidebar-panel"></div>
            <div id="bbf-gjs-traits" class="bbf-sidebar-panel"></div>
        </div>
        <div class="bbf-builder-canvas">
            <div id="bbf-gjs-editor" style="height:100%;"></div>
        </div>
    </div>
</div>

<script>
{literal}
function bbfSwitchTab(btn, panel) {
    document.querySelectorAll('.bbf-sidebar-tab').forEach(function(t) { t.classList.remove('active'); });
    document.querySelectorAll('.bbf-sidebar-panel').forEach(function(p) { p.classList.remove('active'); });
    btn.classList.add('active');
    document.getElementById('bbf-gjs-' + panel).classList.add('active');

    // Traits-Panel: GrapesJS zwingen die Traits neu zu rendern
    if (panel === 'traits' && typeof BbfFormbuilder !== 'undefined' && BbfFormbuilder.editor) {
        var ed = BbfFormbuilder.editor;
        var selected = ed.getSelected();
        if (selected) {
            setTimeout(function() { ed.selectRemove(selected); ed.select(selected); }, 30);
        }
    }
}

// Init — runs after IIFE loaded by admin.js, with retry
(function() {
    var editorEl = document.getElementById('bbf-gjs-editor');
    if (!editorEl) return;

    var attempts = 0;
    function tryInit() {
        if (typeof BbfFormbuilder !== 'undefined') {
            doInit();
            return;
        }
        attempts++;
        if (attempts < 20) {
            // IIFE may still be loading — retry in 250ms
            setTimeout(tryInit, 250);
            return;
        }
        // After 5 seconds: show error
        editorEl.innerHTML =
            '<div style="padding:60px 20px;text-align:center;color:#6c757d;">' +
            '<i class="fa fa-exclamation-triangle fa-3x" style="margin-bottom:16px;display:block;opacity:0.3;"></i>' +
            '<p style="font-size:15px;font-weight:600;">Editor konnte nicht geladen werden</p>' +
            '<p style="font-size:13px;">Bitte laden Sie die Seite neu.</p>' +
            '<button onclick="location.reload()" style="padding:8px 20px;border-radius:6px;border:1px solid #ccc;background:#fff;cursor:pointer;margin-top:8px;">Seite neu laden</button></div>';
    }

    function doInit() {
{/literal}

    BbfFormbuilder.init({ldelim}
        container: '#bbf-gjs-editor',
        formId: {$formId|default:0},
        csrfToken: document.querySelector('[name="jtl_token"]') ? document.querySelector('[name="jtl_token"]').value : '',
        postURL: '{$postURL}',
        canvasStyles: {$canvasStyles|default:'[]'}
    {rdelim});

{literal}
    }

    tryInit();
})();
{/literal}
</script>
