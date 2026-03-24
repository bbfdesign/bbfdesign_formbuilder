{* CSS-Editor *}

<form id="bbf-css-settings" action="savePluginSetting">

    <div style="background:#fff;border-radius:8px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <h4 style="font-weight:700;margin:0 0 4px;">Benutzerdefiniertes CSS</h4>
        <p style="font-size:13px;color:var(--bbf-text-light);margin:0 0 20px;">Eigene CSS-Regeln um das Aussehen der Formulare anzupassen.</p>

        <textarea class="custom-code-editor" id="bbf-custom-css" name="custom_css" spellcheck="false" style="width:100%;min-height:450px;font-size:14px;">{$customCss|default:''}</textarea>

        <div style="margin:16px 0;padding:12px 16px;background:#eef6fc;border:1px solid #b8d8f0;border-radius:6px;color:#1a3a5c;font-size:13px;">
            <strong>Tipp:</strong> Verwende <code>.bbf-form</code> als Prefix.
            Beispiel: <code>.bbf-form .bbf-input {literal}{ border-color: #333; }{/literal}</code>
        </div>

        <button type="button" class="bbf-btn-primary" style="padding:10px 24px;border-radius:8px;border:none;font-size:14px;cursor:pointer;" onclick="saveSetting('bbf-css-settings', 'css-editor');">
            CSS speichern
        </button>
    </div>

</form>
