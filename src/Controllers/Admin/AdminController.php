<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Controllers\Admin;

use BbfdesignFormbuilder\Models\ApiConnection;
use BbfdesignFormbuilder\Models\ApiEndpoint;
use BbfdesignFormbuilder\Models\ApiLog;
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

    /**
     * Render a Smarty template with variables properly assigned.
     */
    private function renderTemplate(string $template, array $vars = []): string
    {
        if (!empty($vars)) {
            $this->smarty->assign($vars);
        }
        return $this->smarty->fetch($template);
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
            case 'saveFormBuilder':
                return $this->saveFormBuilder();
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
            case 'saveApiConnection':
                return $this->saveApiConnection();
            case 'deleteApiConnection':
                return $this->deleteApiConnection();
            case 'saveApiEndpoint':
                return $this->saveApiEndpoint();
            case 'deleteApiEndpoint':
                return $this->deleteApiEndpoint();
            case 'testApiConnection':
                return $this->testApiConnection();
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
            case 'api-connections':
                $content = $this->renderApiConnections();
                break;
            case 'documentation':
                $content = $this->renderTemplate($this->adminTemplatePath . 'templates/documentation.tpl');
                break;
            case 'changelog':
                $content = $this->renderTemplate($this->adminTemplatePath . 'templates/changelog.tpl');
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

            return $this->renderTemplate(
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
        return $this->renderTemplate(
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

        $plugin = $this->plugin;

        // Canvas-CSS dynamisch aus aktivem Shop-Template ermitteln
        $canvasStyles = [];
        $templateDir = '';
        try {
            $shopUrl = Shop::getURL();
            $oTemplate = Shop::Container()->getTemplateService()->getActiveTemplate();
            $templateDir = $oTemplate->getDir();

            // Bootstrap des aktiven Templates (mehrere Pfad-Kandidaten)
            $bootstrapCandidates = [
                '/templates/' . $templateDir . '/themes/base/bootstrap/bootstrap.min.css',
                '/templates/' . $templateDir . '/themes/base/css/bootstrap.min.css',
                '/templates/' . $templateDir . '/bootstrap/bootstrap.min.css',
            ];
            foreach ($bootstrapCandidates as $candidate) {
                if (file_exists(\PFAD_ROOT . ltrim($candidate, '/'))) {
                    $canvasStyles[] = $shopUrl . $candidate;
                    break;
                }
            }

            // Template Haupt-CSS (mehrere Pfad-Kandidaten)
            $mainCssCandidates = [
                '/templates/' . $templateDir . '/themes/base/css/theme.css',
                '/templates/' . $templateDir . '/themes/base/css/custom.css',
                '/templates/' . $templateDir . '/css/style.css',
            ];
            foreach ($mainCssCandidates as $candidate) {
                if (file_exists(\PFAD_ROOT . ltrim($candidate, '/'))) {
                    $canvasStyles[] = $shopUrl . $candidate;
                    break;
                }
            }
        } catch (\Throwable $e) {
            // Fallback: Bootstrap CDN
            $canvasStyles[] = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css';
        }

        // Plugin Frontend-CSS (immer laden)
        $canvasStyles[] = $plugin->getPaths()->getFrontendURL() . 'css/bbf-forms.css';

        return $this->renderTemplate(
            $this->adminTemplatePath . 'templates/form-builder.tpl',
            [
                'form'              => $form,
                'template'          => $template,
                'formId'            => $formId,
                'postURL'           => $plugin->getPaths()->getBackendURL(),
                'pluginFrontendUrl' => $plugin->getPaths()->getFrontendURL(),
                'canvasStyles'      => json_encode($canvasStyles),
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

        return $this->renderTemplate(
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

        return $this->renderTemplate(
            $this->adminTemplatePath . 'templates/entries.tpl',
            [
                'entries'      => $entries,
                'forms'        => $formModel->getAll(),
                'filterFormId' => $formId,
                'totalPages'   => 0,
                'currentPage'  => 1,
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

        return $this->renderTemplate(
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
        return $this->renderTemplate(
            $this->adminTemplatePath . 'templates/templates.tpl',
            ['templates' => $templateModel->getAll()]
        );
    }

    private function renderSettings(): string
    {
        return $this->renderTemplate(
            $this->adminTemplatePath . 'templates/settings.tpl',
            ['settings' => PluginHelper::getSettingsWithDefaults()]
        );
    }

    private function renderSpamProtection(): string
    {
        return $this->renderTemplate(
            $this->adminTemplatePath . 'templates/spam-protection.tpl',
            ['settings' => PluginHelper::getSettingsWithDefaults()]
        );
    }

    private function renderGdpr(): string
    {
        return $this->renderTemplate(
            $this->adminTemplatePath . 'templates/gdpr.tpl',
            ['settings' => PluginHelper::getSettingsWithDefaults()]
        );
    }

    private function renderEmailTemplates(): string
    {
        $emailTemplateModel = new EmailTemplate();
        return $this->renderTemplate(
            $this->adminTemplatePath . 'templates/email-templates.tpl',
            ['emailTemplates' => $emailTemplateModel->getAll()]
        );
    }

    private function renderCssEditor(): string
    {
        return $this->renderTemplate(
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

        try {
            $formId = $formModel->create([
                'title'       => $title,
                'slug'        => $slug,
                'description' => $this->request['description'] ?? '',
                'fields_json' => $fieldsJson,
                'status'      => 'draft',
            ]);
        } catch (\Throwable $e) {
            return ['flag' => false, 'errors' => ['DB-Fehler: ' . $e->getMessage()]];
        }

        if ($formId <= 0) {
            return ['flag' => false, 'errors' => ['Formular konnte nicht erstellt werden. Bitte JTL-Systemlog prüfen.']];
        }

        // Create default confirmation
        try {
            $confirmationModel = new FormConfirmation();
            $confirmationModel->create([
                'form_id'    => $formId,
                'name'       => 'Standard-Bestätigung',
                'type'       => 'message',
                'message'    => 'Vielen Dank! Ihre Nachricht wurde erfolgreich gesendet.',
                'is_default' => 1,
            ]);
        } catch (\Throwable $e) {
            // Confirmation ist optional — Formular trotzdem zurückgeben
        }

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
        if (isset($this->request['allow_in_account'])) {
            $data['allow_in_account'] = (int)$this->request['allow_in_account'];
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
            'description'   => $template->description ?? '',
            'fields_json'   => $template->fields_json ?? '[]',
            'settings_json' => $template->settings_json ?? '',
            'status'        => 'draft',
        ]);

        if ($formId <= 0) {
            return ['flag' => false, 'errors' => ['Formular konnte nicht erstellt werden.']];
        }

        // Create default confirmation (optional, don't fail if it doesn't work)
        try {
            $confirmationModel = new FormConfirmation();
            $confirmationModel->create([
                'form_id'    => $formId,
                'name'       => 'Standard-Bestätigung',
                'type'       => 'message',
                'message'    => 'Vielen Dank! Ihre Nachricht wurde erfolgreich gesendet.',
                'is_default' => 1,
            ]);
        } catch (\Throwable $e) {
            // Non-critical
        }

        // Create notifications from template if available
        if (!empty($template->notifications_json)) {
            try {
                $notifications = json_decode($template->notifications_json, true);
                if (is_array($notifications)) {
                    $notifModel = new FormNotification();
                    foreach ($notifications as $notif) {
                        $notif['form_id'] = $formId;
                        $notifModel->create($notif);
                    }
                }
            } catch (\Throwable $e) {
                // Non-critical
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

    // ─── GrapesJS Builder ───

    public function saveFormBuilder(): array
    {
        $formId = (int)($this->request['form_id'] ?? 0);
        $formModel = new Form();

        // If no form yet, create one
        if ($formId <= 0) {
            $title = trim($this->request['title'] ?? 'Neues Formular');
            $formId = $formModel->create([
                'title'       => $title,
                'slug'        => $formModel->generateSlug($title),
                'description' => '',
                'fields_json' => $this->request['fields_json'] ?? '[]',
                'status'      => 'draft',
            ]);
            if ($formId <= 0) {
                return ['flag' => false, 'errors' => ['Formular konnte nicht erstellt werden.']];
            }
        }

        // Update GrapesJS data
        try {
            $db = Shop::Container()->getDB();
            $db->queryPrepared(
                'UPDATE `bbf_formbuilder_forms` SET
                    gjs_data = :gjs_data,
                    html_rendered = :html,
                    css_rendered = :css,
                    fields_json = :fields_json
                 WHERE id = :id',
                [
                    'gjs_data'    => $this->request['gjs_data'] ?? '',
                    'html'        => $this->request['html_rendered'] ?? '',
                    'css'         => $this->request['css_rendered'] ?? '',
                    'fields_json' => $this->request['fields_json'] ?? '[]',
                    'id'          => $formId,
                ]
            );

            // Update title if provided
            if (!empty($this->request['title'])) {
                $formModel->update($formId, ['title' => trim($this->request['title'])]);
            }
        } catch (\Throwable $e) {
            return ['flag' => false, 'errors' => ['Speichern fehlgeschlagen: ' . $e->getMessage()]];
        }

        return ['flag' => true, 'message' => 'Formular gespeichert.', 'form_id' => $formId];
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

    // ─── API Connections ───

    private function renderApiConnections(): string
    {
        $connModel = new ApiConnection();
        $endpointModel = new ApiEndpoint();
        $logModel = new ApiLog();

        return $this->renderTemplate(
            $this->adminTemplatePath . 'templates/api-connections.tpl',
            [
                'connections' => $connModel->getAll(),
                'endpoints' => $endpointModel->getAll(),
                'logs' => $logModel->getAll([], 50),
            ]
        );
    }

    public function saveApiConnection(): array
    {
        $connModel = new ApiConnection();
        $id = (int)($this->request['connection_id'] ?? 0);

        $data = [
            'name' => trim($this->request['name'] ?? ''),
            'description' => $this->request['description'] ?? '',
            'base_url' => trim($this->request['base_url'] ?? ''),
            'auth_type' => $this->request['auth_type'] ?? 'none',
            'auth_config' => $this->request['auth_config'] ?? '{}',
            'headers' => $this->request['headers'] ?? '{}',
            'timeout' => (int)($this->request['timeout'] ?? 30),
            'active' => (int)($this->request['active'] ?? 1),
        ];

        if (empty($data['name']) || empty($data['base_url'])) {
            return ['flag' => false, 'errors' => ['Name und Base-URL sind erforderlich.']];
        }

        if ($id > 0) {
            $connModel->update($id, $data);
            return ['flag' => true, 'message' => 'Verbindung aktualisiert.'];
        }

        $newId = $connModel->create($data);
        return ['flag' => true, 'message' => 'Verbindung erstellt.', 'connection_id' => $newId];
    }

    public function deleteApiConnection(): array
    {
        $connModel = new ApiConnection();
        $id = (int)($this->request['connection_id'] ?? 0);
        if ($id <= 0) {
            return ['flag' => false, 'errors' => ['Keine Verbindung angegeben.']];
        }
        $connModel->delete($id);
        return ['flag' => true, 'message' => 'Verbindung gelöscht.'];
    }

    public function saveApiEndpoint(): array
    {
        $endpointModel = new ApiEndpoint();
        $id = (int)($this->request['endpoint_id'] ?? 0);

        $data = [
            'connection_id' => (int)($this->request['connection_id'] ?? 0),
            'name' => trim($this->request['name'] ?? ''),
            'method' => $this->request['method'] ?? 'POST',
            'path' => trim($this->request['path'] ?? ''),
            'content_type' => $this->request['content_type'] ?? 'application/json',
            'trigger_on' => $this->request['trigger_on'] ?? 'submit',
            'field_mapping' => $this->request['field_mapping'] ?? '[]',
            'response_map' => $this->request['response_map'] ?? '{}',
            'error_map' => $this->request['error_map'] ?? '{}',
            'active' => (int)($this->request['active'] ?? 1),
        ];

        if (empty($data['name']) || empty($data['path']) || $data['connection_id'] <= 0) {
            return ['flag' => false, 'errors' => ['Name, Pfad und Verbindung sind erforderlich.']];
        }

        if ($id > 0) {
            $endpointModel->update($id, $data);
            return ['flag' => true, 'message' => 'Endpunkt aktualisiert.'];
        }

        $newId = $endpointModel->create($data);
        return ['flag' => true, 'message' => 'Endpunkt erstellt.', 'endpoint_id' => $newId];
    }

    public function deleteApiEndpoint(): array
    {
        $endpointModel = new ApiEndpoint();
        $id = (int)($this->request['endpoint_id'] ?? 0);
        if ($id <= 0) {
            return ['flag' => false, 'errors' => ['Kein Endpunkt angegeben.']];
        }
        $endpointModel->delete($id);
        return ['flag' => true, 'message' => 'Endpunkt gelöscht.'];
    }

    public function testApiConnection(): array
    {
        $baseUrl = trim($this->request['base_url'] ?? '');
        if (empty($baseUrl)) {
            return ['flag' => false, 'errors' => ['Keine URL angegeben.']];
        }

        $ch = curl_init($baseUrl);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 10,
            CURLOPT_NOBODY => true,
            CURLOPT_FOLLOWLOCATION => true,
        ]);
        curl_exec($ch);
        $statusCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($statusCode > 0) {
            return ['flag' => true, 'message' => 'Verbindung erfolgreich (HTTP ' . $statusCode . ')'];
        }
        return ['flag' => false, 'errors' => ['Verbindung fehlgeschlagen: ' . ($error ?: 'Kein Status')]];
    }
}
