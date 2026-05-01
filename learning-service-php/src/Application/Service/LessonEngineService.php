<?php

namespace App\Application\Service;

use App\Domain\Model\LessonSession;
use App\Domain\Model\StudentProgress;

class LessonEngineService {
    public function evaluateAnswer(LessonSession $session, string $answer, string $correctAnswer): array {
        $isCorrect = (trim(strtolower($answer)) === trim(strtolower($correctAnswer)));
        
        if ($isCorrect) {
            $session->xpGained += 10;
        } else {
            $session->heartsRemaining--;
            if ($session->heartsRemaining <= 0) {
                $session->status = 'FAILED';
            }
        }

        return [
            'correct' => $isCorrect,
            'xpGained' => $session->xpGained,
            'heartsLeft' => $session->heartsRemaining,
            'status' => $session->status
        ];
    }
}
