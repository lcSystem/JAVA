<?php
require_once __DIR__ . '/config.php';
header('Content-Type: text/html; charset=UTF-8');

try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    
    echo "<h1>Diagnóstico de Usuarios</h1>";

    echo "<h2>Listado de Usuarios</h2>";
    $stmt = $pdo->query("SELECT id, username, role_id, estado FROM users");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if (empty($users)) {
        echo "<b style='color:red'>LA TABLA USERS ESTÁ VACÍA</b><br>";
    } else {
        echo "<table border='1'><tr><th>ID</th><th>Username</th><th>Role ID</th><th>Estado</th></tr>";
        foreach ($users as $u) {
            echo "<tr><td>{$u['id']}</td><td>{$u['username']}</td><td>{$u['role_id']}</td><td>{$u['estado']}</td></tr>";
        }
        echo "</table>";
    }

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage();
}
