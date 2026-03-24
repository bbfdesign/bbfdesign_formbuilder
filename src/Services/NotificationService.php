<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Helpers\MergeTagHelper;
use BbfdesignFormbuilder\Models\FormNotification;
use BbfdesignFormbuilder\Models\Setting;
use BbfdesignFormbuilder\PluginHelper;
use JTL\Shop;

class NotificationService
{
    /**
     * Send all active notifications for a form submission.
     */
    public function sendNotifications(int $formId, array $entryValues, int $entryId, array $fields): void
    {
        $notificationModel = new FormNotification();
        $notifications = $notificationModel->getByFormId($formId);

        foreach ($notifications as $notification) {
            $notif = (object)$notification;
            if (!(int)$notif->is_active) {
                continue;
            }

            // Check conditional logic
            if (!empty($notif->conditional_logic_json)) {
                $logic = json_decode($notif->conditional_logic_json, true);
                if (!empty($logic)) {
                    $condService = new ConditionalLogicService();
                    if (!$condService->evaluate($logic, $entryValues)) {
                        continue;
                    }
                }
            }

            $this->sendSingleNotification($notif, $entryValues, $entryId, $fields, $formId);
        }
    }

    private function sendSingleNotification(object $notification, array $values, int $entryId, array $fields, int $formId): void
    {
        $mergeHelper = new MergeTagHelper();
        $mergeData = $mergeHelper->buildMergeData($values, $fields, $entryId, $formId);

        // Determine recipient
        $recipients = [];
        if ($notification->recipient_type === 'fixed' || $notification->recipient_type === 'both') {
            if (!empty($notification->recipient_email)) {
                $recipients = array_merge($recipients, array_map('trim', explode(',', $notification->recipient_email)));
            }
        }
        if ($notification->recipient_type === 'field' || $notification->recipient_type === 'both') {
            if (!empty($notification->recipient_field) && !empty($values[$notification->recipient_field])) {
                $recipients[] = $values[$notification->recipient_field];
            }
        }

        if (empty($recipients)) {
            return;
        }

        $subject = $mergeHelper->parse($notification->subject, $mergeData);
        $message = $mergeHelper->parse($notification->message, $mergeData);

        // Render email template
        $emailTemplateService = new EmailTemplateService();
        $renderedHtml = $emailTemplateService->render(
            $notification->email_template ?? 'standard',
            $message,
            $mergeData,
            (int)($notification->custom_template_id ?? 0)
        );

        $senderEmail = $notification->sender_email ?: (PluginHelper::getSetting(Setting::DEFAULT_FROM_EMAIL) ?: '');
        $senderName = $notification->sender_name ?: (PluginHelper::getSetting(Setting::DEFAULT_FROM_NAME) ?: '');

        foreach ($recipients as $recipient) {
            $recipient = trim($recipient);
            if (!filter_var($recipient, FILTER_VALIDATE_EMAIL)) {
                continue;
            }

            try {
                $mailer = Shop::Container()->get(\JTL\Mail\Mailer::class);
                $mail = new \JTL\Mail\Mail\Mail();
                $mail->setToMail($recipient);
                $mail->setSubject($subject);
                $mail->setBodyHTML($renderedHtml);

                if (!empty($senderEmail)) {
                    $mail->setFromMail($senderEmail);
                }
                if (!empty($senderName)) {
                    $mail->setFromName($senderName);
                }

                if (!empty($notification->reply_to_field) && !empty($values[$notification->reply_to_field])) {
                    $mail->setReplyToMail($values[$notification->reply_to_field]);
                }

                if (!empty($notification->cc)) {
                    foreach (explode(',', $notification->cc) as $cc) {
                        $cc = trim($cc);
                        if (filter_var($cc, FILTER_VALIDATE_EMAIL)) {
                            $mail->setCopyRecipientMail($cc);
                        }
                    }
                }

                $mailer->send($mail);
            } catch (\Exception $e) {
                Shop::Container()->getLogService()->error(
                    'BBF Formbuilder: E-Mail-Versand fehlgeschlagen an ' . $recipient . ': ' . $e->getMessage()
                );
            }
        }
    }
}
