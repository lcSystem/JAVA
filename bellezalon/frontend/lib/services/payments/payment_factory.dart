import 'payment_gateway.dart';
import 'gateways/epaico_gateway.dart';
import 'gateways/mercadopago_gateway.dart';
import 'gateways/stripe_gateway.dart';

class PaymentFactory {
  static PaymentGateway getGateway(String gatewayId) {
    switch (gatewayId.toLowerCase()) {
      case 'epaico':
        return EpaicoGateway();
      case 'mercadopago':
        return MercadoPagoGateway();
      case 'stripe':
        return StripeGateway();
      default:
        // Default to epaico if not recognized
        return EpaicoGateway();
    }
  }
}
