<?php
namespace App\Infrastructure\Controllers;

use App\Application\UseCases\AuthenticateUserUseCase;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class AuthController {
    private AuthenticateUserUseCase $useCase;

    public function __construct(AuthenticateUserUseCase $useCase) {
        $this->useCase = $useCase;
    }

    public function login(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        try {
            $ip = $request->getServerParams()['REMOTE_ADDR'] ?? 'unknown';
            $ua = $request->getHeaderLine('User-Agent');
            $lat = isset($data['latitude']) ? (float)$data['latitude'] : null;
            $lng = isset($data['longitude']) ? (float)$data['longitude'] : null;
            $token = $this->useCase->execute($data['username'], $data['password'], $ip, $ua, $lat, $lng);
            $response->getBody()->write(json_encode(['jwt' => $token]));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Exception $e) {
            $response->getBody()->write(json_encode(['error' => $e->getMessage()]));
            return $response->withStatus(401)->withHeader('Content-Type', 'application/json');
        }
    }
}
