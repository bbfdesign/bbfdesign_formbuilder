{* BBF Formbuilder – Field Template: gdpr *}
{* Field ID: {$field->id} *}
<label class="bbf-gdpr-label">
    <input type="checkbox"
           id="{$field->id}"
           name="{$field->id}"
           value="1"
           {if $field->value}checked{/if}
           {if $field->required}required aria-required="true"{/if}>
    <span>{$field->label}</span>
</label>
