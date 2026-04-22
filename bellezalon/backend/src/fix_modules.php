<?php
/**
 * REPARADOR COMPLETO DE MÓDULOS Y PERMISOS
 * 
 * Sube este archivo al servidor de producción en la carpeta:
 *   /api/src/fix_modules.php
 * 
 * Luego visita: https://luigitech.site/api/src/fix_modules.php
 * 
 * Después de ejecutar, CIERRA SESIÓN y vuelve a iniciar para obtener
 * un JWT actualizado con los nuevos permisos.
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: text/plain; charset=UTF-8');

require_once __DIR__ . '/../vendor/autoload.php';

$dotenv = \Dotenv\Dotenv::createImmutable(dirname(__DIR__));
if (file_exists(dirname(__DIR__) . '/.env')) {
    $dotenv->load();
}

$appEnv = $_ENV['APP_ENV'] ?? 'local';
$prefix = ($appEnv === 'production') ? 'PROD_' : 'LOCAL_';

try {
    $host = $_ENV[$prefix . 'DB_SERVER'] ?? '127.0.0.1';
    $db   = $_ENV[$prefix . 'DB_DATABASE'] ?? 'DataCience';
    $user = $_ENV[$prefix . 'DB_USERNAME'] ?? 'root';
    $pass = $_ENV[$prefix . 'DB_PASSWORD'] ?? '';

    $dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

    echo "✅ Conexión exitosa a: $db\n";
    echo "📍 Entorno: $appEnv\n";
    echo "📅 Fecha: " . date('Y-m-d H:i:s') . "\n\n";

    // ═══════════════════════════════════════
    // 1. REPARAR COLUMNAS DE USERS
    // ═══════════════════════════════════════
    echo "═══ PASO 1: REPARAR COLUMNAS DE TABLA USERS ═══\n";
    $expectedColumns = [
        'full_name' => "VARCHAR(255) DEFAULT NULL",
        'email' => "VARCHAR(150) DEFAULT NULL",
        'phone' => "VARCHAR(20) DEFAULT NULL",
        'city' => "VARCHAR(100) DEFAULT NULL",
        'neighborhood' => "VARCHAR(100) DEFAULT NULL",
        'address' => "VARCHAR(255) DEFAULT NULL",
        'avatar_url' => "VARCHAR(255) DEFAULT NULL",
        'technical_sheet' => "TEXT DEFAULT NULL",
        'estado' => "ENUM('activo', 'inactivo') DEFAULT 'activo'",
        'fcm_token' => "VARCHAR(255) DEFAULT NULL"
    ];

    $stmt = $pdo->query("DESCRIBE users");
    $existingColumns = $stmt->fetchAll(PDO::FETCH_COLUMN);
    echo "Columnas actuales: " . implode(', ', $existingColumns) . "\n\n";

    foreach ($expectedColumns as $col => $definition) {
        if (!in_array($col, $existingColumns)) {
            try {
                $pdo->exec("ALTER TABLE users ADD COLUMN $col $definition");
                echo "  ✅ Columna '$col' AÑADIDA\n";
            } catch (Exception $e) {
                echo "  ⚠️ Error al añadir '$col': " . $e->getMessage() . "\n";
            }
        } else {
            echo "  ✓ Columna '$col' ya existe\n";
        }
    }

    // ═══════════════════════════════════════
    // 2. REPARAR ROLES
    // ═══════════════════════════════════════
    echo "\n═══ PASO 2: VERIFICAR ROLES ═══\n";
    $rolesCount = $pdo->query("SELECT COUNT(*) FROM roles")->fetchColumn();
    if ($rolesCount == 0) {
        $pdo->exec("INSERT IGNORE INTO roles (id, name, description) VALUES 
            (1, 'Administrador', 'Acceso total al sistema'),
            (2, 'Usuario', 'Empleado / Estilista'),
            (3, 'Cliente', 'Acceso cliente')");
        echo "  ✅ Roles básicos insertados\n";
    } else {
        echo "  ✓ Roles encontrados: $rolesCount\n";
        $stmt = $pdo->query("SELECT id, name FROM roles ORDER BY id");
        while ($r = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "    - ID:{$r['id']} -> {$r['name']}\n";
        }
    }

    // ═══════════════════════════════════════
    // 3. REPARAR MÓDULOS
    // ═══════════════════════════════════════
    echo "\n═══ PASO 3: SEED DE MÓDULOS ═══\n";
    $requiredModules = [
        'Agenda', 'Servicios', 'Ventas', 'Inventario', 'Reportes',
        'Usuarios', 'Roles y Permisos', 'Configuración', 'Monitoreo',
        'Historial', 'Home', 'Soporte'
    ];

    $existingStmt = $pdo->query("SELECT id, name FROM modules ORDER BY id");
    $existingModules = [];
    echo "  Módulos actuales en BD:\n";
    while ($row = $existingStmt->fetch(PDO::FETCH_ASSOC)) {
        $existingModules[] = $row['name'];
        echo "    - ID:{$row['id']} -> {$row['name']}\n";
    }
    if (empty($existingModules)) {
        echo "    (ninguno)\n";
    }

    $insertStmt = $pdo->prepare("INSERT INTO modules (name) VALUES (:name)");
    $addedModules = [];
    foreach ($requiredModules as $mod) {
        if (!in_array($mod, $existingModules)) {
            $insertStmt->execute(['name' => $mod]);
            $addedModules[] = $mod;
            echo "  ✅ Módulo '$mod' INSERTADO\n";
        }
    }
    if (empty($addedModules)) {
        echo "  ✓ Todos los módulos ya existían\n";
    }

    // ═══════════════════════════════════════
    // 4. ASIGNAR TODOS LOS MÓDULOS AL ADMINISTRADOR
    // ═══════════════════════════════════════
    echo "\n═══ PASO 4: ASIGNAR MÓDULOS A ADMINISTRADOR ═══\n";
    $adminRoleId = $pdo->query("SELECT id FROM roles WHERE name = 'Administrador' LIMIT 1")->fetchColumn();
    
    if (!$adminRoleId) {
        echo "  ⚠️ No existe rol 'Administrador'. Usando role_id=1\n";
        $adminRoleId = 1;
    }

    $allModules = $pdo->query("SELECT id, name FROM modules")->fetchAll(PDO::FETCH_ASSOC);
    $existingRM = $pdo->prepare("SELECT module_id FROM role_modules WHERE role_id = :rid");
    $existingRM->execute(['rid' => $adminRoleId]);
    $assignedModuleIds = $existingRM->fetchAll(PDO::FETCH_COLUMN);

    $assignStmt = $pdo->prepare("INSERT INTO role_modules (role_id, module_id) VALUES (:rid, :mid)");
    foreach ($allModules as $mod) {
        if (!in_array($mod['id'], $assignedModuleIds)) {
            $assignStmt->execute(['rid' => $adminRoleId, 'mid' => $mod['id']]);
            echo "  ✅ Módulo '{$mod['name']}' asignado a Administrador\n";
        } else {
            echo "  ✓ Módulo '{$mod['name']}' ya asignado\n";
        }
    }

    // ═══════════════════════════════════════
    // 5. VERIFICACIÓN FINAL
    // ═══════════════════════════════════════
    echo "\n═══ PASO 5: VERIFICACIÓN FINAL ═══\n";
    
    $totalUsers = $pdo->query("SELECT COUNT(*) FROM users")->fetchColumn();
    echo "  Total usuarios: $totalUsers\n";
    
    echo "  Permisos del Administrador:\n";
    $stmt = $pdo->query("SELECT m.name FROM modules m JOIN role_modules rm ON m.id = rm.module_id WHERE rm.role_id = $adminRoleId ORDER BY m.name");
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "    ✓ {$row['name']}\n";
    }

    // Test the exact query used by findAll()
    echo "\n  Probando query findAll()...\n";
    try {
        $stmt = $pdo->query("SELECT u.id, u.username, u.role_id, u.estado, u.full_name, u.email, u.phone, u.city, u.neighborhood, u.address, u.avatar_url, u.technical_sheet, r.name as role_name FROM users u LEFT JOIN roles r ON u.role_id = r.id ORDER BY u.id");
        $count = 0;
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $count++;
            if ($count <= 5) {
                echo "    - ID:{$row['id']} {$row['username']} | rol:{$row['role_name']} | estado:{$row['estado']}\n";
            }
        }
        echo "  ✅ Query findAll() exitosa: $count usuarios\n";
    } catch (Exception $e) {
        echo "  ❌ Query findAll() FALLÓ: " . $e->getMessage() . "\n";
    }

    echo "\n════════════════════════════════════════\n";
    echo "✅ REPARACIÓN COMPLETADA\n";
    echo "⚠️ IMPORTANTE: Cierra sesión en la app y vuelve a iniciar para\n";
    echo "   obtener un token JWT con los nuevos permisos.\n";
    echo "════════════════════════════════════════\n";

} catch (Exception $e) {
    echo "\n❌ ERROR FATAL: " . $e->getMessage() . "\n";
}
