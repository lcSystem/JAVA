<?php
namespace App\Infrastructure\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;

class PaymentController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    /**
     * Inicia un proceso de pago simulado.
     */
    public function initiate(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        $userId = $request->getAttribute('user_id');

        if (empty($data['amount']) || empty($data['servicio_id'])) {
            $response->getBody()->write(json_encode(['error' => 'Monto y servicio_id son requeridos']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        // En un entorno real, aquí llamaríamos a la API de la pasarela (Stripe, Wompi, etc.)
        // y retornaríamos una URL de pago o un token.
        
        $paymentRef = 'PAY-' . strtoupper(bin2hex(random_bytes(4)));
        
        $response->getBody()->write(json_encode([
            'success' => true,
            'payment_ref' => $paymentRef,
            'message' => 'Pago iniciado. Redirigiendo a pasarela (simulado)...',
            'checkout_url' => 'https://mock-gateway.com/pay/' . $paymentRef
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
    }

    /**
     * Confirma un pago simulado (Webhook / Retorno).
     */
    public function confirm(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        $paymentRef = $data['payment_ref'] ?? null;

        if (!$paymentRef) {
            $response->getBody()->write(json_encode(['error' => 'Referencia de pago requerida']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        // Simulamos validación del pago.
        // En producción, aquí verificaríamos con la pasarela.
        
        $response->getBody()->write(json_encode([
            'success' => true,
            'payment_ref' => $paymentRef,
            'status' => 'APPROVED',
            'message' => 'Pago confirmado exitosamente'
        ]));
        
        return $response->withHeader('Content-Type', 'application/json');
    }
}
