import 'package:flutter/material.dart';
import '../payment_gateway.dart';
import '../payment_result.dart';
import '../../../utils/formatters.dart';

class StripeGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment(BuildContext context, double amount, Map<String, dynamic> data) async {
    bool resultSuccess = false;
    String resultStatus = 'cancelled';
    String? txId;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(builder: (stfCtx, setStfState) {
        bool isProcessing = false;

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Icon(Icons.credit_card, color: Color(0xFF6772E5)),
              const SizedBox(width: 12),
              const Text('Stripe Checkout', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6772E5))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatCurrency(amount), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('Monto de la reserva', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 24),
              if (isProcessing) ...[
                const LinearProgressIndicator(color: Color(0xFF6772E5)),
                const SizedBox(height: 16),
                const Text('Estableciendo conexión segura...', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ] else ...[
                const Text('Introduzca los detalles de su tarjeta para finalizar.', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ]
            ],
          ),
          actions: isProcessing 
              ? [] 
              : [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx), 
                    child: const Text('Cancelar', style: TextStyle(color: Colors.grey))
                  ),
                  FilledButton(
                    onPressed: () async {
                      setStfState(() => isProcessing = true);
                      await Future.delayed(const Duration(seconds: 2));
                      resultSuccess = true;
                      resultStatus = 'paid';
                      txId = 'ST-${DateTime.now().millisecondsSinceEpoch}';
                      if (context.mounted) Navigator.pop(ctx);
                    },
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6772E5)),
                    child: const Text('Pagar con tarjeta'),
                  ),
                ],
        );
      }),
    );

    return PaymentResult(
      success: resultSuccess,
      status: resultStatus,
      transactionId: txId,
    );
  }

  @override
  Future<PaymentResult> refund(BuildContext context, String transactionId, double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult(success: true, status: 'refunded', transactionId: 'ST-REF-$transactionId');
  }
}
