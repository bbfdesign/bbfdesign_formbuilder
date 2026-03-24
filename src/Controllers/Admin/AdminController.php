<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Controllers\Admin;

use BbfdesignFormbuilder\Models\Form;
use BbfdesignFormbuilder\Models\FormEntry;
use BbfdesignFormbuilder\Models\FormNotification;
use BbfdesignFormbuilder\Models\FormConfirmation;
use BbfdesignFormbuilder\Models\FormTemplate;
use BbfdesignFormbuilder\Models\EmailTemplate;
use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;
use Exception;
use JTL\Helpers\Form as FormHelper;
use JTL\Helpers\Text;
use JTL\Plugin\PluginInterface;
use JTL\Shop;

class AdminController
{
    protected array $request;
    protected PluginInterface $plugin;
    protected $smarty;
    protected string $adminTemplatePath;

    public function __construct(PluginInterface $plugin)
    {
        $this->plugin = $plugin;
        $this->request = Text::filterXSS($_REQUEST);
        $this->smarty = Shop::Smarty();
        $this->adminTemplatePath = $this->plugin->getPaths()->getAdminPath();
    }

    public function handleAjax(): array
    {
        $action = $this->request['action'] ?? '';

        switch ($action) {
            case 'getPage':
                return $this->getPage();
            case 'savePluginSetting':
                return $this->savePluginSetting();
            case 'createForm':
                return $this->createForm();
            case 'updateForm':
                return $this->updateForm();
            case 'deleteForm':
                return $this->deleteForm();
            case 'duplicateForm':
                return $this->duplicateForm();
            case 'getFormData':
                return $this->getFormData();
            case 'saveFormFields':
                return $this->saveFormFields();
            case 'createFromTemplate':
                return $this->createFromTemplate();
            case 'deleteEntry':
                return $this->deleteEntry();
            case 'markEntryRead':
                return $this->markEntryRead();
            case 'toggleEntryStar':
                return $this->toggleEntryStar();
            case 'trashEntry':
                return $this->trashEntry();
            case 'bulkEntryAction':
                return $this->bulkEntryAction();
            case 'exportEntriesCsv':
                return $this->exportEntriesCsv();
            default:
                throw new Exception('Unrecognized action "' . Text::filterXSS($action) . '"');
        }
    }

    /**
     * AJAX page loader — renders the requested sub-template.
     */
    public function getPage(): array
    {
        $page = $this->request['page'] ?? 'dashboard';
        $pluginHelper = new PluginHelper($this->plugin);

        $this->smarty->assign([
            'langVars'  => $this->plugin->getLocalization(),
            'tplPath'   => $this->adminTemplatePath . 'templates',
            'ShopURL'   => Shop::getURL(),
            'adminLang' => ($_SESSION['AdminAccount']->language ?? 'de-DE') === 'de-DE' ? 'ger' : 'eng',
            'languages' => $pluginHelper->getAllLanguagesAsArray(),
            'defaultLanguage' => $pluginHelper->defaultLanguage(),
        ]);

        switch ($page) {
            case 'dashboard':
                $content = $this->renderDashboard();
                break;
            case 'forms':
                $content = $this->renderForms();
                break;
            case 'form-builder':
                $content = $this->renderFormBuilder();
                break;
            case 'form-settings':
                $content = $this->renderFormSettings();
                break;
            case 'entries':
                $content = $this->renderEntries();
                break;
            case 'entry-detail':
                $content = $this->renderEntryDetail();
                break;
            case 'templates':
                $content = $this->renderTemplates();
                break;
            case 'settings':
                $content = $this->renderSettings();
                break;
            case 'spam-protection':
                $content = $this->renderSpamProtection();
                break;
            case 'gdpr':
                $content = $this->renderGdpr();
                break;
            case 'email-templates':
                $content = $this->renderEmailTemplates();
                break;
            case 'css-editor':
                $content = $this->renderCssEditor();
                break;
            case 'documentation':
                $content = $this->smarty->fetch($this->adminTemplatePath . 'templates/documentation.tpl');
                break;
            case 'changelog':
                $content = $this->smarty->fetch($this->adminTemplatePath . 'templates/changelog.tpl');
                break;
            default:
                $content = '<div class="bbf-msg bbf-msg-danger">Seite nicht gefunden.</div>';
        }

        return ['content' => $content];
    }

    private function renderDashboard(): string
    {
        try {
            $formModel = new Form();
            $entryModel = new FormEntry();

            $spamCount = 0;
            try {
                $result = Shop::Container()->getDB()->queryPrepared(
                    'SELECT COUNT(*) as cnt FROM bbf_formbuilder_spam_log',
                    []
                );
                $spamCount = is_array($result) && !empty($result) ? (int)($result[0]['cnt'] ?? 0) : 0;
            } catch (\Exception $e) {
                $spamCount = 0;
            }

            $recentEntries = $entryModel->getRecent(10);
            $recentEntries = is_array($recentEntries) ? $this->addEntryPreviews($recentEntries) : [];

            return $this->smarty->fetch(
                $this->adminTemplatePath . 'templates/dashboard.tpl',
                [
                    'totalForms'    => $formModel->getTotalCount(),
                    'totalEntries'  => $entryModel->getTotalCount(),
                    'unreadEntries' => $entryModel->getUnreadCount(),
                    'spamBlocked'   => $spamCount,
                    'recentEntries' => $recentEntries,
                ]
            );
        } catch (\Exception $e) {
            return '<div class="bbf-msg bbf-msg-danger">Dashboard konnte nicht geladen werden: ' . htmlspecialchars($e->getMessage()) . '</div>';
        }
    }

    /**
     * Add first_value preview text to entry arrays.
     */
    private function addEntryPreviews(array $entries): array
    {
        $entryService = new \BbfdesignFormbuilder\Services\EntryService();
        foreach ($entries as &$entry) {
            $values = $entryService->getDecryptedValues((object)$entry);
            $preview = '';
            foreach ($values as $val) {
                if (is_array($val)) {
                    $val = implode(', ', $val);
                }
                $val = trim((string)$val);
                if (!empty($val) && mb_strlen($val) > 2) {
                    $preview = mb_substr($val, 0, 60);
                    break;
                }
            }
            $entry['first_value'] = $preview;
        }
        unset($entry);
        return $entries;
    }

    private function renderForms(): string
    {
        $formModel = new Form();
        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/forms.tpl',
            ['forms' => $formModel->getAll()]
        );
    }

    private function renderFormBuilder(): string
    {
        $formId = (int)($this->request['form_id'] ?? 0);
        $templateId = (int)($this->request['template_id'] ?? 0);
        $form = null;
        $template = null;

        if ($formId > 0) {
            $formModel = new Form();
            $form = $formModel->getById($formId);
        }

        if ($templateId > 0) {
            $templateModel = new FormTemplate();
            $template = $templateModel->getById($templateId);
        }

        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/form-builder.tpl',
            [
                'form'     => $form,
                'template' => $template,
                'formId'   => $formId,
            ]
        );
    }

    private function renderFormSettings(): string
    {
        $formId = (int)($this->request['form_id'] ?? 0);
        $formModel = new Form();
        $form = $formModel->getById($formId);

        $notificationModel = new FormNotification();
        $confirmationModel = new FormConfirmation();

        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/form-settings.tpl',
            [
                'form'          => $form,
                'notifications' => $notificationModel->getByFormId($formId),
                'confirmations' => $confirmationModel->getByFormId($formId),
            ]
        );
    }

    private function renderEntries(): string
    {
        $formModel = new Form();
        $entryModel = new FormEntry();
        $formId = (int)($this->request['filter_form_id'] ?? 0);

        $filters = ['is_trash' => 0];
        if ($formId > 0) {
            $filters['form_id'] = $formId;
        }

        $entries = $entryModel->getAll($filters);

        // Add first_value preview to each entry
        $entryService = new \BbfdesignFormbuilder\Services\EntryService();
        foreach ($entries as &$entry) {
            $entryObj = (object)$entry;
            $values = $entryService->getDecryptedValues($entryObj);
            $preview = '';
            foreach ($values as $val) {
                if (is_array($val)) {
                    $val = implode(', ', $val);
                }
                $val = trim((string)$val);
                if (!empty($val) && mb_strlen($val) > 2) {
                    $preview = mb_substr($val, 0, 60);
                    break;
                }
            }
            $entry['first_value'] = $preview;
        }
        unset($entry);

        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/entries.tpl',
            [
                'entries'      => $entries,
                'forms'        => $formModel->getAll(),
                'filterFormId' => $formId,
            ]
        );
    }

    private function renderEntryDetail(): string
    {
        $entryId = (int)($this->request['entry_id'] ?? 0);
        $entryModel = new FormEntry();
        $entry = $entryModel->getById($entryId);

        if ($entry === null) {
            return '<div class="bbf-msg bbf-msg-danger">Eintrag nicht gefunden.</div>';
        }

        $entryModel->markRead($entryId);

        // Decode field values
        $entryService = new \BbfdesignFormbuilder\Services\EntryService();
        $entryValues = $entryService->getDecryptedValues($entry);

        // Get field definitions
        $fields = json_decode($entry->fields_json ?? '[]', true);

        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/entry-detail.tpl',
            [
                'entry'       => $entry,
                'entryValues' => $entryValues,
                'entryFields' => $fields,
                'files'       => $entryModel->getFiles($entryId),
            ]
        );
    }

    private function renderTemplates(): string
    {
        $templateModel = new FormTemplate();
        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/templates.tpl',
            ['templates' => $templateModel->getAll()]
        );
    }

    private function renderSettings(): string
    {
        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/settings.tpl',
            ['settings' => PluginHelper::getSettings()]
        );
    }

    private function renderSpamProtection(): string
    {
        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/spam-protection.tpl',
            ['settings' => PluginHelper::getSettings()]
        );
    }

    private function renderGdpr(): string
    {
        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/gdpr.tpl',
            ['settings' => PluginHelper::getSettings()]
        );
    }

    private function renderEmailTemplates(): string
    {
        $emailTemplateModel = new EmailTemplate();
        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/email-templates.tpl',
            ['emailTemplates' => $emailTemplateModel->getAll()]
        );
    }

    private function renderCssEditor(): string
    {
        return $this->smarty->fetch(
            $this->adminTemplatePath . 'templates/css-editor.tpl',
            ['customCss' => PluginHelper::getSetting(Setting::CUSTOM_CSS) ?? '']
        );
    }

    // ─── Form CRUD Actions ───

    public function createForm(): array
    {
        $formModel = new Form();
        $title = trim($this->request['title'] ?? '');

        if (empty($title)) {
            return ['flag' => false, 'errors' => ['Formularname ist erforderlich.']];
        }

        $slug = $formModel->generateSlug($title);
        $fieldsJson = $this->request['fields_json'] ?? '[]';
        $templateId = (int)($this->request['template_id'] ?? 0);

        if ($templateId > 0) {
            $templateModel = new FormTemplate();
            $template = $templateModel->getById($templateId);
            if ($template !== null) {
                $fieldsJson = $template->fields_json;
            }
        }

        $formId = $formModel->create([
            'title'       => $title,
            'slug'        => $slug,
            'description' => $this->request['description'] ?? null,
            'fields_json' => $fieldsJson,
            'status'      => 'draft',
        ]);

        // Create default confirmation
        $confirmationModel = new FormConfirmation();
        $confirmationModel->create([
            'form_id'    => $formId,
            'name'       => 'Standard-Bestätigung',
            'type'       => 'message',
            'message'    => 'Vielen Dank! Ihre Nachricht wurde erfolgreich gesendet.',
            'is_default' => 1,
        ]);

        return [
            'flag'    => true,
            'message' => 'Formular erstellt.',
            'form_id' => $formId,
        ];
    }

    public function updateForm(): array
    {
        $formModel = new Form();
        $formId = (int)($this->request['form_id'] ?? 0);
        $form = $formModel->getById($formId);

        if ($form === null) {
            return ['flag' => false, 'errors' => ['Formular nicht gefunden.']];
        }

        $data = [];
        if (isset($this->request['title'])) {
            $data['title'] = trim($this->request['title']);
        }
        if (isset($this->request['slug'])) {
            $data['slug'] = $formModel->generateSlug($this->request['slug'], $formId);
        }
        if (isset($this->request['description'])) {
            $data['description'] = $this->request['description'];
        }
        if (isset($this->request['status'])) {
            $data['status'] = $this->request['status'];
        }
        if (isset($this->request['submit_button_text'])) {
            $data['submit_button_text'] = $this->request['submit_button_text'];
        }
        if (isset($this->request['css_classes'])) {
            $data['css_classes'] = $this->request['css_classes'];
        }
        if (isset($this->request['is_searchable'])) {
            $data['is_searchable'] = (int)$this->request['is_searchable'];
        }

        $formModel->update($formId, $data);

        return ['flag' => true, 'message' => 'Formular aktualisiert.'];
    }

    public function saveFormFields(): array
    {
        $formModel = new Form();
        $formId = (int)($this->request['form_id'] ?? 0);

        if ($formId === 0) {
            return ['flag' => false, 'errors' => ['Keine Formular-ID angegeben.']];
        }

        $fieldsJson = $this->request['fields_json'] ?? '[]';
        $isMultiStep = (int)($this->request['is_multi_step'] ?? 0);

        $formModel->update($formId, [
            'fields_json'  => $fieldsJson,
            'is_multi_step' => $isMultiStep,
        ]);

        return ['flag' => true, 'message' => 'Formularfelder gespeichert.'];
    }

    public function createFromTemplate(): array
    {
        $templateId = (int)($this->request['template_id'] ?? 0);
        if ($templateId <= 0) {
            return ['flag' => false, 'errors' => ['Keine Vorlage ausgewählt.']];
        }

        $templateModel = new FormTemplate();
        $template = $templateModel->getById($templateId);
        if ($template === null) {
            return ['flag' => false, 'errors' => ['Vorlage nicht gefunden.']];
        }

        $formModel = new Form();
        $title = $template->name;
        $slug = $formModel->generateSlug($title);

        $formId = $formModel->create([
            'title'         => $title,
            'slug'          => $slug,
            'description'   => $template->description ?? null,
            'fields_json'   => $template->fields_json,
            'settings_json' => $template->settings_json ?? null,
            'status'        => 'draft',
        ]);

        // Create default confirmation
        $confirmationModel = new FormConfirmation();
        $confirmationModel->create([
            'form_id'    => $formId,
            'name'       => 'Standard-Bestätigung',
            'type'       => 'message',
            'message'    => 'Vielen Dank! Ihre Nachricht wurde erfolgreich gesendet.',
            'is_default' => 1,
        ]);

        // Create notifications from template if available
        if (!empty($template->notifications_json)) {
            $notifications = json_decode($template->notifications_json, true);
            if (is_array($notifications)) {
                $notifModel = new FormNotification();
                foreach ($notifications as $notif) {
                    $notif['form_id'] = $formId;
                    $notifModel->create($notif);
                }
            }
        }

        return [
            'flag'    => true,
            'message' => 'Formular aus Vorlage erstellt.',
            'form_id' => $formId,
        ];
    }

    public function deleteForm(): array
    {
        $formModel = new Form();
        $formId = (int)($this->request['form_id'] ?? 0);

        if ($formId === 0) {
            return ['flag' => false, 'errors' => ['Keine Formular-ID angegeben.']];
        }

        $formModel->delete($formId);
        return ['flag' => true, 'message' => 'Formular gelöscht.'];
    }

    public function duplicateForm(): array
    {
        $formModel = new Form();
        $formId = (int)($this->request['form_id'] ?? 0);

        $newId = $formModel->duplicate($formId);
        if ($newId === null) {
            return ['flag' => false, 'errors' => ['Formular nicht gefunden.']];
        }

        return ['flag' => true, 'message' => 'Formular dupliziert.', 'form_id' => $newId];
    }

    public function getFormData(): array
    {
        $formModel = new Form();
        $formId = (int)($this->request['form_id'] ?? 0);
        $form = $formModel->getById($formId);

        if ($form === null) {
            return ['flag' => false, 'errors' => ['Formular nicht gefunden.']];
        }

        return ['flag' => true, 'form' => $form];
    }

    // ─── Entry Actions ───

    public function deleteEntry(): array
    {
        $entryModel = new FormEntry();
        $entryId = (int)($this->request['entry_id'] ?? 0);
        $entryModel->delete($entryId);
        return ['flag' => true, 'message' => 'Eintrag gelöscht.'];
    }

    public function markEntryRead(): array
    {
        $entryModel = new FormEntry();
        $entryId = (int)($this->request['entry_id'] ?? 0);
        $entryModel->markRead($entryId);
        return ['flag' => true, 'message' => 'Als gelesen markiert.'];
    }

    public function toggleEntryStar(): array
    {
        $entryModel = new FormEntry();
        $entryId = (int)($this->request['entry_id'] ?? 0);
        $entryModel->toggleStar($entryId);
        return ['flag' => true];
    }

    public function trashEntry(): array
    {
        $entryModel = new FormEntry();
        $entryId = (int)($this->request['entry_id'] ?? 0);
        $entryModel->trash($entryId);
        return ['flag' => true, 'message' => 'Eintrag in den Papierkorb verschoben.'];
    }

    public function bulkEntryAction(): array
    {
        $action = $this->request['bulk_action'] ?? '';
        $idsStr = $this->request['entry_ids'] ?? '';
        $ids = array_filter(array_map('intval', explode(',', $idsStr)));

        if (empty($ids)) {
            return ['flag' => false, 'errors' => ['Keine Einträge ausgewählt.']];
        }

        $entryModel = new FormEntry();

        switch ($action) {
            case 'mark_read':
                foreach ($ids as $id) {
                    $entryModel->markRead($id);
                }
                return ['flag' => true, 'message' => count($ids) . ' Einträge als gelesen markiert.'];

            case 'delete':
                foreach ($ids as $id) {
                    $entryModel->trash($id);
                }
                return ['flag' => true, 'message' => count($ids) . ' Einträge gelöscht.'];

            default:
                return ['flag' => false, 'errors' => ['Unbekannte Aktion.']];
        }
    }

    public function exportEntriesCsv(): array
    {
        $formId = (int)($this->request['form_id'] ?? 0);

        if ($formId <= 0) {
            return ['flag' => false, 'errors' => ['Bitte ein Formular zum Export auswählen.']];
        }

        $entryService = new \BbfdesignFormbuilder\Services\EntryService();
        $csv = $entryService->exportCsv($formId);

        $formModel = new Form();
        $form = $formModel->getById($formId);
        $filename = 'formbuilder-' . ($form->slug ?? $formId) . '-' . date('Y-m-d') . '.csv';

        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Pragma: no-cache');
        echo "\xEF\xBB\xBF"; // UTF-8 BOM for Excel
        echo $csv;
        exit;
    }

    // ─── Settings ───

    public function savePluginSetting(): array
    {
        $settingModel = new Setting();
        $defaults = Setting::getDefaults();

        foreach ($defaults as $key => $config) {
            if (isset($this->request[$key])) {
                $settingModel->set($key, $this->request[$key]);
            }
        }

        return ['flag' => true, 'message' => 'Einstellungen gespeichert.'];
    }
}
