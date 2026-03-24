{* BBF Formbuilder – Field Template: password *}
{* Field ID: {$field->id} *}
<input type="password"
       id="{$field->id}"
       name="{$field->id}"
       placeholder="{$field->placeholder|escape:'html'}"
       class="bbf-input"
       autocomplete="new-password"
       {if $field->required}required aria-required="true"{/if}>
