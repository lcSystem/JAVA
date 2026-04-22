<?php
require __DIR__ . '/vendor/autoload.php';

try {
    $dotenv = \Dotenv\Dotenv::createImmutable(__DIR__);
    if (file_exists(__DIR__ . '/.env')) {
        $dotenv->load();
    }
    
    $appEnv = $_ENV['APP_ENV'] ?? 'local';
    $prefix = ($appEnv === 'production') ? 'PROD_' : 'LOCAL_';
    
    $host = $_ENV[$prefix . 'DB_SERVER'] ?? '127.0.0.1';
    $db   = $_ENV[$prefix . 'DB_DATABASE'] ?? 'luigitec_SalonE';
    $user = $_ENV[$prefix . 'DB_USERNAME'] ?? 'root';
    $pass = $_ENV[$prefix . 'DB_PASSWORD'] ?? '';

    $dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]);
    
    echo "[" . date('Y-m-d H:i:s') . "] Starting auto-cancellation of past appointments...\n";

    $sql = "UPDATE citas 
            SET estado = 'cancelada' 
            WHERE (fecha_cita < CURDATE() OR (fecha_cita = CURDATE() AND hora_cita < CURTIME()))
            AND estado NOT IN ('completado', 'cancelada')";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    $count = $stmt->rowCount();

    echo "[" . date('Y-m-d H:i:s') . "] Successfully cancelled $count appointments.\n";

} catch (Exception $e) {
    echo "[" . date('Y-m-d H:i:s') . "] ERROR: " . $e->getMessage() . "\n";
}
