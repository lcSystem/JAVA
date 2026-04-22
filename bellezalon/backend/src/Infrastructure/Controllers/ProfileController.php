<?php
namespace App\Infrastructure\Controllers;

use App\Domain\Repositories\UserRepositoryInterface;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class ProfileController {
    private UserRepositoryInterface $repository;

    public function __construct(UserRepositoryInterface $repository) {
        $this->repository = $repository;
    }

    public function getProfile(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        if (!$userId) {
            $response->getBody()->write(json_encode(['error' => 'No autorizado']));
            return $response->withStatus(401)->withHeader('Content-Type', 'application/json');
        }

        $user = $this->repository->findById($userId);
        if (!$user) {
            $response->getBody()->write(json_encode(['error' => 'Usuario no encontrado']));
            return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
        }

        $response->getBody()->write(json_encode([
            'id' => $user->getId(),
            'username' => $user->getUsername(),
            'full_name' => $user->getFullName(),
            'email' => $user->getEmail(),
            'phone' => $user->getPhone(),
            'city' => $user->getCity(),
            'neighborhood' => $user->getNeighborhood(),
            'address' => $user->getAddress(),
            'avatar_url' => $user->getAvatarUrl(),
            'role_name' => $user->getRoleName(),
            'technical_sheet' => $user->getTechnicalSheet() ? json_decode($user->getTechnicalSheet(), true) : null
        ]));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function updateProfile(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        $data = $request->getParsedBody();
        file_put_contents('/tmp/profile_debug.log', "UpdateProfile called for user: $userId with data: " . json_encode($data) . "\n", FILE_APPEND);
        
        $user = $this->repository->findById($userId);
        if (!$user) {
            file_put_contents('/tmp/profile_debug.log', "User not found for update: $userId\n", FILE_APPEND);
            $response->getBody()->write(json_encode(['error' => 'Usuario no encontrado']));
            return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
        }

        // Create updated user object
        $updatedUser = new \App\Domain\Entities\User(
            $user->getId(),
            $user->getUsername(),
            isset($data['password']) && !empty($data['password']) ? password_hash($data['password'], PASSWORD_DEFAULT) : $user->getPassword(),
            $user->getRoleId(),
            $user->getRoleName(),
            $user->getPermissions(),
            $user->getEstado(),
            $data['full_name'] ?? $user->getFullName(),
            $data['email'] ?? $user->getEmail(),
            $data['phone'] ?? $user->getPhone(),
            $data['city'] ?? $user->getCity(),
            $data['neighborhood'] ?? $user->getNeighborhood(),
            $data['address'] ?? $user->getAddress(),
            $data['avatar_url'] ?? $user->getAvatarUrl(),
            isset($data['technical_sheet']) ? json_encode($data['technical_sheet']) : $user->getTechnicalSheet()
        );

        $this->repository->save($updatedUser);
        
        $response->getBody()->write(json_encode(['message' => 'Perfil actualizado correctamente']));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function uploadPhoto(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        $uploadedFiles = $request->getUploadedFiles();
        
        if (empty($uploadedFiles['photo'])) {
            $response->getBody()->write(json_encode(['error' => 'No se subió ninguna imagen']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $photo = $uploadedFiles['photo'];
        $extension = pathinfo($photo->getClientFilename(), PATHINFO_EXTENSION);
        $filename = 'profile_' . $userId . '_' . time() . '.' . $extension;
        $uploadPath = __DIR__ . '/../../uploads/profiles/' . $filename;

        if (!is_dir(dirname($uploadPath))) {
            mkdir(dirname($uploadPath), 0777, true);
        }

        $photo->moveTo($uploadPath);
        $url = '/uploads/profiles/' . $filename;

        $user = $this->repository->findById($userId);
        $updatedUser = new \App\Domain\Entities\User(
            $user->getId(),
            $user->getUsername(),
            $user->getPassword(),
            $user->getRoleId(),
            $user->getRoleName(),
            $user->getPermissions(),
            $user->getEstado(),
            $user->getFullName(),
            $user->getEmail(),
            $user->getPhone(),
            $user->getCity(),
            $user->getNeighborhood(),
            $user->getAddress(),
            $url
        );

        $this->repository->save($updatedUser);

        $response->getBody()->write(json_encode(['success' => true, 'url' => $url]));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
