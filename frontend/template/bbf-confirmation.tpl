{* BBF Formbuilder – Confirmation / Success Message Template *}
<div class="bbf-form-success" role="status" aria-live="polite">
    {if $bbfConfirmationTitle}
        <h3 class="bbf-form-success-title">{$bbfConfirmationTitle|escape:'html'}</h3>
    {/if}
    <p>{$bbfConfirmationMessage|default:'Vielen Dank! Ihre Eingabe wurde erfolgreich übermittelt.'}</p>
</div>
