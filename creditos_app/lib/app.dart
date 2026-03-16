import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/routes/app_routes.dart';
import 'features/configuracion/providers/config_provider.dart';

/// Root widget that applies dynamic theming from the config API.
class CreditosApp extends ConsumerWidget {
  const CreditosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(designConfigProvider);

    return configAsync.when(
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildDefaultTheme(),
        home: const Scaffold(
          body: Center(child: Text('Error cargando configuración')),
        ),
      ),
      data: (config) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: config.orgName,
        theme: _buildTheme(config),
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }

  ThemeData _buildDefaultTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1A73E8),
      textTheme: GoogleFonts.interTextTheme(),
    );
  }

  ThemeData _buildTheme(AppDesignConfig config) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: config.primaryColor,
        secondary: config.secondaryColor,
        surface: config.backgroundColor,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: config.textPrimaryColor,
        displayColor: config.textPrimaryColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: config.cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: config.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: config.textSecondaryColor.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: config.textSecondaryColor.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: config.primaryColor, width: 2),
        ),
      ),
    );
  }
}
