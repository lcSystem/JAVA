<?php

namespace App\Infrastructure\Adapter\Http;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class LearningController {
    public function getSubjects(Request $request, Response $response): Response {
        $db = \App\Infrastructure\Persistence\Database::getConnection();
        $stmt = $db->query("SELECT * FROM subjects");
        $subjects = $stmt->fetchAll();
        $response->getBody()->write(json_encode($subjects));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function createSubject(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        $name = $data['name'] ?? '';
        $description = $data['description'] ?? '';

        $db = \App\Infrastructure\Persistence\Database::getConnection();
        $stmt = $db->prepare("INSERT INTO subjects (id, name, description) VALUES (?, ?, ?)");
        $id = uniqid('subj_');
        $stmt->execute([$id, $name, $description]);

        $response->getBody()->write(json_encode(['id' => $id, 'status' => 'created']));
        return $response->withHeader('Content-Type', 'application/json')->withStatus(201);
    }

    public function getUnits(Request $request, Response $response, array $args): Response {
        $db = \App\Infrastructure\Persistence\Database::getConnection();
        $subjectId = $args['id'];
        $stmt = $db->prepare("SELECT * FROM units WHERE subject_id = ? ORDER BY order_index ASC");
        $stmt->execute([$subjectId]);
        $units = $stmt->fetchAll();
        
        $response->getBody()->write(json_encode($units));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
