{* BBF Formbuilder – Field Template: number *}
{* Field ID: {$field->id} *}
<input type="number"
       id="{$field->id}"
       name="{$field->id}"
       value="{$field->value|escape:'html'}"
       placeholder="{$field->placeholder|escape:'html'}"
       class="bbf-input"
       {if $field->min !== null}min="{$field->min}"{/if}
       {if $field->max !== null}max="{$field->max}"{/if}
       {if $field->required}required aria-required="true"{/if}>
