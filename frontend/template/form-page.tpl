{**
 * BBF Formbuilder – Custom Drop / Frontend-Link Template
 * URL: /bbf-form/{slug}
 *}
{extends file="layout/index.tpl"}

{block name="content"}
    <div class="container bbf-form-page">
        {if !empty($bbfForm)}
            <h1 class="bbf-form-page-title">{$bbfFormTitle}</h1>
            {if !empty($bbfForm->description)}
                <p class="bbf-form-page-description">{$bbfForm->description}</p>
            {/if}

            {include file="{$bbfFrontendPath}template/form.tpl"}
        {else}
            <div class="alert alert-warning">
                {lang key="form_not_found" section="bbfdesign_formbuilder"}
            </div>
        {/if}
    </div>
{/block}
