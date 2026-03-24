{* BBF Formbuilder – Multi-Step Progress Indicator *}
{literal}
<div class="bbf-multi-step-progress" role="tablist" aria-label="Formular-Schritte">

    <div class="bbf-step-indicators">
        <template x-for="(step, idx) in _steps" :key="idx">
            <button type="button"
                    role="tab"
                    class="bbf-step-indicator"
                    :class="{
                        'is-active':    idx === currentStep,
                        'is-complete':  idx < currentStep,
                        'is-disabled':  idx > currentStep + 1
                    }"
                    :aria-selected="idx === currentStep ? 'true' : 'false'"
                    :aria-current="idx === currentStep ? 'step' : false"
                    :disabled="idx > currentStep + 1"
                    @click="goToStep(idx)">

                <span class="bbf-step-number"
                      x-show="idx >= currentStep"
                      x-text="idx + 1"></span>

                <span class="bbf-step-check"
                      x-show="idx < currentStep"
                      aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </span>

                <span class="bbf-step-title" x-text="step.title || ('Schritt ' + (idx + 1))"></span>
            </button>
        </template>
    </div>

    <div class="bbf-progress-bar" role="progressbar"
         :aria-valuenow="Math.round((currentStep / Math.max(totalSteps - 1, 1)) * 100)"
         aria-valuemin="0"
         aria-valuemax="100">
        <div class="bbf-progress-bar__fill"
             :style="'width:' + Math.round((currentStep / Math.max(totalSteps - 1, 1)) * 100) + '%'"></div>
    </div>

    <div class="sr-only" aria-live="polite"
         x-text="'Schritt ' + (currentStep + 1) + ' von ' + totalSteps">
    </div>
</div>
{/literal}
