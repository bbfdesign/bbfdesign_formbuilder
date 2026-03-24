{* Spam-Schutz Einstellungen *}

<form id="bbf-spam-settings" action="savePluginSetting">

    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Spam-Schutz</h4>
        </div>
        <div class="bbf-card-body">

            {* Honeypot *}
            <div class="bbf-form-group">
                <label class="bbf-label">Honeypot-Feld</label>
                <div class="bbf-toggle-switch">
                    <label class="switch">
                        <input type="checkbox" name="honeypot_enabled" value="1" {if $settings.honeypot_enabled == '1'}checked{/if}>
                        <span class="slider"></span>
                    </label>
                    <span class="bbf-toggle-text">Honeypot aktiviert</span>
                </div>
                <small class="bbf-help-text">F&uuml;gt ein unsichtbares Feld hinzu, das von Bots ausgef&uuml;llt wird. Keine Beeintr&auml;chtigung f&uuml;r echte Nutzer.</small>
            </div>

            <hr class="bbf-divider">

            {* Timing Protection *}
            <div class="bbf-form-group">
                <label class="bbf-label">Timing-Schutz</label>
                <div class="bbf-toggle-switch">
                    <label class="switch">
                        <input type="checkbox" name="timing_enabled" value="1" {if $settings.timing_enabled == '1'}checked{/if} onchange="document.getElementById('timing-settings').style.display = this.checked ? 'block' : 'none';">
                        <span class="slider"></span>
                    </label>
                    <span class="bbf-toggle-text">Zeitschutz aktiviert</span>
                </div>
                <small class="bbf-help-text">Formulare m&uuml;ssen mindestens eine bestimmte Zeit lang ausgef&uuml;llt werden.</small>
            </div>
            <div id="timing-settings" style="display: {if $settings.timing_enabled == '1'}block{else}none{/if}; margin-left: 20px;">
                <div class="bbf-form-group">
                    <label class="bbf-label" for="timing_min_seconds">Mindestzeit (Sekunden)</label>
                    <input type="number" class="bbf-input" id="timing_min_seconds" name="timing_min_seconds" value="{$settings.timing_min_seconds|default:3}" min="1" max="60" style="max-width: 120px;">
                </div>
            </div>

            <hr class="bbf-divider">

            {* Rate Limiting *}
            <div class="bbf-form-group">
                <label class="bbf-label">Rate Limiting</label>
                <div class="bbf-toggle-switch">
                    <label class="switch">
                        <input type="checkbox" name="rate_limit_enabled" value="1" {if $settings.rate_limit_enabled == '1'}checked{/if} onchange="document.getElementById('rate-limit-settings').style.display = this.checked ? 'block' : 'none';">
                        <span class="slider"></span>
                    </label>
                    <span class="bbf-toggle-text">Rate Limiting aktiviert</span>
                </div>
                <small class="bbf-help-text">Begrenzt die Anzahl der Einsendungen pro IP-Adresse in einem Zeitfenster.</small>
            </div>
            <div id="rate-limit-settings" style="display: {if $settings.rate_limit_enabled == '1'}block{else}none{/if}; margin-left: 20px;">
                <div class="bbf-form-row">
                    <div class="bbf-form-group" style="flex: 1;">
                        <label class="bbf-label" for="rate_limit_max">Max. Einsendungen</label>
                        <input type="number" class="bbf-input" id="rate_limit_max" name="rate_limit_max" value="{$settings.rate_limit_max|default:5}" min="1" max="100" style="max-width: 120px;">
                    </div>
                    <div class="bbf-form-group" style="flex: 1;">
                        <label class="bbf-label" for="rate_limit_window">Zeitfenster (Minuten)</label>
                        <input type="number" class="bbf-input" id="rate_limit_window" name="rate_limit_window" value="{$settings.rate_limit_window|default:60}" min="1" max="1440" style="max-width: 120px;">
                    </div>
                </div>
            </div>

        </div>
    </div>

    {* CAPTCHA Settings *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">CAPTCHA</h4>
        </div>
        <div class="bbf-card-body">

            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_provider">CAPTCHA-Anbieter</label>
                <select class="bbf-select" id="captcha_provider" name="captcha_provider" onchange="bbfUpdateCaptchaFields(this.value);">
                    <option value="none" {if ($settings.captcha_provider|default:'none') == 'none'}selected{/if}>Kein CAPTCHA</option>
                    <option value="altcha" {if ($settings.captcha_provider|default:'none') == 'altcha'}selected{/if}>ALTCHA (datenschutzfreundlich)</option>
                    <option value="recaptcha_v2" {if ($settings.captcha_provider|default:'none') == 'recaptcha_v2'}selected{/if}>Google reCAPTCHA v2</option>
                    <option value="recaptcha_v3" {if ($settings.captcha_provider|default:'none') == 'recaptcha_v3'}selected{/if}>Google reCAPTCHA v3</option>
                    <option value="turnstile" {if ($settings.captcha_provider|default:'none') == 'turnstile'}selected{/if}>Cloudflare Turnstile</option>
                    <option value="friendly_captcha" {if ($settings.captcha_provider|default:'none') == 'friendly_captcha'}selected{/if}>Friendly Captcha</option>
                </select>
            </div>

            {* ALTCHA Info *}
            <div class="bbf-captcha-settings" id="captcha-settings-altcha" style="display: {if ($settings.captcha_provider|default:'none') == 'altcha'}block{else}none{/if};">
                <div class="bbf-alert bbf-alert-info" style="margin-bottom: 16px;">
                    ALTCHA ist ein datenschutzfreundliches, selbst-gehostetes CAPTCHA. Es ben&ouml;tigt keine API-Schl&uuml;ssel und verwendet ein Proof-of-Work-Verfahren direkt auf dem Server.
                </div>
            </div>

            {* reCAPTCHA v2 Settings *}
            <div class="bbf-captcha-settings" id="captcha-settings-recaptcha_v2" style="display: {if ($settings.captcha_provider|default:'none') == 'recaptcha_v2'}block{else}none{/if};">
                <div class="bbf-form-group">
                    <label class="bbf-label" for="recaptcha_site_key_v2">Site Key</label>
                    <input type="text" class="bbf-input" id="recaptcha_site_key_v2" name="recaptcha_site_key" value="{$settings.recaptcha_site_key|default:''}">
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-label" for="recaptcha_secret_key_v2">Secret Key</label>
                    <input type="password" class="bbf-input" id="recaptcha_secret_key_v2" name="recaptcha_secret_key" value="{$settings.recaptcha_secret_key|default:''}">
                </div>
            </div>

            {* reCAPTCHA v3 Settings *}
            <div class="bbf-captcha-settings" id="captcha-settings-recaptcha_v3" style="display: {if ($settings.captcha_provider|default:'none') == 'recaptcha_v3'}block{else}none{/if};">
                <div class="bbf-form-group">
                    <label class="bbf-label" for="recaptcha_site_key_v3">Site Key</label>
                    <input type="text" class="bbf-input" id="recaptcha_site_key_v3" name="recaptcha_site_key" value="{$settings.recaptcha_site_key|default:''}">
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-label" for="recaptcha_secret_key_v3">Secret Key</label>
                    <input type="password" class="bbf-input" id="recaptcha_secret_key_v3" name="recaptcha_secret_key" value="{$settings.recaptcha_secret_key|default:''}">
                </div>
            </div>

            {* Turnstile Settings *}
            <div class="bbf-captcha-settings" id="captcha-settings-turnstile" style="display: {if ($settings.captcha_provider|default:'none') == 'turnstile'}block{else}none{/if};">
                <div class="bbf-form-group">
                    <label class="bbf-label" for="turnstile_site_key">Site Key</label>
                    <input type="text" class="bbf-input" id="turnstile_site_key" name="turnstile_site_key" value="{$settings.turnstile_site_key|default:''}">
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-label" for="turnstile_secret_key">Secret Key</label>
                    <input type="password" class="bbf-input" id="turnstile_secret_key" name="turnstile_secret_key" value="{$settings.turnstile_secret_key|default:''}">
                </div>
            </div>

            {* Friendly Captcha Settings *}
            <div class="bbf-captcha-settings" id="captcha-settings-friendly_captcha" style="display: {if ($settings.captcha_provider|default:'none') == 'friendly_captcha'}block{else}none{/if};">
                <div class="bbf-form-group">
                    <label class="bbf-label" for="friendly_captcha_site_key">Site Key</label>
                    <input type="text" class="bbf-input" id="friendly_captcha_site_key" name="friendly_captcha_site_key" value="{$settings.friendly_captcha_site_key|default:''}">
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-label" for="friendly_captcha_secret">API Secret</label>
                    <input type="password" class="bbf-input" id="friendly_captcha_secret" name="friendly_captcha_secret" value="{$settings.friendly_captcha_secret|default:''}">
                </div>
            </div>

        </div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="saveSetting('bbf-spam-settings', 'spam-protection');">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
            <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
            <polyline points="17 21 17 13 7 13 7 21"></polyline>
            <polyline points="7 3 7 8 15 8"></polyline>
        </svg>
        Einstellungen speichern
    </button>

</form>

<script>
function bbfUpdateCaptchaFields(provider) {
    document.querySelectorAll('.bbf-captcha-settings').forEach(function(el) {
        el.style.display = 'none';
    });
    if (provider !== 'none') {
        var el = document.getElementById('captcha-settings-' + provider);
        if (el) el.style.display = 'block';
    }
}
</script>
