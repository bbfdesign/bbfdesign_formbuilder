{* BBF Formbuilder – Field Template: select *}
{* Field ID: {$field->id} *}
<select id="{$field->id}"
        name="{$field->id}"
        class="bbf-select"
        {if $field->required}required aria-required="true"{/if}>
    <option value="">{$field->placeholder|default:'Bitte wählen'|escape:'html'}</option>
    {foreach $field->choices as $choice}
        <option value="{$choice.value|escape:'html'}"{if $field->value === $choice.value} selected{/if}>{$choice.label|escape:'html'}</option>
    {/foreach}
</select>
