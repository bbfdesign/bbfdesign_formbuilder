{* GrapesJS Form Builder *}

<style>
.bbf-builder-wrap {ldelim} display:flex; flex-direction:column; height:calc(100vh - 200px); min-height:500px; background:#fff; border-radius:8px; overflow:hidden; box-shadow:0 1px 3px rgba(0,0,0,0.08); {rdelim}
.bbf-builder-toolbar {ldelim} display:flex; align-items:center; gap:8px; padding:8px 16px; background:#f8f9fa; border-bottom:1px solid #dee2e6; flex-shrink:0; flex-wrap:wrap; {rdelim}
.bbf-builder-toolbar-left {ldelim} display:flex; align-items:center; gap:8px; {rdelim}
.bbf-builder-toolbar-center {ldelim} display:flex; align-items:center; gap:4px; {rdelim}
.bbf-builder-toolbar-right {ldelim} display:flex; align-items:center; gap:8px; margin-left:auto; {rdelim}
.bbf-builder-title {ldelim} border:none; background:transparent; font-size:15px; font-weight:600; padding:6px 8px; border-bottom:2px solid transparent; outline:none; min-width:200px; {rdelim}
.bbf-builder-title:focus {ldelim} border-bottom-color:var(--bbf-primary); {rdelim}
.bbf-tb {ldelim} background:none; border:1px solid #dee2e6; border-radius:4px; padding:6px 10px; cursor:pointer; color:#495057; font-size:13px; display:inline-flex; align-items:center; gap:4px; transition:all 0.15s; {rdelim}
.bbf-tb:hover {ldelim} background:#e9ecef; {rdelim}
.bbf-tb.active {ldelim} background:var(--bbf-primary); color:#fff; border-color:var(--bbf-primary); {rdelim}
.bbf-builder-main {ldelim} display:flex; flex:1; overflow:hidden; {rdelim}
.bbf-builder-sidebar {ldelim} width:280px; flex-shrink:0; border-right:1px solid #dee2e6; overflow-y:auto; background:#fff; {rdelim}
.bbf-builder-canvas {ldelim} flex:1; overflow:hidden; position:relative; {rdelim}
.bbf-sidebar-tabs {ldelim} display:flex; border-bottom:2px solid #dee2e6; position:sticky; top:0; background:#fff; z-index:1; {rdelim}
.bbf-sidebar-tab {ldelim} flex:1; padding:10px 8px; text-align:center; font-size:11px; font-weight:600; border:none; background:none; cursor:pointer; color:#6c757d; border-bottom:2px solid transparent; margin-bottom:-2px; {rdelim}
.bbf-sidebar-tab:hover {ldelim} color:#333; {rdelim}
.bbf-sidebar-tab.active {ldelim} color:var(--bbf-primary); border-bottom-color:var(--bbf-primary); {rdelim}
.bbf-sidebar-panel {ldelim} display:none; {rdelim}
.bbf-sidebar-panel.active {ldelim} display:block; {rdelim}
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
}

// Init immediately — this script runs AFTER the IIFE is loaded by admin.js
(function() {
    var editorEl = document.getElementById('bbf-gjs-editor');
    if (!editorEl) return;

    if (typeof BbfFormbuilder === 'undefined') {
        editorEl.innerHTML =
            '<div style="padding:60px 20px;text-align:center;color:#6c757d;">' +
            '<i class="fa fa-puzzle-piece fa-3x" style="margin-bottom:16px;display:block;opacity:0.3;"></i>' +
            '<p style="font-size:15px;font-weight:600;">GrapesJS Editor</p>' +
            '<p style="font-size:13px;">Das Build wurde noch nicht erstellt.<br>' +
            '<code style="background:#f1f3f5;padding:2px 6px;border-radius:3px;">npm install && npm run build</code></p></div>';
        return;
    }
{/literal}

    BbfFormbuilder.init({ldelim}
        container: '#bbf-gjs-editor',
        formId: {$formId|default:0},
        csrfToken: document.querySelector('[name="jtl_token"]') ? document.querySelector('[name="jtl_token"]').value : '',
        postURL: '{$postURL}',
        canvasStyles: ['{$ShopURL}/templates/NOVA/themes/base/bootstrap/bootstrap.min.css']
    {rdelim});

{literal}
})();
{/literal}
</script>
