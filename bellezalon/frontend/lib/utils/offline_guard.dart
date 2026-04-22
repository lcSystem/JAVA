import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// Ejecuta una operación de escritura (create/update/delete) con manejo
/// automático de OfflineException. Muestra un SnackBar si no hay internet.
///
/// Uso:
/// ```dart
/// await offlineGuard(context, () => api.createServicio(data));
/// ```
Future<T?> offlineGuard<T>(BuildContext context, Future<T> Function() action) async {
  try {
    return await action();
  } on OfflineException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.wifi_off, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(e.message)),
        ]),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ));
    }
    return null;
  }
}
