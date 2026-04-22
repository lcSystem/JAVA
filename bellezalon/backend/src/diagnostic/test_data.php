<?php
require_once __DIR__ . '/config.php';
header('Content-Type: text/html; charset=UTF-8');

try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    
    echo "<h1>Diagnóstico de Datos - Roles y Permisos</h1>";

    // 1. ROLES
    echo "<h2>1. Tabla 'roles'</h2>";
    $stmt = $pdo->query("SELECT * FROM roles");
    $roles = $stmt->fetchAll(PDO::FETCH_ASSOC);
    if (empty($roles)) {
        echo "<b style='color:red'>LA TABLA ROLES ESTÁ VACÍA</b><br>";
    } else {
        echo "<table border='1'><tr><th>ID</th><th>Nombre</th><th>Descripción</th></tr>";
        foreach ($roles as $r) {
            echo "<tr><td>{$r['id']}</td><td>{$r['name']}</td><td>{$r['description']}</td></tr>";
        }
        echo "</table>";
    }

    // 2. MÓDULOS
    echo "<h2>2. Tabla 'modules'</h2>";
    $stmt = $pdo->query("SELECT * FROM modules");
    $modules = $stmt->fetchAll(PDO::FETCH_ASSOC);
    if (empty($modules)) {
        echo "<b style='color:red'>LA TABLA MODULES ESTÁ VACÍA</b><br>";
    } else {
        echo "<table border='1'><tr><th>ID</th><th>Nombre</th></tr>";
        foreach ($modules as $m) {
            echo "<tr><td>{$m['id']}</td><td>{$m['name']}</td></tr>";
        }
        echo "</table>";
    }

    // 3. ASIGNACIONES (role_modules)
    echo "<h2>3. Tabla 'role_modules' (Asignaciones)</h2>";
    $stmt = $pdo->query("SELECT rm.role_id, r.name as role_name, m.name as module_name 
                         FROM role_modules rm 
                         JOIN roles r ON rm.role_id = r.id 
                         JOIN modules m ON rm.module_id = m.id");
    $assigns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    if (empty($assigns)) {
        echo "<b style='color:red'>NO HAY ASIGNACIONES DE PERMISOS</b><br>";
    } else {
        echo "<table border='1'><tr><th>Role ID</th><th>Role Name</th><th>Module Name</th></tr>";
        foreach ($assigns as $a) {
            echo "<tr><td>{$a['role_id']}</td><td>{$a['role_name']}</td><td>{$a['module_name']}</td></tr>";
        }
        echo "</table>";
    }

    // 4. TU USUARIO ACTUAL
    echo "<h2>4. Tu Usuario ('beauty_admin')</h2>";
    $stmt = $pdo->query("SELECT id, username, role_id FROM users WHERE username = 'beauty_admin'");
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$user) {
        echo "<b style='color:red'>NO SE ENCONTRÓ EL USUARIO 'beauty_admin'</b><br>";
    } else {
        echo "ID: {$user['id']}<br>";
        echo "Username: {$user['username']}<br>";
        echo "Role ID: {$user['role_id']}<br>";
    }

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage();
}
