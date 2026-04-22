<?php
namespace App\Infrastructure\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;

class ServicioController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getAll(Request $request, Response $response): Response {
        // Fetch base services
        $stmt = $this->pdo->prepare("SELECT * FROM servicios WHERE estado = 'activo' ORDER BY nombre");
        $stmt->execute();
        $servicios = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Fetch all images map
        $imgStmt = $this->pdo->prepare("SELECT id, servicio_id, image_url FROM servicio_imagenes");
        $imgStmt->execute();
        $allImages = $imgStmt->fetchAll(PDO::FETCH_ASSOC);

        $imagesBySvc = [];
        foreach ($allImages as $img) {
            $imagesBySvc[$img['servicio_id']][] = [
                'id' => $img['id'],
                'image_url' => $img['image_url']
            ];
        }

        // Fetch global invisible tax percentage from settings
        $globalTaxStmt = $this->pdo->prepare("SELECT setting_value FROM app_settings WHERE key_name = 'invisible_tax_percentage'");
        $globalTaxStmt->execute();
        $globalTaxRow = $globalTaxStmt->fetch(PDO::FETCH_ASSOC);
        $globalTaxPct = $globalTaxRow ? floatval($globalTaxRow['setting_value']) : 0;

        foreach ($servicios as &$s) {
            $s['imagenes'] = $imagesBySvc[$s['id']] ?? [];

            // Apply invisible tax: per-service taxes override global
            $taxPct = $globalTaxPct;
            if (!empty($s['taxes'])) {
                $taxData = json_decode($s['taxes'], true);
                if (is_array($taxData) && isset($taxData['percentage'])) {
                    $taxPct = floatval($taxData['percentage']);
                } elseif (is_numeric($s['taxes'])) {
                    $taxPct = floatval($s['taxes']);
                }
            }
            if ($taxPct > 0) {
                $s['precio_base'] = floatval($s['precio']);
                $s['precio'] = round(floatval($s['precio']) * (1 + $taxPct / 100), 2);
                $s['tax_applied_pct'] = $taxPct;
            }
        }

        $response->getBody()->write(json_encode($servicios));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function create(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        if (empty($data['nombre']) || empty($data['precio'])) {
            $response->getBody()->write(json_encode(['error' => 'Nombre y precio son requeridos']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }
        $stmt = $this->pdo->prepare("INSERT INTO servicios (nombre, descripcion, duracion_minutos, precio, taxes, deposit_amount) VALUES (:nombre, :desc, :dur, :precio, :taxes, :deposit)");
        $stmt->execute([
            ':nombre' => $data['nombre'],
            ':desc' => $data['descripcion'] ?? '',
            ':dur' => $data['duracion_minutos'] ?? 30,
            ':precio' => $data['precio'],
            ':taxes' => isset($data['taxes']) ? json_encode($data['taxes']) : null,
            ':deposit' => $data['deposit_amount'] ?? 0.00,
        ]);
        $response->getBody()->write(json_encode(['id' => $this->pdo->lastInsertId(), 'message' => 'Servicio creado']));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }

    public function update(Request $request, Response $response, array $args): Response {
        $data = $request->getParsedBody();
        $stmt = $this->pdo->prepare("UPDATE servicios SET nombre = :nombre, descripcion = :desc, duracion_minutos = :dur, precio = :precio, taxes = :taxes, deposit_amount = :deposit WHERE id = :id");
        $stmt->execute([
            ':nombre' => $data['nombre'],
            ':desc' => $data['descripcion'] ?? '',
            ':dur' => $data['duracion_minutos'] ?? 30,
            ':precio' => $data['precio'],
            ':taxes' => isset($data['taxes']) ? json_encode($data['taxes']) : null,
            ':deposit' => $data['deposit_amount'] ?? 0.00,
            ':id' => $args['id'],
        ]);
        $response->getBody()->write(json_encode(['message' => 'Servicio actualizado']));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function delete(Request $request, Response $response, array $args): Response {
        $stmt = $this->pdo->prepare("DELETE FROM servicios WHERE id = :id");
        $stmt->execute([':id' => $args['id']]);
        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function uploadImage(Request $request, Response $response, array $args): Response {
        $servicioId = (int)$args['id'];
        $uploadedFiles = $request->getUploadedFiles();

        if (empty($uploadedFiles['image'])) {
            $response->getBody()->write(json_encode(['error' => 'No se subió ninguna imagen']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $uploadedFile = $uploadedFiles['image'];
        if ($uploadedFile->getError() === UPLOAD_ERR_OK) {
            // MIME Type Validation
            $finfo = new \finfo(FILEINFO_MIME_TYPE);
            $mimeType = $finfo->file($uploadedFile->getFilePath());
            $allowedMimes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
            
            if (!in_array($mimeType, $allowedMimes)) {
                $response->getBody()->write(json_encode(['error' => 'Tipo de archivo no permitido. Solo se aceptan imágenes (JPG, PNG, GIF, WEBP).']));
                return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
            }

            $extension = pathinfo($uploadedFile->getClientFilename(), PATHINFO_EXTENSION);
            $filename = 'img_' . time() . '_' . bin2hex(random_bytes(4)) . '.' . $extension;
            
            $directory = __DIR__ . '/../../uploads/servicios';
            if (!is_dir($directory)) {
                mkdir($directory, 0777, true);
            }

            $uploadedFile->moveTo($directory . DIRECTORY_SEPARATOR . $filename);
            $path = '/uploads/servicios/' . $filename;

            $stmt = $this->pdo->prepare("INSERT INTO servicio_imagenes (servicio_id, image_url) VALUES (?, ?)");
            $stmt->execute([$servicioId, $path]);

            $response->getBody()->write(json_encode(['success' => true, 'url' => $path, 'id' => $this->pdo->lastInsertId()]));
            return $response->withHeader('Content-Type', 'application/json');
        }

        $response->getBody()->write(json_encode(['error' => 'Upload failed']));
        return $response->withStatus(500)->withHeader('Content-Type', 'application/json');
    }

    public function deleteImage(Request $request, Response $response, array $args): Response {
        $imageId = (int)$args['image_id'];
        
        $stmt = $this->pdo->prepare("SELECT image_url FROM servicio_imagenes WHERE id = ?");
        $stmt->execute([$imageId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            $filePath = __DIR__ . '/../../' . $row['image_url'];
            if (file_exists($filePath)) {
                unlink($filePath);
            }
            $stmt = $this->pdo->prepare("DELETE FROM servicio_imagenes WHERE id = ?");
            $stmt->execute([$imageId]);
        }
        
        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
