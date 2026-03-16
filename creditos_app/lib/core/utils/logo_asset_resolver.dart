import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Resolves the logo asset path dynamically from assets/images/.
/// Searches the asset manifest for any file named "logo" regardless of extension.
class LogoAssetResolver {
  // Lista estricta de extensiones permitidas por seguridad
  static const List<String> _supportedExtensions = [
    '.png', '.svg', '.jpeg', '.jpg'
  ];

  static String? _cachedPath;

  /// Returns the asset path of the first logo file found in assets/images/.
  /// Checks for files named "logo" with any supported image extension.
  /// Returns null if no logo asset is found.
  static Future<String?> resolve() async {
    if (_cachedPath != null) return _cachedPath;

    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = manifest.listAssets();

      // Search for any asset key matching assets/images/logo.<ext>
      for (final ext in _supportedExtensions) {
        final key = 'assets/images/logo$ext';
        if (assets.contains(key)) {
          _cachedPath = key;
          debugPrint('DEBUG: Logo asset resolved -> $key');
          return key;
        }
      }

      // We only look for exact matches: logo.png, logo.svg, etc.
      // We removed the fallback for logo-1, logo_1 so it strictly picks up "logo"

      debugPrint('DEBUG: No logo asset found in assets/images/');
      return null;
    } catch (e) {
      debugPrint('DEBUG: Error resolving logo asset: $e');
      return null;
    }
  }

  /// Clears the cached path (useful for hot restart).
  static void clearCache() {
    _cachedPath = null;
  }

  /// Returns true if the resolved path is an SVG file.
  static bool isSvg(String path) {
    return path.toLowerCase().endsWith('.svg');
  }
}
