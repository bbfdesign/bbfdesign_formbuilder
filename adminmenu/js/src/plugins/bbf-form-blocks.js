/**
 * BBF Formbuilder — GrapesJS Form Blocks
 * Karten-Optik analog Easy Form Builder
 */
export default function bbfFormBlocks(editor) {
    const bm = editor.BlockManager;

    // ── Standard-Felder (13) ─────────────────────────────

    bm.add('bbf-text', { label: 'Textfeld', category: 'Standard-Felder', attributes: { class: 'fa fa-font' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="text" data-label="Textfeld" data-placeholder="Text eingeben..."><label class="bbf-label">Textfeld</label><input type="text" class="form-control" placeholder="Text eingeben..." /></div>` });

    bm.add('bbf-email', { label: 'E-Mail', category: 'Standard-Felder', attributes: { class: 'fa fa-envelope' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="email" data-label="E-Mail-Adresse" data-placeholder="name@beispiel.de"><label class="bbf-label">E-Mail-Adresse</label><input type="email" class="form-control" placeholder="name@beispiel.de" /></div>` });

    bm.add('bbf-textarea', { label: 'Textbereich', category: 'Standard-Felder', attributes: { class: 'fa fa-align-left' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="textarea" data-label="Nachricht" data-placeholder="Ihre Nachricht..."><label class="bbf-label">Nachricht</label><textarea class="form-control" rows="4" placeholder="Ihre Nachricht..."></textarea></div>` });

    bm.add('bbf-phone', { label: 'Telefon', category: 'Standard-Felder', attributes: { class: 'fa fa-phone' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="phone" data-label="Telefon" data-placeholder="+49 ..."><label class="bbf-label">Telefon</label><input type="tel" class="form-control" placeholder="+49 ..." /></div>` });

    bm.add('bbf-number', { label: 'Zahl', category: 'Standard-Felder', attributes: { class: 'fa fa-hashtag' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="number" data-label="Zahl"><label class="bbf-label">Zahl</label><input type="number" class="form-control" placeholder="0" /></div>` });

    bm.add('bbf-select', { label: 'Dropdown', category: 'Standard-Felder', attributes: { class: 'fa fa-chevron-down' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="select" data-label="Auswahl"><label class="bbf-label">Auswahl</label><select class="form-control"><option value="">— Bitte wählen —</option><option value="option_1">Option 1</option><option value="option_2">Option 2</option><option value="option_3">Option 3</option></select></div>` });

    bm.add('bbf-checkbox', { label: 'Checkbox', category: 'Standard-Felder', attributes: { class: 'fa fa-check-square' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="checkbox" data-label="Optionen"><label class="bbf-label">Optionen</label><div class="form-check"><input type="checkbox" class="form-check-input" value="option_a" /><label class="form-check-label">Option A</label></div><div class="form-check"><input type="checkbox" class="form-check-input" value="option_b" /><label class="form-check-label">Option B</label></div></div>` });

    bm.add('bbf-radio', { label: 'Radio', category: 'Standard-Felder', attributes: { class: 'fa fa-dot-circle-o' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="radio" data-label="Auswahl"><label class="bbf-label">Auswahl</label><div class="form-check"><input type="radio" class="form-check-input" name="bbf_radio_1" value="option_a" /><label class="form-check-label">Option A</label></div><div class="form-check"><input type="radio" class="form-check-input" name="bbf_radio_1" value="option_b" /><label class="form-check-label">Option B</label></div></div>` });

    bm.add('bbf-date', { label: 'Datum', category: 'Standard-Felder', attributes: { class: 'fa fa-calendar' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="date" data-label="Datum"><label class="bbf-label">Datum</label><input type="date" class="form-control" /></div>` });

    bm.add('bbf-time', { label: 'Uhrzeit', category: 'Standard-Felder', attributes: { class: 'fa fa-clock-o' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="time" data-label="Uhrzeit"><label class="bbf-label">Uhrzeit</label><input type="time" class="form-control" /></div>` });

    bm.add('bbf-password', { label: 'Passwort', category: 'Standard-Felder', attributes: { class: 'fa fa-lock' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="password" data-label="Passwort"><label class="bbf-label">Passwort</label><input type="password" class="form-control" placeholder="••••••••" /></div>` });

    bm.add('bbf-url', { label: 'URL', category: 'Standard-Felder', attributes: { class: 'fa fa-link' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="url" data-label="Website" data-placeholder="https://..."><label class="bbf-label">Website</label><input type="url" class="form-control" placeholder="https://..." /></div>` });

    bm.add('bbf-hidden', { label: 'Versteckt', category: 'Standard-Felder', attributes: { class: 'fa fa-eye-slash' },
        content: `<div class="bbf-hidden-field-preview" data-gjs-type="bbf-field" data-field-type="hidden" data-label="Verstecktes Feld"><i class="fa fa-eye-slash" style="font-size:13px;"></i><span>Verstecktes Feld</span><input type="hidden" value="" /></div>` });

    // ── Erweiterte Felder (4) ────────────────────────────

    bm.add('bbf-name', { label: 'Name', category: 'Erweiterte Felder', attributes: { class: 'fa fa-user' },
        content: `<div class="bbf-compound-field" data-gjs-type="bbf-compound-field" data-field-type="name" data-label="Name"><div style="display:flex;gap:12px;"><div style="flex:1;"><label class="form-label">Vorname</label><input type="text" class="form-control" placeholder="Vorname" /></div><div style="flex:1;"><label class="form-label">Nachname</label><input type="text" class="form-control" placeholder="Nachname" /></div></div></div>` });

    bm.add('bbf-address', { label: 'Adresse', category: 'Erweiterte Felder', attributes: { class: 'fa fa-map-marker' },
        content: `<div class="bbf-compound-field" data-gjs-type="bbf-compound-field" data-field-type="address" data-label="Adresse"><div style="margin-bottom:10px;"><label class="form-label">Straße & Hausnr.</label><input type="text" class="form-control" placeholder="Musterstraße 1" /></div><div style="display:flex;gap:12px;margin-bottom:10px;"><div style="flex:0 0 120px;"><label class="form-label">PLZ</label><input type="text" class="form-control" placeholder="12345" /></div><div style="flex:1;"><label class="form-label">Ort</label><input type="text" class="form-control" placeholder="Musterstadt" /></div></div><div><label class="form-label">Land</label><select class="form-control"><option>Deutschland</option><option>Österreich</option><option>Schweiz</option></select></div></div>` });

    bm.add('bbf-file-upload', { label: 'Datei-Upload', category: 'Erweiterte Felder', attributes: { class: 'fa fa-upload' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="file_upload" data-label="Datei hochladen"><label class="bbf-label">Datei hochladen</label><input type="file" class="form-control" /><small>Max. 5 MB · JPG, PNG, PDF</small></div>` });

    bm.add('bbf-rating', { label: 'Bewertung', category: 'Erweiterte Felder', attributes: { class: 'fa fa-star' },
        content: `<div class="bbf-field" data-gjs-type="bbf-field" data-field-type="rating" data-label="Bewertung"><label class="bbf-label">Bewertung</label><div class="bbf-rating"><span class="bbf-star">★</span><span class="bbf-star">★</span><span class="bbf-star">★</span><span class="bbf-star">★</span><span class="bbf-star">★</span></div></div>` });

    // ── Layout (6) ───────────────────────────────────────

    bm.add('bbf-row-2', { label: '2 Spalten', category: 'Layout', attributes: { class: 'fa fa-columns' },
        content: `<div class="bbf-col-wrap" data-gjs-type="bbf-layout" data-field-type="columns_2"><div style="display:flex;gap:10px;"><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:10px;background:#fff;"><span class="bbf-col-placeholder">Spalte 1</span></div><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:10px;background:#fff;"><span class="bbf-col-placeholder">Spalte 2</span></div></div></div>` });

    bm.add('bbf-row-3', { label: '3 Spalten', category: 'Layout', attributes: { class: 'fa fa-th' },
        content: `<div class="bbf-col-wrap" data-gjs-type="bbf-layout" data-field-type="columns_3"><div style="display:flex;gap:10px;"><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:10px;background:#fff;"><span class="bbf-col-placeholder">1/3</span></div><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:10px;background:#fff;"><span class="bbf-col-placeholder">1/3</span></div><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:10px;background:#fff;"><span class="bbf-col-placeholder">1/3</span></div></div></div>` });

    bm.add('bbf-row-4', { label: '4 Spalten', category: 'Layout', attributes: { class: 'fa fa-th-large' },
        content: `<div class="bbf-col-wrap" data-gjs-type="bbf-layout" data-field-type="columns_4"><div style="display:flex;gap:8px;"><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:8px;background:#fff;"><span class="bbf-col-placeholder">1/4</span></div><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:8px;background:#fff;"><span class="bbf-col-placeholder">1/4</span></div><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:8px;background:#fff;"><span class="bbf-col-placeholder">1/4</span></div><div style="flex:1;min-height:70px;border:1.5px dashed #e5e7eb;border-radius:6px;padding:8px;background:#fff;"><span class="bbf-col-placeholder">1/4</span></div></div></div>` });

    bm.add('bbf-section', { label: 'Abschnitt', category: 'Layout', attributes: { class: 'fa fa-minus' },
        content: `<div class="bbf-section-break" data-gjs-type="bbf-layout" data-field-type="section_break"><h5>Abschnittstitel</h5><p>Optionale Beschreibung</p><hr /></div>` });

    bm.add('bbf-page-break', { label: 'Seitenumbruch', category: 'Layout', attributes: { class: 'fa fa-arrow-right' },
        content: `<div class="bbf-page-break" data-gjs-type="bbf-layout" data-field-type="page_break"><i class="fa fa-arrow-right"></i> Nächster Schritt</div>` });

    bm.add('bbf-html', { label: 'HTML-Block', category: 'Layout', attributes: { class: 'fa fa-code' },
        content: `<div class="bbf-field" data-gjs-type="bbf-layout" data-field-type="html_block"><p style="color:#9ca3af;font-size:13px;margin:0;">Freier HTML-Inhalt — doppelklicken zum Bearbeiten</p></div>` });

    // ── Spezial (3) ──────────────────────────────────────

    bm.add('bbf-gdpr', { label: 'DSGVO', category: 'Spezial', attributes: { class: 'fa fa-shield' },
        content: `<div class="bbf-gdpr-field" data-gjs-type="bbf-field" data-field-type="gdpr"><input type="checkbox" required /><label>Ich stimme der Verarbeitung meiner Daten gemäß der <a href="/datenschutz">Datenschutzerklärung</a> zu. *</label></div>` });

    bm.add('bbf-captcha', { label: 'CAPTCHA', category: 'Spezial', attributes: { class: 'fa fa-shield' },
        content: `<div class="bbf-captcha-preview" data-gjs-type="bbf-field" data-field-type="captcha"><i class="fa fa-shield" style="font-size:28px;color:#d1d5db;display:block;margin-bottom:8px;"></i><span>CAPTCHA wird im Frontend geladen</span></div>` });

    bm.add('bbf-submit', { label: 'Absenden', category: 'Spezial', attributes: { class: 'fa fa-paper-plane' },
        content: `<div class="bbf-submit-wrap" data-gjs-type="bbf-submit"><button type="submit" class="bbf-submit-btn"><i class="fa fa-paper-plane"></i> Absenden</button></div>` });
}
