<?php
namespace App\Infrastructure\Controllers;

use PDO;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class HomeController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getGallery(Request $request, Response $response): Response {
        $stmt = $this->pdo->query("SELECT * FROM gallery ORDER BY created_at DESC");
        $images = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Prepend baseUrl equivalent where needed if the frontend expects complete paths.
        // Actually, the frontend builds url with ApiService.baseUrl. Just return path.
        
        $response->getBody()->write(json_encode($images));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function uploadImage(Request $request, Response $response): Response {
        $userRole = $request->getAttribute('user_role');
        if ($userRole !== 'Administrador') {
            $response->getBody()->write(json_encode(['error' => 'Solo el administrador puede subir fotos']));
            return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
        }

        $uploadedFiles = $request->getUploadedFiles();
        if (empty($uploadedFiles['image'])) {
            $response->getBody()->write(json_encode(['error' => 'No se subió ninguna imagen']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $parsedBody = $request->getParsedBody();
        $description = $parsedBody['description'] ?? '';

        $uploadedFile = $uploadedFiles['image'];
        if ($uploadedFile->getError() === UPLOAD_ERR_OK) {
            $extension = pathinfo($uploadedFile->getClientFilename(), PATHINFO_EXTENSION);
            $basename = bin2hex(random_bytes(8));
            $filename = sprintf('%s.%0.8s', $basename, $extension);

            $directory = __DIR__ . '/../../uploads/gallery';
            if (!is_dir($directory)) {
                mkdir($directory, 0777, true);
            }

            $uploadedFile->moveTo($directory . DIRECTORY_SEPARATOR . $filename);
            $path = '/uploads/gallery/' . $filename;

            $stmt = $this->pdo->prepare("INSERT INTO gallery (image_path, description) VALUES (:path, :desc)");
            $stmt->execute([':path' => $path, ':desc' => $description]);

            $response->getBody()->write(json_encode([
                'id' => $this->pdo->lastInsertId(),
                'image_path' => $path,
                'description' => $description
            ]));
            return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
        }

        $response->getBody()->write(json_encode(['error' => 'Error al mover el archivo subido']));
        return $response->withStatus(500)->withHeader('Content-Type', 'application/json');
    }

    public function deleteImage(Request $request, Response $response, array $args): Response {
        $userRole = $request->getAttribute('user_role');
        if ($userRole !== 'Administrador') {
            $response->getBody()->write(json_encode(['error' => 'Solo el administrador puede eliminar fotos']));
            return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
        }

        $id = $args['id'];

        $stmt = $this->pdo->prepare("SELECT image_path FROM gallery WHERE id = :id");
        $stmt->execute([':id' => $id]);
        $image = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$image) {
            $response->getBody()->write(json_encode(['error' => 'Imagen no encontrada']));
            return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
        }

        // Delete from filesystem
        $filePath = __DIR__ . '/../../' . $image['image_path'];
        if (file_exists($filePath)) {
            unlink($filePath);
        }

        $stmt = $this->pdo->prepare("DELETE FROM gallery WHERE id = :id");
        $stmt->execute([':id' => $id]);

        $response->getBody()->write(json_encode(['message' => 'Imagen eliminada']));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
