<?php
require __DIR__ . '/../vendor/autoload.php';

use Slim\Factory\AppFactory;
use DI\ContainerBuilder;
use App\Domain\Repositories\UserRepositoryInterface;
use App\Domain\Repositories\SettingsRepositoryInterface;
use App\Domain\Repositories\AppointmentRepositoryInterface;
use App\Domain\Repositories\RoleRepositoryInterface;
use App\Domain\Repositories\ModuleRepositoryInterface;
use App\Infrastructure\Persistence\MySQLUserRepository;
use App\Infrastructure\Persistence\MySQLSettingsRepository;
use App\Infrastructure\Persistence\MySQLAppointmentRepository;
use App\Infrastructure\Persistence\MySQLRoleRepository;
use App\Infrastructure\Persistence\MySQLModuleRepository;
use App\Infrastructure\Persistence\MySQLJwtKeyRepository;
use App\Application\UseCases\AuthenticateUserUseCase;
use App\Infrastructure\Controllers\AuthController;
use App\Infrastructure\Controllers\RegisterController;
use App\Infrastructure\Controllers\AppointmentController;
use App\Infrastructure\Controllers\ServicioController;
use App\Infrastructure\Controllers\VentaController;
use App\Infrastructure\Controllers\ProductoController;
use App\Infrastructure\Controllers\SettingsController;
use App\Infrastructure\Controllers\RoleController;
use App\Infrastructure\Controllers\UserController;
use App\Infrastructure\Controllers\NotificationController;
use App\Infrastructure\Controllers\ProfileController;
use App\Infrastructure\Controllers\MonitoringController;
use App\Infrastructure\Controllers\HomeController;
use App\Infrastructure\Controllers\ChatController;
use App\Infrastructure\Controllers\PaymentController;
use App\Infrastructure\Controllers\PqrsController;
use App\Infrastructure\Services\EmailService;

$dotenv = \Dotenv\Dotenv::createImmutable(dirname(__DIR__));
if (file_exists(dirname(__DIR__) . '/.env')) {
    $dotenv->load();
} else if (file_exists(__DIR__ . '/config.php')) {
    require_once __DIR__ . '/config.php';
}

// Global Error Display for Debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

file_put_contents(__DIR__ . '/../settings_debug.log', "[" . date('Y-m-d H:i:s') . "] REQUEST: " . $_SERVER['REQUEST_METHOD'] . " " . $_SERVER['REQUEST_URI'] . "\n", FILE_APPEND);

// ═══════════════════════════════════════════════
// CONFIGURACIÓN DE SEGURIDAD (Hardening)
// ═══════════════════════════════════════════════
$displayErrors = 1; // Force enabled for debugging
ini_set('display_errors', $displayErrors);
ini_set('display_startup_errors', $displayErrors);
error_reporting($displayErrors ? E_ALL : 0);

// Global CORS Handling (Top Level)
$allowedOrigin = $_SERVER['HTTP_ORIGIN'] ?? '*';
header("Access-Control-Allow-Origin: $allowedOrigin");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS");
header("Access-Control-Allow-Headers: X-Requested-With, Content-Type, Accept, Origin, Authorization");
header("Access-Control-Allow-Credentials: true");

// Early CORS Preflight Handling
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Environment Detection
$appEnv = $_ENV['APP_ENV'] ?? 'local';
$prefix = ($appEnv === 'production') ? 'PROD_' : 'LOCAL_';

$containerBuilder = new ContainerBuilder();
$containerBuilder->addDefinitions([
    PDO::class => function() use ($prefix) {
        try {
            $host = $_ENV[$prefix . 'DB_SERVER'] ?? (defined('DB_SERVER') ? DB_SERVER : '127.0.0.1');
            $db   = $_ENV[$prefix . 'DB_DATABASE'] ?? (defined('DB_DATABASE') ? DB_DATABASE : 'DataCience');
            $user = $_ENV[$prefix . 'DB_USERNAME'] ?? (defined('DB_USERNAME') ? DB_USERNAME : 'root');
            $pass = $_ENV[$prefix . 'DB_PASSWORD'] ?? (defined('DB_PASSWORD') ? DB_PASSWORD : '');
            
            $dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";
            $pdo = new PDO($dsn, $user, $pass,
                [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]);
            return $pdo;
        } catch (\PDOException $e) {
            http_response_code(500);
            header('Content-Type: application/json');
            echo json_encode(['error' => 'DATABASE_CONNECTION_ERROR', 'message' => $e->getMessage()]);
            exit;
        }
    },
    UserRepositoryInterface::class => DI\get(MySQLUserRepository::class),
    SettingsRepositoryInterface::class => DI\get(MySQLSettingsRepository::class),
    AppointmentRepositoryInterface::class => DI\get(MySQLAppointmentRepository::class),
    RoleRepositoryInterface::class => DI\get(MySQLRoleRepository::class),
    ModuleRepositoryInterface::class => DI\get(MySQLModuleRepository::class),
    \App\Domain\Repositories\JwtKeyRepositoryInterface::class => DI\get(\App\Infrastructure\Persistence\MySQLJwtKeyRepository::class),
    AuthenticateUserUseCase::class => function($c) {
        return new AuthenticateUserUseCase(
            $c->get(UserRepositoryInterface::class),
            $_ENV['JWT_SECRET'] ?? 'my_super_secret_key',
            $c->get(\App\Domain\Repositories\JwtKeyRepositoryInterface::class)
        );
    },
    EmailService::class => DI\autowire(),
    AppointmentController::class => DI\autowire(),
    VentaController::class => DI\autowire(),
    PqrsController::class => DI\autowire(),
]);

$container = $containerBuilder->build();
AppFactory::setContainer($container);
$app = AppFactory::create();

// ═══════════════════════════════════════════════
// AUTO-SEED: Ensure all required modules exist and are assigned to Administrador
// ═══════════════════════════════════════════════
try {
    $seedPdo = $container->get(PDO::class);
    $requiredModules = [
        'Agenda', 'Servicios', 'Ventas', 'Inventario', 'Reportes',
        'Usuarios', 'Roles y Permisos', 'Configuración', 'Monitoreo',
        'Historial', 'Home', 'Soporte'
    ];
    
    // Get existing modules
    $existingStmt = $seedPdo->query("SELECT name FROM modules");
    $existingModules = $existingStmt->fetchAll(PDO::FETCH_COLUMN);
    
    $insertStmt = $seedPdo->prepare("INSERT INTO modules (name) VALUES (:name)");
    $newModules = [];
    foreach ($requiredModules as $mod) {
        if (!in_array($mod, $existingModules)) {
            $insertStmt->execute(['name' => $mod]);
            $newModules[] = $mod;
        }
    }
    
    if (!empty($newModules)) {
        error_log("AUTO-SEED: Added modules: " . implode(', ', $newModules));
        
        // Assign ALL modules to Administrador (role_id = 1)
        $adminRoleId = $seedPdo->query("SELECT id FROM roles WHERE name = 'Administrador' LIMIT 1")->fetchColumn();
        if ($adminRoleId) {
            $allModules = $seedPdo->query("SELECT id FROM modules")->fetchAll(PDO::FETCH_COLUMN);
            $existingRoleModules = $seedPdo->prepare("SELECT module_id FROM role_modules WHERE role_id = :rid");
            $existingRoleModules->execute(['rid' => $adminRoleId]);
            $assignedModules = $existingRoleModules->fetchAll(PDO::FETCH_COLUMN);
            
            $assignStmt = $seedPdo->prepare("INSERT INTO role_modules (role_id, module_id) VALUES (:rid, :mid)");
            foreach ($allModules as $modId) {
                if (!in_array($modId, $assignedModules)) {
                    $assignStmt->execute(['rid' => $adminRoleId, 'mid' => $modId]);
                }
            }
            error_log("AUTO-SEED: All modules assigned to Administrador role");
        }
    }
} catch (\Exception $e) {
    error_log("AUTO-SEED WARNING: " . $e->getMessage());
}

// Auto-detect base path for subdirectory deployments
$requestContext = \Slim\Factory\ServerRequestCreatorFactory::create()->createServerRequestFromGlobals();
$scriptName = $requestContext->getServerParams()['SCRIPT_NAME'] ?? '/index.php';
$basePath = str_replace('/index.php', '', $scriptName);
$app->setBasePath($basePath);

$app->addBodyParsingMiddleware();
$app->addRoutingMiddleware();

// Rate Limiting (60 requests per minute)
$app->add(new \App\Infrastructure\RateLimitMiddleware($container->get(PDO::class), 60, 60));

// ═══════════════════════════════════════════════
// SECURITY HEADERS MIDDLEWARE
// ═══════════════════════════════════════════════
$app->add(function ($request, $handler) {
    $response = $handler->handle($request);
    return $response
        ->withHeader('X-Frame-Options', 'DENY')
        ->withHeader('X-Content-Type-Options', 'nosniff')
        ->withHeader('Referrer-Policy', 'strict-origin-when-cross-origin')
        ->withHeader('Content-Security-Policy', "default-src 'self'; script-src 'self'; object-src 'none';");
});

$app->addErrorMiddleware(false, true, true); // Disable display_errors in production logic

$checkPermission = function(string $module) use ($container) {
    return new \App\Infrastructure\CheckPermissionMiddleware(
        $module, 
        $_ENV['JWT_SECRET'] ?? 'my_super_secret_key', 
        $container->get(UserRepositoryInterface::class),
        $container->get(\App\Domain\Repositories\JwtKeyRepositoryInterface::class)
    );
};

// ═══════════════════════════════════════════════
// AUTH (Public - no JWT required)
// ═══════════════════════════════════════════════
$app->post('/api/auth/login', [AuthController::class, 'login']);
$app->post('/api/auth/register', [RegisterController::class, 'register']);

// ═══════════════════════════════════════════════
// AGENDA & CITAS
// ═══════════════════════════════════════════════
$app->get('/api/citas/historial', [AppointmentController::class, 'getHistory'])->add($checkPermission('Historial'));
$app->get('/api/citas', [AppointmentController::class, 'getAll'])->add($checkPermission('Agenda'));
$app->post('/api/citas', [AppointmentController::class, 'create'])->add($checkPermission('Agenda'));
$app->post('/api/citas/auto-cancel', [AppointmentController::class, 'autoCancel']); // Public or CRON access
$app->put('/api/citas/{id}', [AppointmentController::class, 'update'])->add($checkPermission('Agenda'));
$app->delete('/api/citas/{id}', [AppointmentController::class, 'delete'])->add($checkPermission('Agenda'));

// ═══════════════════════════════════════════════
// SERVICIOS
// ═══════════════════════════════════════════════
$app->get('/api/servicios', [ServicioController::class, 'getAll'])->add($checkPermission('ANY'));
$app->post('/api/servicios', [ServicioController::class, 'create'])->add($checkPermission('Servicios'));
$app->put('/api/servicios/{id}', [ServicioController::class, 'update'])->add($checkPermission('Servicios'));
$app->delete('/api/servicios/{id}', [ServicioController::class, 'delete'])->add($checkPermission('Servicios'));
$app->post('/api/servicios/{id}/imagenes', [ServicioController::class, 'uploadImage'])->add($checkPermission('Servicios'));
$app->delete('/api/servicios/imagenes/{image_id}', [ServicioController::class, 'deleteImage'])->add($checkPermission('Servicios'));

// ═══════════════════════════════════════════════
// VENTAS & FACTURACIÓN
// ═══════════════════════════════════════════════
$app->get('/api/ventas', [VentaController::class, 'getAll'])->add($checkPermission('Ventas'));
$app->post('/api/ventas', [VentaController::class, 'create'])->add($checkPermission('Ventas'));
$app->get('/api/ventas/{id}/detalles', [VentaController::class, 'getDetalles'])->add($checkPermission('Ventas'));

// ═══════════════════════════════════════════════
// REPORTES
// ═══════════════════════════════════════════════
$app->get('/api/reportes/ingresos', [VentaController::class, 'getReporteIngresos'])->add($checkPermission('Reportes'));
$app->get('/api/reportes/servicios-top', [VentaController::class, 'getReporteServiciosTop'])->add($checkPermission('Reportes'));
$app->get('/api/reportes/empleados', [VentaController::class, 'getReporteEmpleados'])->add($checkPermission('Reportes'));
$app->get('/api/reportes/clientes-top', [VentaController::class, 'getReporteClientesTop'])->add($checkPermission('Reportes'));

// ═══════════════════════════════════════════════
// PRODUCTOS / INVENTARIO
// ═══════════════════════════════════════════════
$app->get('/api/productos', [ProductoController::class, 'getAll'])->add($checkPermission('Inventario'));
$app->post('/api/productos', [ProductoController::class, 'create'])->add($checkPermission('Inventario'));
$app->put('/api/productos/{id}', [ProductoController::class, 'update'])->add($checkPermission('Inventario'));
$app->delete('/api/productos/{id}', [ProductoController::class, 'delete'])->add($checkPermission('Inventario'));
$app->get('/api/productos/alertas', [ProductoController::class, 'getAlertasStock'])->add($checkPermission('Inventario'));
$app->get('/api/productos/{id}/movimientos', [ProductoController::class, 'getMovimientos'])->add($checkPermission('Inventario'));
$app->post('/api/productos/{id}/movimientos', [ProductoController::class, 'registrarMovimiento'])->add($checkPermission('Inventario'));

// ═══════════════════════════════════════════════
// CONFIGURACIÓN
// ═══════════════════════════════════════════════
$app->get('/api/settings', [SettingsController::class, 'getAll']);
$app->patch('/api/settings', [SettingsController::class, 'update'])->add($checkPermission('Configuración'));
$app->post('/api/settings/upload-logo', [SettingsController::class, 'uploadLogo'])->add($checkPermission('Configuración'));

// ═══════════════════════════════════════════════
// ROLES & ACCESO
// ═══════════════════════════════════════════════
$app->get('/api/roles', [RoleController::class, 'getAll'])->add($checkPermission('Roles y Permisos'));
$app->post('/api/roles', [RoleController::class, 'create'])->add($checkPermission('Roles y Permisos'));
$app->put('/api/roles/{id}', [RoleController::class, 'update'])->add($checkPermission('Roles y Permisos'));
$app->delete('/api/roles/{id}', [RoleController::class, 'delete'])->add($checkPermission('Roles y Permisos'));
$app->get('/api/modules', [RoleController::class, 'getModules'])->add($checkPermission('Roles y Permisos'));

// ═══════════════════════════════════════════════
// USUARIOS
// ═══════════════════════════════════════════════
$app->get('/api/users/empleados', [UserController::class, 'getEmpleados'])->add($checkPermission('ANY'));
$app->get('/api/users/clientes', [UserController::class, 'getClientes'])->add($checkPermission('ANY'));
$app->get('/api/users', [UserController::class, 'getAll'])->add($checkPermission('Usuarios'));
$app->post('/api/users', [UserController::class, 'create'])->add($checkPermission('Usuarios'));
$app->put('/api/users/{id}', [UserController::class, 'update'])->add($checkPermission('Usuarios'));
$app->patch('/api/users/{id}/fcm-token', [UserController::class, 'updateFcmToken']);
$app->delete('/api/users/{id}', [UserController::class, 'delete'])->add($checkPermission('Usuarios'));

// ═══════════════════════════════════════════════
// NOTIFICACIONES
// ═══════════════════════════════════════════════
$app->get('/api/notifications', [NotificationController::class, 'getAll'])->add($checkPermission('ANY'));
$app->get('/api/notifications/{userId}', [NotificationController::class, 'getForUser']);
$app->get('/api/notifications/{userId}/unread', [NotificationController::class, 'getUnreadCount']);
$app->patch('/api/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
$app->patch('/api/notifications/{userId}/read-all', [NotificationController::class, 'markAllRead']);
// ═══════════════════════════════════════════════
// PERFIL Y MONITORIZACIÓN
// ═══════════════════════════════════════════════
$app->get('/api/profile', [ProfileController::class, 'getProfile'])->add($checkPermission('ANY'));
$app->patch('/api/profile', [ProfileController::class, 'updateProfile'])->add($checkPermission('ANY'));
$app->post('/api/profile/upload-photo', [ProfileController::class, 'uploadPhoto'])->add($checkPermission('ANY'));
$app->get('/api/monitoring/logins', [MonitoringController::class, 'getLoginLogs'])->add($checkPermission('Monitoreo'));
$app->delete('/api/monitoring/sessions/{id}', [MonitoringController::class, 'logoutRemote'])->add($checkPermission('Monitoreo'));
$app->get('/api/monitoring/sucursales', [MonitoringController::class, 'getSucursales'])->add($checkPermission('Monitoreo'));
$app->post('/api/monitoring/sucursales', [MonitoringController::class, 'createSucursal'])->add($checkPermission('Monitoreo'));
$app->put('/api/monitoring/sucursales/{id}', [MonitoringController::class, 'updateSucursal'])->add($checkPermission('Monitoreo'));
$app->delete('/api/monitoring/sucursales/{id}', [MonitoringController::class, 'deleteSucursal'])->add($checkPermission('Monitoreo'));

// ═══════════════════════════════════════════════
// HOME Y GALERÍA
// ═══════════════════════════════════════════════
$app->get('/api/home/gallery', [HomeController::class, 'getGallery'])->add($checkPermission('ANY'));
$app->post('/api/home/gallery/upload', [HomeController::class, 'uploadImage'])->add($checkPermission('Home'));
$app->delete('/api/home/gallery/{id}', [HomeController::class, 'deleteImage'])->add($checkPermission('Home'));

// ═══════════════════════════════════════════════
// CHAT INTERNO
// ═══════════════════════════════════════════════
$app->get('/api/chat/my-chats', [ChatController::class, 'getMyChats'])->add($checkPermission('ANY'));
$app->get('/api/chat/messages/{citaId}', [ChatController::class, 'getMessages'])->add($checkPermission('ANY'));
$app->post('/api/chat/messages/{citaId}', [ChatController::class, 'sendMessage'])->add($checkPermission('ANY'));

// ═══════════════════════════════════════════════
// PAGOS (SIMULADO)
// ═══════════════════════════════════════════════
$app->post('/api/payments/init', [PaymentController::class, 'initiate'])->add($checkPermission('ANY'));
$app->post('/api/payments/confirm', [PaymentController::class, 'confirm'])->add($checkPermission('ANY'));

// ═══════════════════════════════════════════════
// PQRS (SOPORTE)
// ═══════════════════════════════════════════════
$app->get('/api/pqrs', [PqrsController::class, 'getAll'])->add($checkPermission('ANY'));
$app->get('/api/pqrs/{id}', [PqrsController::class, 'getById'])->add($checkPermission('ANY'));
$app->post('/api/pqrs', [PqrsController::class, 'create'])->add($checkPermission('ANY'));
$app->post('/api/pqrs/{id}/respuestas', [PqrsController::class, 'addRespuesta'])->add($checkPermission('ANY'));
$app->patch('/api/pqrs/{id}/status', [PqrsController::class, 'updateStatus'])->add($checkPermission('Configuración'));

$app->run();
