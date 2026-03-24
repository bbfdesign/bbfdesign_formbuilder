{* BBF Formbuilder – Field Template: textarea *}
{* Field ID: {$field->id} *}
<textarea id="{$field->id}"
          name="{$field->id}"
          placeholder="{$field->placeholder|escape:'html'}"
          class="bbf-textarea"
          rows="5"
          {if $field->required}required aria-required="true"{/if}>{$field->value|escape:'html'}</textarea>
