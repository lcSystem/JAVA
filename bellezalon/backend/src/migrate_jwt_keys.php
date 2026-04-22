<?php
require_once __DIR__ . '/config.php';

try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    
    $sql = "CREATE TABLE IF NOT EXISTS jwt_keys (
        kid VARCHAR(64) PRIMARY KEY,
        secret VARCHAR(255) NOT NULL,
        status ENUM('active', 'expired') DEFAULT 'active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )";
    
    $pdo->exec($sql);
    echo "Migration successful: jwt_keys table created or already exists.\n";
} catch (Exception $e) {
    echo "Migration failed: " . $e->getMessage() . "\n";
}
