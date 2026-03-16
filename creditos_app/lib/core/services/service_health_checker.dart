import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../config/app_config.dart';

/// Represents the health status of a single microservice.
class ServiceHealthStatus {
  final String name;
  final bool isHealthy;
  final String? error;

  const ServiceHealthStatus({
    required this.name,
    required this.isHealthy,
    this.error,
  });
}

/// Checks whether all required backend microservices are running.
/// All checks go through the API Gateway (CORS-safe for Flutter Web).
class ServiceHealthChecker {
  /// Each service is checked via a lightweight endpoint routed through the gateway.
  /// A 401/403/404 = service IS running (just needs auth). Only 502/503 = truly down.
  static final List<_ServiceCheck> _requiredServices = [
    _ServiceCheck('API Gateway', '/actuator/health'),
    _ServiceCheck('Créditos Web', '/api/credit-types'),
    _ServiceCheck('ERP Portfolio', '/api/folders'),
    _ServiceCheck('Customer Service', '/api/customers'),
    _ServiceCheck('Client Auth', '/api/config-creditos'),
  ];

  /// Pings all services through the gateway. Returns list of statuses.
  static Future<List<ServiceHealthStatus>> checkAll() async {
    final baseUrl = AppConfig.baseUrl; // localhost:8080 (gateway)
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 4),
      receiveTimeout: const Duration(seconds: 4),
    ));

    final results = await Future.wait(
      _requiredServices.map((svc) async {
        try {
          final response = await dio.get(
            svc.healthPath,
            options: Options(
              // Accept any status code; evaluate below to avoid exceptions
              validateStatus: (status) => true,
            ),
          );
          // 500+ usually means gateway failed to route or service is failing
          // 401/403/404 = service IS running but needs auth or endpoint missing
          // A status code of 0 indicates a CORS or connection error in Web, which means DOWN.
          final isUp = response.statusCode != null && 
                       response.statusCode! >= 100 && 
                       response.statusCode! < 500;
          return ServiceHealthStatus(
            name: svc.name,
            isHealthy: isUp,
            error: isUp ? null : (response.statusCode! == 0 ? 'No responde' : 'HTTP ${response.statusCode}'),
          );
        } on DioException catch (e) {
          // Connection refused / timeout / DNS = service not running
          final status = e.response?.statusCode ?? 0;
          return ServiceHealthStatus(
            name: svc.name,
            isHealthy: false,
            error: status > 0 ? 'HTTP $status' : 'No responde',
          );
        } catch (e) {
          return ServiceHealthStatus(
            name: svc.name,
            isHealthy: false,
            error: 'No responde',
          );
        }
      }),
    );

    for (final s in results) {
      debugPrint('Health: ${s.name} → ${s.isHealthy ? "✅" : "❌ ${s.error}"}');
    }

    return results;
  }

  /// Returns true only if every required service responds.
  static Future<bool> allHealthy() async {
    final statuses = await checkAll();
    return statuses.every((s) => s.isHealthy);
  }

  /// Returns human-readable list of services that are down.
  static Future<List<String>> getDownServices() async {
    final statuses = await checkAll();
    return statuses
        .where((s) => !s.isHealthy)
        .map((s) => s.name)
        .toList();
  }
}

class _ServiceCheck {
  final String name;
  final String healthPath;
  const _ServiceCheck(this.name, this.healthPath);
}
