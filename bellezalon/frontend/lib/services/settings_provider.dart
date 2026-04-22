import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'api_service.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _cacheKey = 'design_settings_cache';
  static const String _localLogoPathKey = 'local_logo_path';

  Map<String, String> _settings = {
    'primary_color': '#8C4D53',
    'secondary_color': '#785A29',
    'font_family': 'PlusJakartaSans',
    'theme_mode': 'light',
    'salon_name': 'Belleza',
    'salon_logo_url': '',
    'max_appointments_per_day': '20',
    'is_tax_enabled': 'false',
    'business_taxes': '[]',
    'blocked_schedules': '{}',
    'time_format': '24h',
  };

  final String baseUrl = ApiService.baseUrl;

  /// Carga los settings desde cache local (SharedPreferences, funciona en web)
  Future<bool> loadFromLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null && cached.isNotEmpty) {
        final map = Map<String, dynamic>.from(jsonDecode(cached));
        map.forEach((k, v) => _settings[k] = v.toString());
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Error loading local settings cache: $e");
    }
    return false;
  }

  /// Persiste los settings actuales al cache local
  Future<void> _saveToLocalJson() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(_settings));
    } catch (e) {
      debugPrint("Error saving local settings cache: $e");
    }
  }

  Map<String, String> get settings => _settings;
  Color get primaryColor => _parseHex(_settings['primary_color'] ?? '#8C4D53');
  Color get secondaryColor => _parseHex(_settings['secondary_color'] ?? '#785A29');
  String get fontFamily => _settings['font_family'] ?? 'PlusJakartaSans';
  String get salonName => _settings['salon_name'] ?? 'Salón Belleza Pro';
  String get salonLogo => _settings['salon_logo_url'] ?? '';
  String? get localLogoPath => _settings[_localLogoPathKey];
  ThemeMode get themeMode => _settings['theme_mode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
  String get timeFormat => _settings['time_format'] ?? '24h';
  bool get use24HourFormat => timeFormat == '24h';

  // Payment Options
  bool get requireAdvancePayment => _settings['require_advance_payment'] == 'true';
  int get advancePaymentPercentage => int.tryParse(_settings['advance_payment_percentage'] ?? '100') ?? 100;
  String get paymentGateway => _settings['payment_gateway'] ?? 'epaico';
  String get epaicoPublicKey => _settings['epaico_public_key'] ?? '';
  String get mercadopagoPublicKey => _settings['mercadopago_public_key'] ?? '';
  String get stripePublicKey => _settings['stripe_public_key'] ?? '';
  bool get paymentTestMode => _settings['payment_test_mode'] == 'true';

  // Tax helpers
  bool get isTaxEnabled => _settings['is_tax_enabled'] == 'true';

  List<Map<String, dynamic>> get businessTaxes {
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(_settings['business_taxes'] ?? '[]'));
    } catch (_) {
      return [];
    }
  }

  /// Solo los impuestos marcados como activos
  List<Map<String, dynamic>> get activeTaxes =>
      businessTaxes.where((t) => t['active'] == true).toList();

  /// Impuestos activos que se muestran en el total (VISIBLES)
  List<Map<String, dynamic>> get activeVisibleTaxes =>
      activeTaxes.where((t) => t['invisible'] != true).toList();

  /// Impuestos activos que se suman al precio del producto (INVISIBLES)
  List<Map<String, dynamic>> get activeInvisibleTaxes =>
      activeTaxes.where((t) => t['invisible'] == true).toList();

  /// Porcentaje total combinado de impuestos activos (ej: IVA 19% + otro 2% = 21)
  double get totalActiveTaxRate =>
      activeVisibleTaxes.fold(0.0, (sum, t) => sum + (double.tryParse(t['rate'].toString()) ?? 0.0));

  /// Porcentaje total combinado de impuestos INVISIBLES
  double get totalInvisibleTaxRate =>
      activeInvisibleTaxes.fold(0.0, (sum, t) => sum + (double.tryParse(t['rate'].toString()) ?? 0.0));

  /// Calcula el precio ajustado sumando los impuestos invisibles aplicables
  double calculatePriceWithInvisibleTaxes(double basePrice, {List<String>? selectedTaxNames}) {
    double rate = 0;
    if (selectedTaxNames == null) {
      // Si no se especifican, aplicamos todos los invisibles (compatible con lógica global si se desea)
      rate = totalInvisibleTaxRate;
    } else {
      // Aplicar solo los seleccionados que sean invisibles
      final invTaxes = activeInvisibleTaxes.where((t) => selectedTaxNames.contains(t['name']));
      rate = invTaxes.fold(0.0, (sum, t) => sum + (double.tryParse(t['rate'].toString()) ?? 0.0));
    }
    return basePrice * (1 + (rate / 100));
  }

  /// Límite de imágenes permitidas en el catálogo por servicio
  int get maxServiceImages => int.tryParse(_settings['max_service_images'] ?? '5') ?? 5;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (ApiService().token != null) 'Authorization': 'Bearer ${ApiService().token}',
  };

  Future<void> fetchSettings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/settings'), headers: _headers);
      if (response.statusCode == 200) {
        final fetched = Map<String, dynamic>.from(jsonDecode(response.body));
        fetched.forEach((k, v) {
          _settings[k] = v.toString();
        });
        
        // Check if logo changed to update cache
        final newLogo = fetched['salon_logo_url']?.toString() ?? '';
        if (newLogo.isNotEmpty && (newLogo != _settings['salon_logo_url'] || _settings[_localLogoPathKey] == null)) {
          _cacheLogoLocally(newLogo);
        }
        
        notifyListeners();
        await _saveToLocalJson();
      }
    } catch (e) {
      debugPrint("Error fetching settings: $e");
    }
  }

  /// Downloads the logo and saves it to a local file
  Future<void> _cacheLogoLocally(String logoUrl) async {
    if (kIsWeb || logoUrl.isEmpty) return;
    
    try {
      final fullUrl = '${ApiService.assetsBaseUrl}$logoUrl';
      final response = await http.get(Uri.parse(fullUrl));
      
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filename = p.basename(logoUrl);
        final file = File(p.join(directory.path, filename));
        
        await file.writeAsBytes(response.bodyBytes);
        
        _settings[_localLogoPathKey] = file.path;
        await _saveToLocalJson();
        notifyListeners();
        debugPrint("Logo cached locally at: ${file.path}");
      }
    } catch (e) {
      debugPrint("Error caching logo: $e");
    }
  }

  Future<bool> updateSettings(Map<String, String> newSettings) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/settings'),
        headers: _headers,
        body: jsonEncode(newSettings),
      );
      if (response.statusCode == 200) {
        _settings.addAll(newSettings);
        notifyListeners();
        await _saveToLocalJson();
        return true;
      }
      debugPrint("Error response updating settings: ${response.body}");
      return false;
    } catch (e) {
      debugPrint("Error updating settings: $e");
      return false;
    }
  }

  Color _parseHex(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length != 6) return const Color(0xFF8C4D53); // Fallback
    return Color(int.parse('FF$hex', radix: 16));
  }
}
