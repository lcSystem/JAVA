import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/services/logo_persistence_service.dart';
import '../domain/models/app_design_config.dart';

export '../domain/models/app_design_config.dart';

/// Provider that loads the design configuration from the API.
/// This is one of the first things loaded when the app starts.
final designConfigProvider = FutureProvider<AppDesignConfig>((ref) async {
  try {
    final api = ApiClient();
    debugPrint('DEBUG: Cargando configuración de diseño desde ${ApiEndpoints.configCreditos}');
    final response = await api.dio.get(ApiEndpoints.configCreditos);

    if (response.statusCode == 200 && response.data != null) {
      debugPrint('DEBUG: Configuración recibida: ${response.data}');
      final configMap = Map<String, String>.from(
        (response.data['config'] as Map).map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ),
      );
      final config = AppDesignConfig.fromMap(configMap);
      debugPrint('DEBUG: logoUrl derivado: ${config.logoUrl}');
      
      // Persist logo locally for offline use (if applicable)
      if (config.logoUrl != null) {
        await LogoPersistenceService.updateLogo(config.logoUrl!);
      }
      
      // Get persistent path and BRING THE BYTES for cross-platform safety
      final persistentPath = await LogoPersistenceService.getLocalPersistentLogoPath();
      final logoBytes = await LogoPersistenceService.getLogoBytes();
      
      return config.copyWith(
        persistentLogoPath: persistentPath,
        logoBytes: logoBytes,
      );
    } else {
      debugPrint('DEBUG: Error en respuesta de configuración: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('DEBUG: Excepción cargando configuración: $e');
  }
  
  debugPrint('DEBUG: Usando configuración por defecto o de caché');
  final persistentPath = await LogoPersistenceService.getLocalPersistentLogoPath();
  final logoBytes = await LogoPersistenceService.getLogoBytes();
  
  return AppDesignConfig().copyWith(
    persistentLogoPath: persistentPath,
    logoBytes: logoBytes,
  );
});
