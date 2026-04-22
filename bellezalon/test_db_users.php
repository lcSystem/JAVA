<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$dsn = 'mysql:host=127.0.0.1;dbname=DataCience;charset=utf8mb4';
$user = 'root';
$pass = '';

try {
    $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    echo "Conexion LOCAL OK\n\n";
    
    echo "=== COLUMNAS DE LA TABLA users ===\n";
    $stmt = $pdo->query('DESCRIBE users');
    while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo $row['Field'] . ' | ' . $row['Type'] . ' | ' . $row['Null'] . ' | ' . ($row['Default'] ?? 'NULL') . "\n";
    }
    
    echo "\n=== TOTAL USUARIOS ===\n";
    echo $pdo->query('SELECT COUNT(*) FROM users')->fetchColumn() . " usuarios\n";
    
    echo "\n=== QUERY findAll() ===\n";
    try {
        $stmt = $pdo->query("SELECT u.id, u.username, u.role_id, u.estado, u.full_name, u.email, u.phone, u.city, u.neighborhood, u.address, u.avatar_url, u.technical_sheet, r.name as role_name FROM users u LEFT JOIN roles r ON u.role_id = r.id ORDER BY u.id");
        $count = 0;
        while($row = $stmt->fetch(PDO::FETCH_ASSOC)) { 
            $count++; 
            if ($count <= 5) {
                echo "  ID:" . $row['id'] . " username:" . $row['username'] . " role:" . ($row['role_name'] ?? 'null') . " estado:" . ($row['estado'] ?? 'null') . "\n";
            }
        }
        echo "Query exitosa: $count usuarios totales\n";
    } catch(Exception $e) {
        echo "QUERY FALLA: " . $e->getMessage() . "\n";
        
        echo "\n=== Intentando query minima ===\n";
        try {
            $stmt = $pdo->query("SELECT u.id, u.username, u.role_id FROM users u ORDER BY u.id");
            $count = 0;
            while($row = $stmt->fetch(PDO::FETCH_ASSOC)) { 
                $count++; 
                if ($count <= 5) {
                    echo "  ID:" . $row['id'] . " username:" . $row['username'] . "\n";
                }
            }
            echo "Query minima: $count usuarios\n";
        } catch(Exception $e2) {
            echo "QUERY MINIMA FALLA: " . $e2->getMessage() . "\n";
        }
    }

    echo "\n=== ROLES ===\n";
    try {
        $stmt = $pdo->query("SELECT * FROM roles");
        while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "  ID:" . $row['id'] . " name:" . $row['name'] . "\n";
        }
    } catch(Exception $e) {
        echo "No roles table: " . $e->getMessage() . "\n";
    }

    echo "\n=== MODULOS con permiso 'Usuarios' ===\n";
    try {
        $stmt = $pdo->query("SELECT m.id, m.name FROM modules m WHERE m.name = 'Usuarios'");
        while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "  Module: ID=" . $row['id'] . " name=" . $row['name'] . "\n";
        }
        
        $stmt = $pdo->query("SELECT rm.role_id, r.name as role_name, m.name as module_name FROM role_modules rm JOIN roles r ON rm.role_id = r.id JOIN modules m ON rm.module_id = m.id WHERE m.name = 'Usuarios'");
        while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "  Role '" . $row['role_name'] . "' tiene permiso 'Usuarios'\n";
        }
    } catch(Exception $e) {
        echo "Error checking modules: " . $e->getMessage() . "\n";
    }

} catch(Exception $e) {
    echo 'ERROR: ' . $e->getMessage() . "\n";
}
