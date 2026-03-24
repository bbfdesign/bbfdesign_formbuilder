{* BBF Formbuilder – Multi-Step Progress Indicator *}
<div class="bbf-multi-step-progress" role="tablist" aria-label="Formular-Schritte">

    {* Step buttons *}
    <div class="bbf-step-indicators">
        <template x-for="(step, idx) in _steps" :key="idx">
            <button type="button"
                    role="tab"
                    class="bbf-step-indicator"
                    :class="{
                        'is-active':    idx === currentStep,
                        'is-complete':  idx < currentStep && BbfMultiStep.isStepComplete(_steps, idx, values, (f) => isFieldVisible(f)),
                        'is-disabled':  !BbfMultiStep.canGoToStep(idx, currentStep, _steps, values, (f) => isFieldVisible(f))
                    }"
                    :aria-selected="idx === currentStep ? 'true' : 'false'"
                    :aria-current="idx === currentStep ? 'step' : false"
                    :aria-label="BbfMultiStep.getStepTitle(_steps, idx)"
                    :disabled="!BbfMultiStep.canGoToStep(idx, currentStep, _steps, values, (f) => isFieldVisible(f))"
                    @click="goToStep(idx)">

                {* Step number / checkmark *}
                <span class="bbf-step-number"
                      x-show="!(idx < currentStep && BbfMultiStep.isStepComplete(_steps, idx, values, (f) => isFieldVisible(f)))"
                      x-text="idx + 1"></span>

                <span class="bbf-step-check"
                      x-show="idx < currentStep && BbfMultiStep.isStepComplete(_steps, idx, values, (f) => isFieldVisible(f))"
                      aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </span>

                {* Step title *}
                <span class="bbf-step-title" x-text="BbfMultiStep.getStepTitle(_steps, idx)"></span>
            </button>
        </template>
    </div>

    {* Progress bar *}
    <div class="bbf-progress-bar" role="progressbar"
         :aria-valuenow="BbfMultiStep.getProgressPercent(currentStep, totalSteps)"
         aria-valuemin="0"
         aria-valuemax="100"
         :aria-label="'Fortschritt: ' + BbfMultiStep.getProgressPercent(currentStep, totalSteps) + '%'">
        <div class="bbf-progress-bar__fill"
             :style="'width:' + BbfMultiStep.getProgressPercent(currentStep, totalSteps) + '%'"></div>
    </div>

    {* Current step indicator for screen readers *}
    <div class="sr-only" aria-live="polite"
         x-text="'Schritt ' + (currentStep + 1) + ' von ' + totalSteps + ': ' + BbfMultiStep.getStepTitle(_steps, currentStep)">
    </div>
</div>
