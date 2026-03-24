<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_formbuilder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

/**
 * Adds remaining 7 system form templates (total: 10).
 */
class Migration20260324100002 extends Migration implements IMigration
{
    public function up(): void
    {
        // Template 4: Reklamationsformular (Multi-Step)
        $this->execute("INSERT INTO bbf_formbuilder_templates (name, description, category, icon, fields_json, settings_json, is_system, sort_order) VALUES (
            'Reklamationsformular',
            'Multi-Step Reklamation mit Bestelldaten, Problembeschreibung und Foto-Upload.',
            'Service',
            'alert-triangle',
            '" . $this->esc(json_encode([
                ['id'=>'field_rekl_name','type'=>'text','label'=>'Name','placeholder'=>'Ihr Name','required'=>true,'width'=>'half','sort_order'=>0,'step'=>0],
                ['id'=>'field_rekl_email','type'=>'email','label'=>'E-Mail','placeholder'=>'ihre@email.de','required'=>true,'width'=>'half','sort_order'=>1,'step'=>0],
                ['id'=>'field_rekl_order','type'=>'text','label'=>'Bestellnummer','placeholder'=>'z.B. 12345','required'=>true,'width'=>'half','sort_order'=>2,'step'=>0],
                ['id'=>'field_rekl_date','type'=>'date','label'=>'Kaufdatum','required'=>true,'width'=>'half','sort_order'=>3,'step'=>0],
                ['id'=>'field_rekl_break','type'=>'page_break','label'=>'Problembeschreibung','sort_order'=>4,'step'=>0],
                ['id'=>'field_rekl_product','type'=>'text','label'=>'Betroffenes Produkt','required'=>true,'width'=>'full','sort_order'=>5,'step'=>1],
                ['id'=>'field_rekl_desc','type'=>'textarea','label'=>'Problembeschreibung','placeholder'=>'Beschreiben Sie das Problem möglichst genau...','required'=>true,'sort_order'=>6,'step'=>1],
                ['id'=>'field_rekl_photo','type'=>'file_upload','label'=>'Foto des Problems','max_file_size'=>10,'allowed_extensions'=>'jpg,png,pdf','sort_order'=>7,'step'=>1],
                ['id'=>'field_rekl_gdpr','type'=>'gdpr','label'=>'Datenschutz','gdpr_text'=>'Ich stimme der Verarbeitung meiner Daten gemäß der <a href=\"/datenschutz\">Datenschutzerklärung</a> zu.','required'=>true,'sort_order'=>8,'step'=>1],
            ])) . "',
            NULL, 1, 4
        )");

        // Template 5: Produktanfrage
        $this->execute("INSERT INTO bbf_formbuilder_templates (name, description, category, icon, fields_json, is_system, sort_order) VALUES (
            'Produktanfrage',
            'Anfrage zu einem bestimmten Produkt mit Mengenangabe.',
            'Vertrieb',
            'shopping-bag',
            '" . $this->esc(json_encode([
                ['id'=>'field_prod_name','type'=>'text','label'=>'Name','required'=>true,'width'=>'half','sort_order'=>0],
                ['id'=>'field_prod_company','type'=>'text','label'=>'Firma','width'=>'half','sort_order'=>1],
                ['id'=>'field_prod_email','type'=>'email','label'=>'E-Mail','required'=>true,'width'=>'half','sort_order'=>2],
                ['id'=>'field_prod_phone','type'=>'phone','label'=>'Telefon','width'=>'half','sort_order'=>3],
                ['id'=>'field_prod_article','type'=>'text','label'=>'Artikelnummer / Produktname','required'=>true,'sort_order'=>4],
                ['id'=>'field_prod_qty','type'=>'number','label'=>'Gewünschte Menge','width'=>'half','sort_order'=>5],
                ['id'=>'field_prod_msg','type'=>'textarea','label'=>'Ihre Anfrage','placeholder'=>'Was möchten Sie wissen?','sort_order'=>6],
                ['id'=>'field_prod_gdpr','type'=>'gdpr','label'=>'Datenschutz','gdpr_text'=>'Ich stimme der Verarbeitung meiner Daten gemäß der <a href=\"/datenschutz\">Datenschutzerklärung</a> zu.','required'=>true,'sort_order'=>7],
            ])) . "',
            1, 5
        )");

        // Template 6: B2B Anfrage (Multi-Step)
        $this->execute("INSERT INTO bbf_formbuilder_templates (name, description, category, icon, fields_json, is_system, sort_order) VALUES (
            'B2B Anfrage',
            'Geschäftskundenanfrage mit Firmendaten und Anforderungen.',
            'Vertrieb',
            'briefcase',
            '" . $this->esc(json_encode([
                ['id'=>'field_b2b_company','type'=>'text','label'=>'Firmenname','required'=>true,'sort_order'=>0,'step'=>0],
                ['id'=>'field_b2b_contact','type'=>'text','label'=>'Ansprechpartner','required'=>true,'width'=>'half','sort_order'=>1,'step'=>0],
                ['id'=>'field_b2b_position','type'=>'text','label'=>'Position','width'=>'half','sort_order'=>2,'step'=>0],
                ['id'=>'field_b2b_email','type'=>'email','label'=>'E-Mail','required'=>true,'width'=>'half','sort_order'=>3,'step'=>0],
                ['id'=>'field_b2b_phone','type'=>'phone','label'=>'Telefon','required'=>true,'width'=>'half','sort_order'=>4,'step'=>0],
                ['id'=>'field_b2b_break','type'=>'page_break','label'=>'Anfrage-Details','sort_order'=>5,'step'=>0],
                ['id'=>'field_b2b_interest','type'=>'select','label'=>'Interesse an','choices'=>[['label'=>'Großhandel','value'=>'wholesale'],['label'=>'Partnerschaft','value'=>'partnership'],['label'=>'Individuelles Angebot','value'=>'custom']],'required'=>true,'sort_order'=>6,'step'=>1],
                ['id'=>'field_b2b_volume','type'=>'text','label'=>'Geschätztes Volumen','sort_order'=>7,'step'=>1],
                ['id'=>'field_b2b_msg','type'=>'textarea','label'=>'Ihre Nachricht','required'=>true,'sort_order'=>8,'step'=>1],
                ['id'=>'field_b2b_gdpr','type'=>'gdpr','label'=>'Datenschutz','gdpr_text'=>'Ich stimme der Verarbeitung meiner Daten gemäß der <a href=\"/datenschutz\">Datenschutzerklärung</a> zu.','required'=>true,'sort_order'=>9,'step'=>1],
            ])) . "',
            1, 6
        )");

        // Template 7: Bewerbungsformular (Multi-Step, 3 Steps)
        $this->execute("INSERT INTO bbf_formbuilder_templates (name, description, category, icon, fields_json, is_system, sort_order) VALUES (
            'Bewerbungsformular',
            'Online-Bewerbung mit persönlichen Daten, Berufserfahrung und Dokumenten-Upload.',
            'Personal',
            'user-check',
            '" . $this->esc(json_encode([
                ['id'=>'field_app_fname','type'=>'text','label'=>'Vorname','required'=>true,'width'=>'half','sort_order'=>0,'step'=>0],
                ['id'=>'field_app_lname','type'=>'text','label'=>'Nachname','required'=>true,'width'=>'half','sort_order'=>1,'step'=>0],
                ['id'=>'field_app_email','type'=>'email','label'=>'E-Mail','required'=>true,'width'=>'half','sort_order'=>2,'step'=>0],
                ['id'=>'field_app_phone','type'=>'phone','label'=>'Telefon','required'=>true,'width'=>'half','sort_order'=>3,'step'=>0],
                ['id'=>'field_app_break1','type'=>'page_break','label'=>'Berufserfahrung','sort_order'=>4,'step'=>0],
                ['id'=>'field_app_position','type'=>'text','label'=>'Gewünschte Stelle','required'=>true,'sort_order'=>5,'step'=>1],
                ['id'=>'field_app_start','type'=>'date','label'=>'Frühestmöglicher Eintritt','sort_order'=>6,'step'=>1],
                ['id'=>'field_app_experience','type'=>'textarea','label'=>'Berufserfahrung','placeholder'=>'Beschreiben Sie kurz Ihre relevante Berufserfahrung...','sort_order'=>7,'step'=>1],
                ['id'=>'field_app_break2','type'=>'page_break','label'=>'Dokumente','sort_order'=>8,'step'=>1],
                ['id'=>'field_app_cv','type'=>'file_upload','label'=>'Lebenslauf','required'=>true,'max_file_size'=>10,'allowed_extensions'=>'pdf,doc,docx','sort_order'=>9,'step'=>2],
                ['id'=>'field_app_cover','type'=>'file_upload','label'=>'Anschreiben','max_file_size'=>10,'allowed_extensions'=>'pdf,doc,docx','sort_order'=>10,'step'=>2],
                ['id'=>'field_app_msg','type'=>'textarea','label'=>'Zusätzliche Anmerkungen','sort_order'=>11,'step'=>2],
                ['id'=>'field_app_gdpr','type'=>'gdpr','label'=>'Datenschutz','gdpr_text'=>'Ich stimme der Verarbeitung meiner Bewerbungsdaten gemäß der <a href=\"/datenschutz\">Datenschutzerklärung</a> zu.','required'=>true,'sort_order'=>12,'step'=>2],
            ])) . "',
            1, 7
        )");

        // Template 8: Feedback-Formular
        $this->execute("INSERT INTO bbf_formbuilder_templates (name, description, category, icon, fields_json, is_system, sort_order) VALUES (
            'Feedback-Formular',
            'Kundenzufriedenheit mit Sternebewertung und bedingtem Kommentarfeld.',
            'Feedback',
            'star',
            '" . $this->esc(json_encode([
                ['id'=>'field_fb_name','type'=>'text','label'=>'Name','width'=>'half','sort_order'=>0],
                ['id'=>'field_fb_email','type'=>'email','label'=>'E-Mail','width'=>'half','sort_order'=>1],
                ['id'=>'field_fb_rating','type'=>'rating','label'=>'Wie zufrieden sind Sie?','required'=>true,'max_stars'=>5,'sort_order'=>2],
                ['id'=>'field_fb_what','type'=>'select','label'=>'Worauf bezieht sich Ihr Feedback?','choices'=>[['label'=>'Produkt','value'=>'product'],['label'=>'Lieferung','value'=>'delivery'],['label'=>'Kundenservice','value'=>'service'],['label'=>'Website','value'=>'website'],['label'=>'Sonstiges','value'=>'other']],'sort_order'=>3],
                ['id'=>'field_fb_comment','type'=>'textarea','label'=>'Ihr Feedback','placeholder'=>'Erzählen Sie uns mehr...','required'=>true,'sort_order'=>4],
                ['id'=>'field_fb_gdpr','type'=>'gdpr','label'=>'Datenschutz','gdpr_text'=>'Ich stimme der Verarbeitung meiner Daten gemäß der <a href=\"/datenschutz\">Datenschutzerklärung</a> zu.','required'=>true,'sort_order'=>5],
            ])) . "',
            1, 8
        )");

        // Template 9: Terminbuchung
        $this->execute("INSERT INTO bbf_formbuilder_templates (name, description, category, icon, fields_json, is_system, sort_order) VALUES (
            'Terminbuchung',
            'Online-Terminvereinbarung mit Datum, Uhrzeit und Anliegen.',
            'Service',
            'calendar',
            '" . $this->esc(json_encode([
                ['id'=>'field_term_name','type'=>'text','label'=>'Name','required'=>true,'width'=>'half','sort_order'=>0],
                ['id'=>'field_term_email','type'=>'email','label'=>'E-Mail','required'=>true,'width'=>'half','sort_order'=>1],
                ['id'=>'field_term_phone','type'=>'phone','label'=>'Telefon','width'=>'half','sort_order'=>2],
                ['id'=>'field_term_date','type'=>'date','label'=>'Wunschtermin','required'=>true,'width'=>'half','sort_order'=>3],
                ['id'=>'field_term_time','type'=>'select','label'=>'Uhrzeit','choices'=>[['label'=>'09:00','value'=>'09:00'],['label'=>'10:00','value'=>'10:00'],['label'=>'11:00','value'=>'11:00'],['label'=>'13:00','value'=>'13:00'],['label'=>'14:00','value'=>'14:00'],['label'=>'15:00','value'=>'15:00'],['label'=>'16:00','value'=>'16:00']],'required'=>true,'width'=>'half','sort_order'=>4],
                ['id'=>'field_term_topic','type'=>'select','label'=>'Anliegen','choices'=>[['label'=>'Beratung','value'=>'consultation'],['label'=>'Besichtigung','value'=>'viewing'],['label'=>'Reklamation','value'=>'complaint'],['label'=>'Sonstiges','value'=>'other']],'width'=>'half','sort_order'=>5],
                ['id'=>'field_term_msg','type'=>'textarea','label'=>'Anmerkungen','sort_order'=>6],
                ['id'=>'field_term_gdpr','type'=>'gdpr','label'=>'Datenschutz','gdpr_text'=>'Ich stimme der Verarbeitung meiner Daten gemäß der <a href=\"/datenschutz\">Datenschutzerklärung</a> zu.','required'=>true,'sort_order'=>7],
            ])) . "',
            1, 9
        )");

        // Template 10: Leeres Formular
        $this->execute("INSERT INTO bbf_formbuilder_templates (name, description, category, icon, fields_json, is_system, sort_order) VALUES (
            'Leeres Formular',
            'Starte mit einem leeren Formular und füge eigene Felder hinzu.',
            'Allgemein',
            'plus',
            '[]',
            1, 10
        )");
    }

    public function down(): void
    {
        $this->execute("DELETE FROM bbf_formbuilder_templates WHERE is_system = 1 AND sort_order >= 4");
    }

    private function esc(string $value): string
    {
        return addslashes($value);
    }
}
