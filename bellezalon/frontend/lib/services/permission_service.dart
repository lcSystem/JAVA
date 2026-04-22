import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionService {
  /// Requests all necessary permissions for the app:
  /// - Location: For branch distances and maps.
  /// - Storage: For caching the salon logo and gallery images.
  static Future<void> requestAllPermissions() async {
    if (kIsWeb) return; // Permissions work differently on web

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      // For Android 13+ support, we might need photos/videos permissions instead of general storage
      Permission.photos,
    ].request();

    debugPrint("Permission statuses: $statuses");
  }

  static Future<bool> hasLocationPermission() async {
    if (kIsWeb) return true; // Web handles this via browser prompt
    return await Permission.location.isGranted;
  }

  static Future<bool> hasStoragePermission() async {
    if (kIsWeb) return true;
    return await Permission.storage.isGranted || await Permission.photos.isGranted;
  }
}
