<?php
require_once __DIR__ . '/src/config.php';
header('Content-Type: text/plain; charset=UTF-8');

try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    
    echo "Columns in 'users' table:\n";
    $stmt = $pdo->query("SHOW COLUMNS FROM users");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach ($columns as $column) {
        echo "- {$column['Field']} ({$column['Type']})\n";
    }

    echo "\nColumns in 'citas' table:\n";
    $stmt = $pdo->query("SHOW COLUMNS FROM citas");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach ($columns as $column) {
        echo "- {$column['Field']} ({$column['Type']})\n";
    }

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage();
}
