<?php
require_once __DIR__ . '/config.php';

try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    
    $settings = [
        ['smtp_host', 'smtp.gmail.com', 'EMAIL'],
        ['smtp_port', '587', 'EMAIL'],
        ['smtp_user', '', 'EMAIL'],
        ['smtp_pass', '', 'EMAIL'],
        ['smtp_encryption', 'tls', 'EMAIL'],
        ['mail_from_address', '', 'EMAIL'],
        ['mail_from_name', 'Salón Belleza Pro', 'EMAIL'],
        ['enable_email_notifications', '0', 'EMAIL'],
    ];
    
    $stmt = $pdo->prepare("INSERT IGNORE INTO app_settings (key_name, setting_value, category) VALUES (?, ?, ?)");
    
    foreach ($settings as $setting) {
        $stmt->execute($setting);
    }
    
    echo "Email settings migration successful.\n";
} catch (Exception $e) {
    echo "Migration failed: " . $e->getMessage() . "\n";
}
