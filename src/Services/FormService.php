<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Models\Form;
use BbfdesignFormbuilder\Models\FormNotification;
use BbfdesignFormbuilder\Models\FormConfirmation;

class FormService
{
    private Form $formModel;

    public function __construct()
    {
        $this->formModel = new Form();
    }

    /**
     * Create a form from a template.
     */
    public function createFromTemplate(string $title, int $templateId): int
    {
        $templateModel = new \BbfdesignFormbuilder\Models\FormTemplate();
        $template = $templateModel->getById($templateId);

        if ($template === null) {
            throw new \RuntimeException('Vorlage nicht gefunden.');
        }

        $slug = $this->formModel->generateSlug($title);

        $formId = $this->formModel->create([
            'title'       => $title,
            'slug'        => $slug,
            'fields_json' => $template->fields_json,
            'settings_json' => $template->settings_json,
            'status'      => 'draft',
        ]);

        // Create default notification if template has notifications
        if (!empty($template->notifications_json)) {
            $notifications = json_decode($template->notifications_json, true);
            $notificationModel = new FormNotification();
            foreach ($notifications as $notif) {
                $notif['form_id'] = $formId;
                $notificationModel->create($notif);
            }
        }

        // Create default confirmation
        $confirmationModel = new FormConfirmation();
        $confirmationModel->create([
            'form_id'    => $formId,
            'name'       => 'Standard-Bestätigung',
            'type'       => 'message',
            'message'    => 'Vielen Dank! Ihre Nachricht wurde erfolgreich gesendet.',
            'is_default' => 1,
        ]);

        return $formId;
    }

    /**
     * Export a form as JSON.
     */
    public function exportAsJson(int $formId): array
    {
        $form = $this->formModel->getById($formId);
        if ($form === null) {
            throw new \RuntimeException('Formular nicht gefunden.');
        }

        $notificationModel = new FormNotification();
        $confirmationModel = new FormConfirmation();

        return [
            'version' => '1.0',
            'plugin'  => 'bbfdesign_formbuilder',
            'form'    => [
                'title'              => $form->title,
                'description'        => $form->description,
                'fields_json'        => $form->fields_json,
                'settings_json'      => $form->settings_json,
                'css_classes'        => $form->css_classes,
                'is_multi_step'      => $form->is_multi_step,
                'submit_button_text' => $form->submit_button_text,
            ],
            'notifications' => $notificationModel->getByFormId($formId),
            'confirmations' => $confirmationModel->getByFormId($formId),
        ];
    }

    /**
     * Import a form from JSON data.
     */
    public function importFromJson(array $data): int
    {
        if (($data['plugin'] ?? '') !== 'bbfdesign_formbuilder') {
            throw new \RuntimeException('Ungültiges Import-Format.');
        }

        $formData = $data['form'];
        $slug = $this->formModel->generateSlug($formData['title']);

        $formId = $this->formModel->create([
            'title'              => $formData['title'],
            'slug'               => $slug,
            'description'        => $formData['description'] ?? null,
            'fields_json'        => $formData['fields_json'],
            'settings_json'      => $formData['settings_json'] ?? null,
            'css_classes'        => $formData['css_classes'] ?? null,
            'status'             => 'draft',
            'is_multi_step'      => $formData['is_multi_step'] ?? 0,
            'submit_button_text' => $formData['submit_button_text'] ?? 'Absenden',
        ]);

        return $formId;
    }
}
