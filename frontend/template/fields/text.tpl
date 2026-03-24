{* BBF Formbuilder – Field Template: text *}
{* Field ID: {$field->id} *}
<input type="text"
       id="{$field->id}"
       name="{$field->id}"
       value="{$field->value|escape:'html'}"
       placeholder="{$field->placeholder|escape:'html'}"
       class="bbf-input"
       {if $field->required}required aria-required="true"{/if}>
