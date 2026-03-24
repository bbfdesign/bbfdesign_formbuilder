{* BBF Formbuilder – Field Template: name *}
{* Field ID: {$field->id} *}
<div class="bbf-fields-row">
    <div class="bbf-field bbf-field--half">
        <label for="{$field->id}_first">Vorname</label>
        <input type="text"
               id="{$field->id}_first"
               name="{$field->id}[first]"
               value="{$field->value.first|default:''|escape:'html'}"
               placeholder="Vorname"
               class="bbf-input"
               {if $field->required}required aria-required="true"{/if}>
    </div>
    <div class="bbf-field bbf-field--half">
        <label for="{$field->id}_last">Nachname</label>
        <input type="text"
               id="{$field->id}_last"
               name="{$field->id}[last]"
               value="{$field->value.last|default:''|escape:'html'}"
               placeholder="Nachname"
               class="bbf-input"
               {if $field->required}required aria-required="true"{/if}>
    </div>
</div>
