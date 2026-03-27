<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

/**
 * Seed 8 system form templates.
 */
class Migration20260327100002 extends Migration implements IMigration
{
    public function up(): void
    {
        $templates = $this->getTemplates();

        foreach ($templates as $tpl) {
            // Prüfe ob Template mit diesem Namen bereits existiert
            $exists = $this->getDB()->queryPrepared(
                "SELECT id FROM bbf_formbuilder_templates WHERE name = :name LIMIT 1",
                ['name' => $tpl['name']]
            );

            if (!empty($exists) && is_array($exists)) {
                continue;
            }

            $this->getDB()->queryPrepared(
                "INSERT INTO bbf_formbuilder_templates
                 (name, description, category, fields_json, settings_json, sort_order, is_system)
                 VALUES (:name, :desc, :cat, :fields, :settings, :sort, 1)",
                [
                    'name' => $tpl['name'],
                    'desc' => $tpl['description'],
                    'cat' => $tpl['category'],
                    'fields' => json_encode($tpl['fields'], JSON_UNESCAPED_UNICODE),
                    'settings' => '{}',
                    'sort' => $tpl['sort'],
                ]
            );
        }
    }

    public function down(): void
    {
        $this->execute("DELETE FROM bbf_formbuilder_templates WHERE is_system = 1 AND sort_order >= 20");
    }

    private function getTemplates(): array
    {
        return [
            // 1. Kontaktformular
            [
                'name' => 'Kontaktformular',
                'description' => 'Standard-Kontaktformular mit Name, E-Mail, Betreff und Nachricht.',
                'category' => 'standard',
                'sort' => 20,
                'fields' => [
                    ['id' => 'name', 'type' => 'name', 'label' => 'Name', 'required' => true],
                    ['id' => 'email', 'type' => 'email', 'label' => 'E-Mail-Adresse', 'required' => true, 'placeholder' => 'name@beispiel.de'],
                    ['id' => 'telefon', 'type' => 'phone', 'label' => 'Telefon', 'required' => false, 'placeholder' => '+49 ...'],
                    ['id' => 'betreff', 'type' => 'select', 'label' => 'Betreff', 'required' => true, 'options' => ['Allgemeine Anfrage', 'Bestellanfrage', 'Reklamation', 'Sonstiges']],
                    ['id' => 'nachricht', 'type' => 'textarea', 'label' => 'Ihre Nachricht', 'required' => true, 'placeholder' => 'Wie können wir Ihnen helfen?'],
                    ['id' => 'dsgvo', 'type' => 'gdpr', 'label' => 'Datenschutz', 'required' => true],
                ],
            ],
            // 2. Retourenantrag
            [
                'name' => 'Retourenantrag',
                'description' => 'Retourenanfrage mit Bestellnummer, Grund und optionalem Foto-Upload.',
                'category' => 'ecommerce',
                'sort' => 21,
                'fields' => [
                    ['id' => 'vorname', 'type' => 'text', 'label' => 'Vorname', 'required' => true],
                    ['id' => 'nachname', 'type' => 'text', 'label' => 'Nachname', 'required' => true],
                    ['id' => 'email', 'type' => 'email', 'label' => 'E-Mail', 'required' => true],
                    ['id' => 'bestellnummer', 'type' => 'text', 'label' => 'Bestellnummer', 'required' => true, 'placeholder' => 'z.B. 100001234'],
                    ['id' => 'artikel', 'type' => 'text', 'label' => 'Betroffener Artikel', 'required' => true],
                    ['id' => 'grund', 'type' => 'select', 'label' => 'Retourengrund', 'required' => true, 'options' => ['Defekt/Beschädigt', 'Falscher Artikel geliefert', 'Gefällt nicht', 'Größe passt nicht', 'Sonstiges']],
                    ['id' => 'beschreibung', 'type' => 'textarea', 'label' => 'Beschreibung', 'required' => false, 'placeholder' => 'Bitte beschreiben Sie das Problem...'],
                    ['id' => 'foto', 'type' => 'file_upload', 'label' => 'Foto (optional)', 'required' => false],
                    ['id' => 'dsgvo', 'type' => 'gdpr', 'label' => 'Datenschutz', 'required' => true],
                ],
            ],
            // 3. Angebotsanfrage
            [
                'name' => 'Angebotsanfrage',
                'description' => 'B2B-Angebotsanfrage mit Firma, Produkt-Interesse und Menge.',
                'category' => 'ecommerce',
                'sort' => 22,
                'fields' => [
                    ['id' => 'firma', 'type' => 'text', 'label' => 'Firma', 'required' => false],
                    ['id' => 'name', 'type' => 'name', 'label' => 'Name', 'required' => true],
                    ['id' => 'email', 'type' => 'email', 'label' => 'E-Mail', 'required' => true],
                    ['id' => 'telefon', 'type' => 'phone', 'label' => 'Telefon', 'required' => false],
                    ['id' => 'produkt', 'type' => 'text', 'label' => 'Produkt-Interesse', 'required' => true],
                    ['id' => 'menge', 'type' => 'number', 'label' => 'Gewünschte Menge', 'required' => false],
                    ['id' => 'wunschtermin', 'type' => 'date', 'label' => 'Wunschtermin', 'required' => false],
                    ['id' => 'nachricht', 'type' => 'textarea', 'label' => 'Nachricht', 'required' => false],
                    ['id' => 'dsgvo', 'type' => 'gdpr', 'label' => 'Datenschutz', 'required' => true],
                ],
            ],
            // 4. Feedback / Bewertung
            [
                'name' => 'Feedback-Formular',
                'description' => 'Kundenfeedback mit Bewertung, Kommentaren und Empfehlung.',
                'category' => 'feedback',
                'sort' => 23,
                'fields' => [
                    ['id' => 'name', 'type' => 'text', 'label' => 'Name', 'required' => false],
                    ['id' => 'email', 'type' => 'email', 'label' => 'E-Mail', 'required' => true],
                    ['id' => 'produkt', 'type' => 'text', 'label' => 'Produkt/Bestellung', 'required' => false],
                    ['id' => 'bewertung', 'type' => 'rating', 'label' => 'Gesamtbewertung', 'required' => true],
                    ['id' => 'positiv', 'type' => 'textarea', 'label' => 'Was hat Ihnen gefallen?', 'required' => false],
                    ['id' => 'verbesserung', 'type' => 'textarea', 'label' => 'Was können wir verbessern?', 'required' => false],
                    ['id' => 'empfehlung', 'type' => 'radio', 'label' => 'Würden Sie uns weiterempfehlen?', 'required' => true, 'options' => ['Ja', 'Nein', 'Vielleicht']],
                    ['id' => 'dsgvo', 'type' => 'gdpr', 'label' => 'Datenschutz', 'required' => true],
                ],
            ],
            // 5. Terminanfrage
            [
                'name' => 'Terminanfrage',
                'description' => 'Terminbuchung mit Wunschdatum, Uhrzeit und Alternativtermin.',
                'category' => 'standard',
                'sort' => 24,
                'fields' => [
                    ['id' => 'name', 'type' => 'name', 'label' => 'Name', 'required' => true],
                    ['id' => 'email', 'type' => 'email', 'label' => 'E-Mail', 'required' => true],
                    ['id' => 'telefon', 'type' => 'phone', 'label' => 'Telefon', 'required' => false],
                    ['id' => 'terminart', 'type' => 'select', 'label' => 'Terminart', 'required' => true, 'options' => ['Beratungsgespräch', 'Vor-Ort-Termin', 'Online-Meeting', 'Telefon']],
                    ['id' => 'wunschdatum', 'type' => 'date', 'label' => 'Wunschdatum', 'required' => true],
                    ['id' => 'wunschuhrzeit', 'type' => 'time', 'label' => 'Wunschuhrzeit', 'required' => false],
                    ['id' => 'alternativdatum', 'type' => 'date', 'label' => 'Alternativdatum', 'required' => false],
                    ['id' => 'nachricht', 'type' => 'textarea', 'label' => 'Anmerkungen', 'required' => false],
                    ['id' => 'dsgvo', 'type' => 'gdpr', 'label' => 'Datenschutz', 'required' => true],
                ],
            ],
            // 6. Bewerbungsformular
            [
                'name' => 'Bewerbungsformular',
                'description' => 'Stellenbewerbung mit Lebenslauf-Upload und Gehaltsvorstellung.',
                'category' => 'standard',
                'sort' => 25,
                'fields' => [
                    ['id' => 'vorname', 'type' => 'text', 'label' => 'Vorname', 'required' => true],
                    ['id' => 'nachname', 'type' => 'text', 'label' => 'Nachname', 'required' => true],
                    ['id' => 'email', 'type' => 'email', 'label' => 'E-Mail', 'required' => true],
                    ['id' => 'telefon', 'type' => 'phone', 'label' => 'Telefon', 'required' => false],
                    ['id' => 'stelle', 'type' => 'text', 'label' => 'Gewünschte Stelle', 'required' => true],
                    ['id' => 'eintrittsdatum', 'type' => 'date', 'label' => 'Frühester Eintrittstermin', 'required' => false],
                    ['id' => 'gehalt', 'type' => 'text', 'label' => 'Gehaltsvorstellung', 'required' => false, 'placeholder' => 'z.B. 45.000 € brutto/Jahr'],
                    ['id' => 'lebenslauf', 'type' => 'file_upload', 'label' => 'Lebenslauf (PDF)', 'required' => true],
                    ['id' => 'anschreiben', 'type' => 'textarea', 'label' => 'Anschreiben / Motivation', 'required' => false],
                    ['id' => 'dsgvo', 'type' => 'gdpr', 'label' => 'Datenschutz-Einwilligung', 'required' => true],
                ],
            ],
            // 7. Support-Ticket
            [
                'name' => 'Support-Ticket',
                'description' => 'Kundensupport mit Kategorie, Priorität und Screenshot-Upload.',
                'category' => 'ecommerce',
                'sort' => 26,
                'fields' => [
                    ['id' => 'name', 'type' => 'text', 'label' => 'Name', 'required' => true],
                    ['id' => 'email', 'type' => 'email', 'label' => 'E-Mail', 'required' => true],
                    ['id' => 'bestellnummer', 'type' => 'text', 'label' => 'Bestellnummer (falls vorhanden)', 'required' => false],
                    ['id' => 'kategorie', 'type' => 'select', 'label' => 'Kategorie', 'required' => true, 'options' => ['Bestellung & Versand', 'Zahlung', 'Produkt-Frage', 'Technisches Problem', 'Sonstiges']],
                    ['id' => 'prioritaet', 'type' => 'radio', 'label' => 'Priorität', 'required' => true, 'options' => ['Normal', 'Hoch', 'Dringend']],
                    ['id' => 'beschreibung', 'type' => 'textarea', 'label' => 'Problembeschreibung', 'required' => true, 'placeholder' => 'Bitte beschreiben Sie Ihr Anliegen möglichst genau...'],
                    ['id' => 'screenshot', 'type' => 'file_upload', 'label' => 'Screenshot (optional)', 'required' => false],
                    ['id' => 'dsgvo', 'type' => 'gdpr', 'label' => 'Datenschutz', 'required' => true],
                ],
            ],
            // 8. Newsletter-Anmeldung
            [
                'name' => 'Newsletter-Anmeldung',
                'description' => 'Einfache Newsletter-Registrierung mit Interessen-Auswahl.',
                'category' => 'marketing',
                'sort' => 27,
                'fields' => [
                    ['id' => 'vorname', 'type' => 'text', 'label' => 'Vorname', 'required' => false],
                    ['id' => 'email', 'type' => 'email', 'label' => 'E-Mail-Adresse', 'required' => true, 'placeholder' => 'name@beispiel.de'],
                    ['id' => 'interessen', 'type' => 'checkbox', 'label' => 'Interessen', 'required' => false, 'options' => ['Angebote & Rabatte', 'Neue Produkte', 'Events & Aktionen']],
                    ['id' => 'dsgvo', 'type' => 'gdpr', 'label' => 'Einwilligung', 'required' => true],
                ],
            ],
        ];
    }
}
