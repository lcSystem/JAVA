import 'package:flutter/material.dart';
import '../payment_gateway.dart';
import '../payment_result.dart';
import '../../../utils/formatters.dart';

class MercadoPagoGateway implements PaymentGateway {
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
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF009EE3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.handshake, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Mercado Pago', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF009EE3))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatCurrency(amount), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              const Text('Total a pagar', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 24),
              if (isProcessing) ...[
                const CircularProgressIndicator(color: Color(0xFF009EE3)),
                const SizedBox(height: 16),
                const Text('Validando con Mercado Pago...', style: TextStyle(color: Colors.grey)),
              ] else ...[
                const Text('Paga de forma segura con tu cuenta de Mercado Pago o tarjeta.', 
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
                    child: const Text('Volver', style: TextStyle(color: Colors.grey))
                  ),
                  FilledButton(
                    onPressed: () async {
                      setStfState(() => isProcessing = true);
                      await Future.delayed(const Duration(seconds: 2));
                      resultSuccess = true;
                      resultStatus = 'paid';
                      txId = 'MP-${DateTime.now().millisecondsSinceEpoch}';
                      if (context.mounted) Navigator.pop(ctx);
                    },
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF009EE3)),
                    child: const Text('Pagar ahora'),
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
    return PaymentResult(success: true, status: 'refunded', transactionId: 'MP-REF-$transactionId');
  }
}
