{* Spam-Schutz Einstellungen *}

<form id="bbf-spam-settings" action="savePluginSetting">

    {* Interne Spam-Schutz-Methoden *}
    <div style="background:#fff;border-radius:8px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <h4 style="font-weight:700;margin:0 0 20px;">Spam-Schutz</h4>

        {* Honeypot *}
        <div style="margin-bottom:20px;">
            <div style="display:flex;align-items:center;gap:10px;margin-bottom:4px;">
                <label class="switch">
                    <input type="checkbox" name="honeypot_enabled" value="1" {if $settings.honeypot_enabled == '1'}checked{/if}>
                    <span class="slider"></span>
                </label>
                <span style="font-weight:500;">Honeypot-Feld</span>
            </div>
            <p style="font-size:12px;color:var(--bbf-text-light);margin:4px 0 0 54px;">Unsichtbares Feld das von Bots ausgefüllt wird. Keine Beeinträchtigung für echte Nutzer.</p>
        </div>

        <hr style="border:0;border-top:1px solid var(--bbf-border-light);margin:16px 0;">

        {* Timing *}
        <div style="margin-bottom:20px;">
            <div style="display:flex;align-items:center;gap:10px;margin-bottom:4px;">
                <label class="switch">
                    <input type="checkbox" name="timing_enabled" value="1" id="bbf-timing-toggle" {if $settings.timing_enabled == '1'}checked{/if}>
                    <span class="slider"></span>
                </label>
                <span style="font-weight:500;">Zeitschutz</span>
            </div>
            <p style="font-size:12px;color:var(--bbf-text-light);margin:4px 0 0 54px;">Formulare müssen mindestens eine bestimmte Zeit lang ausgefüllt werden.</p>
            <div id="bbf-timing-details" style="margin:12px 0 0 54px;{if $settings.timing_enabled != '1'}display:none;{/if}">
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Mindestzeit (Sekunden)</label>
                <input type="number" name="timing_min_seconds" value="{$settings.timing_min_seconds|default:3}" min="1" max="60" class="form-control" style="max-width:120px;">
            </div>
        </div>

        <hr style="border:0;border-top:1px solid var(--bbf-border-light);margin:16px 0;">

        {* Rate Limiting *}
        <div style="margin-bottom:8px;">
            <div style="display:flex;align-items:center;gap:10px;margin-bottom:4px;">
                <label class="switch">
                    <input type="checkbox" name="rate_limit_enabled" value="1" id="bbf-ratelimit-toggle" {if $settings.rate_limit_enabled == '1'}checked{/if}>
                    <span class="slider"></span>
                </label>
                <span style="font-weight:500;">Rate Limiting</span>
            </div>
            <p style="font-size:12px;color:var(--bbf-text-light);margin:4px 0 0 54px;">Begrenzt die Anzahl der Einsendungen pro IP-Adresse.</p>
            <div id="bbf-ratelimit-details" style="margin:12px 0 0 54px;{if $settings.rate_limit_enabled != '1'}display:none;{/if}">
                <div style="display:flex;gap:16px;">
                    <div>
                        <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Max. Einsendungen</label>
                        <input type="number" name="rate_limit_max" value="{$settings.rate_limit_max|default:10}" min="1" max="100" class="form-control" style="max-width:120px;">
                    </div>
                    <div>
                        <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Zeitfenster (Sekunden)</label>
                        <input type="number" name="rate_limit_window" value="{$settings.rate_limit_window|default:3600}" min="60" max="86400" class="form-control" style="max-width:120px;">
                    </div>
                </div>
            </div>
        </div>
    </div>

    {* CAPTCHA *}
    <div style="background:#fff;border-radius:8px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <h4 style="font-weight:700;margin:0 0 20px;">CAPTCHA</h4>

        <div style="margin-bottom:16px;">
            <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">CAPTCHA-Anbieter</label>
            <select name="captcha_provider" id="bbf-captcha-select" class="form-control" style="max-width:300px;">
                <option value="none" {if $settings.captcha_provider == 'none' || !$settings.captcha_provider}selected{/if}>Kein CAPTCHA</option>
                <option value="altcha" {if $settings.captcha_provider == 'altcha'}selected{/if}>ALTCHA (datenschutzfreundlich, lokal)</option>
                <option value="recaptcha_v2" {if $settings.captcha_provider == 'recaptcha_v2'}selected{/if}>Google reCAPTCHA v2</option>
                <option value="recaptcha_v3" {if $settings.captcha_provider == 'recaptcha_v3'}selected{/if}>Google reCAPTCHA v3</option>
                <option value="turnstile" {if $settings.captcha_provider == 'turnstile'}selected{/if}>Cloudflare Turnstile</option>
                <option value="friendly_captcha" {if $settings.captcha_provider == 'friendly_captcha'}selected{/if}>Friendly Captcha (EU)</option>
            </select>
        </div>

        {* ALTCHA Info *}
        <div class="bbf-captcha-panel" data-provider="altcha" style="{if $settings.captcha_provider != 'altcha'}display:none;{/if}">
            <div style="padding:12px 16px;background:#eef6fc;border:1px solid #b8d8f0;border-radius:6px;color:#1a3a5c;font-size:13px;">
                ALTCHA ist ein datenschutzfreundliches Proof-of-Work-CAPTCHA. Es läuft lokal auf dem Server, benötigt keine API-Schlüssel und ist DSGVO-konform.
            </div>
        </div>

        {* reCAPTCHA v2 *}
        <div class="bbf-captcha-panel" data-provider="recaptcha_v2" style="{if $settings.captcha_provider != 'recaptcha_v2'}display:none;{/if}">
            <div style="margin-bottom:12px;">
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Site Key</label>
                <input type="text" name="recaptcha_site_key" value="{$settings.recaptcha_site_key|default:''}" class="form-control">
            </div>
            <div>
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Secret Key</label>
                <input type="password" name="recaptcha_secret_key" value="{$settings.recaptcha_secret_key|default:''}" class="form-control">
            </div>
        </div>

        {* reCAPTCHA v3 *}
        <div class="bbf-captcha-panel" data-provider="recaptcha_v3" style="{if $settings.captcha_provider != 'recaptcha_v3'}display:none;{/if}">
            <div style="margin-bottom:12px;">
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Site Key</label>
                <input type="text" name="recaptcha_site_key" value="{$settings.recaptcha_site_key|default:''}" class="form-control">
            </div>
            <div>
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Secret Key</label>
                <input type="password" name="recaptcha_secret_key" value="{$settings.recaptcha_secret_key|default:''}" class="form-control">
            </div>
        </div>

        {* Turnstile *}
        <div class="bbf-captcha-panel" data-provider="turnstile" style="{if $settings.captcha_provider != 'turnstile'}display:none;{/if}">
            <div style="margin-bottom:12px;">
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Site Key</label>
                <input type="text" name="turnstile_site_key" value="{$settings.turnstile_site_key|default:''}" class="form-control">
            </div>
            <div>
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Secret Key</label>
                <input type="password" name="turnstile_secret_key" value="{$settings.turnstile_secret_key|default:''}" class="form-control">
            </div>
        </div>

        {* Friendly Captcha *}
        <div class="bbf-captcha-panel" data-provider="friendly_captcha" style="{if $settings.captcha_provider != 'friendly_captcha'}display:none;{/if}">
            <div style="margin-bottom:12px;">
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">Site Key</label>
                <input type="text" name="friendly_captcha_site_key" value="{$settings.friendly_captcha_site_key|default:''}" class="form-control">
            </div>
            <div>
                <label style="font-size:12px;font-weight:500;display:block;margin-bottom:4px;">API Secret</label>
                <input type="password" name="friendly_captcha_secret" value="{$settings.friendly_captcha_secret|default:''}" class="form-control">
            </div>
        </div>
    </div>

    <button type="button" class="bbf-btn-primary" style="padding:10px 24px;border-radius:8px;border:none;font-size:14px;cursor:pointer;" onclick="saveSetting('bbf-spam-settings', 'spam-protection');">
        Einstellungen speichern
    </button>
</form>

<script>
{literal}
document.addEventListener('DOMContentLoaded', function() {
    // Timing toggle
    var timingToggle = document.getElementById('bbf-timing-toggle');
    if (timingToggle) {
        timingToggle.addEventListener('change', function() {
            document.getElementById('bbf-timing-details').style.display = this.checked ? 'block' : 'none';
        });
    }
    // Rate limit toggle
    var rlToggle = document.getElementById('bbf-ratelimit-toggle');
    if (rlToggle) {
        rlToggle.addEventListener('change', function() {
            document.getElementById('bbf-ratelimit-details').style.display = this.checked ? 'block' : 'none';
        });
    }
    // CAPTCHA provider select
    var captchaSelect = document.getElementById('bbf-captcha-select');
    if (captchaSelect) {
        captchaSelect.addEventListener('change', function() {
            document.querySelectorAll('.bbf-captcha-panel').forEach(function(el) {
                el.style.display = 'none';
            });
            var panel = document.querySelector('.bbf-captcha-panel[data-provider="' + this.value + '"]');
            if (panel) panel.style.display = 'block';
        });
    }
});
{/literal}
</script>
