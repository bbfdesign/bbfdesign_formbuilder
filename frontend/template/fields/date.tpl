{* BBF Formbuilder – Field Template: date *}
{* Field ID: {$field->id} *}
<input type="date"
       id="{$field->id}"
       name="{$field->id}"
       value="{$field->value|escape:'html'}"
       class="bbf-input"
       {if $field->required}required aria-required="true"{/if}>
