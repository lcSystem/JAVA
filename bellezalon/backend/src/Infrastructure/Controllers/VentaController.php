<?php
namespace App\Infrastructure\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;
use App\Infrastructure\Services\EmailService;

class VentaController {
    private PDO $pdo;
    private EmailService $emailService;

    public function __construct(PDO $pdo, EmailService $emailService) {
        $this->pdo = $pdo;
        $this->emailService = $emailService;
    }

    public function getAll(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        $userRole = strtolower($request->getAttribute('user_role') ?? '');

        $query = "
            SELECT v.*, COALESCE(u.full_name, u.username) AS cliente_nombre
            FROM ventas v
            LEFT JOIN users u ON v.cliente_id = u.id
        ";
        
        $params = [];
        if (in_array($userRole, ['cliente', 'customer'])) {
            $query .= " WHERE v.cliente_id = :uid";
            $params[':uid'] = $userId;
        }
        
        $query .= " ORDER BY v.fecha_venta DESC";

        $stmt = $this->pdo->prepare($query);
        $stmt->execute($params);
        $ventas = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response->getBody()->write(json_encode($ventas));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getDetalles(Request $request, Response $response, array $args): Response {
        $id = $args['id'];
        $stmt = $this->pdo->prepare("
            SELECT d.*, COALESCE(s.nombre, p.nombre, d.descripcion) AS item_nombre 
            FROM detalle_ventas d
            LEFT JOIN servicios s ON d.servicio_id = s.id
            LEFT JOIN productos p ON d.producto_id = p.id
            WHERE d.venta_id = :id
        ");
        $stmt->execute([':id' => $id]);
        $detalles = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response->getBody()->write(json_encode($detalles));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function create(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        if (!isset($data['cliente_id']) || !isset($data['total'])) {
            $response->getBody()->write(json_encode(['error' => 'Cliente y total son requeridos']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $this->pdo->beginTransaction();
        try {
            // Generate invoice number: FAC-YYYYMMDD-XXXX
            $stmt = $this->pdo->prepare("SELECT COUNT(*) + 1 AS num FROM ventas WHERE DATE(fecha_venta) = CURDATE()");
            $stmt->execute();
            $num = $stmt->fetch(PDO::FETCH_ASSOC)['num'];
            $numFactura = 'FAC-' . date('Ymd') . '-' . str_pad($num, 4, '0', STR_PAD_LEFT);

            $subtotal = floatval($data['subtotal'] ?? $data['total']);
            $ivaPorcentaje = isset($data['iva_porcentaje']) ? floatval($data['iva_porcentaje']) : 19;
            $ivaMonto = $subtotal * ($ivaPorcentaje / 100);
            $descuento = floatval($data['descuento'] ?? 0);
            $total = $subtotal + $ivaMonto - $descuento;

            $stmt = $this->pdo->prepare("INSERT INTO ventas (numero_factura, cita_id, cliente_id, empleado_id, subtotal, iva_porcentaje, iva_monto, descuento, total, metodo_pago, transaction_id, estado, notas) VALUES (:nf, :cita, :cli, :emp, :sub, :ivap, :ivam, :desc, :total, :metodo, :txid, 'pagada', :notas)");
            $stmt->execute([
                ':nf' => $numFactura,
                ':cita' => $data['cita_id'] ?? null,
                ':cli' => $data['cliente_id'],
                ':emp' => $data['empleado_id'] ?? null,
                ':sub' => $subtotal,
                ':ivap' => $ivaPorcentaje,
                ':ivam' => $ivaMonto,
                ':desc' => $descuento,
                ':total' => $total,
                ':metodo' => $data['metodo_pago'] ?? 'efectivo',
                ':txid' => $data['transaction_id'] ?? null,
                ':notas' => $data['notas'] ?? null,
            ]);
            $ventaId = $this->pdo->lastInsertId();

            // Insert detail lines
            if (!empty($data['detalles']) && is_array($data['detalles'])) {
                $stmtDet = $this->pdo->prepare("INSERT INTO detalle_ventas (venta_id, servicio_id, producto_id, descripcion, cantidad, precio_unitario, subtotal) VALUES (:vid, :sid, :pid, :desc, :cant, :pu, :sub)");
                foreach ($data['detalles'] as $det) {
                    $stmtDet->execute([
                        ':vid' => $ventaId,
                        ':sid' => $det['servicio_id'] ?? null,
                        ':pid' => $det['producto_id'] ?? null,
                        ':desc' => $det['descripcion'] ?? '',
                        ':cant' => $det['cantidad'] ?? 1,
                        ':pu' => $det['precio_unitario'],
                        ':sub' => ($det['cantidad'] ?? 1) * $det['precio_unitario'],
                    ]);

                    // Deduct stock if product
                    if (!empty($det['producto_id'])) {
                        $stmtStock = $this->pdo->prepare("UPDATE productos SET stock = stock - :cant WHERE id = :pid AND stock >= :cant");
                        $stmtStock->execute([':cant' => $det['cantidad'] ?? 1, ':pid' => $det['producto_id']]);
                    }
                }
            }

            // Update appointment status if linked
            if (!empty($data['cita_id'])) {
                $stmtCita = $this->pdo->prepare("UPDATE citas SET estado = 'completada' WHERE id = :id");
                $stmtCita->execute([':id' => $data['cita_id']]);
            }

            $this->pdo->commit();

            // Push notification to client about completed appointment
            if (!empty($data['cita_id']) && !empty($data['cliente_id'])) {
                $title = "Cita Confirmada ✅";
                $msg = "Tu cita ha sido completada y el pago registrado. Factura: $numFactura";

                // Persist notification
                $notifStmt = $this->pdo->prepare("INSERT INTO notifications (user_id, title, message, type, context_id, context_type) VALUES (:uid, :t, :m, 'success', :cid, 'cita')");
                $notifStmt->execute([':uid' => $data['cliente_id'], ':t' => $title, ':m' => $msg, ':cid' => $data['cita_id']]);

                // Send FCM Push
                $serviceAccountFile = __DIR__ . '/../firebase-service-account.json';
                if (file_exists($serviceAccountFile)) {
                    require_once __DIR__ . '/../Services/FcmService.php';
                    $fcmService = new \App\Infrastructure\Services\FcmService($serviceAccountFile);
                    
                    $fcmTokenStmt = $this->pdo->prepare("SELECT fcm_token FROM users WHERE id = :uid");
                    $fcmTokenStmt->execute([':uid' => $data['cliente_id']]);
                    $tokenRow = $fcmTokenStmt->fetch(\PDO::FETCH_ASSOC);
                    
                    if (!empty($tokenRow['fcm_token'])) {
                        $fcmService->sendToToken($tokenRow['fcm_token'], $title, $msg, [
                            'cita_id' => (string)$data['cita_id'],
                            'type' => 'cita_completada'
                        ]);
                    }
                }
            }

            // Send Invoice Email
            $stmtClient = $this->pdo->prepare("SELECT email FROM users WHERE id = :id");
            $stmtClient->execute([':id' => $data['cliente_id']]);
            $clientEmail = $stmtClient->fetchColumn();

            if ($clientEmail) {
                $this->emailService->sendInvoiceEmail($clientEmail, [
                    'id' => $ventaId,
                    'numero_factura' => $numFactura,
                    'total' => $total,
                    'detalles' => $data['detalles'] ?? []
                ]);
            }

            $response->getBody()->write(json_encode(['id' => $ventaId, 'numero_factura' => $numFactura, 'message' => 'Venta registrada']));
            return $response->withStatus(201)->withHeader('Content-Type', 'application/json');

        } catch (\Exception $e) {
            $this->pdo->rollBack();
            $response->getBody()->write(json_encode(['error' => 'Error al registrar venta: ' . $e->getMessage()]));
            return $response->withStatus(500)->withHeader('Content-Type', 'application/json');
        }
    }

    public function getReporteIngresos(Request $request, Response $response): Response {
        $params = $request->getQueryParams();
        $periodo = $params['periodo'] ?? 'dia';

        $groupBy = match($periodo) {
            'semana' => "DATE_FORMAT(fecha_venta, '%Y-%u')",
            'mes' => "DATE_FORMAT(fecha_venta, '%Y-%m')",
            default => "DATE(fecha_venta)",
        };

        $stmt = $this->pdo->prepare("
            SELECT {$groupBy} AS periodo, COUNT(*) AS total_ventas, SUM(total) AS ingresos, SUM(iva_monto) AS total_iva
            FROM ventas WHERE estado = 'pagada'
            GROUP BY periodo ORDER BY periodo DESC LIMIT 30
        ");
        $stmt->execute();
        $response->getBody()->write(json_encode($stmt->fetchAll(PDO::FETCH_ASSOC)));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getReporteServiciosTop(Request $request, Response $response): Response {
        $stmt = $this->pdo->prepare("
            SELECT s.nombre, COUNT(*) AS total_vendido, SUM(dv.subtotal) AS ingresos
            FROM detalle_ventas dv
            JOIN servicios s ON dv.servicio_id = s.id
            GROUP BY s.id ORDER BY total_vendido DESC LIMIT 10
        ");
        $stmt->execute();
        $response->getBody()->write(json_encode($stmt->fetchAll(PDO::FETCH_ASSOC)));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getReporteEmpleados(Request $request, Response $response): Response {
        $stmt = $this->pdo->prepare("
            SELECT COALESCE(e.full_name, e.username) AS nombre_completo, COUNT(c.id) AS total_citas,
            SUM(CASE WHEN c.estado = 'completada' THEN 1 ELSE 0 END) AS completadas,
            COALESCE(SUM(v.total), 0) AS ingresos_generados
            FROM users e
            LEFT JOIN citas c ON c.empleado_id = e.id
            LEFT JOIN ventas v ON v.empleado_id = e.id AND v.estado = 'pagada'
            WHERE e.role_id != 3 AND e.role_id != 1
            GROUP BY e.id ORDER BY ingresos_generados DESC
        ");
        $stmt->execute();
        $response->getBody()->write(json_encode($stmt->fetchAll(PDO::FETCH_ASSOC)));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getReporteClientesTop(Request $request, Response $response): Response {
        $stmt = $this->pdo->prepare("
            SELECT 
                COALESCE(u.full_name, u.username) AS nombre_completo,
                (SELECT COUNT(*) FROM citas c WHERE c.cliente_id = u.id AND c.estado = 'completada') AS citas_completadas,
                (SELECT COALESCE(SUM(total), 0) FROM ventas v WHERE v.cliente_id = u.id AND v.estado = 'pagada') AS total_gastado
            FROM users u
            WHERE u.role_id = 3
            ORDER BY total_gastado DESC, citas_completadas DESC
            LIMIT 10
        ");
        $stmt->execute();
        $response->getBody()->write(json_encode($stmt->fetchAll(PDO::FETCH_ASSOC)));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
