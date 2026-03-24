{* Dokumentation *}

<div class="bbf-documentation">

    {* Einführung *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">BBF Formbuilder -- Dokumentation</h4>
        </div>
        <div class="bbf-card-body">
            <p>Willkommen zur Dokumentation des BBF Formbuilders für JTL-Shop 5. Dieses Plugin ermöglicht es Ihnen, professionelle Formulare per Drag & Drop zu erstellen und in Ihrem Shop einzubinden.</p>
        </div>
    </div>

    {* Formular erstellen *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Formular erstellen</h4>
        </div>
        <div class="bbf-card-body">
            <ol class="bbf-doc-list">
                <li>Navigieren Sie zu <strong>Formulare &rarr; Vorlagen</strong> und wählen Sie eine Vorlage aus oder starten Sie mit einem leeren Formular.</li>
                <li>Im <strong>Formular-Builder</strong> ziehen Sie Felder aus der linken Palette in den mittleren Bereich.</li>
                <li>Klicken Sie auf ein Feld, um dessen Einstellungen auf der rechten Seite zu bearbeiten (Label, Pflichtfeld, Validierung etc.).</li>
                <li>Ordnen Sie die Felder per Drag & Drop in die gewünschte Reihenfolge.</li>
                <li>Klicken Sie auf <strong>Speichern</strong>, um das Formular zu sichern.</li>
                <li>Konfigurieren Sie unter <strong>Einstellungen</strong> die E-Mail-Benachrichtigungen und Bestätigungsnachricht.</li>
            </ol>
        </div>
    </div>

    {* Verfügbare Feldtypen *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Verfügbare Feldtypen</h4>
        </div>
        <div class="bbf-card-body">
            <h5 style="margin-bottom: 12px;">Standard-Felder</h5>
            <table class="bbf-table" style="margin-bottom: 24px;">
                <thead>
                    <tr>
                        <th>Feldtyp</th>
                        <th>Beschreibung</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td><strong>Text</strong></td><td>Einzeiliges Textfeld</td></tr>
                    <tr><td><strong>E-Mail</strong></td><td>E-Mail-Feld mit Validierung</td></tr>
                    <tr><td><strong>Textarea</strong></td><td>Mehrzeiliges Textfeld</td></tr>
                    <tr><td><strong>Select</strong></td><td>Dropdown-Auswahlliste</td></tr>
                    <tr><td><strong>Checkbox</strong></td><td>Einzelne Checkbox oder Checkbox-Gruppe</td></tr>
                    <tr><td><strong>Radio</strong></td><td>Radio-Button-Gruppe</td></tr>
                    <tr><td><strong>Nummer</strong></td><td>Numerisches Eingabefeld</td></tr>
                    <tr><td><strong>Telefon</strong></td><td>Telefonnummer-Feld</td></tr>
                    <tr><td><strong>Datum</strong></td><td>Datumsauswahl</td></tr>
                    <tr><td><strong>Passwort</strong></td><td>Passwort-Eingabefeld</td></tr>
                </tbody>
            </table>

            <h5 style="margin-bottom: 12px;">Erweiterte Felder</h5>
            <table class="bbf-table" style="margin-bottom: 24px;">
                <thead>
                    <tr>
                        <th>Feldtyp</th>
                        <th>Beschreibung</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td><strong>Datei-Upload</strong></td><td>Datei-Upload mit konfigurierbaren Dateitypen und Größenlimit</td></tr>
                    <tr><td><strong>Verstecktes Feld</strong></td><td>Unsichtbares Feld mit vordefiniertem Wert</td></tr>
                    <tr><td><strong>Rating</strong></td><td>Sternebewertung (1-5)</td></tr>
                    <tr><td><strong>Slider</strong></td><td>Bereichs-Slider mit Min/Max</td></tr>
                    <tr><td><strong>Farbauswahl</strong></td><td>Farbwähler</td></tr>
                </tbody>
            </table>

            <h5 style="margin-bottom: 12px;">Layout-Elemente</h5>
            <table class="bbf-table">
                <thead>
                    <tr>
                        <th>Element</th>
                        <th>Beschreibung</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td><strong>Überschrift</strong></td><td>Abschnitts-Überschrift (H2-H6)</td></tr>
                    <tr><td><strong>Absatz</strong></td><td>Erklärender Text zwischen Feldern</td></tr>
                    <tr><td><strong>Trennlinie</strong></td><td>Horizontale Trennlinie</td></tr>
                    <tr><td><strong>Abstandhalter</strong></td><td>Vertikaler Abstand</td></tr>
                    <tr><td><strong>Spalten</strong></td><td>Mehrspaltiges Layout (2-4 Spalten)</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    {* Smarty-Einbindung *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Einbindung per Smarty</h4>
        </div>
        <div class="bbf-card-body">
            <p>Formulare können in jedem Smarty-Template eingebunden werden:</p>
            <pre class="bbf-code-block"><code>{literal}{bbf_form slug="kontaktformular"}{/literal}</code></pre>
            <p style="margin-top: 12px;">Alternativ über die Formular-ID:</p>
            <pre class="bbf-code-block"><code>{literal}{bbf_form id=1}{/literal}</code></pre>
            <p style="margin-top: 12px;">Weitere Parameter:</p>
            <table class="bbf-table" style="margin-top: 8px;">
                <thead>
                    <tr>
                        <th>Parameter</th>
                        <th>Beschreibung</th>
                        <th>Beispiel</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td><code>slug</code></td><td>Formular-Slug</td><td><code>slug="kontaktformular"</code></td></tr>
                    <tr><td><code>id</code></td><td>Formular-ID</td><td><code>id=1</code></td></tr>
                    <tr><td><code>class</code></td><td>Zusätzliche CSS-Klassen</td><td><code>class="my-form"</code></td></tr>
                    <tr><td><code>title</code></td><td>Formular-Titel anzeigen</td><td><code>title=true</code></td></tr>
                </tbody>
            </table>
        </div>
    </div>

    {* OPC Portlet *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">OPC Portlet</h4>
        </div>
        <div class="bbf-card-body">
            <p>Das Plugin enthält ein OPC-Portlet (OnPage Composer), mit dem Formulare visuell in JTL-Shop-Seiten platziert werden können:</p>
            <ol class="bbf-doc-list">
                <li>Öffnen Sie den <strong>OnPage Composer</strong> für die gewünschte Seite.</li>
                <li>Suchen Sie in der Portlet-Liste nach <strong>"BBF Formular"</strong>.</li>
                <li>Ziehen Sie das Portlet an die gewünschte Position.</li>
                <li>Wählen Sie in den Portlet-Einstellungen das gewünschte Formular aus.</li>
            </ol>
        </div>
    </div>

    {* Bedingte Logik *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Bedingte Logik (Conditional Logic)</h4>
        </div>
        <div class="bbf-card-body">
            <p>Mit der bedingten Logik können Felder dynamisch ein- oder ausgeblendet werden, basierend auf den Eingaben in anderen Feldern:</p>
            <ol class="bbf-doc-list">
                <li>Wählen Sie ein Feld im Builder aus.</li>
                <li>Wechseln Sie zum Tab <strong>"Logik"</strong> in den Feld-Einstellungen.</li>
                <li>Aktivieren Sie die bedingte Logik.</li>
                <li>Definieren Sie Bedingungen (z.B. "Zeige dieses Feld, wenn Feld X den Wert Y hat").</li>
                <li>Mehrere Bedingungen können mit UND/ODER verknüpft werden.</li>
            </ol>
            <p style="margin-top: 12px;"><strong>Verfügbare Operatoren:</strong></p>
            <ul style="margin-top: 8px; padding-left: 20px;">
                <li><code>ist gleich</code> -- Exakter Wert</li>
                <li><code>ist nicht gleich</code> -- Wert weicht ab</li>
                <li><code>enthält</code> -- Wert enthält Teilstring</li>
                <li><code>enthält nicht</code> -- Wert enthält keinen Teilstring</li>
                <li><code>ist leer</code> -- Feld hat keinen Wert</li>
                <li><code>ist nicht leer</code> -- Feld hat einen Wert</li>
                <li><code>größer als</code> -- Numerischer Vergleich</li>
                <li><code>kleiner als</code> -- Numerischer Vergleich</li>
            </ul>
        </div>
    </div>

    {* Spam-Schutz *}
    <div class="bbf-card" style="margin-bottom: 24px;">
        <div class="bbf-card-header">
            <h4 class="bbf-card-title">Spam-Schutz</h4>
        </div>
        <div class="bbf-card-body">
            <p>Das Plugin bietet mehrere Schutzmechanismen gegen Spam:</p>
            <table class="bbf-table" style="margin-top: 12px;">
                <thead>
                    <tr>
                        <th>Methode</th>
                        <th>Beschreibung</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Honeypot</strong></td>
                        <td>Ein unsichtbares Feld, das nur von Bots ausgefüllt wird. Keine Beeinträchtigung für echte Nutzer.</td>
                    </tr>
                    <tr>
                        <td><strong>Zeitbasierter Schutz</strong></td>
                        <td>Formulare müssen eine Mindestzeit lang ausgefüllt werden, bevor sie abgesendet werden können.</td>
                    </tr>
                    <tr>
                        <td><strong>Rate Limiting</strong></td>
                        <td>Begrenzt die Anzahl der Einsendungen pro IP-Adresse innerhalb eines Zeitfensters.</td>
                    </tr>
                    <tr>
                        <td><strong>CAPTCHA</strong></td>
                        <td>Unterstützt ALTCHA, Google reCAPTCHA (v2/v3), Cloudflare Turnstile und Friendly Captcha.</td>
                    </tr>
                </tbody>
            </table>
            <p style="margin-top: 12px;">Die Spam-Schutz-Einstellungen finden Sie unter <strong>Einstellungen &rarr; Spam-Schutz</strong>.</p>
        </div>
    </div>

</div>
