import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de cache offline usando SharedPreferences.
/// Guarda las respuestas JSON de los endpoints GET para servir
/// los datos cuando no hay conexión a internet.
class OfflineCacheService {
  static final OfflineCacheService instance = OfflineCacheService._internal();
  factory OfflineCacheService() => instance;
  OfflineCacheService._internal();

  static const String _prefix = 'offline_cache_';
  SharedPreferences? _prefs;

  /// Inicializa el servicio. Llamar una sola vez en main().
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Guarda el body JSON de un endpoint en el cache local.
  Future<void> saveCache(String endpointKey, String jsonBody) async {
    try {
      await _prefs?.setString('$_prefix$endpointKey', jsonBody);
      debugPrint('[OfflineCache] 💾 Cached: $endpointKey');
    } catch (e) {
      debugPrint('[OfflineCache] Error saving cache for $endpointKey: $e');
    }
  }

  /// Recupera el body JSON cacheado de un endpoint.
  /// Retorna null si no hay cache disponible.
  String? getCache(String endpointKey) {
    try {
      return _prefs?.getString('$_prefix$endpointKey');
    } catch (e) {
      debugPrint('[OfflineCache] Error reading cache for $endpointKey: $e');
      return null;
    }
  }

  /// Limpia todo el cache offline (ej. al hacer logout).
  Future<void> clearAll() async {
    try {
      final keys = _prefs?.getKeys() ?? {};
      for (final key in keys) {
        if (key.startsWith(_prefix)) {
          await _prefs?.remove(key);
        }
      }
      debugPrint('[OfflineCache] 🗑️ Cache cleared');
    } catch (e) {
      debugPrint('[OfflineCache] Error clearing cache: $e');
    }
  }
}
