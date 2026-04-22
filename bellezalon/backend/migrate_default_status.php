require __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/src/config.php';

$dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
$pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD,
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

try {
    $pdo->exec("ALTER TABLE users MODIFY estado enum('activo','inactivo') DEFAULT 'inactivo'");
    echo "Default user status changed to 'inactivo' successfully.\n";
} catch (Exception $e) {
    echo "Error modifying users table: " . $e->getMessage() . "\n";
}
