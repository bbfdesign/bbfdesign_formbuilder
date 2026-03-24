<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\SpamProtection;

class SpamProtectorRegistry
{
    /** @var SpamProtectorInterface[] */
    private array $protectors = [];

    /** @var string[] IDs of protectors that are currently active */
    private array $activeIds = [];

    public function register(SpamProtectorInterface $protector): void
    {
        $this->protectors[$protector->getIdentifier()] = $protector;
    }

    public function get(string $id): ?SpamProtectorInterface
    {
        return $this->protectors[$id] ?? null;
    }

    /** @return SpamProtectorInterface[] */
    public function getAll(): array
    {
        return $this->protectors;
    }

    public function setActive(array $ids): void
    {
        $this->activeIds = $ids;
    }

    /** @return SpamProtectorInterface[] */
    public function getActive(): array
    {
        $active = [];
        foreach ($this->activeIds as $id) {
            if (isset($this->protectors[$id])) {
                $active[$id] = $this->protectors[$id];
            }
        }
        return $active;
    }
}
