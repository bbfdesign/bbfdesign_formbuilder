{* Dokumentation *}

<div style="display: flex; flex-direction: column; gap: 20px;">

    {* Einführung *}
    <div style="background: #fff; border-radius: 10px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <h4 style="margin: 0 0 12px 0; font-size: 16px; font-weight: 600; color: #1f2937;">BBF Formbuilder -- Dokumentation</h4>
        <p style="margin: 0; font-size: 14px; color: #4b5563; line-height: 1.6;">Willkommen zur Dokumentation des BBF Formbuilders für JTL-Shop 5. Dieses Plugin ermöglicht es Ihnen, professionelle Formulare per Drag &amp; Drop zu erstellen und in Ihrem Shop einzubinden.</p>
    </div>

    {* Formular erstellen *}
    <div style="background: #fff; border-radius: 10px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <h4 style="margin: 0 0 12px 0; font-size: 16px; font-weight: 600; color: #1f2937;">Formular erstellen</h4>
        <ol style="margin: 0; padding-left: 20px; font-size: 14px; color: #4b5563; line-height: 1.8;">
            <li>Navigieren Sie zu <strong>Formulare</strong> und wählen Sie eine Vorlage oder starten Sie mit einem leeren Formular.</li>
            <li>Im <strong>Formular-Builder</strong> ziehen Sie Felder aus der linken Palette in den mittleren Bereich.</li>
            <li>Klicken Sie auf ein Feld, um dessen Einstellungen zu bearbeiten (Label, Pflichtfeld, Validierung etc.).</li>
            <li>Ordnen Sie die Felder per Drag &amp; Drop in die gewünschte Reihenfolge.</li>
            <li>Klicken Sie auf <strong>Speichern</strong>, um das Formular zu sichern.</li>
            <li>Konfigurieren Sie unter <strong>Einstellungen</strong> die E-Mail-Benachrichtigungen und Bestätigungsnachricht.</li>
        </ol>
    </div>

    {* Verfügbare Feldtypen (24) *}
    <div style="background: #fff; border-radius: 10px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <h4 style="margin: 0 0 16px 0; font-size: 16px; font-weight: 600; color: #1f2937;">Verfügbare Feldtypen (24)</h4>

        <h5 style="margin: 0 0 8px 0; font-size: 14px; font-weight: 600; color: #374151;">Standard-Felder</h5>
        <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
            <thead>
                <tr>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Feldtyp</th>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Beschreibung</th>
                </tr>
            </thead>
            <tbody>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Text</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Einzeiliges Textfeld</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">E-Mail</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">E-Mail-Feld mit Validierung</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Textarea</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Mehrzeiliges Textfeld</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Select</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Dropdown-Auswahlliste</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Checkbox</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Einzelne Checkbox oder Checkbox-Gruppe</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Radio</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Radio-Button-Gruppe</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Nummer</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Numerisches Eingabefeld</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Telefon</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Telefonnummer-Feld</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Datum</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Datumsauswahl</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Passwort</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Passwort-Eingabefeld</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">URL</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">URL-Feld mit Validierung</td></tr>
            </tbody>
        </table>

        <h5 style="margin: 0 0 8px 0; font-size: 14px; font-weight: 600; color: #374151;">Erweiterte Felder</h5>
        <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
            <thead>
                <tr>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Feldtyp</th>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Beschreibung</th>
                </tr>
            </thead>
            <tbody>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Datei-Upload</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Datei-Upload mit konfigurierbaren Dateitypen und Größenlimit</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Verstecktes Feld</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Unsichtbares Feld mit vordefiniertem Wert</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Rating</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Sternebewertung (1-5)</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Slider</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Bereichs-Slider mit Min/Max</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Signature</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Unterschrift-Feld</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">DSGVO-Checkbox</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Datenschutz-Zustimmung mit konfigurierbarem Text</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">CAPTCHA</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">ALTCHA, reCAPTCHA, Turnstile, Friendly Captcha</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Multi-Step</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Schritt-Trenner für mehrseitige Formulare</td></tr>
            </tbody>
        </table>

        <h5 style="margin: 0 0 8px 0; font-size: 14px; font-weight: 600; color: #374151;">Layout-Elemente</h5>
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Element</th>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Beschreibung</th>
                </tr>
            </thead>
            <tbody>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Überschrift</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Abschnitts-Überschrift (H2-H6)</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Absatz</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Erklärender Text zwischen Feldern</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Trennlinie</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Horizontale Trennlinie</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Abstandhalter</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Vertikaler Abstand</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Spalten</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Mehrspaltiges Layout (2-4 Spalten)</td></tr>
            </tbody>
        </table>
    </div>

    {* Einbindung *}
    <div style="background: #fff; border-radius: 10px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <h4 style="margin: 0 0 16px 0; font-size: 16px; font-weight: 600; color: #1f2937;">Einbindung in den Shop</h4>

        <h5 style="margin: 0 0 8px 0; font-size: 14px; font-weight: 600; color: #374151;">Smarty-Tag</h5>
        <p style="margin: 0 0 8px 0; font-size: 14px; color: #4b5563;">Formulare können in jedem Smarty-Template eingebunden werden:</p>
        <pre style="background: #f8f9fa; border: 1px solid #e5e7eb; border-radius: 6px; padding: 12px 16px; font-size: 13px; overflow-x: auto; margin: 0 0 12px 0;"><code>{literal}{bbf_form id=1}{/literal}</code></pre>
        <pre style="background: #f8f9fa; border: 1px solid #e5e7eb; border-radius: 6px; padding: 12px 16px; font-size: 13px; overflow-x: auto; margin: 0 0 16px 0;"><code>{literal}{bbf_form slug="kontakt"}{/literal}</code></pre>

        <h5 style="margin: 0 0 8px 0; font-size: 14px; font-weight: 600; color: #374151;">OPC Portlet</h5>
        <p style="margin: 0; font-size: 14px; color: #4b5563; line-height: 1.6;">Im OnPage Composer das Portlet <strong>"BBF Formular"</strong> suchen, an die gewünschte Position ziehen und in den Portlet-Einstellungen das Formular auswählen.</p>
    </div>

    {* Merge-Tags *}
    <div style="background: #fff; border-radius: 10px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <h4 style="margin: 0 0 16px 0; font-size: 16px; font-weight: 600; color: #1f2937;">Merge-Tags für E-Mail-Templates</h4>
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Tag</th>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Beschreibung</th>
                </tr>
            </thead>
            <tbody>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px;"><code>{literal}{alle_felder}{/literal}</code></td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Gibt alle Felder und Werte des Eintrags aus</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px;"><code>{literal}{feld:field_id}{/literal}</code></td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Wert eines bestimmten Feldes (field_id ersetzen)</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px;"><code>{literal}{formular_name}{/literal}</code></td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Name des Formulars</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px;"><code>{literal}{eintrag_id}{/literal}</code></td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">ID des Eintrags</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px;"><code>{literal}{datum}{/literal}</code></td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Datum der Einsendung</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px;"><code>{literal}{uhrzeit}{/literal}</code></td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Uhrzeit der Einsendung</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px;"><code>{literal}{shop_name}{/literal}</code></td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Name des Shops</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px;"><code>{literal}{shop_url}{/literal}</code></td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">URL des Shops</td></tr>
            </tbody>
        </table>
    </div>

    {* Bedingte Logik *}
    <div style="background: #fff; border-radius: 10px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <h4 style="margin: 0 0 12px 0; font-size: 16px; font-weight: 600; color: #1f2937;">Bedingte Logik (Conditional Logic)</h4>
        <p style="margin: 0 0 12px 0; font-size: 14px; color: #4b5563; line-height: 1.6;">Felder können dynamisch ein- oder ausgeblendet werden. Wählen Sie ein Feld aus, wechseln Sie zum Tab <strong>"Logik"</strong>, und definieren Sie Bedingungen.</p>
        <p style="margin: 0 0 8px 0; font-size: 14px; font-weight: 600; color: #374151;">Verfügbare Operatoren:</p>
        <ul style="margin: 0; padding-left: 20px; font-size: 13px; color: #4b5563; line-height: 1.8;">
            <li><code>ist gleich</code> / <code>ist nicht gleich</code></li>
            <li><code>enthält</code> / <code>enthält nicht</code></li>
            <li><code>ist leer</code> / <code>ist nicht leer</code></li>
            <li><code>größer als</code> / <code>kleiner als</code></li>
        </ul>
    </div>

    {* Spam-Schutz *}
    <div style="background: #fff; border-radius: 10px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
        <h4 style="margin: 0 0 12px 0; font-size: 16px; font-weight: 600; color: #1f2937;">Spam-Schutz</h4>
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Methode</th>
                    <th style="background: #f8f9fa; padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; color: #6b7280; border-bottom: 1px solid #e5e7eb;">Beschreibung</th>
                </tr>
            </thead>
            <tbody>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Honeypot</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Unsichtbares Feld, das nur von Bots ausgefüllt wird</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Zeitbasierter Schutz</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Mindestausfüllzeit bevor Absenden möglich ist</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Rate Limiting</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Begrenzte Einsendungen pro IP-Adresse</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">ALTCHA</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Proof-of-Work CAPTCHA ohne externe Dienste</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">reCAPTCHA</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Google reCAPTCHA v2 und v3</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Turnstile</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">Cloudflare Turnstile</td></tr>
                <tr style="border-bottom: 1px solid #f3f4f6;"><td style="padding: 8px 12px; font-size: 13px; font-weight: 600; color: #1f2937;">Friendly Captcha</td><td style="padding: 8px 12px; font-size: 13px; color: #4b5563;">DSGVO-freundliches CAPTCHA</td></tr>
            </tbody>
        </table>
    </div>

</div>
