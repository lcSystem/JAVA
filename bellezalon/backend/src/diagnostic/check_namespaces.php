<?php
// Lector de Autoload PSR-4
header('Content-Type: text/html; charset=UTF-8');
require_once dirname(__DIR__) . '/vendor/autoload.php';

echo "<h1>Comprobador de Autocarga (PSR-4)</h1>";

if (class_exists('App\Infrastructure\CheckPermissionMiddleware')) {
    echo "<b style='color:green'>[OK] La clase CheckPermissionMiddleware SE ENCUENTRA!</b><br>";
} else {
    echo "<b style='color:red'>[ERROR] La clase CheckPermissionMiddleware NO SE ENCUENTRA.</b><br>";
    
    echo "<h2>Rutas detectadas por Composer:</h2>";
    $loader = require dirname(__DIR__) . '/vendor/composer/autoload_psr4.php';
    echo "<pre>" . print_r($loader, true) . "</pre>";
    
    echo "<h2>Escaneando carpeta src:</h2>";
    $srcPath = dirname(__DIR__) . '/src';
    if (is_dir($srcPath)) {
        echo "Contenido de src:<pre>" . print_r(scandir($srcPath), true) . "</pre>";
        $infraPath = $srcPath . '/Infrastructure';
        if (is_dir($infraPath)) {
            echo "Contenido de src/Infrastructure:<pre>" . print_r(scandir($infraPath), true) . "</pre>";
        } else {
            echo "No se encontró src/Infrastructure<br>";
        }
    } else {
        echo "No se encontró la carpeta src en $srcPath<br>";
    }
}
