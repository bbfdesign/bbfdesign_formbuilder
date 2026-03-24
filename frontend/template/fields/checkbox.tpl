{* BBF Formbuilder – Field Template: checkbox *}
{* Field ID: {$field->id} *}
<div class="bbf-checkbox-group">
    {foreach $field->choices as $choice}
        <label class="bbf-checkbox-label">
            <input type="checkbox"
                   name="{$field->id}[]"
                   value="{$choice.value|escape:'html'}"
                   {if in_array($choice.value, $field->value|default:[])}checked{/if}>
            <span>{$choice.label|escape:'html'}</span>
        </label>
    {/foreach}
</div>
