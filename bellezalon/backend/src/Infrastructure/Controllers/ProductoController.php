<?php
namespace App\Infrastructure\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;

class ProductoController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getAll(Request $request, Response $response): Response {
        $stmt = $this->pdo->prepare("SELECT * FROM productos ORDER BY nombre");
        $stmt->execute();
        $productos = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Fetch global invisible tax percentage from settings
        $globalTaxStmt = $this->pdo->prepare("SELECT setting_value FROM app_settings WHERE key_name = 'invisible_tax_percentage'");
        $globalTaxStmt->execute();
        $globalTaxRow = $globalTaxStmt->fetch(PDO::FETCH_ASSOC);
        $globalTaxPct = $globalTaxRow ? floatval($globalTaxRow['setting_value']) : 0;

        foreach ($productos as &$p) {
            $taxPct = $globalTaxPct;
            if (!empty($p['taxes'])) {
                $taxData = json_decode($p['taxes'], true);
                if (is_array($taxData) && isset($taxData['percentage'])) {
                    $taxPct = floatval($taxData['percentage']);
                } elseif (is_numeric($p['taxes'])) {
                    $taxPct = floatval($p['taxes']);
                }
            }
            if ($taxPct > 0) {
                $p['precio_venta_base'] = floatval($p['precio_venta']);
                $p['precio_venta'] = round(floatval($p['precio_venta']) * (1 + $taxPct / 100), 2);
                $p['tax_applied_pct'] = $taxPct;
            }
        }

        $response->getBody()->write(json_encode($productos));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function create(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        if (empty($data['nombre']) || empty($data['precio_venta'])) {
            $response->getBody()->write(json_encode(['error' => 'Nombre y precio son requeridos']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }
        $stmt = $this->pdo->prepare("INSERT INTO productos (nombre, descripcion, categoria, precio_compra, precio_venta, taxes, stock, stock_minimo) VALUES (:nom, :desc, :cat, :pc, :pv, :taxes, :stock, :min)");
        $stmt->execute([
            ':nom' => $data['nombre'],
            ':desc' => $data['descripcion'] ?? '',
            ':cat' => $data['categoria'] ?? 'general',
            ':pc' => $data['precio_compra'] ?? 0,
            ':pv' => $data['precio_venta'],
            ':taxes' => isset($data['taxes']) ? json_encode($data['taxes']) : null,
            ':stock' => $data['stock'] ?? 0,
            ':min' => $data['stock_minimo'] ?? 5,
        ]);
        $response->getBody()->write(json_encode(['id' => $this->pdo->lastInsertId(), 'message' => 'Producto creado']));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }

    public function update(Request $request, Response $response, array $args): Response {
        $data = $request->getParsedBody();
        $stmt = $this->pdo->prepare("UPDATE productos SET nombre=:nom, descripcion=:desc, categoria=:cat, precio_compra=:pc, precio_venta=:pv, taxes=:taxes, stock_minimo=:min WHERE id=:id");
        $stmt->execute([
            ':nom' => $data['nombre'],
            ':desc' => $data['descripcion'] ?? '',
            ':cat' => $data['categoria'] ?? 'general',
            ':pc' => $data['precio_compra'] ?? 0,
            ':pv' => $data['precio_venta'],
            ':taxes' => isset($data['taxes']) ? json_encode($data['taxes']) : null,
            ':min' => $data['stock_minimo'] ?? 5,
            ':id' => $args['id'],
        ]);
        $response->getBody()->write(json_encode(['message' => 'Producto actualizado']));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function delete(Request $request, Response $response, array $args): Response {
        // Option to delete or hide. Soft delete is not supported in the table? Just hard delete.
        $stmt = $this->pdo->prepare("DELETE FROM movimientos_inventario WHERE producto_id = :id");
        $stmt->execute([':id' => $args['id']]);
        $stmt = $this->pdo->prepare("DELETE FROM productos WHERE id = :id");
        $stmt->execute([':id' => $args['id']]);
        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getAlertasStock(Request $request, Response $response): Response {
        $stmt = $this->pdo->prepare("SELECT * FROM productos WHERE stock <= stock_minimo AND estado = 'activo'");
        $stmt->execute();
        $response->getBody()->write(json_encode($stmt->fetchAll(PDO::FETCH_ASSOC)));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getMovimientos(Request $request, Response $response, array $args): Response {
        $stmt = $this->pdo->prepare("SELECT mi.*, p.nombre AS producto_nombre FROM movimientos_inventario mi JOIN productos p ON mi.producto_id = p.id WHERE mi.producto_id = :id ORDER BY mi.fecha DESC");
        $stmt->execute([':id' => $args['id']]);
        $response->getBody()->write(json_encode($stmt->fetchAll(PDO::FETCH_ASSOC)));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function registrarMovimiento(Request $request, Response $response, array $args): Response {
        $data = $request->getParsedBody();
        $productoId = $args['id'];

        $this->pdo->beginTransaction();
        try {
            $stmt = $this->pdo->prepare("SELECT stock FROM productos WHERE id = :id FOR UPDATE");
            $stmt->execute([':id' => $productoId]);
            $producto = $stmt->fetch(PDO::FETCH_ASSOC);
            if (!$producto) throw new \Exception('Producto no encontrado');

            $stockAnterior = $producto['stock'];
            $cantidad = intval($data['cantidad']);
            $tipo = $data['tipo'];

            $stockNuevo = match($tipo) {
                'entrada' => $stockAnterior + $cantidad,
                'salida' => $stockAnterior - $cantidad,
                'ajuste' => $cantidad,
                default => throw new \Exception('Tipo inválido'),
            };

            if ($stockNuevo < 0) throw new \Exception('Stock insuficiente');

            $stmt = $this->pdo->prepare("UPDATE productos SET stock = :stock WHERE id = :id");
            $stmt->execute([':stock' => $stockNuevo, ':id' => $productoId]);

            $stmt = $this->pdo->prepare("INSERT INTO movimientos_inventario (producto_id, tipo, cantidad, stock_anterior, stock_nuevo, motivo) VALUES (:pid, :tipo, :cant, :sa, :sn, :motivo)");
            $stmt->execute([
                ':pid' => $productoId,
                ':tipo' => $tipo,
                ':cant' => $cantidad,
                ':sa' => $stockAnterior,
                ':sn' => $stockNuevo,
                ':motivo' => $data['motivo'] ?? '',
            ]);

            $this->pdo->commit();
            $response->getBody()->write(json_encode(['message' => 'Movimiento registrado', 'stock_nuevo' => $stockNuevo]));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Exception $e) {
            $this->pdo->rollBack();
            $response->getBody()->write(json_encode(['error' => $e->getMessage()]));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }
    }
}
