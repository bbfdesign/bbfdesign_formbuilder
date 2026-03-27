<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Email\Styles;

class MinimalStyle implements EmailStyleInterface
{
    public function getIdentifier(): string { return 'minimal'; }
    public function getLabel(): string { return 'Minimal'; }

    public function wrap(string $content, array $mergeData): string
    {
        $formName = htmlspecialchars($mergeData['formular_name'] ?? 'Formular');
        $shopName = htmlspecialchars($mergeData['shop_name'] ?? '');

        return <<<HTML
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<style>
body{margin:0;padding:0;background:#fff;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;color:#374151;}
.wrapper{max-width:600px;margin:0 auto;padding:40px 24px;}
h1{font-size:18px;font-weight:600;color:#111827;margin:0 0 24px;padding-bottom:16px;border-bottom:2px solid #e5e7eb;}
table{width:100%;border-collapse:collapse;}
td{padding:8px 0;font-size:14px;border-bottom:1px solid #f3f4f6;}
td:first-child{font-weight:600;color:#6b7280;width:35%;vertical-align:top;}
.footer{margin-top:32px;padding-top:16px;border-top:1px solid #e5e7eb;font-size:12px;color:#9ca3af;}
</style>
</head>
<body>
<div class="wrapper">
<h1>{$formName}</h1>
{$content}
<div class="footer">{$shopName}</div>
</div>
</body>
</html>
HTML;
    }
}
