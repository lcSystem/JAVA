import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/models/login_response.dart';

/// Authentication state.
enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final CustomerProfile? customer;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.customer,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    CustomerProfile? customer,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      customer: customer ?? this.customer,
      error: error,
    );
  }
}

/// Auth provider — manages login, logout, and token persistence.
class AuthNotifier extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiClient _api = ApiClient();
  AuthState _state = const AuthState();

  AuthState get state => _state;

  AuthNotifier() {
    _checkAuth();
  }

  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Check if user is already authenticated (persisted token).
  Future<void> _checkAuth() async {
    final token = await _storage.read(key: AppConfig.tokenKey);
    final customerJson = await _storage.read(key: AppConfig.customerKey);

    if (token != null && customerJson != null) {
      try {
        final customer = CustomerProfile.fromJson(
            json.decode(customerJson) as Map<String, dynamic>);
        _updateState(_state.copyWith(
          status: AuthStatus.authenticated,
          customer: customer,
        ));
        return;
      } catch (_) {}
    }
    _updateState(_state.copyWith(status: AuthStatus.unauthenticated));
  }

  /// Login with cédula and password.
  Future<void> login({
    required String cedula,
    required String password,
  }) async {
    _updateState(_state.copyWith(status: AuthStatus.loading));

    try {
      final response = await _api.dio.post(ApiEndpoints.login, data: {
        'cedula': cedula,
        'password': password,
      });

      final result = LoginResult.fromJson(response.data);

      // Persist tokens and customer data
      await _storage.write(key: AppConfig.tokenKey, value: result.token);
      await _storage.write(
        key: AppConfig.refreshTokenKey,
        value: result.refreshToken,
      );
      await _storage.write(
        key: AppConfig.customerKey,
        value: json.encode(result.customer.toJson()),
      );

      _updateState(_state.copyWith(
        status: AuthStatus.authenticated,
        customer: result.customer,
      ));
    } catch (e) {
      String errorMsg = 'Error de conexión. Intente de nuevo.';
      if (e is DioException && e.response != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMsg = data['message'];
        }
      }
      _updateState(_state.copyWith(
        status: AuthStatus.unauthenticated,
        error: errorMsg,
      ));
      throw Exception(errorMsg);
    }
  }

  /// Update the current customer profile in state and storage
  Future<void> updateCustomer(CustomerProfile updatedCustomer) async {
    // Save to local storage
    await _storage.write(
      key: AppConfig.customerKey,
      value: json.encode(updatedCustomer.toJson()),
    );
    // Update state
    _updateState(_state.copyWith(customer: updatedCustomer));
  }

  /// Logout — revoke tokens and clear local storage.
  Future<void> logout() async {
    try {
      await _api.dio.post(ApiEndpoints.logout);
    } catch (_) {}
    await _api.clearTokens();
    _updateState(const AuthState(status: AuthStatus.unauthenticated));
  }

  /// Get current customer ID.
  int? get customerId => _state.customer?.id;
}

// Providers
final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});

final authStateProvider = Provider<AuthState>((ref) {
  final auth = ref.watch(authProvider);
  return auth.state;
});
