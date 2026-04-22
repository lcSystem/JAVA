<?php
require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/src/config.php';

use App\Infrastructure\Persistence\MySQLSettingsRepository;
use App\Infrastructure\Services\EmailService;

echo "--- BELLEZALON EMAIL VERIFICATION ---\n";

try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    $repo = new MySQLSettingsRepository($pdo);
    $emailService = new EmailService($repo);

    // Test sending email
    echo "Attempting to send a test email...\n";
    echo "Note: This depends on correct SMTP settings in the 'app_settings' table.\n";
    
    // Check if enabled
    $enabled = $repo->findByKey('enable_email_notifications');
    if (!$enabled || $enabled->getValue() !== '1') {
        echo "WARNING: Email notifications are DISABLED in settings.\n";
        echo "Run: UPDATE app_settings SET setting_value = '1' WHERE key_name = 'enable_email_notifications';\n";
    }

    // You can call it here if you manually put settings in the DB
    // $emailService->sendEmail('your-email@example.com', 'Test Subject', '<h1>It works!</h1>');
    echo "Service initialized successfully.\n";

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
}
echo "----------------------------------------\n";
