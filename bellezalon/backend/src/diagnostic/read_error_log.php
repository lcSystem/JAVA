<?php
echo "<h1>Lector de Error Log</h1>";

$logFile = dirname(__DIR__) . '/error_log';

if (file_exists($logFile)) {
    echo "<b>Archivo: $logFile</b><br>";
    echo "Ultimas 50 líneas:<br>";
    $lines = file($logFile);
    $lastLines = array_slice($lines, -50);
    echo "<pre style='background:#000; color:#0f0; padding:10px;'>" . htmlspecialchars(implode("", $lastLines)) . "</pre>";
} else {
    echo "<b style='color:red'>No se encontró el archivo error_log en " . dirname(__DIR__) . "</b>";
}
