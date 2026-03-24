{* CSS-Editor *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Benutzerdefiniertes CSS</h4>
        <p class="bbf-card-subtitle">Eigene CSS-Regeln hinzufügen, um das Aussehen der Formulare anzupassen.</p>
    </div>
    <div class="bbf-card-body">
        <div class="bbf-form-group">
            <textarea class="bbf-textarea custom-code-editor" id="bbf-custom-css" rows="25" spellcheck="false">{$customCSS|default:''}</textarea>
        </div>

        <div class="bbf-alert bbf-alert-info" style="margin-bottom: 16px;">
            <strong>Tipp:</strong> Verwende die Klasse <code>.bbf-form</code> als Präfix für deine CSS-Regeln, um nur Formulare dieses Plugins zu stylen.<br>
            Beispiel: <code>.bbf-form .bbf-field-input {literal}{ border-color: #333; }{/literal}</code>
        </div>

        <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveCustomCSS();">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
                <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                <polyline points="17 21 17 13 7 13 7 21"></polyline>
                <polyline points="7 3 7 8 15 8"></polyline>
            </svg>
            CSS speichern
        </button>
    </div>
</div>
