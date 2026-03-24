<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

class Migration20260324100001 extends Migration implements IMigration
{
    public function up(): void
    {
        // =====================================================================
        // 1. Default settings
        // =====================================================================
        $altchaHmacKey = \bin2hex(\random_bytes(32));

        $settings = [
            ['plugin_status',              '1',    'general'],
            ['default_from_email',         '',     'email'],
            ['default_from_name',          '',     'email'],
            ['captcha_provider',           'altcha', 'spam'],
            ['honeypot_enabled',           '1',    'spam'],
            ['timing_enabled',             '1',    'spam'],
            ['timing_min_seconds',         '3',    'spam'],
            ['rate_limit_enabled',         '1',    'spam'],
            ['rate_limit_max',             '10',   'spam'],
            ['rate_limit_window',          '3600', 'spam'],
            ['recaptcha_site_key',         '',     'spam'],
            ['recaptcha_secret_key',       '',     'spam'],
            ['turnstile_site_key',         '',     'spam'],
            ['turnstile_secret_key',       '',     'spam'],
            ['friendly_captcha_site_key',  '',     'spam'],
            ['friendly_captcha_secret',    '',     'spam'],
            ['altcha_hmac_key',            $altchaHmacKey, 'spam'],
            ['encryption_enabled',         '0',    'security'],
            ['ip_anonymization',           'last_octet', 'gdpr'],
            ['auto_delete_days',           '365',  'gdpr'],
            ['custom_css',                 '',     'appearance'],
            ['gdpr_checkbox_text',         'Ich stimme der Verarbeitung meiner Daten gem&auml;&szlig; der <a href="/datenschutz">Datenschutzerkl&auml;rung</a> zu.', 'gdpr'],
        ];

        foreach ($settings as [$key, $value, $group]) {
            $escapedValue = \addslashes($value);
            $this->execute(
                "INSERT INTO `bbf_formbuilder_settings` (`setting_key`, `setting_value`, `setting_group`)
                 VALUES ('{$key}', '{$escapedValue}', '{$group}')"
            );
        }

        // =====================================================================
        // 2. System email templates
        // =====================================================================

        // 2a. Standard template - simple passthrough, relies on JTL shop mail layout
        $standardTemplate = '{\$content}';
        $this->execute(
            "INSERT INTO `bbf_formbuilder_email_templates` (`name`, `type`, `html_template`, `is_system`)
             VALUES ('Standard', 'standard', '" . \addslashes($standardTemplate) . "', 1)"
        );

        // 2b. Fancy template - styled HTML email
        $fancyTemplate = <<<'HTML'
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{$subject}</title>
<style>
body { margin: 0; padding: 0; background-color: #f4f5f7; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; }
.wrapper { width: 100%; background-color: #f4f5f7; padding: 40px 0; }
.container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
.header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 32px 40px; text-align: center; }
.header h1 { color: #ffffff; margin: 0; font-size: 22px; font-weight: 600; }
.header p { color: rgba(255,255,255,0.85); margin: 8px 0 0; font-size: 14px; }
.content { padding: 32px 40px; }
.fields-table { width: 100%; border-collapse: collapse; margin: 16px 0; }
.fields-table tr { border-bottom: 1px solid #edf2f7; }
.fields-table td { padding: 12px 8px; vertical-align: top; font-size: 14px; color: #4a5568; }
.fields-table td.label { font-weight: 600; color: #2d3748; width: 35%; white-space: nowrap; }
.fields-table td.value { color: #4a5568; }
.meta { padding: 20px 40px; background-color: #f7fafc; border-top: 1px solid #edf2f7; font-size: 12px; color: #a0aec0; }
.meta table { width: 100%; }
.meta td { padding: 2px 0; }
.footer { padding: 24px 40px; text-align: center; font-size: 12px; color: #a0aec0; background-color: #f4f5f7; }
</style>
</head>
<body>
<div class="wrapper">
  <div class="container">
    <div class="header">
      <h1>{$form_title}</h1>
      <p>Neue Formular-Einsendung</p>
    </div>
    <div class="content">
      <table class="fields-table">
        {$fields_html}
      </table>
    </div>
    <div class="meta">
      <table>
        <tr><td>Eingegangen:</td><td>{$submitted_at}</td></tr>
        <tr><td>IP-Adresse:</td><td>{$ip_address}</td></tr>
        <tr><td>Seite:</td><td>{$page_url}</td></tr>
      </table>
    </div>
    <div class="footer">
      Diese E-Mail wurde automatisch vom Formular-Plugin gesendet.
    </div>
  </div>
</div>
</body>
</html>
HTML;

        $this->execute(
            "INSERT INTO `bbf_formbuilder_email_templates` (`name`, `type`, `html_template`, `is_system`)
             VALUES ('Fancy', 'fancy', '" . \addslashes($fancyTemplate) . "', 1)"
        );

        // =====================================================================
        // 3. System form templates
        // =====================================================================

        // 3a. Einfaches Kontaktformular
        $contactFieldsJson = \json_encode([
            [
                'id'          => 'field_name',
                'type'        => 'text',
                'label'       => 'Name',
                'placeholder' => 'Ihr Name',
                'required'    => true,
                'width'       => 'half',
                'sort_order'  => 0,
            ],
            [
                'id'          => 'field_email',
                'type'        => 'email',
                'label'       => 'E-Mail-Adresse',
                'placeholder' => 'Ihre E-Mail-Adresse',
                'required'    => true,
                'width'       => 'half',
                'sort_order'  => 1,
            ],
            [
                'id'          => 'field_subject',
                'type'        => 'text',
                'label'       => 'Betreff',
                'placeholder' => 'Betreff Ihrer Nachricht',
                'required'    => true,
                'width'       => 'full',
                'sort_order'  => 2,
            ],
            [
                'id'          => 'field_message',
                'type'        => 'textarea',
                'label'       => 'Nachricht',
                'placeholder' => 'Ihre Nachricht...',
                'required'    => true,
                'width'       => 'full',
                'rows'        => 6,
                'sort_order'  => 3,
            ],
            [
                'id'          => 'field_gdpr',
                'type'        => 'gdpr',
                'label'       => 'Datenschutz',
                'required'    => true,
                'width'       => 'full',
                'sort_order'  => 4,
            ],
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $contactSettingsJson = \json_encode([
            'submit_button_text' => 'Nachricht senden',
            'success_message'    => 'Vielen Dank f\u00fcr Ihre Nachricht! Wir werden uns so schnell wie m\u00f6glich bei Ihnen melden.',
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $contactNotificationsJson = \json_encode([
            [
                'name'           => 'Admin-Benachrichtigung',
                'recipient_type' => 'admin',
                'subject'        => 'Neue Kontaktanfrage: {field_subject}',
                'email_template' => 'fancy',
            ],
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $this->execute(
            "INSERT INTO `bbf_formbuilder_templates`
                (`name`, `description`, `category`, `icon`, `fields_json`, `settings_json`, `notifications_json`, `is_system`, `sort_order`)
             VALUES (
                'Einfaches Kontaktformular',
                'Ein schlichtes Kontaktformular mit Name, E-Mail, Betreff und Nachricht.',
                'Kontakt',
                'mail',
                '" . \addslashes($contactFieldsJson) . "',
                '" . \addslashes($contactSettingsJson) . "',
                '" . \addslashes($contactNotificationsJson) . "',
                1,
                0
             )"
        );

        // 3b. Erweiterte Kontaktanfrage
        $advancedContactFieldsJson = \json_encode([
            [
                'id'          => 'field_salutation',
                'type'        => 'select',
                'label'       => 'Anrede',
                'required'    => true,
                'width'       => 'third',
                'options'     => [
                    ['value' => '', 'label' => 'Bitte w\u00e4hlen...'],
                    ['value' => 'herr', 'label' => 'Herr'],
                    ['value' => 'frau', 'label' => 'Frau'],
                    ['value' => 'divers', 'label' => 'Divers'],
                ],
                'sort_order'  => 0,
            ],
            [
                'id'          => 'field_firstname',
                'type'        => 'text',
                'label'       => 'Vorname',
                'placeholder' => 'Ihr Vorname',
                'required'    => true,
                'width'       => 'third',
                'sort_order'  => 1,
            ],
            [
                'id'          => 'field_lastname',
                'type'        => 'text',
                'label'       => 'Nachname',
                'placeholder' => 'Ihr Nachname',
                'required'    => true,
                'width'       => 'third',
                'sort_order'  => 2,
            ],
            [
                'id'          => 'field_email',
                'type'        => 'email',
                'label'       => 'E-Mail-Adresse',
                'placeholder' => 'Ihre E-Mail-Adresse',
                'required'    => true,
                'width'       => 'half',
                'sort_order'  => 3,
            ],
            [
                'id'          => 'field_phone',
                'type'        => 'text',
                'label'       => 'Telefonnummer',
                'placeholder' => 'Ihre Telefonnummer',
                'required'    => false,
                'width'       => 'half',
                'sort_order'  => 4,
            ],
            [
                'id'          => 'field_company',
                'type'        => 'text',
                'label'       => 'Firma',
                'placeholder' => 'Firmenname (optional)',
                'required'    => false,
                'width'       => 'full',
                'sort_order'  => 5,
            ],
            [
                'id'          => 'field_subject',
                'type'        => 'select',
                'label'       => 'Betreff',
                'required'    => true,
                'width'       => 'full',
                'options'     => [
                    ['value' => '', 'label' => 'Bitte w\u00e4hlen...'],
                    ['value' => 'allgemein', 'label' => 'Allgemeine Anfrage'],
                    ['value' => 'bestellung', 'label' => 'Frage zu einer Bestellung'],
                    ['value' => 'produkt', 'label' => 'Produktanfrage'],
                    ['value' => 'reklamation', 'label' => 'Reklamation'],
                    ['value' => 'sonstiges', 'label' => 'Sonstiges'],
                ],
                'sort_order'  => 6,
            ],
            [
                'id'          => 'field_order_number',
                'type'        => 'text',
                'label'       => 'Bestellnummer',
                'placeholder' => 'Falls vorhanden',
                'required'    => false,
                'width'       => 'full',
                'sort_order'  => 7,
            ],
            [
                'id'          => 'field_message',
                'type'        => 'textarea',
                'label'       => 'Nachricht',
                'placeholder' => 'Beschreiben Sie Ihr Anliegen...',
                'required'    => true,
                'width'       => 'full',
                'rows'        => 8,
                'sort_order'  => 8,
            ],
            [
                'id'          => 'field_attachment',
                'type'        => 'file',
                'label'       => 'Anhang',
                'required'    => false,
                'width'       => 'full',
                'allowed_extensions' => ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
                'max_file_size'      => 5242880,
                'sort_order'  => 9,
            ],
            [
                'id'          => 'field_gdpr',
                'type'        => 'gdpr',
                'label'       => 'Datenschutz',
                'required'    => true,
                'width'       => 'full',
                'sort_order'  => 10,
            ],
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $advancedContactSettingsJson = \json_encode([
            'submit_button_text' => 'Anfrage absenden',
            'success_message'    => 'Vielen Dank f\u00fcr Ihre Anfrage! Wir werden uns zeitnah bei Ihnen melden.',
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $advancedContactNotificationsJson = \json_encode([
            [
                'name'           => 'Admin-Benachrichtigung',
                'recipient_type' => 'admin',
                'subject'        => 'Neue Kontaktanfrage von {field_firstname} {field_lastname}',
                'email_template' => 'fancy',
            ],
            [
                'name'           => 'Best\u00e4tigung an Kunden',
                'recipient_type' => 'field',
                'recipient_field' => 'field_email',
                'subject'        => 'Ihre Anfrage bei uns - Eingangsbest\u00e4tigung',
                'email_template' => 'standard',
            ],
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $this->execute(
            "INSERT INTO `bbf_formbuilder_templates`
                (`name`, `description`, `category`, `icon`, `fields_json`, `settings_json`, `notifications_json`, `is_system`, `sort_order`)
             VALUES (
                'Erweiterte Kontaktanfrage',
                'Umfassendes Kontaktformular mit Anrede, Firmenfeld, Betreffauswahl, Datei-Upload und mehr.',
                'Kontakt',
                'mail-plus',
                '" . \addslashes($advancedContactFieldsJson) . "',
                '" . \addslashes($advancedContactSettingsJson) . "',
                '" . \addslashes($advancedContactNotificationsJson) . "',
                1,
                1
             )"
        );

        // 3c. Rückruf-Formular
        $callbackFieldsJson = \json_encode([
            [
                'id'          => 'field_name',
                'type'        => 'text',
                'label'       => 'Name',
                'placeholder' => 'Ihr Name',
                'required'    => true,
                'width'       => 'half',
                'sort_order'  => 0,
            ],
            [
                'id'          => 'field_phone',
                'type'        => 'text',
                'label'       => 'Telefonnummer',
                'placeholder' => 'Unter welcher Nummer erreichen wir Sie?',
                'required'    => true,
                'width'       => 'half',
                'sort_order'  => 1,
            ],
            [
                'id'          => 'field_email',
                'type'        => 'email',
                'label'       => 'E-Mail-Adresse',
                'placeholder' => 'Ihre E-Mail-Adresse',
                'required'    => false,
                'width'       => 'full',
                'sort_order'  => 2,
            ],
            [
                'id'          => 'field_preferred_time',
                'type'        => 'select',
                'label'       => 'Gew\u00fcnschte R\u00fcckrufzeit',
                'required'    => true,
                'width'       => 'half',
                'options'     => [
                    ['value' => '', 'label' => 'Bitte w\u00e4hlen...'],
                    ['value' => 'vormittag', 'label' => 'Vormittags (9-12 Uhr)'],
                    ['value' => 'nachmittag', 'label' => 'Nachmittags (12-17 Uhr)'],
                    ['value' => 'abend', 'label' => 'Abends (17-19 Uhr)'],
                    ['value' => 'egal', 'label' => 'Jederzeit'],
                ],
                'sort_order'  => 3,
            ],
            [
                'id'          => 'field_urgency',
                'type'        => 'select',
                'label'       => 'Dringlichkeit',
                'required'    => false,
                'width'       => 'half',
                'options'     => [
                    ['value' => '', 'label' => 'Bitte w\u00e4hlen...'],
                    ['value' => 'normal', 'label' => 'Normal'],
                    ['value' => 'dringend', 'label' => 'Dringend'],
                ],
                'sort_order'  => 4,
            ],
            [
                'id'          => 'field_topic',
                'type'        => 'text',
                'label'       => 'Thema',
                'placeholder' => 'Worum geht es? (optional)',
                'required'    => false,
                'width'       => 'full',
                'sort_order'  => 5,
            ],
            [
                'id'          => 'field_gdpr',
                'type'        => 'gdpr',
                'label'       => 'Datenschutz',
                'required'    => true,
                'width'       => 'full',
                'sort_order'  => 6,
            ],
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $callbackSettingsJson = \json_encode([
            'submit_button_text' => 'R\u00fcckruf anfordern',
            'success_message'    => 'Vielen Dank! Wir rufen Sie so schnell wie m\u00f6glich zur\u00fcck.',
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $callbackNotificationsJson = \json_encode([
            [
                'name'           => 'Admin-Benachrichtigung',
                'recipient_type' => 'admin',
                'subject'        => 'Neuer R\u00fcckrufwunsch von {field_name}',
                'email_template' => 'fancy',
            ],
        ], \JSON_UNESCAPED_UNICODE | \JSON_UNESCAPED_SLASHES);

        $this->execute(
            "INSERT INTO `bbf_formbuilder_templates`
                (`name`, `description`, `category`, `icon`, `fields_json`, `settings_json`, `notifications_json`, `is_system`, `sort_order`)
             VALUES (
                'R\u00fcckruf-Formular',
                'Formular f\u00fcr R\u00fcckrufanfragen mit Telefonnummer, Wunschzeit und Dringlichkeit.',
                'Service',
                'phone',
                '" . \addslashes($callbackFieldsJson) . "',
                '" . \addslashes($callbackSettingsJson) . "',
                '" . \addslashes($callbackNotificationsJson) . "',
                1,
                2
             )"
        );
    }

    public function down(): void
    {
        $this->execute("DELETE FROM `bbf_formbuilder_templates` WHERE `is_system` = 1");
        $this->execute("DELETE FROM `bbf_formbuilder_email_templates` WHERE `is_system` = 1");
        $this->execute("TRUNCATE TABLE `bbf_formbuilder_settings`");
    }
}
