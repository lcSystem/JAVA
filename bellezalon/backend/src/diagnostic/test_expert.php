<?php
/**
 * BACKEND MASTER DIAGNOSTIC (MODO EXPERTO)
 * Este script verifica la integridad total del sistema, base de datos y conectividad CORS/SSL.
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: text/html; charset=UTF-8');

function get_status_icon($bool) {
    return $bool ? '<span style="color:green">✔ OK</span>' : '<span style="color:red">✘ FALLO</span>';
}

echo "<html><head><title>Backend Master Diagnostic</title><style>body{font-family:sans-serif;line-height:1.5;background:#f4f4f9;padding:20px} .card{background:white;padding:20px;border-radius:10px;box-shadow:0 2px 5px rgba(0,0,0,0.1);margin-bottom:20px} h2{border-bottom:2px solid #3498db;padding-bottom:10px;color:#2c3e50} pre{background:#2c3e50;color:#ecf0f1;padding:15px;border-radius:5px;overflow-x:auto}</style></head><body>";
echo "<h1>Diagnosticador Maestro - Salón Belleza Pro</h1>";

// 1. ENTORNO SERVIDOR
echo "<div class='card'><h2>1. Entorno del Servidor</h2>";
echo "Versión PHP: " . PHP_VERSION . "<br>";
echo "Sistema Operativo: " . PHP_OS . "<br>";
echo "Software Servidor: " . ($_SERVER['SERVER_SOFTWARE'] ?? 'N/A') . "<br>";
echo "Límite de Memoria: " . ini_get('memory_limit') . "<br>";
echo "Extensiones Críticas (PDO, JSON, MBSTRING): " . 
     get_status_icon(extension_loaded('pdo') && extension_loaded('json') && extension_loaded('mbstring')) . "<br>";
echo "Driver MySQL: " . get_status_icon(extension_loaded('pdo_mysql')) . "<br>";
echo "</div>";

// 2. VERIFICACIÓN DE ARCHIVOS Y RUTAS
echo "<div class='card'><h2>2. Archivos y Autoload</h2>";
$files = [
    'index.php' => 'Punto de entrada API',
    '.htaccess' => 'Reglas de ruteo Apache',
    'config.php' => 'Configuración de DB',
    'vendor/autoload.php' => 'Librerías Composer (Carpeta Actual)',
    '../vendor/autoload.php' => 'Librerías Composer (Carpeta Padre)'
];

foreach ($files as $file => $desc) {
    $exists = file_exists(__DIR__ . '/' . $file);
    echo "<b>$file:</b> (" . $desc . ") " . get_status_icon($exists) . "<br>";
}
echo "</div>";

// 3. BASE DE DATOS PROFUNDA
echo "<div class='card'><h2>3. Base de Datos</h2>";
if (!file_exists(__DIR__ . '/config.php')) {
    echo "<span style='color:red'>ERROR: No se encontró config.php</span></div>";
} else {
    require_once __DIR__ . '/config.php';
    try {
        $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
        $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
        echo "[OK] Conexión establecida.<br>";
        
        $tables = ['users', 'roles', 'modules', 'role_modules', 'login_logs', 'app_settings'];
        foreach ($tables as $table) {
            $stmt = $pdo->query("SHOW TABLES LIKE '$table'");
            $count = $stmt->rowCount();
            echo "Tabla <b>$table</b>: " . get_status_icon($count > 0) . "<br>";
            if ($count > 0 && $table === 'users') {
                 // Check if role_id exists (critical for your stuck loading)
                 $cols = $pdo->query("DESCRIBE users")->fetchAll(PDO::FETCH_COLUMN);
                 echo " --- Columna 'role_id': " . get_status_icon(in_array('role_id', $cols)) . "<br>";
                 echo " --- Columna 'estado': " . get_status_icon(in_array('estado', $cols)) . "<br>";
            }
        }
    } catch (Exception $e) {
        echo "<pre style='background:red; color:white'>ERROR DB: " . $e->getMessage() . "</pre>";
    }
}
echo "</div>";

// 4. PRUEBA DE CONECTIVIDAD EXTERNA (CORS / SSL)
echo "<div class='card'><h2>4. Prueba de Conectividad (CORS)</h2>";
echo "Tu navegador debe ser capaz de ver 'Access-Control-Allow-Origin: *'<br>";
echo "Origen de la petición: " . ($_SERVER['HTTP_ORIGIN'] ?? 'Directo / Navegador') . "<br>";

// Simulamos una respuesta de cabeceras
echo "<b>Cabeceras que enviará tu API:</b><br>";
echo "<pre>";
echo "Access-Control-Allow-Origin: *\n";
echo "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS\n";
echo "Access-Control-Allow-Headers: X-Requested-With, Content-Type, Accept, Origin, Authorization";
echo "</pre>";
echo "</div>";

// 5. DIAGNÓSTICO DE RUTA (LO MÁS IMPORTANTE)
echo "<div class='card'><h2>5. Diagnóstico de Ruteo (.htaccess)</h2>";
$uri = $_SERVER['REQUEST_URI'];
echo "URI actual: <b>$uri</b><br>";
echo "Directorio actual: <b>" . __DIR__ . "</b><br>";

if (str_contains($uri, 'test_expert.php')) {
    echo "Si ves esta página, el ruteo interno está funcionando.<br>";
} else {
    echo "<span style='color:red'>AVISO: El servidor procesó esta petición, pero la ruta no es la esperada.</span><br>";
}
echo "</div>";

echo "<div class='card' style='background:#e8f4fd'><h2>⚠ ACCIÓN REQUERIDA (EL TRUCO FINAL)</h2>";
echo "Si la aplicación sigue diciendo 'Failed to fetch' en Chrome, haz lo siguiente:<br>";
echo "1. Abre la consola de Chrome en tu app local (Presiona F12).<br>";
echo "2. Ve a la pestaña 'Network'.<br>";
echo "3. Haz clic en la petición roja que dice 'settings'.<br>";
echo "4. Mira la pestaña 'Console' y dime si dice algo sobre 'SSL', 'CORS' o 'CERTIFICATE'.<br>";
echo "</div>";

echo "</body></html>";
