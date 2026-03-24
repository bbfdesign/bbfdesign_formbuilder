{* BBF Formbuilder – Field Template: address *}
{* Field ID: {$field->id} *}
<div class="bbf-address-fields">
    <div class="bbf-field">
        <label for="{$field->id}_street">Straße</label>
        <input type="text" id="{$field->id}_street" name="{$field->id}[street]"
               value="{$field->value.street|default:''|escape:'html'}" placeholder="Straße und Hausnummer"
               class="bbf-input" {if $field->required}required{/if}>
    </div>
    <div class="bbf-fields-row">
        <div class="bbf-field bbf-field--third">
            <label for="{$field->id}_zip">PLZ</label>
            <input type="text" id="{$field->id}_zip" name="{$field->id}[zip]"
                   value="{$field->value.zip|default:''|escape:'html'}" placeholder="PLZ"
                   class="bbf-input" {if $field->required}required{/if}>
        </div>
        <div class="bbf-field bbf-field--two-thirds">
            <label for="{$field->id}_city">Ort</label>
            <input type="text" id="{$field->id}_city" name="{$field->id}[city]"
                   value="{$field->value.city|default:''|escape:'html'}" placeholder="Ort"
                   class="bbf-input" {if $field->required}required{/if}>
        </div>
    </div>
    <div class="bbf-field">
        <label for="{$field->id}_country">Land</label>
        <input type="text" id="{$field->id}_country" name="{$field->id}[country]"
               value="{$field->value.country|default:''|escape:'html'}" placeholder="Land"
               class="bbf-input">
    </div>
</div>
