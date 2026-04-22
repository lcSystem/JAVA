<?php
/**
 * REPARADOR DE ESQUEMA DE USUARIOS
 * Este script añade las columnas faltantes a la tabla 'users' para asegurar que la API funcione correctamente.
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: text/plain; charset=UTF-8');

require_once __DIR__ . '/../vendor/autoload.php';

// Cargar entorno
$dotenv = \Dotenv\Dotenv::createImmutable(dirname(__DIR__));
if (file_exists(dirname(__DIR__) . '/.env')) {
    $dotenv->load();
}

$appEnv = $_ENV['APP_ENV'] ?? 'local';
$prefix = ($appEnv === 'production') ? 'PROD_' : 'LOCAL_';

try {
    $host = $_ENV[$prefix . 'DB_SERVER'] ?? (defined('DB_SERVER') ? DB_SERVER : '127.0.0.1');
    $db   = $_ENV[$prefix . 'DB_DATABASE'] ?? (defined('DB_DATABASE') ? DB_DATABASE : 'DataCience');
    $user = $_ENV[$prefix . 'DB_USERNAME'] ?? (defined('DB_USERNAME') ? DB_USERNAME : 'root');
    $pass = $_ENV[$prefix . 'DB_PASSWORD'] ?? (defined('DB_PASSWORD') ? DB_PASSWORD : '');

    $dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

    echo "Conexión exitosa a la base de datos: $db\n";
    echo "Entorno detectado: $appEnv\n\n";

    // 1. Verificar y reparar columnas de la tabla users
    $expectedColumns = [
        'full_name' => "VARCHAR(255) DEFAULT NULL",
        'email' => "VARCHAR(150) DEFAULT NULL",
        'phone' => "VARCHAR(20) DEFAULT NULL",
        'city' => "VARCHAR(100) DEFAULT NULL",
        'neighborhood' => "VARCHAR(100) DEFAULT NULL",
        'address' => "VARCHAR(255) DEFAULT NULL",
        'avatar_url' => "VARCHAR(255) DEFAULT NULL",
        'technical_sheet' => "JSON DEFAULT NULL",
        'estado' => "ENUM('activo', 'inactivo') DEFAULT 'activo'",
        'role_id' => "INT(11) DEFAULT 2",
        'fcm_token' => "VARCHAR(255) DEFAULT NULL"
    ];

    echo "Verificando columnas en la tabla 'users'...\n";
    $stmt = $pdo->query("DESCRIBE users");
    $existingColumns = $stmt->fetchAll(PDO::FETCH_COLUMN);

    foreach ($expectedColumns as $col => $definition) {
        if (!in_array($col, $existingColumns)) {
            echo " - Añadiendo columna '$col'...";
            try {
                $pdo->exec("ALTER TABLE users ADD COLUMN $col $definition");
                echo " [OK]\n";
            } catch (Exception $e) {
                echo " [ERROR: " . $e->getMessage() . "]\n";
                // En algunos MySQL viejos JSON no es compatible, intentar TEXT
                if (str_contains($e->getMessage(), 'JSON') && $col === 'technical_sheet') {
                    echo "   Intentando con TEXT para technical_sheet...";
                    $pdo->exec("ALTER TABLE users ADD COLUMN technical_sheet TEXT DEFAULT NULL");
                    echo " [OK]\n";
                }
            }
        } else {
            echo " - Columna '$col' ya existe.\n";
        }
    }

    // 2. Verificar integridad de roles
    echo "\nVerificando roles básicos...\n";
    $rolesCount = $pdo->query("SELECT COUNT(*) FROM roles")->fetchColumn();
    if ($rolesCount == 0) {
        echo " - Insertando roles por defecto...\n";
        $pdo->exec("INSERT IGNORE INTO roles (id, name, description) VALUES 
            (1, 'Administrador', 'Acceso total'),
            (2, 'Usuario', 'Empleado / Estilista'),
            (3, 'Cliente', 'Acceso cliente')");
    } else {
        echo " - Roles encontrados: $rolesCount\n";
    }

    // 3. Asegurar que los usuarios tengan un role_id válido
    echo "\nReparando usuarios con role_id nulo...\n";
    $stmt = $pdo->prepare("UPDATE users SET role_id = 2 WHERE role_id IS NULL OR role_id NOT IN (SELECT id FROM roles)");
    $stmt->execute();
    echo " - Filas afectadas: " . $stmt->rowCount() . "\n";

    echo "\n¡REPARACIÓN COMPLETADA!\n";

} catch (Exception $e) {
    echo "\nFATAL ERROR: " . $e->getMessage() . "\n";
}
