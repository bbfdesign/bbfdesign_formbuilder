{* BBF Formbuilder – Field Template: slider *}
{* Field ID: {$field->id} *}
<div class="bbf-slider-wrapper">
    <input type="range"
           id="{$field->id}"
           name="{$field->id}"
           min="{$field->min|default:0}"
           max="{$field->max|default:100}"
           step="{$field->step_size|default:1}"
           value="{$field->value|default:50}">
    <span class="bbf-slider-value">{$field->value|default:50}</span>
</div>
