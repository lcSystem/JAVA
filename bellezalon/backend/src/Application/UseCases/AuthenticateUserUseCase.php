<?php
namespace App\Application\UseCases;

use App\Domain\Repositories\UserRepositoryInterface;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class AuthenticateUserUseCase {
    private UserRepositoryInterface $repository;
    private string $jwtSecret;
    private ?\App\Domain\Repositories\JwtKeyRepositoryInterface $keyRepository;

    public function __construct(
        UserRepositoryInterface $repository, 
        string $jwtSecret,
        ?\App\Domain\Repositories\JwtKeyRepositoryInterface $keyRepository = null
    ) {
        $this->repository = $repository;
        $this->jwtSecret = $jwtSecret;
        $this->keyRepository = $keyRepository;
    }

    public function execute(string $username, string $password, string $ip = '', string $userAgent = '', ?float $latitude = null, ?float $longitude = null): string {
        $user = $this->repository->findByUsername($username);

        if (!$user || !password_verify($password, $user->getPassword())) {
            throw new \Exception("Invalid credentials.");
        }

        // Get location from IP
        $location = $this->getLocationFromIp($ip);

        // Record successful login
        $loginId = $this->repository->recordLogin(
            $user->getId(), 
            $ip, 
            $userAgent,
            $latitude ?? ($location['lat'] ?? null),
            $longitude ?? ($location['lon'] ?? null),
            $location['city'] ?? null,
            null // neighborhood
        );

        if ($user->getEstado() === 'inactivo') {
            throw new \Exception("Tu cuenta aún no ha sido activada o está inactiva. Por favor, contacte al administrador.");
        }

        $payload = [
            'iat' => time(),
            'exp' => time() + (8 * 60 * 60), // 8 hours
            'sub' => $user->getId(),
            'sid' => $loginId,
            'username' => $user->getUsername(),
            'rol' => $user->getRoleName(),
            'modules' => $user->getPermissions()
        ];

        $secret = $this->jwtSecret;
        $headers = [];

        if ($this->keyRepository) {
            $currentKey = $this->keyRepository->rotateKeys(); // Ensures we use a fresh key
            $secret = $currentKey['secret'];
            $headers = ['kid' => $currentKey['kid']];
        }

        return JWT::encode($payload, $secret, 'HS256', null, $headers);
    }

    private function getLocationFromIp(string $ip): array {
        // Fallback for localhost
        if ($ip === '127.0.0.1' || $ip === '::1' || str_starts_with($ip, '192.168.')) {
            return [
                'lat' => 4.6097,
                'lon' => -74.0817,
                'city' => 'Bogotá (Dev)'
            ];
        }

        try {
            $context = stream_context_create([
                'http' => ['timeout' => 2] // 2 second timeout
            ]);
            $response = @file_get_contents("http://ip-api.com/json/{$ip}", false, $context);
            if ($response) {
                $data = json_decode($response, true);
                if ($data && ($data['status'] ?? '') === 'success') {
                    return [
                        'lat' => $data['lat'],
                        'lon' => $data['lon'],
                        'city' => $data['city']
                    ];
                }
            }
        } catch (\Exception $e) {
            // Ignore errors in location retrieval to avoid blocking login
        }

        return [];
    }
}
