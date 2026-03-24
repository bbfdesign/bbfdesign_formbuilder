{**
 * BBF Formbuilder – Custom Drop / Frontend-Link Template
 * Wird geladen wenn die Eigene Seite /formular aufgerufen wird.
 * Das Formular wird per {bbf_form} Smarty-Plugin gerendert.
 *}
{extends file="layout/index.tpl"}

{block name="content"}
    <div class="container bbf-form-page" style="padding-top:30px;padding-bottom:60px;">
        {* Das Formular-Slug wird aus der URL extrahiert.
           Nutzung: /formular?form=kontakt oder /formular?id=1 *}
        {if !empty($smarty.get.id)}
            {bbf_form id=$smarty.get.id}
        {elseif !empty($smarty.get.form)}
            {bbf_form slug=$smarty.get.form}
        {else}
            <div class="alert alert-info">
                <p>Kein Formular angegeben. Bitte verwende einen Link wie:</p>
                <code>/formular?id=1</code> oder <code>/formular?form=kontakt</code>
            </div>
        {/if}
    </div>
{/block}
