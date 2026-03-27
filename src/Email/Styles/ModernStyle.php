<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Email\Styles;

class ModernStyle implements EmailStyleInterface
{
    public function getIdentifier(): string { return 'modern'; }
    public function getLabel(): string { return 'Modern (BBF-Design)'; }

    public function wrap(string $content, array $mergeData): string
    {
        $formName = htmlspecialchars($mergeData['formular_name'] ?? 'Formular');
        $date = htmlspecialchars($mergeData['datum'] ?? date('d.m.Y'));
        $shopName = htmlspecialchars($mergeData['shop_name'] ?? '');

        return <<<HTML
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<style>
body{margin:0;padding:0;background:#f4f4f5;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;}
.wrapper{max-width:600px;margin:32px auto;background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,.08);}
.header{background:linear-gradient(135deg,#e8420a,#ff6b35);padding:32px 40px;}
.header h1{margin:0;color:#fff;font-size:22px;font-weight:700;}
.header p{margin:6px 0 0;color:rgba(255,255,255,.85);font-size:14px;}
.body{padding:32px 40px;}
.body p{color:#374151;font-size:15px;line-height:1.6;}
table{width:100%;border-collapse:collapse;}
td{padding:10px 12px;border-bottom:1px solid #f3f4f6;font-size:14px;color:#374151;}
td:first-child{font-weight:600;color:#6b7280;width:35%;vertical-align:top;}
.footer{padding:20px 40px;background:#f9fafb;border-top:1px solid #f3f4f6;}
.footer p{margin:0;font-size:12px;color:#9ca3af;text-align:center;}
</style>
</head>
<body>
<div class="wrapper">
<div class="header">
<h1>{$formName}</h1>
<p>Neue Einsendung vom {$date}</p>
</div>
<div class="body">
{$content}
</div>
<div class="footer">
<p>Diese E-Mail wurde automatisch von {$shopName} gesendet.</p>
</div>
</div>
</body>
</html>
HTML;
    }
}
