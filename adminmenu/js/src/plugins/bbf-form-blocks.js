/**
 * BBF Formbuilder – Custom GrapesJS Form Blocks
 * Bootstrap 5 classes for proper canvas styling.
 */
export default function bbfFormBlocks(editor) {
    const bm = editor.BlockManager;

    // ── Standard-Felder (13) ─────────────────────────────────

    bm.add('bbf-text', { label: 'Textfeld', category: 'Standard-Felder', attributes: { class: 'fa fa-font' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="text"><label class="form-label bbf-label">Textfeld</label><input type="text" class="form-control" placeholder="Text eingeben..." /></div>` });

    bm.add('bbf-email', { label: 'E-Mail', category: 'Standard-Felder', attributes: { class: 'fa fa-envelope' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="email"><label class="form-label bbf-label">E-Mail-Adresse</label><input type="email" class="form-control" placeholder="name@beispiel.de" /></div>` });

    bm.add('bbf-textarea', { label: 'Textbereich', category: 'Standard-Felder', attributes: { class: 'fa fa-align-left' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="textarea"><label class="form-label bbf-label">Nachricht</label><textarea class="form-control" rows="4" placeholder="Ihre Nachricht..."></textarea></div>` });

    bm.add('bbf-phone', { label: 'Telefon', category: 'Standard-Felder', attributes: { class: 'fa fa-phone' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="phone"><label class="form-label bbf-label">Telefon</label><input type="tel" class="form-control" placeholder="+49 ..." /></div>` });

    bm.add('bbf-number', { label: 'Zahl', category: 'Standard-Felder', attributes: { class: 'fa fa-hashtag' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="number"><label class="form-label bbf-label">Zahl</label><input type="number" class="form-control" placeholder="0" /></div>` });

    bm.add('bbf-select', { label: 'Dropdown', category: 'Standard-Felder', attributes: { class: 'fa fa-chevron-down' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="select"><label class="form-label bbf-label">Auswahl</label><select class="form-select"><option value="">— Bitte wählen —</option><option value="1">Option 1</option><option value="2">Option 2</option><option value="3">Option 3</option></select></div>` });

    bm.add('bbf-checkbox', { label: 'Checkbox', category: 'Standard-Felder', attributes: { class: 'fa fa-check-square' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="checkbox"><label class="form-label bbf-label">Optionen</label><div class="form-check"><input type="checkbox" class="form-check-input" /><label class="form-check-label">Option A</label></div><div class="form-check"><input type="checkbox" class="form-check-input" /><label class="form-check-label">Option B</label></div></div>` });

    bm.add('bbf-radio', { label: 'Radio', category: 'Standard-Felder', attributes: { class: 'fa fa-dot-circle-o' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="radio"><label class="form-label bbf-label">Auswahl</label><div class="form-check"><input type="radio" class="form-check-input" name="rg" /><label class="form-check-label">Option A</label></div><div class="form-check"><input type="radio" class="form-check-input" name="rg" /><label class="form-check-label">Option B</label></div></div>` });

    bm.add('bbf-date', { label: 'Datum', category: 'Standard-Felder', attributes: { class: 'fa fa-calendar' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="date"><label class="form-label bbf-label">Datum</label><input type="date" class="form-control" /></div>` });

    bm.add('bbf-time', { label: 'Uhrzeit', category: 'Standard-Felder', attributes: { class: 'fa fa-clock-o' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="time"><label class="form-label bbf-label">Uhrzeit</label><input type="time" class="form-control" /></div>` });

    bm.add('bbf-password', { label: 'Passwort', category: 'Standard-Felder', attributes: { class: 'fa fa-lock' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="password"><label class="form-label bbf-label">Passwort</label><input type="password" class="form-control" /></div>` });

    bm.add('bbf-url', { label: 'URL', category: 'Standard-Felder', attributes: { class: 'fa fa-link' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="url"><label class="form-label bbf-label">Website</label><input type="url" class="form-control" placeholder="https://..." /></div>` });

    bm.add('bbf-hidden', { label: 'Versteckt', category: 'Standard-Felder', attributes: { class: 'fa fa-eye-slash' },
        content: `<div class="mb-2 bbf-field" data-gjs-type="bbf-field" data-field-type="hidden" style="border:1px dashed #ccc;padding:8px;background:#f9f9f9;font-size:12px;"><i class="fa fa-eye-slash"></i> Verstecktes Feld<input type="hidden" value="" /></div>` });

    // ── Erweiterte Felder (4) ────────────────────────────────

    bm.add('bbf-name', { label: 'Name', category: 'Erweiterte Felder', attributes: { class: 'fa fa-user' },
        content: `<div class="row mb-3" data-gjs-type="bbf-compound-field" data-field-type="name"><div class="col-md-6"><label class="form-label">Vorname</label><input type="text" class="form-control" placeholder="Vorname" /></div><div class="col-md-6"><label class="form-label">Nachname</label><input type="text" class="form-control" placeholder="Nachname" /></div></div>` });

    bm.add('bbf-address', { label: 'Adresse', category: 'Erweiterte Felder', attributes: { class: 'fa fa-map-marker' },
        content: `<div class="mb-3" data-gjs-type="bbf-compound-field" data-field-type="address"><div class="mb-2"><label class="form-label">Straße & Hausnr.</label><input type="text" class="form-control" /></div><div class="row mb-2"><div class="col-4"><label class="form-label">PLZ</label><input type="text" class="form-control" /></div><div class="col-8"><label class="form-label">Ort</label><input type="text" class="form-control" /></div></div><label class="form-label">Land</label><select class="form-select"><option selected>Deutschland</option><option>Österreich</option><option>Schweiz</option></select></div>` });

    bm.add('bbf-file-upload', { label: 'Datei-Upload', category: 'Erweiterte Felder', attributes: { class: 'fa fa-upload' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="file_upload"><label class="form-label bbf-label">Datei hochladen</label><input type="file" class="form-control" /><small class="form-text text-muted">Max. 5 MB · JPG, PNG, PDF</small></div>` });

    bm.add('bbf-rating', { label: 'Bewertung', category: 'Erweiterte Felder', attributes: { class: 'fa fa-star' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="rating"><label class="form-label bbf-label">Bewertung</label><div style="font-size:24px;color:#f59e0b;cursor:pointer;">★★★★★</div></div>` });

    // ── Layout (7) ───────────────────────────────────────────

    bm.add('bbf-row-2', { label: '2 Spalten', category: 'Layout', attributes: { class: 'fa fa-columns' },
        content: `<div class="row mb-3"><div class="col-md-6" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;"><span style="color:#adb5bd;font-size:12px;">Spalte 1</span></div><div class="col-md-6" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;"><span style="color:#adb5bd;font-size:12px;">Spalte 2</span></div></div>` });

    bm.add('bbf-row-3', { label: '3 Spalten', category: 'Layout', attributes: { class: 'fa fa-th' },
        content: `<div class="row mb-3"><div class="col-md-4" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;"><span style="color:#adb5bd;font-size:12px;">1</span></div><div class="col-md-4" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;"><span style="color:#adb5bd;font-size:12px;">2</span></div><div class="col-md-4" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;"><span style="color:#adb5bd;font-size:12px;">3</span></div></div>` });

    bm.add('bbf-row-4', { label: '4 Spalten', category: 'Layout', attributes: { class: 'fa fa-th-large' },
        content: `<div class="row mb-3"><div class="col-md-3" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;">1</div><div class="col-md-3" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;">2</div><div class="col-md-3" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;">3</div><div class="col-md-3" style="min-height:60px;border:1px dashed #dee2e6;padding:10px;border-radius:4px;">4</div></div>` });

    bm.add('bbf-section', { label: 'Abschnitt', category: 'Layout', attributes: { class: 'fa fa-minus' },
        content: `<div class="mb-4" data-gjs-type="bbf-layout" data-field-type="section_break"><h5 style="font-weight:600;margin-bottom:4px;">Abschnittstitel</h5><p class="text-muted" style="font-size:13px;margin-bottom:8px;">Optionale Beschreibung</p><hr /></div>` });

    bm.add('bbf-page-break', { label: 'Seitenumbruch', category: 'Layout', attributes: { class: 'fa fa-arrow-right' },
        content: `<div class="my-3" data-gjs-type="bbf-layout" data-field-type="page_break" style="border:2px dashed var(--bbf-primary,#db2e87);padding:12px;text-align:center;border-radius:6px;background:#f9e8f1;"><strong style="color:var(--bbf-primary,#db2e87);">↓ Nächster Schritt ↓</strong></div>` });

    bm.add('bbf-html', { label: 'HTML-Block', category: 'Layout', attributes: { class: 'fa fa-code' },
        content: `<div class="mb-3" data-gjs-type="bbf-layout" data-field-type="html_block"><p>Freier HTML-Inhalt — doppelklicken zum Bearbeiten</p></div>` });

    // ── Spezial (3) ──────────────────────────────────────────

    bm.add('bbf-gdpr', { label: 'DSGVO', category: 'Spezial', attributes: { class: 'fa fa-shield' },
        content: `<div class="mb-3 bbf-field" data-gjs-type="bbf-field" data-field-type="gdpr"><div class="form-check"><input type="checkbox" class="form-check-input" required /><label class="form-check-label">Ich stimme der Verarbeitung meiner Daten gemäß der <a href="/datenschutz">Datenschutzerklärung</a> zu. *</label></div></div>` });

    bm.add('bbf-captcha', { label: 'CAPTCHA', category: 'Spezial', attributes: { class: 'fa fa-shield' },
        content: `<div class="mb-3" data-gjs-type="bbf-field" data-field-type="captcha" style="border:1px dashed #ccc;padding:16px;text-align:center;background:#f9f9f9;border-radius:6px;"><i class="fa fa-shield" style="font-size:24px;color:#9ca3af;"></i><p style="margin:8px 0 0;color:#6b7280;font-size:13px;">CAPTCHA (wird im Frontend gerendert)</p></div>` });

    bm.add('bbf-submit', { label: 'Absenden', category: 'Spezial', attributes: { class: 'fa fa-paper-plane' },
        content: `<div class="mb-3"><button type="submit" class="btn btn-primary bbf-submit-btn">Absenden</button></div>` });
}
