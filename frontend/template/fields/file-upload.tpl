{* BBF Formbuilder – Field Template: file-upload *}
{* Field ID: {$field->id} *}
<div class="bbf-file-drop-zone">
    <div class="bbf-file-icon">&#128206;</div>
    <span>Datei hierher ziehen oder klicken</span>
    <span class="bbf-file-hint">{$field->placeholder|default:'Erlaubte Dateitypen: PDF, JPG, PNG'}</span>
    <input type="file"
           id="{$field->id}"
           name="{$field->id}"
           {if $field->accept}accept="{$field->accept}"{/if}
           {if $field->required}required aria-required="true"{/if}
           style="position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0,0,0,0);">
</div>
