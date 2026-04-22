import 'package:flutter/material.dart';
import 'payment_result.dart';

abstract class PaymentGateway {
  Future<PaymentResult> processPayment(BuildContext context, double amount, Map<String, dynamic> data);
  
  Future<PaymentResult> refund(BuildContext context, String transactionId, double amount);
}
