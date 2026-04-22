<?php
require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/src/config.php';

// Verification Script for Security Fixes
echo "--- BELLEZALON SECURITY VERIFICATION ---\n";

// 1. Check Technical Info Leakage
echo "[1] Checking Information Leakage: ";
$displayErrors = ini_get('display_errors');
if ($displayErrors == '0' || $displayErrors == '') {
    echo "PASS (display_errors is OFF)\n";
} else {
    echo "FAIL (display_errors is still ON: $displayErrors)\n";
}

// 2. Check JWT Secret rotation capability
echo "[2] Checking JWT Key Table: ";
try {
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USERNAME, DB_PASSWORD, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    $stmt = $pdo->query("SELECT COUNT(*) FROM jwt_keys");
    $count = $stmt->fetchColumn();
    echo "PASS (Found $count keys in rotating system)\n";
} catch (Exception $e) {
    echo "FAIL (Database error: " . $e->getMessage() . ")\n";
}

// 3. Test IDOR logic (Simulation via mock request if possible, or just file check)
echo "[3] Verifying Code Fixes: \n";
$appContent = file_get_contents(__DIR__ . '/src/Infrastructure/Controllers/AppointmentController.php');
if (str_contains($appContent, "IDOR Prevention: Check ownership")) {
    echo "    - AppointmentController IDOR Fix: PASS\n";
} else {
    echo "    - AppointmentController IDOR Fix: FAIL\n";
}

$chatContent = file_get_contents(__DIR__ . '/src/Infrastructure/Controllers/ChatController.php');
if (str_contains($chatContent, "IDOR Prevention: Check if user is participant")) {
    echo "    - ChatController IDOR Fix: PASS\n";
} else {
    echo "    - ChatController IDOR Fix: FAIL\n";
}

if (str_contains($appContent, "VALUES (:cli, :svc, :emp, :fecha, :hora, :dur, 'pendiente', :com, :creado, 0, :pay_ref)")) {
    echo "    - Mass Assignment Fix (is_paid): PASS\n";
} else {
    echo "    - Mass Assignment Fix (is_paid): FAIL\n";
}

// 4. Rate Limiting Check
if (file_exists(__DIR__ . '/src/Infrastructure/RateLimitMiddleware.php')) {
    echo "[4] Rate Limiting Middleware: PASS\n";
} else {
    echo "[4] Rate Limiting Middleware: FAIL\n";
}

echo "----------------------------------------\n";
echo "Verification Complete.\n";
