<?php
require __DIR__ . '/vendor/autoload.php';

try {
    $dotenv = \Dotenv\Dotenv::createImmutable(__DIR__);
    if (file_exists(__DIR__ . '/.env')) {
        $dotenv->load();
    }
    
    $appEnv = $_ENV['APP_ENV'] ?? 'local';
    
    // Check if we are being forced to use a specific env via command line
    if (isset($argv[1]) && in_array($argv[1], ['local', 'production'])) {
        $appEnv = $argv[1];
    }
    
    $prefix = ($appEnv === 'production') ? 'PROD_' : 'LOCAL_';
    
    $host = $_ENV[$prefix . 'DB_SERVER'] ?? '127.0.0.1';
    $db   = $_ENV[$prefix . 'DB_DATABASE'] ?? 'luigitec_SalonE';
    $user = $_ENV[$prefix . 'DB_USERNAME'] ?? 'root';
    $pass = $_ENV[$prefix . 'DB_PASSWORD'] ?? '';

    echo "Attempting to connect to $appEnv database ($host / $db)...\n";

    $dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    
    echo "Checking and adding missing columns to 'users' table...\n";

    $columnsToAdd = [
        'full_name' => "VARCHAR(100) DEFAULT NULL",
        'email' => "VARCHAR(100) DEFAULT NULL",
        'phone' => "VARCHAR(20) DEFAULT NULL",
        'city' => "VARCHAR(100) DEFAULT NULL",
        'neighborhood' => "VARCHAR(100) DEFAULT NULL",
        'address' => "VARCHAR(255) DEFAULT NULL",
        'avatar_url' => "VARCHAR(255) DEFAULT NULL",
        'technical_sheet' => "JSON DEFAULT NULL",
        'estado' => "ENUM('activo', 'inactivo') DEFAULT 'activo'"
    ];

    foreach ($columnsToAdd as $column => $definition) {
        $res = $pdo->query("SHOW COLUMNS FROM users LIKE '$column'");
        if ($res->rowCount() === 0) {
            echo "Adding column '$column'...\n";
            $pdo->exec("ALTER TABLE users ADD COLUMN $column $definition");
        } else {
            echo "Column '$column' already exists.\n";
        }
    }

    echo "Migration completed successfully for $appEnv environment.\n";

} catch (Exception $e) {
    echo "ERROR ($appEnv): " . $e->getMessage() . "\n";
}
