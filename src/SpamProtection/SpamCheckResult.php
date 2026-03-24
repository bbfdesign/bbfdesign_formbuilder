<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

class SpamCheckResult
{
    public bool $isSpam;
    public float $score;
    public string $reason;
    public string $protector;

    public function __construct(bool $isSpam, float $score = 0.0, string $reason = '', string $protector = '')
    {
        $this->isSpam = $isSpam;
        $this->score = $score;
        $this->reason = $reason;
        $this->protector = $protector;
    }

    public static function pass(string $protector): self
    {
        return new self(false, 0.0, '', $protector);
    }

    public static function fail(string $protector, string $reason, float $score = 1.0): self
    {
        return new self(true, $score, $reason, $protector);
    }
}
