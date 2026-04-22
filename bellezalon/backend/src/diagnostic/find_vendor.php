<?php
echo "<h1>Buscador de Carpeta Vendor</h1>";
echo "Directorio actual: " . __DIR__ . "<br>";

$dirs = [
    __DIR__,
    dirname(__DIR__),
    dirname(dirname(__DIR__)),
    '/home/luigitec/public_html/api'
];

foreach ($dirs as $dir) {
    $path = $dir . '/vendor/autoload.php';
    echo "Probando: $path ... ";
    if (file_exists($path)) {
        echo "<b style='color:green'>ENCONTRADO!</b><br>";
    } else {
        echo "<b style='color:red'>No existe</b><br>";
    }
}

echo "<h2>Exploración de directorios (Nivel superior)</h2>";
$parentFiles = scandir(dirname(__DIR__));
echo "<pre>" . print_r($parentFiles, true) . "</pre>";
