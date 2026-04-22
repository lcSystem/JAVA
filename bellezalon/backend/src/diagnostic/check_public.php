<?php
echo "<h1>Explorador de Carpeta Public</h1>";
$publicPath = dirname(__DIR__) . '/public';

if (is_dir($publicPath)) {
    echo "Contenido de $publicPath:<pre>" . print_r(scandir($publicPath), true) . "</pre>";
    if (file_exists($publicPath . '/index.php')) {
        echo "<b style='color:green'>[OK] SE ENCONTRÓ index.php en public/</b><br>";
        echo "Ultima modificación: " . date("Y-m-d H:i:s", filemtime($publicPath . '/index.php')) . "<br>";
    }
} else {
    echo "No existe la carpeta public en " . dirname(__DIR__);
}
