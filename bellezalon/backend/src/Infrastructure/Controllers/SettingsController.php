<?php
namespace App\Infrastructure\Controllers;

use App\Domain\Repositories\SettingsRepositoryInterface;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class SettingsController {
    private SettingsRepositoryInterface $repository;

    public function __construct(SettingsRepositoryInterface $repository) {
        $this->repository = $repository;
    }

    public function getAll(Request $request, Response $response): Response {
        $settings = $this->repository->getAll();
        $data = [];
        foreach ($settings as $s) {
            $data[$s->getKeyName()] = $s->getValue();
        }
        $response->getBody()->write(json_encode($data));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function update(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        error_log("Settings Update Received: " . json_encode($data));
        try {
            if (!$data) {
                throw new \Exception("No data received or invalid JSON");
            }
            foreach ($data as $key => $value) {
                $this->repository->update($key, $value);
            }
            $response->getBody()->write(json_encode(['success' => true]));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Exception $e) {
            $response->getBody()->write(json_encode(['error' => $e->getMessage()]));
            return $response->withStatus(500)->withHeader('Content-Type', 'application/json');
        }
    }

    public function uploadLogo(Request $request, Response $response): Response {
        $uploadedFiles = $request->getUploadedFiles();
        if (empty($uploadedFiles['logo'])) {
            $response->getBody()->write(json_encode(['error' => 'No se subió ningún archivo']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $logo = $uploadedFiles['logo'];
        if ($logo->getError() !== UPLOAD_ERR_OK) {
            $response->getBody()->write(json_encode(['error' => 'Error al subir el archivo']));
            return $response->withStatus(500)->withHeader('Content-Type', 'application/json');
        }

        // MIME Type Validation
        $finfo = new \finfo(FILEINFO_MIME_TYPE);
        $mimeType = $finfo->file($logo->getFilePath());
        $allowedMimes = ['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml'];

        if (!in_array($mimeType, $allowedMimes)) {
            $response->getBody()->write(json_encode(['error' => 'Contenido de archivo no permitido']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $extension = pathinfo($logo->getClientFilename(), PATHINFO_EXTENSION);
        $allowedExt = ['jpg', 'jpeg', 'png', 'webp', 'svg'];
        if (!in_array(strtolower($extension), $allowedExt)) {
            $response->getBody()->write(json_encode(['error' => 'Extensión no permitida']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $filename = 'logo_' . time() . '.' . $extension;
        $uploadPath = __DIR__ . '/../../uploads/logo/' . $filename;
        
        // Ensure directory exists
        if (!is_dir(dirname($uploadPath))) {
            mkdir(dirname($uploadPath), 0777, true);
        }

        $logo->moveTo($uploadPath);
        
        $url = '/uploads/logo/' . $filename;
        $this->repository->update('salon_logo_url', $url);

        $response->getBody()->write(json_encode(['success' => true, 'url' => $url]));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
