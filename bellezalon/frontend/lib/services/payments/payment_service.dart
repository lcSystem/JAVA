import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment_result.dart';
import 'payment_factory.dart';
import '../settings_provider.dart';

class PaymentService {
  Future<PaymentResult> processAdvancePayment(BuildContext context, double amount, Map<String, dynamic> data) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final gateway = PaymentFactory.getGateway(settings.paymentGateway);
    return await gateway.processPayment(context, amount, data);
  }

  Future<PaymentResult> processTransaction(BuildContext context, double amount, Map<String, dynamic> data) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final gateway = PaymentFactory.getGateway(settings.paymentGateway);
    return await gateway.processPayment(context, amount, data);
  }

  Future<PaymentResult> refund(BuildContext context, String transactionId, double amount) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final gateway = PaymentFactory.getGateway(settings.paymentGateway);
    return await gateway.refund(context, transactionId, amount);
  }
}
