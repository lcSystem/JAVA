<?php

namespace App\Infrastructure\Adapter\Http;

use App\Application\Service\LessonEngineService;
use App\Domain\Model\LessonSession;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class LessonController {
    private LessonEngineService $engineService;

    public function __construct() {
        $this->engineService = new LessonEngineService();
    }

    public function startLesson(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        $studentId = $data['studentId'] ?? 'guest';
        $lessonId = $data['lessonId'] ?? '';

        // In a real app, we would persist this to MySQL
        $session = new LessonSession(
            id: uniqid('sess_'),
            studentId: $studentId,
            lessonId: $lessonId
        );

        $response->getBody()->write(json_encode($session));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function submitAnswer(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        $sessionId = $data['sessionId'] ?? '';
        $answer = $data['answer'] ?? '';

        // Mock session and correct answer for demonstration
        $session = new LessonSession(id: $sessionId, studentId: 's1', lessonId: 'l1');
        $result = $this->engineService->evaluateAnswer($session, $answer, '4'); // Example: 2+2

        $response->getBody()->write(json_encode($result));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
