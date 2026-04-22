class PaymentResult {
  final bool success;
  final String status; // 'paid', 'pending', 'failed', 'cancelled'
  final String? transactionId;
  final String? message;

  PaymentResult({
    required this.success,
    required this.status,
    this.transactionId,
    this.message,
  });
}
