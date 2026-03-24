{* BBF Formbuilder OPC Portlet Template *}
{if $instance->getProperty('form_id')}
    {bbf_form id=$instance->getProperty('form_id') class=$instance->getProperty('custom_class')}
{else}
    <p class="text-muted text-center" style="padding: 20px;">Bitte ein Formular in den Portlet-Einstellungen auswählen.</p>
{/if}
