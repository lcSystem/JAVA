<?php

namespace App\Domain\Model;

class StudentProgress {
    public function __construct(
        public string $id,
        public string $studentId,
        public string $subjectId,
        public int $currentLevel = 1,
        public int $totalXp = 0,
        public int $hearts = 5,
        public int $streakDays = 0,
        public ?string $lastParticipationAt = null
    ) {}

    public function addXp(int $amount): void {
        $this->totalXp += $amount;
    }

    public function loseHeart(): void {
        if ($this->hearts > 0) {
            $this->hearts--;
        }
    }
}
