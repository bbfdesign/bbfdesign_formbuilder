{* BBF Formbuilder – Field Template: url *}
{* Field ID: {$field->id} *}
<input type="url"
       id="{$field->id}"
       name="{$field->id}"
       value="{$field->value|escape:'html'}"
       placeholder="{$field->placeholder|default:'https://'|escape:'html'}"
       class="bbf-input"
       {if $field->required}required aria-required="true"{/if}>
