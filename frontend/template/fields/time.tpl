{* BBF Formbuilder – Field Template: time *}
{* Field ID: {$field->id} *}
<input type="time"
       id="{$field->id}"
       name="{$field->id}"
       value="{$field->value|escape:'html'}"
       class="bbf-input"
       {if $field->required}required aria-required="true"{/if}>
