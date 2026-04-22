import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

/// Servicio singleton que monitorea el estado de la red en tiempo real.
/// Emite eventos cuando cambia la conectividad y realiza un ping HTTP
/// real a la API para confirmar que el servidor es alcanzable.
class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._internal();
  factory ConnectivityService() => instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  // Stream controller para notificar a la UI de cambios
  final _controller = StreamController<ConnectivityStatus>.broadcast();
  Stream<ConnectivityStatus> get onStatusChange => _controller.stream;

  /// Inicializa el monitoreo. Llamar una sola vez en main().
  Future<void> init() async {
    // Check initial state
    await _checkConnectivity();

    // Listen to changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _onConnectivityChanged(results);
    });
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    final hadConnection = _isOnline;
    
    if (results.contains(ConnectivityResult.none)) {
      _isOnline = false;
      _controller.add(ConnectivityStatus.offline);
      debugPrint('[Connectivity] ❌ Sin conexión a internet');
    } else {
      // Hay interfaz de red, pero verificar con ping real
      final reachable = await _pingApi();
      _isOnline = reachable;
      
      if (reachable) {
        _controller.add(
          hadConnection ? ConnectivityStatus.online : ConnectivityStatus.restored,
        );
        debugPrint('[Connectivity] ✅ Conexión activa');
      } else {
        _controller.add(ConnectivityStatus.offline);
        debugPrint('[Connectivity] ⚠️ Red detectada pero API no alcanzable');
      }
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.contains(ConnectivityResult.none)) {
        _isOnline = false;
      } else {
        _isOnline = await _pingApi();
      }
    } catch (e) {
      _isOnline = false;
      debugPrint('[Connectivity] Error checking initial state: $e');
    }
  }

  /// Ping real a la API para verificar que el servidor responde.
  Future<bool> _pingApi() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiService.baseUrl}/settings'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Fuerza un re-chequeo de la conectividad (útil para retry manual).
  Future<bool> recheckConnectivity() async {
    await _checkConnectivity();
    if (_isOnline) {
      _controller.add(ConnectivityStatus.restored);
    } else {
      _controller.add(ConnectivityStatus.offline);
    }
    return _isOnline;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

enum ConnectivityStatus {
  online,    // Ya estaba online, sigue online
  offline,   // Sin conexión
  restored,  // Se recuperó la conexión (antes offline, ahora online)
}
