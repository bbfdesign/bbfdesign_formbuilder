{* BBF Formbuilder – Multi-Step Progress Indicator *}
<ol class="bbf-multi-step-progress" aria-label="Formular-Fortschritt">
    {for $i=0 to $bbfTotalSteps-1}
        <li class="{if $i < $bbfCurrentStep}is-complete{elseif $i === $bbfCurrentStep}is-active{/if}"
            {if $i === $bbfCurrentStep}aria-current="step"{/if}>
            <span class="bbf-step-label">{$bbfStepLabels[$i]|default:"Schritt `$i+1`"}</span>
        </li>
    {/for}
</ol>
