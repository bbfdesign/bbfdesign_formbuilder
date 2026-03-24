{* BBF Formbuilder – Field Template: phone *}
{* Field ID: {$field->id} *}
<input type="tel"
       id="{$field->id}"
       name="{$field->id}"
       value="{$field->value|escape:'html'}"
       placeholder="{$field->placeholder|escape:'html'}"
       class="bbf-input"
       {if $field->required}required aria-required="true"{/if}>
