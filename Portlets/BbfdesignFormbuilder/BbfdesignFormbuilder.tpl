{if $isPreview}
    <div style="background:#f8f9fa;border:2px dashed #dee2e6;padding:24px;text-align:center;border-radius:8px;">
        <p style="color:#333;margin:0;font-weight:600;">BBF Formbuilder</p>
        {if $instance->getProperty('form_id')}
            <p style="color:#6c757d;margin:4px 0 0;font-size:13px;">Formular #{$instance->getProperty('form_id')}</p>
        {else}
            <p style="color:#6c757d;margin:4px 0 0;font-size:13px;">Bitte ein Formular auswählen</p>
        {/if}
    </div>
{else}
    {if $instance->getProperty('form_id')}
        {bbf_form id=$instance->getProperty('form_id') class=$instance->getProperty('custom_class')}
    {else}
        <p class="text-muted text-center" style="padding: 20px;">Bitte ein Formular in den Portlet-Einstellungen auswählen.</p>
    {/if}
{/if}
