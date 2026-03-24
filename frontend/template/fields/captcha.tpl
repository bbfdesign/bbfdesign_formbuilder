{* BBF Formbuilder – Field Template: captcha *}
{* Field ID: {$field->id} *}
{* Captcha integration placeholder – implementation depends on provider (e.g. Google reCAPTCHA, hCaptcha) *}
<div class="bbf-captcha" id="{$field->id}">
    <div class="bbf-captcha-widget" data-sitekey="{$field->sitekey|default:''}"></div>
</div>
