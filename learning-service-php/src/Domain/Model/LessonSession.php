<?php

namespace App\Domain\Model;

class LessonSession {
    public function __construct(
        public string $id,
        public string $studentId,
        public string $lessonId,
        public string $status = 'IN_PROGRESS',
        public int $currentChallengeIndex = 0,
        public int $heartsRemaining = 5,
        public int $xpGained = 0
    ) {}

    public function isFinished(): bool {
        return $this->status !== 'IN_PROGRESS';
    }
}
