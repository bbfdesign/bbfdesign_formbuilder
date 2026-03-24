{* Spam-Schutz Einstellungen *}

<div class="bbf-card" style="margin-bottom: 24px;">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Spam-Schutz</h4>
    </div>
    <div class="bbf-card-body">

        {* Honeypot *}
        <div class="bbf-form-group">
            <label class="bbf-label">Honeypot-Feld</label>
            <div class="bbf-toggle-switch">
                <label class="bbf-switch">
                    <input type="checkbox" id="spam_honeypot_enabled" {if $spamSettings.honeypot_enabled|default:true}checked{/if} onchange="bbfSaveSetting('honeypot_enabled', this.checked);">
                    <span class="bbf-switch-slider"></span>
                </label>
                <span class="bbf-toggle-text">Honeypot aktiviert</span>
            </div>
            <small class="bbf-help-text">Fügt ein unsichtbares Feld hinzu, das von Bots ausgefüllt wird. Keine Beeinträchtigung für echte Nutzer.</small>
        </div>

        <hr class="bbf-divider">

        {* Timing Protection *}
        <div class="bbf-form-group">
            <label class="bbf-label">Zeitbasierter Schutz</label>
            <div class="bbf-toggle-switch">
                <label class="bbf-switch">
                    <input type="checkbox" id="spam_timing_enabled" {if $spamSettings.timing_enabled|default:true}checked{/if} onchange="bbfSaveSetting('timing_enabled', this.checked); document.getElementById('timing-settings').style.display = this.checked ? 'block' : 'none';">
                    <span class="bbf-switch-slider"></span>
                </label>
                <span class="bbf-toggle-text">Zeitschutz aktiviert</span>
            </div>
            <small class="bbf-help-text">Formulare müssen mindestens eine bestimmte Zeit lang ausgefüllt werden.</small>
        </div>
        <div id="timing-settings" style="display: {if $spamSettings.timing_enabled|default:true}block{else}none{/if}; margin-left: 20px;">
            <div class="bbf-form-group">
                <label class="bbf-label" for="spam_timing_min_seconds">Mindestzeit (Sekunden)</label>
                <input type="number" class="bbf-input" id="spam_timing_min_seconds" value="{$spamSettings.timing_min_seconds|default:3}" min="1" max="60" style="max-width: 120px;" onchange="bbfSaveSetting('timing_min_seconds', this.value);">
            </div>
        </div>

        <hr class="bbf-divider">

        {* Rate Limiting *}
        <div class="bbf-form-group">
            <label class="bbf-label">Rate Limiting</label>
            <div class="bbf-toggle-switch">
                <label class="bbf-switch">
                    <input type="checkbox" id="spam_rate_limit_enabled" {if $spamSettings.rate_limit_enabled|default:true}checked{/if} onchange="bbfSaveSetting('rate_limit_enabled', this.checked); document.getElementById('rate-limit-settings').style.display = this.checked ? 'block' : 'none';">
                    <span class="bbf-switch-slider"></span>
                </label>
                <span class="bbf-toggle-text">Rate Limiting aktiviert</span>
            </div>
            <small class="bbf-help-text">Begrenzt die Anzahl der Einsendungen pro IP-Adresse in einem Zeitfenster.</small>
        </div>
        <div id="rate-limit-settings" style="display: {if $spamSettings.rate_limit_enabled|default:true}block{else}none{/if}; margin-left: 20px;">
            <div class="bbf-form-row">
                <div class="bbf-form-group" style="flex: 1;">
                    <label class="bbf-label" for="spam_rate_limit_max">Max. Einsendungen</label>
                    <input type="number" class="bbf-input" id="spam_rate_limit_max" value="{$spamSettings.rate_limit_max|default:5}" min="1" max="100" style="max-width: 120px;" onchange="bbfSaveSetting('rate_limit_max', this.value);">
                </div>
                <div class="bbf-form-group" style="flex: 1;">
                    <label class="bbf-label" for="spam_rate_limit_window">Zeitfenster (Minuten)</label>
                    <input type="number" class="bbf-input" id="spam_rate_limit_window" value="{$spamSettings.rate_limit_window|default:60}" min="1" max="1440" style="max-width: 120px;" onchange="bbfSaveSetting('rate_limit_window', this.value);">
                </div>
            </div>
        </div>

    </div>
</div>

{* CAPTCHA Settings *}
<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">CAPTCHA</h4>
    </div>
    <div class="bbf-card-body">

        <div class="bbf-form-group">
            <label class="bbf-label" for="spam_captcha_provider">CAPTCHA-Anbieter</label>
            <select class="bbf-select" id="spam_captcha_provider" onchange="bbfSaveSetting('captcha_provider', this.value); bbfUpdateCaptchaFields(this.value);">
                <option value="none" {if ($spamSettings.captcha_provider|default:'none') == 'none'}selected{/if}>Kein CAPTCHA</option>
                <option value="altcha" {if ($spamSettings.captcha_provider|default:'none') == 'altcha'}selected{/if}>ALTCHA (datenschutzfreundlich)</option>
                <option value="recaptcha_v2" {if ($spamSettings.captcha_provider|default:'none') == 'recaptcha_v2'}selected{/if}>Google reCAPTCHA v2</option>
                <option value="recaptcha_v3" {if ($spamSettings.captcha_provider|default:'none') == 'recaptcha_v3'}selected{/if}>Google reCAPTCHA v3</option>
                <option value="turnstile" {if ($spamSettings.captcha_provider|default:'none') == 'turnstile'}selected{/if}>Cloudflare Turnstile</option>
                <option value="friendly_captcha" {if ($spamSettings.captcha_provider|default:'none') == 'friendly_captcha'}selected{/if}>Friendly Captcha</option>
            </select>
        </div>

        {* ALTCHA Settings *}
        <div class="bbf-captcha-settings" id="captcha-settings-altcha" style="display: {if ($spamSettings.captcha_provider|default:'none') == 'altcha'}block{else}none{/if};">
            <div class="bbf-alert bbf-alert-info" style="margin-bottom: 16px;">
                ALTCHA ist ein datenschutzfreundliches CAPTCHA ohne Drittanbieter-Cookies. Es verwendet ein Proof-of-Work-Verfahren.
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_altcha_api_key">ALTCHA API Key</label>
                <input type="text" class="bbf-input" id="captcha_altcha_api_key" value="{$spamSettings.altcha_api_key|default:''}" onchange="bbfSaveSetting('altcha_api_key', this.value);">
            </div>
        </div>

        {* reCAPTCHA v2 Settings *}
        <div class="bbf-captcha-settings" id="captcha-settings-recaptcha_v2" style="display: {if ($spamSettings.captcha_provider|default:'none') == 'recaptcha_v2'}block{else}none{/if};">
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_recaptcha_v2_site_key">Site Key</label>
                <input type="text" class="bbf-input" id="captcha_recaptcha_v2_site_key" value="{$spamSettings.recaptcha_v2_site_key|default:''}" onchange="bbfSaveSetting('recaptcha_v2_site_key', this.value);">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_recaptcha_v2_secret_key">Secret Key</label>
                <input type="password" class="bbf-input" id="captcha_recaptcha_v2_secret_key" value="{$spamSettings.recaptcha_v2_secret_key|default:''}" onchange="bbfSaveSetting('recaptcha_v2_secret_key', this.value);">
            </div>
        </div>

        {* reCAPTCHA v3 Settings *}
        <div class="bbf-captcha-settings" id="captcha-settings-recaptcha_v3" style="display: {if ($spamSettings.captcha_provider|default:'none') == 'recaptcha_v3'}block{else}none{/if};">
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_recaptcha_v3_site_key">Site Key</label>
                <input type="text" class="bbf-input" id="captcha_recaptcha_v3_site_key" value="{$spamSettings.recaptcha_v3_site_key|default:''}" onchange="bbfSaveSetting('recaptcha_v3_site_key', this.value);">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_recaptcha_v3_secret_key">Secret Key</label>
                <input type="password" class="bbf-input" id="captcha_recaptcha_v3_secret_key" value="{$spamSettings.recaptcha_v3_secret_key|default:''}" onchange="bbfSaveSetting('recaptcha_v3_secret_key', this.value);">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_recaptcha_v3_threshold">Score-Schwellenwert</label>
                <input type="number" class="bbf-input" id="captcha_recaptcha_v3_threshold" value="{$spamSettings.recaptcha_v3_threshold|default:'0.5'}" min="0" max="1" step="0.1" style="max-width: 120px;" onchange="bbfSaveSetting('recaptcha_v3_threshold', this.value);">
                <small class="bbf-help-text">Werte von 0.0 (wahrscheinlich Bot) bis 1.0 (wahrscheinlich Mensch). Standard: 0.5</small>
            </div>
        </div>

        {* Turnstile Settings *}
        <div class="bbf-captcha-settings" id="captcha-settings-turnstile" style="display: {if ($spamSettings.captcha_provider|default:'none') == 'turnstile'}block{else}none{/if};">
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_turnstile_site_key">Site Key</label>
                <input type="text" class="bbf-input" id="captcha_turnstile_site_key" value="{$spamSettings.turnstile_site_key|default:''}" onchange="bbfSaveSetting('turnstile_site_key', this.value);">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_turnstile_secret_key">Secret Key</label>
                <input type="password" class="bbf-input" id="captcha_turnstile_secret_key" value="{$spamSettings.turnstile_secret_key|default:''}" onchange="bbfSaveSetting('turnstile_secret_key', this.value);">
            </div>
        </div>

        {* Friendly Captcha Settings *}
        <div class="bbf-captcha-settings" id="captcha-settings-friendly_captcha" style="display: {if ($spamSettings.captcha_provider|default:'none') == 'friendly_captcha'}block{else}none{/if};">
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_friendly_site_key">Site Key</label>
                <input type="text" class="bbf-input" id="captcha_friendly_site_key" value="{$spamSettings.friendly_captcha_site_key|default:''}" onchange="bbfSaveSetting('friendly_captcha_site_key', this.value);">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-label" for="captcha_friendly_secret_key">API Key</label>
                <input type="password" class="bbf-input" id="captcha_friendly_secret_key" value="{$spamSettings.friendly_captcha_secret_key|default:''}" onchange="bbfSaveSetting('friendly_captcha_secret_key', this.value);">
            </div>
        </div>

    </div>
</div>

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
