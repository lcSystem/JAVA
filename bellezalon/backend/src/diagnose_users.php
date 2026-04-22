<?php
/**
 * DIAGNÓSTICO DE INTEGRIDAD DE USUARIOS
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

    echo "--- DIAGNÓSTICO DE USUARIOS ---\n";
    echo "Base de Datos: $db\n";
    echo "Fecha: " . date('Y-m-d H:i:s') . "\n\n";

    // 1. Conteo total
    $total = $pdo->query("SELECT COUNT(*) FROM users")->fetchColumn();
    echo "Total de usuarios en DB: $total\n";

    // 2. Usuarios por estado
    echo "\nUsuarios por Estado:\n";
    $stmt = $pdo->query("SELECT estado, COUNT(*) as qty FROM users GROUP BY estado");
    while($row = $stmt->fetch()) {
        echo " - " . ($row['estado'] ?? 'NULL') . ": " . $row['qty'] . "\n";
    }

    // 3. Usuarios por rol
    echo "\nUsuarios por Rol:\n";
    $stmt = $pdo->query("SELECT r.name, COUNT(u.id) as qty 
                        FROM roles r 
                        LEFT JOIN users u ON r.id = u.role_id 
                        GROUP BY r.id, r.name");
    while($row = $stmt->fetch()) {
        echo " - " . $row['name'] . ": " . $row['qty'] . "\n";
    }

    // 4. Muestra de usuarios (top 10)
    echo "\nMuestra de los últimos 10 usuarios:\n";
    echo "ID | Username | Rol | Estado | Nombre Completo\n";
    echo str_repeat("-", 60) . "\n";
    $stmt = $pdo->query("SELECT u.id, u.username, r.name as role_name, u.estado, u.full_name 
                        FROM users u 
                        LEFT JOIN roles r ON u.role_id = r.id 
                        ORDER BY u.id DESC LIMIT 10");
    while($u = $stmt->fetch()) {
        printf("%d | %s | %s | %s | %s\n", 
            $u['id'], 
            str_pad($u['username'], 12), 
            str_pad($u['role_name'], 12), 
            str_pad($u['estado'], 8),
            $u['full_name'] ?? '(Sin nombre)'
        );
    }

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
}
