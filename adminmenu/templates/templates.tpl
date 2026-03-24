{* Formular-Vorlagen *}

<div class="bbf-card">
    <div class="bbf-card-header">
        <h4 class="bbf-card-title">Formular-Vorlagen</h4>
        <p class="bbf-card-subtitle">Wähle eine Vorlage als Ausgangspunkt für dein neues Formular.</p>
    </div>
    <div class="bbf-card-body">
        <div class="bbf-template-grid">

            {* Blank Template *}
            <div class="bbf-template-card">
                <div class="bbf-template-card-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="40" height="40">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                </div>
                <h5 class="bbf-template-card-title">Leeres Formular</h5>
                <p class="bbf-template-card-desc">Starte mit einem leeren Formular und füge eigene Felder hinzu.</p>
                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-primary" onclick="bbfCreateFromTemplate('blank');">
                    Formular erstellen
                </button>
            </div>

            {* Contact Form *}
            <div class="bbf-template-card">
                <div class="bbf-template-card-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="40" height="40">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                        <polyline points="22,6 12,13 2,6"></polyline>
                    </svg>
                </div>
                <h5 class="bbf-template-card-title">Kontaktformular</h5>
                <p class="bbf-template-card-desc">Klassisches Kontaktformular mit Name, E-Mail, Betreff und Nachricht.</p>
                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-primary" onclick="bbfCreateFromTemplate('contact');">
                    Formular erstellen
                </button>
            </div>

            {* Callback Form *}
            <div class="bbf-template-card">
                <div class="bbf-template-card-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="40" height="40">
                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                    </svg>
                </div>
                <h5 class="bbf-template-card-title">Rückruf-Formular</h5>
                <p class="bbf-template-card-desc">Rückruf-Anfrage mit Name, Telefonnummer und Wunschtermin.</p>
                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-primary" onclick="bbfCreateFromTemplate('callback');">
                    Formular erstellen
                </button>
            </div>

            {* Newsletter Form *}
            <div class="bbf-template-card">
                <div class="bbf-template-card-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="40" height="40">
                        <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
                    </svg>
                </div>
                <h5 class="bbf-template-card-title">Newsletter-Anmeldung</h5>
                <p class="bbf-template-card-desc">Einfaches Anmeldeformular mit E-Mail und DSGVO-Einwilligung.</p>
                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-primary" onclick="bbfCreateFromTemplate('newsletter');">
                    Formular erstellen
                </button>
            </div>

            {* Support Form *}
            <div class="bbf-template-card">
                <div class="bbf-template-card-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="40" height="40">
                        <circle cx="12" cy="12" r="10"></circle>
                        <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                    </svg>
                </div>
                <h5 class="bbf-template-card-title">Support-Anfrage</h5>
                <p class="bbf-template-card-desc">Support-Ticket mit Kategorie, Priorität, Beschreibung und Dateianhang.</p>
                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-primary" onclick="bbfCreateFromTemplate('support');">
                    Formular erstellen
                </button>
            </div>

            {* Feedback Form *}
            <div class="bbf-template-card">
                <div class="bbf-template-card-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="40" height="40">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                    </svg>
                </div>
                <h5 class="bbf-template-card-title">Feedback-Formular</h5>
                <p class="bbf-template-card-desc">Kundenzufriedenheit abfragen mit Sternebewertung und Kommentar.</p>
                <button type="button" class="bbf-btn bbf-btn-sm bbf-btn-primary" onclick="bbfCreateFromTemplate('feedback');">
                    Formular erstellen
                </button>
            </div>

        </div>
    </div>
</div>
