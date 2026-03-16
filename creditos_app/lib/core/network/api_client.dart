import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../config/app_config.dart';

/// Singleton HTTP client with JWT interceptor and automatic token refresh.
class ApiClient {
  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static ApiClient? _instance;
  factory ApiClient() => _instance ??= ApiClient._internal();

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ));

    // JWT interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConfig.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Clone the original request with the new token
            final token = await _storage.read(key: AppConfig.tokenKey);
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            try {
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } catch (e) {
              return handler.next(error);
            }
          }
        }
        handler.next(error);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: AppConfig.refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await Dio(BaseOptions(
        baseUrl: AppConfig.baseUrl,
      )).post(
        '/api/client/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        await _storage.write(
          key: AppConfig.tokenKey,
          value: response.data['token'],
        );
        await _storage.write(
          key: AppConfig.refreshTokenKey,
          value: response.data['refreshToken'],
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Clear stored tokens on logout.
  Future<void> clearTokens() async {
    await _storage.delete(key: AppConfig.tokenKey);
    await _storage.delete(key: AppConfig.refreshTokenKey);
    await _storage.delete(key: AppConfig.customerKey);
  }
}
