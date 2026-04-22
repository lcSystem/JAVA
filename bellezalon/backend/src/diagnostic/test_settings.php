require __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/src/config.php';

use App\Infrastructure\Persistence\MySQLSettingsRepository;

$dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
$pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD);
$repo = new MySQLSettingsRepository($pdo);

echo "Updating salon_name...\n";
$repo->update('salon_name', 'TEST SALON NAME');
$repo->update('primary_color', '#00FF00');

echo "Done. Checking DB...\n";
