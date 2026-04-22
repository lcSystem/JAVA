require_once __DIR__ . '/src/config.php';
try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Drop the stale constraint
    $pdo->exec("ALTER TABLE ventas DROP FOREIGN KEY ventas_ibfk_2");
    
    // Add the new constraint pointing to users table
    $pdo->exec("ALTER TABLE ventas ADD CONSTRAINT ventas_ibfk_2 FOREIGN KEY (cliente_id) REFERENCES users(id)");
    
    echo "Success: FK constraint updated on ventas.\n";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
