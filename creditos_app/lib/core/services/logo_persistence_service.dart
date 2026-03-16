import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

/// Manages logo persistence to local storage for offline use.
class LogoPersistenceService {
  static const String _logoUrlKey = 'persisted_logo_url';
  static const String _logoPathKey = 'persisted_logo_path';
  static const String _baseFileName = 'current_logo';

  /// Returns the bytes of the persisted logo if it exists.
  static Future<Uint8List?> getLogoBytes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (kIsWeb) {
        final base64String = prefs.getString(_logoPathKey);
        if (base64String != null) {
          return base64Decode(base64String);
        }
        return null;
      }

      final path = prefs.getString(_logoPathKey);
      if (path != null) {
        final file = io.File(path);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      }
    } catch (_) {}
    return null;
  }

  /// Returns the local file path if it exists, otherwise null.
  static Future<String?> getLocalPersistentLogoPath() async {
    if (kIsWeb) return null;
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString(_logoPathKey);
      if (path != null && io.File(path).existsSync()) {
        return path;
      }
    } catch (_) {}
    return null;
  }
  /// Downloads and updates the persistent logo if the URL changed.
  static Future<void> updateLogo(String url) async {
    if (url.isEmpty || !url.startsWith('http')) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUrl = prefs.getString(_logoUrlKey);

      // Web handling: we use SharedPreferences to store the bytes as Base64
      if (kIsWeb) {
        if (lastUrl == url && prefs.getString(_logoPathKey) != null) {
          debugPrint('DEBUG [Web]: Logo ya sincronizado en memoria (Base64)');
          return;
        }

        debugPrint('DEBUG [Web]: Intentando sincronizar nuevo logo desde $url');
        final dio = Dio();
        final response = await dio.get<Uint8List>(
          url,
          options: Options(responseType: ResponseType.bytes, followRedirects: true),
        );

        if (response.data != null && response.data!.isNotEmpty) {
          final base64String = base64Encode(response.data!);
          await prefs.setString(_logoUrlKey, url);
          await prefs.setString(_logoPathKey, base64String); // We reuse the path key for the base64 data on web
          debugPrint('DEBUG [Web]: ¡Logo DESCARGADO y REEMPLAZADO en localStorage!');
        }
        return;
      }

      // Mobile/Desktop handling (io.File)
      // If URL is the same, we check if the file still exists to avoid redundant downloads
      if (lastUrl == url) {
        final currentPath = prefs.getString(_logoPathKey);
        if (currentPath != null && io.File(currentPath).existsSync()) {
          debugPrint('DEBUG: Logo ya sincronizado y verificado: $currentPath');
          return;
        }
      }

      debugPrint('DEBUG: Iniciando descarga y reemplazo de logo desde $url');
      final dio = Dio();
      final directory = await getApplicationDocumentsDirectory();
      
      // Determine extension from URL
      final uri = Uri.parse(url);
      final extension = uri.pathSegments.isNotEmpty && uri.pathSegments.last.contains('.') 
          ? uri.pathSegments.last.split('.').last.toLowerCase()
          : 'png';
      
      final savePath = '${directory.path}/$_baseFileName.$extension';
      
      // Download to a temporary file first to avoid corruption
      final tempPath = '$savePath.tmp';
      await dio.download(url, tempPath);

      // If download successful, clear all previous logos to ensure "replacement"
      for (var ext in ['png', 'jpg', 'svg', 'jpeg']) {
        final oldFile = io.File('${directory.path}/$_baseFileName.$ext');
        if (oldFile.existsSync()) {
          debugPrint('DEBUG: Eliminando logo anterior: ${oldFile.path}');
          await oldFile.delete();
        }
      }

      // Move temp to final path
      await io.File(tempPath).rename(savePath);

      await prefs.setString(_logoUrlKey, url);
      await prefs.setString(_logoPathKey, savePath);
      
      debugPrint('DEBUG: ¡Logo DESCARGADO y REEMPLAZADO exitosamente en $savePath!');
    } catch (e) {
      if (kIsWeb && e.toString().contains('XMLHttpRequest')) {
        debugPrint('DEBUG [Web]: ERROR DE RED/CORS - El navegador bloqueó la descarga del logo.');
        debugPrint('DEBUG [Web]: Esto es normal si el servidor de origen no permite CORS.');
      } else {
        debugPrint('DEBUG: Error en proceso de sincronización del logo: $e');
      }
    }
  }
}
