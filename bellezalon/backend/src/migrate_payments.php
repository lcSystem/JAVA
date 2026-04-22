<?php
require_once __DIR__ . '/config.php';

try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    
    $sql = "ALTER TABLE citas 
ADD COLUMN payment_status VARCHAR(20) DEFAULT 'pending',
ADD COLUMN transaction_id VARCHAR(100) DEFAULT NULL,
ADD COLUMN deposit_amount DECIMAL(10,2) DEFAULT 0.00;";
    
    $pdo->exec($sql);
    echo "Payment columns migration successful.\n";
} catch (Exception $e) {
    if (strpos($e->getMessage(), 'Duplicate column') !== false) {
        echo "Columns already exist.\n";
    } else {
        echo "Migration failed: " . $e->getMessage() . "\n";
    }
}
