<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: text/plain');

echo "Test Instantiating Role and Module entities...\n";

try {
    require __DIR__ . '/vendor/autoload.php';

    // Manejar casos donde el autoloader de Composer podría no funcionar bien en hosting
    if (!class_exists('App\Domain\Entities\Role')) {
        require_once __DIR__ . '/src/Domain/Entities/Role.php';
    }
    if (!class_exists('App\Domain\Entities\Module')) {
        require_once __DIR__ . '/src/Domain/Entities/Module.php';
    }

    echo "Archivos incluidos correctamente.\n";

    $module = new App\Domain\Entities\Module(1, "Test Module");
    echo "Módulo instanciado con éxito: " . $module->getName() . "\n";

    $role = new App\Domain\Entities\Role(1, "Test Role", "Test Desc", [$module]);
    echo "Rol instanciado con éxito: " . $role->getName() . "\n";

    echo "\nTest Finalizado Correctamente. Si ves esto, PHP soporta las entidades.";
} catch (\Throwable $e) {
    echo "\nExcepción atrapada:\n";
    echo $e->getMessage() . "\n";
    echo $e->getFile() . " on line " . $e->getLine() . "\n";
}
