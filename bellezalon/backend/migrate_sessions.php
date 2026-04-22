require __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/src/config.php';

$dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
$pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD,
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

try {
    $pdo->exec("ALTER TABLE login_logs ADD COLUMN is_active TINYINT DEFAULT 1");
    echo "Column is_active added to login_logs successfully.\n";
} catch (Exception $e) {
    echo "Error or column already exists: " . $e->getMessage() . "\n";
}
