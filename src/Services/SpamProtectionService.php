<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\SpamProtection\SpamCheckResult;
use BbfdesignFormbuilder\SpamProtection\SpamProtectorInterface;
use BbfdesignFormbuilder\SpamProtection\SpamProtectorRegistry;
use JTL\Shop;

class SpamProtectionService
{
    private SpamProtectorRegistry $registry;

    public function __construct(SpamProtectorRegistry $registry)
    {
        $this->registry = $registry;
    }

    /**
     * Run all active spam protectors against the submission.
     *
     * @return SpamCheckResult|null The first failed result, or null if all passed
     */
    public function check(array $submissionData, int $formId): ?SpamCheckResult
    {
        foreach ($this->registry->getActive() as $protector) {
            $result = $protector->validate($submissionData);
            if ($result->isSpam) {
                $this->logSpam($formId, $result);
                return $result;
            }
        }

        return null;
    }

    /**
     * Log a spam detection event.
     */
    private function logSpam(int $formId, SpamCheckResult $result): void
    {
        $ip = $_SERVER['REMOTE_ADDR'] ?? '';

        Shop::Container()->getDB()->queryPrepared(
            'INSERT INTO bbf_formbuilder_spam_log (form_id, ip_address, reason, details) VALUES (:fid, :ip, :reason, :details)',
            [
                'fid'     => $formId,
                'ip'      => $ip,
                'reason'  => $result->protector . ':' . $result->reason,
                'details' => json_encode(['score' => $result->score]),
            ]
        );
    }

    /**
     * Get spam count for dashboard.
     */
    public static function getSpamCount(): int
    {
        $result = Shop::Container()->getDB()->queryPrepared(
            'SELECT COUNT(*) as cnt FROM bbf_formbuilder_spam_log',
            []
        );
        return (int)($result[0]['cnt'] ?? 0);
    }
}
