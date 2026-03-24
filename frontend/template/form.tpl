{* BBF Formbuilder – Frontend Form Template *}
<div class="bbf-form-wrapper"
     x-data="bbfForm({
         formId: {$bbfForm->id},
         fields: {$bbfFields|json_encode},
         csrfToken: '{$bbfCsrfToken}',
         ajaxUrl: '{$bbfPluginUrl}submit'
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

        <div class="bbf-fields-row">
            <template x-for="(field, index) in fields" :key="field.id">
                <div x-show="isFieldVisible(field)"
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

                    {* GDPR Consent *}
                    <template x-if="field.type === 'gdpr'">
                        <label class="bbf-gdpr-label">
                            <input type="checkbox"
                                   :name="field.id"
                                   value="1"
                                   x-model="values[field.id]"
                                   :required="field.required"
                                   :aria-invalid="errors[field.id] ? 'true' : 'false'">
                            <span x-html="field.label"></span>
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

        {* Submit Button *}
        <div class="bbf-submit-row">
            <button type="submit"
                    class="bbf-submit-btn"
                    :disabled="isSubmitting">
                <span x-show="!isSubmitting">{$bbfSubmitText}</span>
                <span x-show="isSubmitting" class="bbf-spinner-sm"></span>
            </button>
        </div>
    </form>
</div>
