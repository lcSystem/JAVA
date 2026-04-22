import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'; // Add this for kIsWeb
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/settings_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/api_service.dart';
import 'services/connectivity_service.dart';
import 'services/offline_cache_service.dart';
import 'services/permission_service.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase background error: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Robust Permissions
  try {
    await PermissionService.requestAllPermissions();
  } catch (e) {
    debugPrint("Permission request failed: $e");
  }
  
  // Robust Firebase Initialization
  try {
    if (!kIsWeb) {
      await Firebase.initializeApp();
      
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.instance.subscribeToTopic("all");
      }
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      debugPrint("Web platform detected, skipping Firebase auto-init");
    }
  } catch (e) {
    debugPrint("Firebase init failed: $e. Continining app startup...");
  }

  try {
    await initializeDateFormatting('es_ES', null);
  } catch (e) {
    debugPrint("DateFormatting init failed: $e");
  }

  // Inicializar cache offline
  try {
    await OfflineCacheService.instance.init();
  } catch (e) {
    debugPrint("OfflineCacheService init failed: $e");
  }

  // Inicializar monitoreo de conectividad
  try {
    await ConnectivityService.instance.init();
  } catch (e) {
    debugPrint("ConnectivityService init failed: $e");
  }

  final apiService = ApiService();
  try {
    await apiService.init();
  } catch (e) {
    debugPrint("ApiService init failed: $e");
  }

  final settingsProvider = SettingsProvider();
  try {
    final hasCache = await settingsProvider.loadFromLocalCache();
    if (!hasCache) {
      // Use timeout for network fetch to avoid blocking indefinitely
      await settingsProvider.fetchSettings().timeout(const Duration(seconds: 5));
    } else {
      settingsProvider.fetchSettings(); 
    }
  } catch (e) {
    debugPrint("SettingsProvider init failed: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => settingsProvider,
      child: const SalonBeautyApp(),
    ),
  );
}

class SalonBeautyApp extends StatelessWidget {
  const SalonBeautyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return MaterialApp(
      title: '${settings.salonName} — Sistema Empresarial',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.primaryColor,
          primary: settings.primaryColor,
          secondary: settings.secondaryColor,
          surface: const Color(0xFFFCF9F8),
        ),
        fontFamily: settings.fontFamily.isNotEmpty ? settings.fontFamily : 'PlusJakartaSans',
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      locale: const Locale('es', 'ES'),
      initialRoute: ApiService().token != null ? '/dashboard' : '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
