<?php
namespace App\Infrastructure;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface as Handler;
use App\Domain\Repositories\UserRepositoryInterface;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class CheckPermissionMiddleware implements MiddlewareInterface {
    private string $module;
    private string $jwtSecret; // Fallback for legacy tokens
    private ?UserRepositoryInterface $repository;
    private ?\App\Domain\Repositories\JwtKeyRepositoryInterface $keyRepository;

    public function __construct(
        string $module, 
        string $jwtSecret = 'my_super_secret_key', 
        ?UserRepositoryInterface $repository = null,
        ?\App\Domain\Repositories\JwtKeyRepositoryInterface $keyRepository = null
    ) {
        $this->module = $module;
        $this->jwtSecret = $jwtSecret;
        $this->repository = $repository;
        $this->keyRepository = $keyRepository;
    }

    public function process(Request $request, Handler $handler): Response {
        $authHeader = $request->getHeaderLine('Authorization');
        if (!$authHeader) {
            $response = new \Slim\Psr7\Response();
            $response->getBody()->write(json_encode(['error' => 'No token provided']));
            return $response->withStatus(401)->withHeader('Content-Type', 'application/json');
        }

        $token = str_replace('Bearer ', '', $authHeader);
        try {
            // 1. Resolve signing key
            $secret = $this->jwtSecret;
            $tks = explode('.', $token);
            if (count($tks) === 3) {
                $header = json_decode(base64_decode($tks[0]), true);
                if (isset($header['kid']) && $this->keyRepository) {
                    $keyData = $this->keyRepository->findByKid($header['kid']);
                    if ($keyData) {
                        $secret = $keyData['secret'];
                    }
                }
            }

            $payload = (array) JWT::decode($token, new Key($secret, 'HS256'));
            
            // Verify session is active if sid is present
            if ($this->repository && isset($payload['sid'])) {
                if (!$this->repository->isSessionActive($payload['sid'])) {
                    $response = new \Slim\Psr7\Response();
                    $response->getBody()->write(json_encode(['error' => 'La sesión ha sido cerrada remotamente']));
                    return $response->withStatus(401)->withHeader('Content-Type', 'application/json');
                }
            }

            $modules = $payload['modules'] ?? [];
            
            $request = $request->withAttribute('user_id', $payload['sub'] ?? null)
                               ->withAttribute('user_role', $payload['rol'] ?? null)
                               ->withAttribute('sid', $payload['sid'] ?? null);

            if ($this->module !== 'ANY' && !in_array($this->module, $modules)) {
                $response = new \Slim\Psr7\Response();
                $response->getBody()->write(json_encode(['error' => "Access denied to module: {$this->module}"]));
                return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
            }
        } catch (\Firebase\JWT\ExpiredException $e) {
            $response = new \Slim\Psr7\Response();
            $response->getBody()->write(json_encode(['error' => 'Token expirado. Por favor, inicie sesión nuevamente.']));
            return $response->withStatus(401)->withHeader('Content-Type', 'application/json');
        } catch (\Throwable $e) {
            $response = new \Slim\Psr7\Response();
            $response->getBody()->write(json_encode(['error' => 'Acceso no autorizado'])); // Generic message for security
            return $response->withStatus(401)->withHeader('Content-Type', 'application/json');
        }

        return $handler->handle($request);
    }
}
