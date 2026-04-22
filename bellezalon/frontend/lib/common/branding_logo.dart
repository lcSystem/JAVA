import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/settings_provider.dart';
import '../services/api_service.dart';

class BrandingLogo extends StatelessWidget {
  final double size;
  final double iconSize;
  final Color? color;
  final bool isCircular;

  const BrandingLogo({
    super.key, 
    this.size = 60, 
    this.iconSize = 48,
    this.color,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final localPath = settings.localLogoPath;
    final remotePath = settings.salonLogo;

    Widget child;

    // Resolve local path if not on web
    bool hasLocalFile = false;
    if (!kIsWeb && localPath != null && localPath.isNotEmpty) {
      try {
        hasLocalFile = File(localPath).existsSync();
      } catch (_) {
        hasLocalFile = false;
      }
    }

    if (hasLocalFile) {
      child = Image.file(
        File(localPath!),
        height: size,
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    } else if (remotePath.isNotEmpty && remotePath != 'null' && remotePath != 'undefined') {
      // Validate remotePath looks like a valid path
      final fullUrl = remotePath.startsWith('http') 
          ? remotePath 
          : '${ApiService.assetsBaseUrl}$remotePath';
          
      child = CachedNetworkImage(
        imageUrl: fullUrl,
        height: size,
        width: size,
        fit: BoxFit.contain,
        placeholder: (context, url) {
          return Center(
            child: SizedBox(
              width: size / 2,
              height: size / 2,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorWidget: (_, __, ___) {
          debugPrint("Error loading branding logo from $fullUrl");
          return _buildFallback();
        },
      );
    } else {
      child = _buildFallback();
    }

    if (isCircular) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }
    return child;
  }

  Widget _buildFallback() {
    return Icon(
      Icons.spa, 
      size: iconSize, 
      color: color ?? Colors.white,
    );
  }
}
