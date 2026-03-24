{* BBF Formbuilder – Frontend Form Template *}
<div class="bbf-form-wrapper"
     x-data="bbfForm({
         formId: {$bbfForm->id},
         fields: {$bbfFields|json_encode},
         csrfToken: '{$bbfCsrfToken}',
         ajaxUrl: '{$bbfSubmitUrl}'
     })">

    {* Success Message *}
    <div x-show="isSuccess" x-cloak class="bbf-form-success" role="alert">
        <p x-text="successMessage"></p>
    </div>

    {* Form Error *}
    <div x-show="errors._form" x-cloak class="bbf-form-error" role="alert">
        <p x-text="errors._form"></p>
    </div>

    {* Form *}
    <form x-show="!isSuccess"
          class="bbf-form {$bbfCssClass}"
          @submit.prevent="submitForm()"
          novalidate
          aria-label="{$bbfFormTitle}">

        {* Multi-Step Progress *}
        {if $bbfForm->is_multi_step}
            {include file="frontend/template/multi-step-progress.tpl"}
        {/if}

        <div class="bbf-fields-row">
            <template x-for="(field, index) in fields" :key="field.id">
                <div x-show="isFieldVisible(field) && field.type !== 'page_break' && (totalSteps <= 1 || field._step === currentStep)"
                     class="bbf-field"
                     :class="'bbf-field--' + (field.width || 'full') + (errors[field.id] ? ' bbf-field--error' : '')"
                     role="group"
                     :aria-labelledby="'label-' + field.id">

                    {* Label *}
                    <label :id="'label-' + field.id" :for="field.id" x-show="field.type !== 'hidden'">
                        <span x-text="field.label"></span>
                        <span x-show="field.required" class="bbf-required" aria-label="Pflichtfeld">*</span>
                    </label>

                    {* Description *}
                    <span x-show="field.description"
                          :id="'desc-' + field.id"
                          class="bbf-field-description"
                          x-text="field.description"></span>

                    {* Text / Email / Phone / URL / Password / Number *}
                    <template x-if="['text','email','phone','url','password','number'].includes(field.type)">
                        <input :type="field.type === 'phone' ? 'tel' : field.type"
                               :id="field.id"
                               :name="field.id"
                               :placeholder="field.placeholder"
                               x-model="values[field.id]"
                               :required="field.required"
                               :aria-required="field.required ? 'true' : 'false'"
                               :aria-describedby="(field.description ? 'desc-' + field.id : '') + (errors[field.id] ? ' error-' + field.id : '')"
                               :aria-invalid="errors[field.id] ? 'true' : 'false'"
                               class="bbf-input">
                    </template>

                    {* Textarea *}
                    <template x-if="field.type === 'textarea'">
                        <textarea :id="field.id"
                                  :name="field.id"
                                  :placeholder="field.placeholder"
                                  x-model="values[field.id]"
                                  :required="field.required"
                                  :aria-required="field.required ? 'true' : 'false'"
                                  :aria-invalid="errors[field.id] ? 'true' : 'false'"
                                  rows="5"
                                  class="bbf-textarea"></textarea>
                    </template>

                    {* Select *}
                    <template x-if="field.type === 'select'">
                        <select :id="field.id"
                                :name="field.id"
                                x-model="values[field.id]"
                                :required="field.required"
                                :aria-invalid="errors[field.id] ? 'true' : 'false'"
                                class="bbf-select">
                            <option value="" x-text="field.placeholder || 'Bitte wählen'"></option>
                            <template x-for="choice in (field.choices || [])" :key="choice.value">
                                <option :value="choice.value" x-text="choice.label"></option>
                            </template>
                        </select>
                    </template>

                    {* Radio *}
                    <template x-if="field.type === 'radio'">
                        <div class="bbf-radio-group" role="radiogroup">
                            <template x-for="choice in (field.choices || [])" :key="choice.value">
                                <label class="bbf-radio-label">
                                    <input type="radio"
                                           :name="field.id"
                                           :value="choice.value"
                                           x-model="values[field.id]">
                                    <span x-text="choice.label"></span>
                                </label>
                            </template>
                        </div>
                    </template>

                    {* Checkbox *}
                    <template x-if="field.type === 'checkbox'">
                        <div class="bbf-checkbox-group">
                            <template x-for="choice in (field.choices || [])" :key="choice.value">
                                <label class="bbf-checkbox-label">
                                    <input type="checkbox"
                                           :name="field.id + '[]'"
                                           :value="choice.value"
                                           @change="if(!values[field.id]) values[field.id]=[]; const i=values[field.id].indexOf(choice.value); i>-1?values[field.id].splice(i,1):values[field.id].push(choice.value)">
                                    <span x-text="choice.label"></span>
                                </label>
                            </template>
                        </div>
                    </template>

                    {* Hidden *}
                    <template x-if="field.type === 'hidden'">
                        <input type="hidden"
                               :name="field.id"
                               :value="field.default_value"
                               x-model="values[field.id]">
                    </template>

                    {* Date *}
                    <template x-if="field.type === 'date'">
                        <input type="date" :id="field.id" :name="field.id" x-model="values[field.id]"
                               :required="field.required" :aria-invalid="errors[field.id] ? 'true' : 'false'" class="bbf-input">
                    </template>

                    {* Time *}
                    <template x-if="field.type === 'time'">
                        <input type="time" :id="field.id" :name="field.id" x-model="values[field.id]"
                               :required="field.required" :aria-invalid="errors[field.id] ? 'true' : 'false'" class="bbf-input">
                    </template>

                    {* File Upload *}
                    <template x-if="field.type === 'file_upload'">
                        <div class="bbf-file-drop-zone">
                            <input type="file" :id="field.id" :name="field.id"
                                   :required="field.required" :aria-invalid="errors[field.id] ? 'true' : 'false'"
                                   :accept="field.allowed_extensions ? '.' + field.allowed_extensions.split(',').join(',.') : ''">
                            <p class="bbf-file-hint" x-show="field.max_file_size">
                                Max. <span x-text="field.max_file_size"></span> MB
                            </p>
                        </div>
                    </template>

                    {* Rating *}
                    <template x-if="field.type === 'rating'">
                        {literal}
                        <div class="bbf-rating" role="radiogroup" :aria-label="field.label">
                            <template x-for="star in Array.from({length: field.max_stars || 5}, (_, i) => i + 1)" :key="star">
                                <label class="bbf-rating-star" :class="{ 'is-active': values[field.id] >= star }">
                                    <input type="radio" :name="field.id" :value="star" x-model.number="values[field.id]" class="sr-only">
                                    <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                </label>
                            </template>
                        </div>
                        {/literal}
                    </template>

                    {* Slider *}
                    <template x-if="field.type === 'slider'">
                        <div class="bbf-slider-wrap">
                            <input type="range" :id="field.id" :name="field.id" x-model="values[field.id]"
                                   :min="field.min_value || 0" :max="field.max_value || 100" :step="field.step_value || 1"
                                   class="bbf-slider">
                            <output class="bbf-slider-value" x-text="values[field.id] || (field.min_value || 0)"></output>
                        </div>
                    </template>

                    {* Section Break *}
                    <template x-if="field.type === 'section_break'">
                        <div class="bbf-section-break">
                            <h3 class="bbf-section-title" x-text="field.section_title || field.label"></h3>
                            <hr>
                        </div>
                    </template>

                    {* HTML Block *}
                    <template x-if="field.type === 'html_block'">
                        <div class="bbf-html-block" x-html="field.html_content || ''"></div>
                    </template>

                    {* GDPR Consent *}
                    <template x-if="field.type === 'gdpr'">
                        <label class="bbf-gdpr-label">
                            <input type="checkbox"
                                   :name="field.id"
                                   value="1"
                                   x-model="values[field.id]"
                                   :required="field.required"
                                   :aria-invalid="errors[field.id] ? 'true' : 'false'">
                            <span x-html="field.gdpr_text || field.label"></span>
                        </label>
                    </template>

                    {* Error message *}
                    <span x-show="errors[field.id]"
                          :id="'error-' + field.id"
                          class="bbf-error-message"
                          role="alert"
                          x-text="errors[field.id]"></span>
                </div>
            </template>
        </div>

        {* Honeypot (hidden spam protection) *}
        <div style="position:absolute;left:-9999px;top:-9999px;" aria-hidden="true">
            <input type="text" name="bbf_hp_field" value="" tabindex="-1" autocomplete="off">
        </div>

        {* Hidden page URL for tracking *}
        <input type="hidden" name="_page_url" :value="window.location.href">

        {* Step Navigation (multi-step forms) *}
        {if $bbfForm->is_multi_step}
        <div class="bbf-step-nav" x-show="totalSteps > 1">
            <button type="button"
                    class="bbf-step-nav__prev bbf-btn bbf-btn--secondary"
                    x-show="currentStep > 0"
                    @click="prevStep()"
                    aria-label="Zurück zum vorherigen Schritt">
                &larr; Zurück
            </button>

            <button type="button"
                    class="bbf-step-nav__next bbf-btn bbf-btn--primary"
                    x-show="currentStep < totalSteps - 1"
                    @click="nextStep()"
                    aria-label="Weiter zum nächsten Schritt">
                Weiter &rarr;
            </button>
        </div>
        {/if}

        {* Submit Button *}
        <div class="bbf-submit-row" {if $bbfForm->is_multi_step}x-show="currentStep === totalSteps - 1"{/if}>
            <button type="submit"
                    class="bbf-submit-btn"
                    :disabled="isSubmitting">
                <span x-show="!isSubmitting">{$bbfSubmitText}</span>
                <span x-show="isSubmitting" class="bbf-spinner-sm"></span>
            </button>
        </div>
    </form>
</div>
