{* BBF Formbuilder – Field Template: section-break *}
{* Field ID: {$field->id} *}
<div class="bbf-section-break-wrapper" id="{$field->id}">
    {if $field->label}
        <div class="bbf-section-break-title">{$field->label|escape:'html'}</div>
    {/if}
    {if $field->description}
        <p class="bbf-field-description">{$field->description|escape:'html'}</p>
    {/if}
    <hr class="bbf-section-break">
</div>
