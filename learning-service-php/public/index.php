<?php

use Slim\Factory\AppFactory;

require __DIR__ . '/../vendor/autoload.php';

$app = AppFactory::create();

// CORS Middleware
$app->add(function ($request, $handler) {
    if ($request->getMethod() === 'OPTIONS') {
        $response = new \Slim\Psr7\Response();
    } else {
        $response = $handler->handle($request);
    }
    return $response
        ->withHeader('Access-Control-Allow-Origin', '*')
        ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
        ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
});

// Add generic Error Middleware
$app->addErrorMiddleware(true, true, true);

// Academic Endpoints
$app->get('/api/v1/learning/subjects', [\App\Infrastructure\Adapter\Http\LearningController::class, 'getSubjects']);
$app->post('/api/v1/learning/subjects', [\App\Infrastructure\Adapter\Http\LearningController::class, 'createSubject']);
$app->get('/api/v1/learning/subjects/{id}/units', [\App\Infrastructure\Adapter\Http\LearningController::class, 'getUnits']);

// Lesson Engine Endpoints
$app->post('/api/v1/lessons/start', [\App\Infrastructure\Adapter\Http\LessonController::class, 'startLesson']);
$app->post('/api/v1/challenges/submit', [\App\Infrastructure\Adapter\Http\LessonController::class, 'submitAnswer']);

$app->run();
