<?php
require_once __DIR__ . '/backend/src/config.php';

try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    
    echo "Check columns for 'users' table:\n";
    $stmt = $pdo->query("DESCRIBE users");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach ($columns as $col) {
        echo " - {$col['Field']} ({$col['Type']})\n";
    }

    echo "\nCheck sample users:\n";
    $stmt = $pdo->query("SELECT id, username, role_id, estado FROM users LIMIT 5");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach ($users as $u) {
        echo "ID: {$u['id']}, User: {$u['username']}, Role: {$u['role_id']}, Status: {$u['estado']}\n";
    }

    if (empty($users)) {
        echo "NO USERS FOUND IN DATABASE.\n";
    }

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
}
