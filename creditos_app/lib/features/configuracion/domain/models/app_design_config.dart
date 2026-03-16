import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';

/// Holds the dynamic design configuration loaded from the API.
class AppDesignConfig {
  final String orgName;
  final String welcomeMessage;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color gradientStart;
  final Color gradientEnd;
  final String? logoUrl;
  final String? loginBgImageUrl;
  final String localLogoPath;
  final String? persistentLogoPath;
  final Uint8List? logoBytes; // Bytes of the persisted logo (multi-platform)
  final String supportPhone;
  final String supportEmail;
  final String termsUrl;
  final String minVersion;

  const AppDesignConfig({
    this.orgName = 'Mi Cooperativa',
    this.welcomeMessage = 'Bienvenido a tu portal de créditos',
    this.primaryColor = const Color(0xFF1A73E8),
    this.secondaryColor = const Color(0xFFFF6D00),
    this.backgroundColor = const Color(0xFFF5F7FA),
    this.cardColor = const Color(0xFFFFFFFF),
    this.textPrimaryColor = const Color(0xFF1E293B),
    this.textSecondaryColor = const Color(0xFF64748B),
    this.gradientStart = const Color(0xFF1A73E8),
    this.gradientEnd = const Color(0xFF6366F1),
    this.logoUrl,
    this.loginBgImageUrl,
    this.localLogoPath = 'images/logo',
    this.persistentLogoPath,
    this.logoBytes,
    this.supportPhone = '+57 300 123 4567',
    this.supportEmail = 'soporte@micooperativa.com',
    this.termsUrl = '',
    this.minVersion = '1.0.0',
  });

  factory AppDesignConfig.fromMap(Map<String, String> map) {
    return AppDesignConfig(
      orgName: map['org_name'] ?? 'Mi Cooperativa',
      welcomeMessage: map['welcome_message'] ?? 'Bienvenido',
      primaryColor: _parseColor(map['primary_color'], 0xFF1A73E8),
      secondaryColor: _parseColor(map['secondary_color'], 0xFFFF6D00),
      backgroundColor: _parseColor(map['background_color'], 0xFFF5F7FA),
      cardColor: _parseColor(map['card_color'], 0xFFFFFFFF),
      textPrimaryColor: _parseColor(map['text_primary_color'], 0xFF1E293B),
      textSecondaryColor: _parseColor(map['text_secondary_color'], 0xFF64748B),
      gradientStart: _parseColor(map['gradient_start'], 0xFF1A73E8),
      gradientEnd: _parseColor(map['gradient_end'], 0xFF6366F1),
      logoUrl: _joinUrl(AppConfig.baseUrl, map['app_logo_url']),
      loginBgImageUrl: _joinUrl(AppConfig.baseUrl, map['login_bg_image_url']),
      localLogoPath: 'images/logo', // Extension resolved dynamically by LogoAssetResolver
      supportPhone: map['support_phone'] ?? '',
      supportEmail: map['support_email'] ?? '',
      termsUrl: map['terms_url'] ?? '',
      minVersion: map['app_version_min'] ?? '1.0.0',
    );
  }

  AppDesignConfig copyWith({
    String? orgName,
    String? welcomeMessage,
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? cardColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? gradientStart,
    Color? gradientEnd,
    String? logoUrl,
    String? loginBgImageUrl,
    String? localLogoPath,
    String? persistentLogoPath,
    Uint8List? logoBytes,
    String? supportPhone,
    String? supportEmail,
    String? termsUrl,
    String? minVersion,
  }) {
    return AppDesignConfig(
      orgName: orgName ?? this.orgName,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardColor: cardColor ?? this.cardColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      logoUrl: logoUrl ?? this.logoUrl,
      loginBgImageUrl: loginBgImageUrl ?? this.loginBgImageUrl,
      localLogoPath: localLogoPath ?? this.localLogoPath,
      persistentLogoPath: persistentLogoPath ?? this.persistentLogoPath,
      logoBytes: logoBytes ?? this.logoBytes,
      supportPhone: supportPhone ?? this.supportPhone,
      supportEmail: supportEmail ?? this.supportEmail,
      termsUrl: termsUrl ?? this.termsUrl,
      minVersion: minVersion ?? this.minVersion,
    );
  }

  static String? _joinUrl(String baseUrl, String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    
    return '$cleanBase$cleanPath';
  }

  static Color _parseColor(String? hex, int fallback) {
    if (hex == null || hex.isEmpty) return Color(fallback);
    try {
      final cleaned = hex.replaceAll('#', '');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return Color(fallback);
    }
  }
}
