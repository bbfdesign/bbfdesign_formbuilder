<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

use JTL\Shop;

class RateLimitProtector implements SpamProtectorInterface
{
    private int $maxSubmissions;
    private int $windowSeconds;

    public function __construct(int $maxSubmissions = 10, int $windowSeconds = 3600)
    {
        $this->maxSubmissions = $maxSubmissions;
        $this->windowSeconds = $windowSeconds;
    }

    public function getIdentifier(): string { return 'rate_limit'; }
    public function getDisplayName(): string { return 'Rate Limiting'; }
    public function requiresExternalScripts(): bool { return false; }
    public function requiresConsent(): bool { return false; }
    public function getScripts(): array { return []; }
    public function getConfigFields(): array { return []; }
    public function renderWidget(array $formConfig): string { return ''; }

    public function validate(array $submissionData): SpamCheckResult
    {
        $ip = $_SERVER['REMOTE_ADDR'] ?? '';
        if (empty($ip)) {
            return SpamCheckResult::pass('rate_limit');
        }

        $db = Shop::Container()->getDB();
        $result = $db->queryPrepared(
            'SELECT COUNT(*) as cnt FROM bbf_formbuilder_entries
             WHERE ip_address = :ip AND created_at > DATE_SUB(NOW(), INTERVAL :window SECOND)',
            ['ip' => $ip, 'window' => $this->windowSeconds]
        );

        $count = (int)($result[0]['cnt'] ?? 0);

        if ($count >= $this->maxSubmissions) {
            return SpamCheckResult::fail('rate_limit', 'Rate limit exceeded: ' . $count . ' submissions', 0.9);
        }

        return SpamCheckResult::pass('rate_limit');
    }
}
