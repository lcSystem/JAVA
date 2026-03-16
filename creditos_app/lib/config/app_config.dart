import 'package:flutter/foundation.dart' show kIsWeb;

/// API configuration constants
class AppConfig {
  /// Auto-detect the correct base URL:
  /// - Web (Chrome): use localhost
  /// - Android emulator: use 10.0.2.2 (maps to host localhost)
  /// - Real device: use the actual IP
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    // Para pruebas en dispositivo físico, usar la IP de tu computadora:
    return 'http://192.168.1.100:8080';
  }

  static const String baseUrlDevice = 'http://192.168.1.100:8080'; // Real device

  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String tokenKey = 'jwt_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String customerKey = 'customer_data';
}
