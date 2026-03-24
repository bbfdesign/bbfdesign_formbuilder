{* BBF Formbuilder – Field Template: radio *}
{* Field ID: {$field->id} *}
<div class="bbf-radio-group" role="radiogroup">
    {foreach $field->choices as $choice}
        <label class="bbf-radio-label">
            <input type="radio"
                   name="{$field->id}"
                   value="{$choice.value|escape:'html'}"
                   {if $field->value === $choice.value}checked{/if}>
            <span>{$choice.label|escape:'html'}</span>
        </label>
    {/foreach}
</div>
