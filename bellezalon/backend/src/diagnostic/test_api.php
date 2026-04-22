<?php
header('Content-Type: text/plain; charset=UTF-8');
echo "=== DIAGNÓSTICO DEL BACKEND EXTENDIDO ===\n\n";

require_once __DIR__ . '/config.php';
try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    echo "[OK] Conexión a Base de Datos exitosa.\n\n";
    
    // 1. Listar Módulos
    echo "--- CONTENIDO DE TABLA 'modules' ---\n";
    $stmt = $pdo->query("SELECT * FROM modules");
    $rowCount = 0;
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "ID: {$row['id']} | Name: {$row['name']} | Description: {$row['description']}\n";
        $rowCount++;
    }
    echo "Total módulos: $rowCount\n\n";

    // 2. Listar Roles
    echo "--- CONTENIDO DE TABLA 'roles' ---\n";
    $stmt = $pdo->query("SELECT * FROM roles");
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "ID: {$row['id']} | Name: {$row['name']} | Description: {$row['description']}\n";
    }
    echo "\n";

    // 3. Verificar mi rol
    // (Asumimos que el admin se loguea, verifiquemos el rol_id 1)
    echo "--- PERMISOS DE ROL ADMINISTRADOR (ID 1) ---\n";
    $stmt = $pdo->prepare("
        SELECT m.name FROM modules m
        JOIN role_modules rm ON m.id = rm.module_id
        WHERE rm.role_id = 1
    ");
    $stmt->execute();
    $perms = $stmt->fetchAll(PDO::FETCH_COLUMN);
    echo "Permisos: " . implode(", ", $perms) . "\n\n";

    // 4. Verificar columnas críticas en 'users'
    echo "--- ESTRUCTURA DE TABLA 'users' ---\n";
    $stmt = $pdo->query("DESCRIBE users");
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "{$row['Field']} ({$row['Type']})\n";
    }

} catch (Exception $e) {
    echo "[ERROR] Fallo en el diagnóstico: " . $e->getMessage() . "\n";
}

echo "\n=== FIN DEL DIAGNÓSTICO ===\n";
