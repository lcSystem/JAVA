<?php
namespace App\Infrastructure\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;
use App\Infrastructure\Services\EmailService;
use App\Domain\Repositories\AppointmentRepositoryInterface;

class AppointmentController {
    private PDO $pdo;
    private EmailService $emailService;
    private AppointmentRepositoryInterface $appointmentRepository;

    public function __construct(PDO $pdo, EmailService $emailService, AppointmentRepositoryInterface $appointmentRepository) {
        $this->pdo = $pdo;
        $this->emailService = $emailService;
        $this->appointmentRepository = $appointmentRepository;
    }

    public function getAll(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        $userRole = $request->getAttribute('user_role');

        $stmt = $this->pdo->prepare("
            SELECT c.*, COALESCE(u.full_name, u.username) AS cliente_nombre, s.nombre AS servicio_nombre,
            s.precio AS servicio_precio, COALESCE(e.full_name, e.username) AS empleado_nombre
            FROM citas c
            LEFT JOIN users u ON c.cliente_id = u.id
            LEFT JOIN servicios s ON c.servicio_id = s.id
            LEFT JOIN users e ON c.empleado_id = e.id
            WHERE c.estado != 'cancelada'
            ORDER BY c.fecha_cita DESC, c.hora_cita ASC
        ");
        $stmt->execute();
        $citas = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Privacy Masking for Clients
        if ($userRole === 'Cliente') {
            foreach ($citas as &$cita) {
                if ($cita['cliente_id'] != $userId) {
                    $cita['id'] = 0; // Hide real ID
                    $cita['cliente_id'] = 0;
                    $cita['cliente_nombre'] = 'Ocupado';
                    $cita['servicio_nombre'] = 'Bloqueado';
                    $cita['empleado_nombre'] = 'Personal del Centro';
                    $cita['servicio_precio'] = null;
                    $cita['comentarios'] = '';
                }
            }
        }

        $response->getBody()->write(json_encode($citas));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function create(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        $userId = $request->getAttribute('user_id');
        $userRole = $request->getAttribute('user_role');

        if ($userRole === 'Cliente') {
            $data['cliente_id'] = $userId;
        }

        if (empty($data['cliente_id']) || empty($data['servicio_id']) || empty($data['fecha_cita']) || empty($data['hora_cita'])) {
            $response->getBody()->write(json_encode(['error' => 'Campos obligatorios: cliente_id, servicio_id, fecha_cita, hora_cita']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        try {
            // Check max appointments per day
            $maxStmt = $this->pdo->prepare("SELECT setting_value FROM app_settings WHERE key_name = 'max_appointments_per_day'");
            $maxStmt->execute();
            $maxRow = $maxStmt->fetch(PDO::FETCH_ASSOC);
            $maxPerDay = $maxRow ? (int)$maxRow['setting_value'] : 20;

            $countStmt = $this->pdo->prepare("SELECT COUNT(*) as cnt FROM citas WHERE fecha_cita = :fecha AND estado != 'cancelada'");
            $countStmt->execute([':fecha' => $data['fecha_cita']]);
            $countRow = $countStmt->fetch(PDO::FETCH_ASSOC);
            if ((int)$countRow['cnt'] >= $maxPerDay) {
                $response->getBody()->write(json_encode(['error' => "Se alcanzó el máximo de $maxPerDay citas para este día"]));
                return $response->withStatus(409)->withHeader('Content-Type', 'application/json');
            }

            // Check max pending appointments per client
            $maxPendStmt = $this->pdo->prepare("SELECT setting_value FROM app_settings WHERE key_name = 'max_pending_appointments_per_client'");
            $maxPendStmt->execute();
            $maxPendRow = $maxPendStmt->fetch(PDO::FETCH_ASSOC);
            $maxPending = $maxPendRow ? (int)$maxPendRow['setting_value'] : 2;

            $pendCountStmt = $this->pdo->prepare("SELECT COUNT(*) as cnt FROM citas WHERE cliente_id = :cli AND estado = 'pendiente'");
            $pendCountStmt->execute([':cli' => $data['cliente_id']]);
            $pendCountRow = $pendCountStmt->fetch(PDO::FETCH_ASSOC);
            if ((int)$pendCountRow['cnt'] >= $maxPending) {
                $response->getBody()->write(json_encode(['error' => "Ya tienes el máximo permitido de $maxPending citas en estado pendiente."]));
                return $response->withStatus(409)->withHeader('Content-Type', 'application/json');
            }

            // Check if schedule is blocked
            $blockStmt = $this->pdo->prepare("SELECT setting_value FROM app_settings WHERE key_name = 'blocked_schedules'");
            $blockStmt->execute();
            $blockRow = $blockStmt->fetch(PDO::FETCH_ASSOC);
            if ($blockRow) {
                $blockedSchedules = json_decode($blockRow['setting_value'], true);
                $isBlocked = $this->isScheduleBlocked($data['fecha_cita'], $data['hora_cita'], $blockedSchedules);
                if ($isBlocked['blocked']) {
                    $response->getBody()->write(json_encode(['error' => "El horario seleccionado está restringido: " . $isBlocked['reason']]));
                    return $response->withStatus(409)->withHeader('Content-Type', 'application/json');
                }
            }

            // Get service duration
            $stmtSvc = $this->pdo->prepare("SELECT duracion_minutos FROM servicios WHERE id = :id");
            $stmtSvc->execute([':id' => $data['servicio_id']]);
            $svc = $stmtSvc->fetch(PDO::FETCH_ASSOC);
            if (!$svc) {
                $response->getBody()->write(json_encode(['error' => 'Servicio no encontrado']));
                return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
            }
            $duracion = $svc['duracion_minutos'] ?? 30;

            $stmt = $this->pdo->prepare("INSERT INTO citas (cliente_id, servicio_id, empleado_id, fecha_cita, hora_cita, duracion_minutos, estado, comentarios, creada_por, payment_status, transaction_id, deposit_amount) 
                                     VALUES (:cli, :svc, :emp, :fecha, :hora, :dur, 'pendiente', :com, :creado, :pstatus, :txid, :damount)");
            $stmt->execute([
                ':cli' => $data['cliente_id'],
                ':svc' => $data['servicio_id'],
                ':emp' => $data['empleado_id'] ?? null,
                ':fecha' => $data['fecha_cita'],
                ':hora' => $data['hora_cita'],
                ':dur' => $duracion,
                ':com' => $data['comentarios'] ?? '',
                ':creado' => $userId,
                ':pstatus' => $data['payment_status'] ?? 'pending',
                ':txid' => $data['transaction_id'] ?? null,
                ':damount' => $data['deposit_amount'] ?? 0
            ]);
            $citaId = $this->pdo->lastInsertId();

            // Notify Employee if assigned
            if (!empty($data['empleado_id'])) {
                // Get Client Name
                $clientStmt = $this->pdo->prepare("SELECT COALESCE(full_name, username) as name FROM users WHERE id = :id");
                $clientStmt->execute([':id' => $data['cliente_id']]);
                $clName = $clientStmt->fetch(PDO::FETCH_ASSOC)['name'] ?? 'Un cliente';

                $title = "Nueva Cita Agendada";
                $msg = "El cliente $clName agendó una cita contigo. Estado: pendiente.";

                // Persist notification
                $notifStmt = $this->pdo->prepare("INSERT INTO notifications (user_id, title, message, type, context_id, context_type) VALUES (:uid, :t, :m, 'info', :cid, 'cita')");
                $notifStmt->execute([':uid' => $data['empleado_id'], ':t' => $title, ':m' => $msg, ':cid' => $citaId]);

                // Send FCM
                $serviceAccountFile = __DIR__ . '/../firebase-service-account.json';
                if (file_exists($serviceAccountFile)) {
                    require_once __DIR__ . '/../Services/FcmService.php';
                    $fcmService = new \App\Infrastructure\Services\FcmService($serviceAccountFile);
                    
                    $fcmTokenStmt = $this->pdo->prepare("SELECT fcm_token FROM users WHERE id = :uid");
                    $fcmTokenStmt->execute([':uid' => $data['empleado_id']]);
                    $tokenRow = $fcmTokenStmt->fetch(\PDO::FETCH_ASSOC);
                    
                    if (!empty($tokenRow['fcm_token'])) {
                        $fcmService->sendToToken($tokenRow['fcm_token'], $title, $msg, [
                            'cita_id' => (string)$citaId, 
                            'type' => 'cita'
                        ]);
                    }
                }
            }

            $response->getBody()->write(json_encode(['id' => $citaId, 'message' => 'Cita agendada']));
            return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
        } catch (\PDOException $e) {
            error_log("PDO Error in AppointmentController: " . $e->getMessage());
            $response->getBody()->write(json_encode(['error' => 'Error de base de datos: ' . $e->getMessage()]));
            return $response->withStatus(500)->withHeader('Content-Type', 'application/json');
        }
    }

    public function update(Request $request, Response $response, array $args): Response {
        $userId = $request->getAttribute('user_id');
        $userRole = $request->getAttribute('user_role');
        $isAdmin = in_array(strtolower($userRole), ['administrador', 'admin']);

        // IDOR Prevention: Check ownership
        $stmtCheck = $this->pdo->prepare("SELECT cliente_id, empleado_id FROM citas WHERE id = :id");
        $stmtCheck->execute([':id' => $args['id']]);
        $cita = $stmtCheck->fetch(PDO::FETCH_ASSOC);

        if (!$cita) {
            $response->getBody()->write(json_encode(['error' => 'Cita no encontrada']));
            return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
        }

        if (!$isAdmin && $cita['cliente_id'] != $userId && $cita['empleado_id'] != $userId) {
            $response->getBody()->write(json_encode(['error' => 'No tienes permiso para modificar esta cita']));
            return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
        }

        $data = $request->getParsedBody();
        $fields = [];
        $params = [':id' => $args['id']];

        if (isset($data['estado'])) { $fields[] = 'estado = :estado'; $params[':estado'] = $data['estado']; }
        if (isset($data['fecha_cita'])) { $fields[] = 'fecha_cita = :fecha'; $params[':fecha'] = $data['fecha_cita']; }
        if (isset($data['hora_cita'])) { $fields[] = 'hora_cita = :hora'; $params[':hora'] = $data['hora_cita']; }
        if (isset($data['empleado_id'])) { $fields[] = 'empleado_id = :emp'; $params[':emp'] = $data['empleado_id']; }
        if (isset($data['comentarios'])) { $fields[] = 'comentarios = :com'; $params[':com'] = $data['comentarios']; }
        if (isset($data['payment_status'])) { $fields[] = 'payment_status = :pstatus'; $params[':pstatus'] = $data['payment_status']; }
        if (isset($data['transaction_id'])) { $fields[] = 'transaction_id = :txid'; $params[':txid'] = $data['transaction_id']; }
        if (isset($data['deposit_amount'])) { $fields[] = 'deposit_amount = :damount'; $params[':damount'] = $data['deposit_amount']; }

        if (empty($fields)) {
            $response->getBody()->write(json_encode(['error' => 'Nada que actualizar']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        if (isset($data['fecha_cita']) || isset($data['hora_cita'])) {
            $checkFecha = $data['fecha_cita'] ?? null;
            $checkHora = $data['hora_cita'] ?? null;
            
            // If only one is provided, get the other from current record
            if (!$checkFecha || !$checkHora) {
                $currStmt = $this->pdo->prepare("SELECT fecha_cita, hora_cita FROM citas WHERE id = :id");
                $currStmt->execute([':id' => $args['id']]);
                $curr = $currStmt->fetch(PDO::FETCH_ASSOC);
                $checkFecha = $checkFecha ?: $curr['fecha_cita'];
                $checkHora = $checkHora ?: $curr['hora_cita'];
            }

            $blockStmt = $this->pdo->prepare("SELECT setting_value FROM app_settings WHERE key_name = 'blocked_schedules'");
            $blockStmt->execute();
            $blockRow = $blockStmt->fetch(PDO::FETCH_ASSOC);
            if ($blockRow) {
                $blockedSchedules = json_decode($blockRow['setting_value'], true);
                $isBlocked = $this->isScheduleBlocked($checkFecha, $checkHora, $blockedSchedules);
                if ($isBlocked['blocked']) {
                    $response->getBody()->write(json_encode(['error' => "Este cambio pondría la cita en un horario restringido: " . $isBlocked['reason']]));
                    return $response->withStatus(409)->withHeader('Content-Type', 'application/json');
                }
            }
        }

        $sql = "UPDATE citas SET " . implode(', ', $fields) . " WHERE id = :id";
        $this->pdo->prepare($sql)->execute($params);

        // Targeted Notification Logic
        if (isset($data['estado'])) {
            $title = "Actualización de Cita";
            $msg = "El estado de la cita ha cambiado a: " . $data['estado'];
            
            // Get client and employee IDs
            $stmtCitaInfo = $this->pdo->prepare("SELECT cliente_id, empleado_id FROM citas WHERE id = :id");
            $stmtCitaInfo->execute([':id' => $args['id']]);
            $citaInfo = $stmtCitaInfo->fetch(PDO::FETCH_ASSOC);

            if ($citaInfo) {
                // Initialize FCM Service
                $fcmService = null;
                $serviceAccountFile = __DIR__ . '/../firebase-service-account.json';
                if (file_exists($serviceAccountFile)) {
                    require_once __DIR__ . '/../Services/FcmService.php';
                    $fcmService = new \App\Infrastructure\Services\FcmService($serviceAccountFile);
                } else {
                    error_log("FCM: Service account file NOT FOUND at $serviceAccountFile");
                }

                $fcmTokenStmt = $this->pdo->prepare("SELECT fcm_token FROM users WHERE id = :uid");
                $notifStmt = $this->pdo->prepare("INSERT INTO notifications (user_id, title, message, type, context_id, context_type) VALUES (:uid, :t, :m, 'info', :cid, 'cita')");
                
                // Notify Client
                if (!empty($citaInfo['cliente_id'])) {
                    $notifStmt->execute([':uid' => $citaInfo['cliente_id'], ':t' => $title, ':m' => $msg, ':cid' => $args['id']]);
                    if ($fcmService) {
                        $fcmTokenStmt->execute([':uid' => $citaInfo['cliente_id']]);
                        $tokenRow = $fcmTokenStmt->fetch(\PDO::FETCH_ASSOC);
                        if (!empty($tokenRow['fcm_token'])) {
                            error_log("FCM: Sending update to CLIENT id " . $citaInfo['cliente_id']);
                            $fcmService->sendToToken($tokenRow['fcm_token'], $title, $msg, [
                                'cita_id' => (string)$args['id'], 
                                'type' => 'cita'
                            ]);
                        } else {
                            error_log("FCM: No token for CLIENT id " . $citaInfo['cliente_id']);
                        }
                    }

                    // Send Email Notification to Client
                    $stmtUser = $this->pdo->prepare("SELECT email, full_name FROM users WHERE id = :uid");
                    $stmtUser->execute([':uid' => $citaInfo['cliente_id']]);
                    $user = $stmtUser->fetch(PDO::FETCH_ASSOC);
                    if ($user && !empty($user['email'])) {
                        $subject = "Actualización de tu cita en Salón Belleza Pro";
                        $body = "<h2>Hola " . ($user['full_name'] ?? 'Cliente') . "</h2>";
                        $body .= "<p>Te informamos que el estado de tu cita #{$args['id']} ha cambiado a: <strong>" . strtoupper($data['estado']) . "</strong>.</p>";
                        $body .= "<p>Gracias por elegirnos.</p>";
                        $this->emailService->sendEmail($user['email'], $subject, $body);
                    }
                }
                
                // Notify Employee (if assigned)
                if (!empty($citaInfo['empleado_id'])) {
                    $notifStmt->execute([':uid' => $citaInfo['empleado_id'], ':t' => $title, ':m' => $msg, ':cid' => $args['id']]);
                    if ($fcmService) {
                        $fcmTokenStmt->execute([':uid' => $citaInfo['empleado_id']]);
                        $tokenRow = $fcmTokenStmt->fetch(\PDO::FETCH_ASSOC);
                        if (!empty($tokenRow['fcm_token'])) {
                            error_log("FCM: Sending update to EMPLOYEE id " . $citaInfo['empleado_id']);
                            $fcmService->sendToToken($tokenRow['fcm_token'], $title, $msg, [
                                'cita_id' => (string)$args['id'], 
                                'type' => 'cita'
                            ]);
                        } else {
                            error_log("FCM: No token for EMPLOYEE id " . $citaInfo['empleado_id']);
                        }
                    }
                }
            }
        }

        $response->getBody()->write(json_encode(['message' => 'Cita actualizada']));
        return $response->withHeader('Content-Type', 'application/json');
    }

    private function isScheduleBlocked(string $dateStr, string $timeStr, ?array $blockedSchedules): array {
        if (!$blockedSchedules) return ['blocked' => false];

        $timestamp = strtotime($dateStr);
        $dayKey = strtolower(date('D', $timestamp)); // mon, tue, wed, thu, fri, sat, sun
        
        // Map PHP short day to our key names if they differ
        $dayMap = [
            'mon' => 'monday', 'tue' => 'tuesday', 'wed' => 'wednesday', 
            'thu' => 'thursday', 'fri' => 'friday', 'sat' => 'saturday', 'sun' => 'sunday'
        ];
        $fullDayKey = $dayMap[$dayKey] ?? $dayKey;

        if (!isset($blockedSchedules[$fullDayKey])) return ['blocked' => false];

        $sch = $blockedSchedules[$fullDayKey];
        
        // Check if day is closed
        if (!empty($sch['closed']) && $sch['closed'] == true) {
            return ['blocked' => true, 'reason' => 'El local está cerrado este día.'];
        }

        // Check time blocks
        if (!empty($sch['blocks'])) {
            $appointmentTime = strtotime($timeStr);
            foreach ($sch['blocks'] as $block) {
                $blockStart = strtotime($block['start']);
                $blockEnd = strtotime($block['end']);
                if ($appointmentTime >= $blockStart && $appointmentTime < $blockEnd) {
                    return ['blocked' => true, 'reason' => "Horario no disponible ({$block['start']} - {$block['end']})."];
                }
            }
        }

        return ['blocked' => false];
    }

    public function delete(Request $request, Response $response, array $args): Response {
        $userId = $request->getAttribute('user_id');
        $userRole = $request->getAttribute('user_role');
        $isAdmin = in_array(strtolower($userRole), ['administrador', 'admin']);

        // IDOR Prevention: Check ownership
        $stmtCheck = $this->pdo->prepare("SELECT cliente_id FROM citas WHERE id = :id");
        $stmtCheck->execute([':id' => $args['id']]);
        $cita = $stmtCheck->fetch(PDO::FETCH_ASSOC);

        if ($cita && !$isAdmin && $cita['cliente_id'] != $userId) {
            $response->getBody()->write(json_encode(['error' => 'No tienes permiso para cancelar esta cita']));
            return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
        }

        $stmt = $this->pdo->prepare("UPDATE citas SET estado = 'cancelada' WHERE id = :id");
        $stmt->execute([':id' => $args['id']]);

        // Notify relevant parties about cancellation
        $stmtCitaInfo = $this->pdo->prepare("SELECT cliente_id, empleado_id FROM citas WHERE id = :id");
        $stmtCitaInfo->execute([':id' => $args['id']]);
        $citaInfo = $stmtCitaInfo->fetch(PDO::FETCH_ASSOC);

        if ($citaInfo) {
            $title = "Cita Cancelada ❌";
            $msg = "La cita #{$args['id']} ha sido cancelada.";

            $fcmService = null;
            $serviceAccountFile = __DIR__ . '/../firebase-service-account.json';
            if (file_exists($serviceAccountFile)) {
                require_once __DIR__ . '/../Services/FcmService.php';
                $fcmService = new \App\Infrastructure\Services\FcmService($serviceAccountFile);
            }

            $notifStmt = $this->pdo->prepare("INSERT INTO notifications (user_id, title, message, type, context_id, context_type) VALUES (:uid, :t, :m, 'warning', :cid, 'cita')");
            $fcmTokenStmt = $this->pdo->prepare("SELECT fcm_token FROM users WHERE id = :uid");

            // Notify Client (if canceller is not the client)
            if (!empty($citaInfo['cliente_id']) && $citaInfo['cliente_id'] != $userId) {
                $notifStmt->execute([':uid' => $citaInfo['cliente_id'], ':t' => $title, ':m' => $msg, ':cid' => $args['id']]);
                if ($fcmService) {
                    $fcmTokenStmt->execute([':uid' => $citaInfo['cliente_id']]);
                    $tokenRow = $fcmTokenStmt->fetch(\PDO::FETCH_ASSOC);
                    if (!empty($tokenRow['fcm_token'])) {
                        $fcmService->sendToToken($tokenRow['fcm_token'], $title, $msg, ['cita_id' => (string)$args['id'], 'type' => 'cita_cancelada']);
                    }
                }
            }

            // Notify Employee (if canceller is not the employee)
            if (!empty($citaInfo['empleado_id']) && $citaInfo['empleado_id'] != $userId) {
                $notifStmt->execute([':uid' => $citaInfo['empleado_id'], ':t' => $title, ':m' => $msg, ':cid' => $args['id']]);
                if ($fcmService) {
                    $fcmTokenStmt->execute([':uid' => $citaInfo['empleado_id']]);
                    $tokenRow = $fcmTokenStmt->fetch(\PDO::FETCH_ASSOC);
                    if (!empty($tokenRow['fcm_token'])) {
                        $fcmService->sendToToken($tokenRow['fcm_token'], $title, $msg, ['cita_id' => (string)$args['id'], 'type' => 'cita_cancelada']);
                    }
                }
            }
        }

        $response->getBody()->write(json_encode(['message' => 'Cita cancelada']));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getHistory(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        $userRole = $request->getAttribute('user_role');
        $queryParams = $request->getQueryParams();
        
        $status = $queryParams['status'] ?? null;
        $search = $queryParams['search'] ?? null;
        $isAdmin = in_array(strtolower($userRole), ['administrador', 'admin']);

        $query = "
            SELECT c.*, u.full_name AS cliente_nombre, s.nombre AS servicio_nombre,
            s.precio AS servicio_precio, e.full_name AS empleado_nombre,
            v.total AS total_cobrado
            FROM citas c
            LEFT JOIN users u ON c.cliente_id = u.id
            LEFT JOIN servicios s ON c.servicio_id = s.id
            LEFT JOIN users e ON c.empleado_id = e.id
            LEFT JOIN ventas v ON v.cita_id = c.id
            WHERE 1=1
        ";
        $params = [];
        $userRoleLower = strtolower($userRole ?? '');
        $isAdmin = in_array($userRoleLower, ['administrador', 'admin']);

        // Filter visibility based on role
        if (in_array($userRoleLower, ['cliente', 'customer'])) {
            // Clients see all THEIR appointments
            $query .= " AND c.cliente_id = :uid";
            $params[':uid'] = $userId;
        } else {
            // Admins and Employees can see all appointments and use status filters
            if ($status && $status !== 'todas') {
                $query .= " AND c.estado = :status";
                $params[':status'] = $status;
            }
        }

        if ($search) {
            $query .= " AND (u.full_name LIKE :search OR u.username LIKE :search OR s.nombre LIKE :search)";
            $params[':search'] = "%$search%";
        }

        $query .= " ORDER BY c.fecha_cita DESC, c.hora_cita DESC";
        
        $stmt = $this->pdo->prepare($query);
        $stmt->execute($params);
        $citas = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $response->getBody()->write(json_encode($citas));
        return $response->withHeader('Content-Type', 'application/json');
    }
    public function autoCancel(Request $request, Response $response): Response {
        try {
            $count = $this->appointmentRepository->cancelPastAppointments();
            
            $response->getBody()->write(json_encode([
                'status' => 'success',
                'message' => 'Citas expiradas canceladas automáticamente.',
                'cancelled_count' => $count
            ]));
            return $response->withHeader('Content-Type', 'application/json')->withStatus(200);
        } catch (\Exception $e) {
            $response->getBody()->write(json_encode([
                'status' => 'error',
                'message' => 'Error al cancelar citas expiradas: ' . $e->getMessage()
            ]));
            return $response->withHeader('Content-Type', 'application/json')->withStatus(500);
        }
    }
}
