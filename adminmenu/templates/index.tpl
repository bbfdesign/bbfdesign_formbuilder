<link rel="stylesheet" href="{$adminUrl}css/admin.css">
<link rel="stylesheet" href="{$adminUrl}js/dist/grapes.min.css">

<div class="bbf-plugin-page">
    {$jtl_token}

    {* Sidebar Navigation *}
    <div class="bbf-sidebar" id="bbf-sidebar">
        <div class="bbf-sidebar-header">
            <div class="bbf-sidebar-logo">
                <img src="{$adminUrl}images/Logo_bbfdesign_dark_2024.png" alt="bbf.design" class="bbf-logo-img">
            </div>
            <button type="button" class="bbf-sidebar-toggle" id="bbf-sidebar-toggle">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="3" y1="12" x2="21" y2="12"></line>
                    <line x1="3" y1="6" x2="21" y2="6"></line>
                    <line x1="3" y1="18" x2="21" y2="18"></line>
                </svg>
            </button>
        </div>

        <div class="bbf-sidebar-content">
            {* ÜBERSICHT section *}
            <div class="bbf-nav-section">ÜBERSICHT</div>
            <ul class="bbf-sidebar-nav">
                <li>
                    <a href="#" data-page="dashboard" onclick="bbfNavigate('dashboard'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                        <span>Dashboard</span>
                    </a>
                </li>
            </ul>

            {* FORMULARE section *}
            <div class="bbf-nav-section">FORMULARE</div>
            <ul class="bbf-sidebar-nav">
                <li>
                    <a href="#" data-page="forms" onclick="bbfNavigate('forms'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        <span>Alle Formulare</span>
                    </a>
                </li>
                <li>
                    <a href="#" data-page="templates" onclick="bbfNavigate('templates'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="3" y1="9" x2="21" y2="9"></line><line x1="9" y1="21" x2="9" y2="9"></line></svg>
                        <span>Vorlagen</span>
                    </a>
                </li>
            </ul>

            {* DATEN section *}
            <div class="bbf-nav-section">DATEN</div>
            <ul class="bbf-sidebar-nav">
                <li>
                    <a href="#" data-page="entries" onclick="bbfNavigate('entries'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                        <span>Einträge</span>
                    </a>
                </li>
            </ul>

            {* EINSTELLUNGEN section *}
            <div class="bbf-nav-section">EINSTELLUNGEN</div>
            <ul class="bbf-sidebar-nav">
                <li>
                    <a href="#" data-page="settings" onclick="bbfNavigate('settings'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                        <span>Allgemein</span>
                    </a>
                </li>
                <li>
                    <a href="#" data-page="spam-protection" onclick="bbfNavigate('spam-protection'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                        <span>Spam-Schutz</span>
                    </a>
                </li>
                <li>
                    <a href="#" data-page="gdpr" onclick="bbfNavigate('gdpr'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        <span>DSGVO</span>
                    </a>
                </li>
                <li>
                    <a href="#" data-page="email-templates" onclick="bbfNavigate('email-templates'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                        <span>E-Mail-Templates</span>
                    </a>
                </li>
                <li>
                    <a href="#" data-page="css-editor" onclick="bbfNavigate('css-editor'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>
                        <span>CSS-Editor</span>
                    </a>
                </li>
            </ul>

            {* HILFE section *}
            <div class="bbf-nav-section">HILFE</div>
            <ul class="bbf-sidebar-nav">
                <li>
                    <a href="#" data-page="documentation" onclick="bbfNavigate('documentation'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path></svg>
                        <span>Dokumentation</span>
                    </a>
                </li>
                <li>
                    <a href="#" data-page="changelog" onclick="bbfNavigate('changelog'); return false;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        <span>Changelog</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="bbf-sidebar-footer">
            <span class="bbf-version">v{$pluginVersion}</span>
        </div>
    </div>

    {* Main Content *}
    <div class="bbf-main">
        <div class="bbf-header">
            <div class="bbf-header-inner">
                <div>
                    <h3 class="bbf-header-title" id="bbf-page-title">BBF Formbuilder</h3>
                    <p class="bbf-header-subtitle">Professioneller Formular-Builder für JTL-Shop 5</p>
                </div>
            </div>
        </div>

        <div class="bbf-content">
            <div id="bbf-page-content">
                <div class="text-center" style="padding: 60px 0;">
                    <div class="bbf-spinner" style="width:40px; height:40px; border-width:3px; margin: 0 auto 16px;"></div>
                    <p style="color: var(--bbf-text-light);">Lade...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var ShopURL = "{$ShopURL}";
    var adminUrl = "{$adminUrl}";
    var postURL = "{$postURL}";
</script>
<script src="{$adminUrl}js/vendor/bootstrap-notify.min.js"></script>
<script src="{$adminUrl}js/admin.js"></script>
