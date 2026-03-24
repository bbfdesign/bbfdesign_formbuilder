{* BBF Formbuilder – Fancy HTML Email Template *}
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{$subject}</title>
    <!--[if mso]>
    <style type="text/css">
        table, td {ldelim}font-family: Arial, sans-serif;{rdelim}
    </style>
    <![endif]-->
</head>
<body style="margin: 0; padding: 0; background-color: #f4f5f7; font-family: Arial, Helvetica, sans-serif; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color: #f4f5f7;">
        <tr>
            <td align="center" style="padding: 40px 20px;">
                <table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width: 600px; width: 100%;">

                    {* Header with gradient *}
                    <tr>
                        <td style="background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); border-radius: 8px 8px 0 0; padding: 30px 40px; text-align: center;">
                            {if isset($shopLogo) && $shopLogo}
                                <img src="{$shopLogo}" alt="{$shopName}" style="max-height: 50px; margin-bottom: 10px;">
                            {/if}
                            <h1 style="margin: 0; color: #ffffff; font-size: 22px; font-weight: 700; line-height: 1.3;">
                                {$subject}
                            </h1>
                        </td>
                    </tr>

                    {* Content area *}
                    <tr>
                        <td style="background-color: #ffffff; padding: 40px; border-left: 1px solid #e5e7eb; border-right: 1px solid #e5e7eb;">
                            <table role="presentation" width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="color: #1a1a1a; font-size: 15px; line-height: 1.6;">
                                        {$content}
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    {* Footer *}
                    <tr>
                        <td style="background-color: #f9fafb; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px; padding: 20px 40px; text-align: center;">
                            <p style="margin: 0; color: #6b7280; font-size: 12px; line-height: 1.5;">
                                {if isset($shopName)}{$shopName}{/if}
                                {if isset($shopUrl)}<br><a href="{$shopUrl}" style="color: #2563eb; text-decoration: none;">{$shopUrl}</a>{/if}
                            </p>
                            <p style="margin: 8px 0 0; color: #9ca3af; font-size: 11px;">
                                Diese E-Mail wurde automatisch generiert.
                            </p>
                        </td>
                    </tr>

                </table>
            </td>
        </tr>
    </table>
</body>
</html>
