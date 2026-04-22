<?php
require_once __DIR__ . '/src/config.php';
$dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
$pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
$hash = password_hash("admin123", PASSWORD_BCRYPT);
try {
    $stmt = $pdo->prepare("INSERT INTO usuarios (username, email, password, nombre_completo, fecha_registro, estado, rol) VALUES (?, ?, ?, ?, NOW(), 'activo', 'admin')");
    $stmt->execute(['admin', 'admin@salon.pro', $hash, 'Administrator']);
    echo "Inserted into usuarios!\n";
} catch (PDOException $e) {
    if ($e->getCode() == 23000) {
        $stmt2 = $pdo->prepare("UPDATE usuarios SET password = ? WHERE username = 'admin'");
        $stmt2->execute([$hash]);
        echo "Updated existing in usuarios!\n";
    } else {
        echo "Error: " . $e->getMessage() . "\n";
    }
}
