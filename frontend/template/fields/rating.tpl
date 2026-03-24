{* BBF Formbuilder – Field Template: rating *}
{* Field ID: {$field->id} *}
<div class="bbf-rating" id="{$field->id}_wrapper">
    {for $i=5 to 1 step -1}
        <input type="radio" id="{$field->id}_{$i}" name="{$field->id}" value="{$i}"
               {if $field->value == $i}checked{/if}>
        <label for="{$field->id}_{$i}" title="{$i} Stern{if $i > 1}e{/if}"></label>
    {/for}
</div>
