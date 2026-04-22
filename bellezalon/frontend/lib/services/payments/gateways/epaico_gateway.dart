import 'package:flutter/material.dart';
import '../payment_gateway.dart';
import '../payment_result.dart';
import '../../../utils/formatters.dart';

class EpaicoGateway implements PaymentGateway {
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
          title: const Text('Pasarela ePaico (Simulación)', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Monto a cobrar: ${formatCurrency(amount)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              if (isProcessing) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Procesando pago... por favor espera', style: TextStyle(color: Colors.grey)),
              ] else ...[
                const Text('Haga clic en Pagar para simular una transacción exitosa.'),
              ]
            ],
          ),
          actions: isProcessing 
              ? [] 
              : [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    }, 
                    child: const Text('Cancelar', style: TextStyle(color: Colors.grey))
                  ),
                  FilledButton.icon(
                    icon: const Icon(Icons.payment),
                    label: const Text('Pagar'),
                    style: FilledButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () async {
                      setStfState(() => isProcessing = true);
                      // Simulate network delay
                      await Future.delayed(const Duration(seconds: 2));
                      
                      resultSuccess = true;
                      resultStatus = 'paid';
                      txId = 'TX-EPAICO-${DateTime.now().millisecondsSinceEpoch}';
                      
                      if (context.mounted) Navigator.pop(ctx);
                    },
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
    // Simulación de reembolso
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult(success: true, status: 'refunded', transactionId: 'REF-$transactionId');
  }
}
