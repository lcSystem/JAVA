import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'connectivity_service.dart';
import 'offline_cache_service.dart';

/// Excepción lanzada cuando se intenta una operación de escritura sin internet.
class OfflineException implements Exception {
  final String message;
  OfflineException([this.message = 'Esta acción requiere conexión a internet.']);
  @override
  String toString() => message;
}

class ApiService {
  // AUTO-DETECCIÓN DE ENTORNO (Selecciona automáticamente local o producción)
  static String get baseUrl {
    return 'https://luigitech.site/api/src/api';
  }

  static String get assetsBaseUrl {
    return 'https://luigitech.site/api/src';
  }
  String? _token;
  String? _userRole;
  String? _userName;
  List<String> _permissions = [];
  SharedPreferences? _prefs;

  // Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs?.getString('jwt');
    _userRole = _prefs?.getString('userRole');
    _userName = _prefs?.getString('userName');
    _permissions = _prefs?.getStringList('permissions') ?? [];
  }

  String? get token => _token;
  String? get userRole => _userRole;
  String? get userName => _userName;
  List<String> get permissions => _permissions;
  bool get isAdmin => _userRole?.toLowerCase() == 'administrador' || _userRole?.toLowerCase() == 'admin';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Cache-Control': 'no-cache, no-store, must-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ═══════════════════════════════════════
  // HELPERS — CACHE & OFFLINE GUARD
  // ═══════════════════════════════════════

  /// GET con fallback a cache offline.
  /// Intenta hacer HTTP GET; si tiene éxito, guarda el body en cache.
  /// Si falla (sin red), devuelve los datos del cache local.
  Future<List<dynamic>> _getListWithCache(String path) async {
    final cache = OfflineCacheService.instance;
    try {
      final r = await http.get(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (r.statusCode == 200) {
        // Guardar en cache para uso offline
        cache.saveCache(path, r.body);
        return jsonDecode(r.body);
      }
      return _fallbackFromCache(path);
    } catch (e) {
      debugPrint('[ApiService] GET $path falló: $e — usando cache');
      return _fallbackFromCache(path);
    }
  }

  /// GET que retorna un Map con fallback a cache offline.
  Future<Map<String, dynamic>> _getMapWithCache(String path) async {
    final cache = OfflineCacheService.instance;
    try {
      final r = await http.get(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (r.statusCode == 200) {
        cache.saveCache(path, r.body);
        return Map<String, dynamic>.from(jsonDecode(r.body));
      }
      return _fallbackMapFromCache(path);
    } catch (e) {
      debugPrint('[ApiService] GET $path falló: $e — usando cache');
      return _fallbackMapFromCache(path);
    }
  }

  List<dynamic> _fallbackFromCache(String path) {
    final cached = OfflineCacheService.instance.getCache(path);
    if (cached != null) {
      try {
        return jsonDecode(cached);
      } catch (_) {}
    }
    return [];
  }

  Map<String, dynamic> _fallbackMapFromCache(String path) {
    final cached = OfflineCacheService.instance.getCache(path);
    if (cached != null) {
      try {
        return Map<String, dynamic>.from(jsonDecode(cached));
      } catch (_) {}
    }
    return {};
  }

  /// Verifica que hay conexión a internet antes de una operación de escritura.
  /// Lanza OfflineException si no hay conexión.
  void _requireOnline() {
    if (!ConnectivityService.instance.isOnline) {
      throw OfflineException();
    }
  }

  // ═══════════════════════════════════════
  // AUTH
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> login(String username, String password, {double? lat, double? lng}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username, 
        'password': password,
        'latitude': lat,
        'longitude': lng,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['jwt'];
      if (_token == null) {
        return {'success': false, 'error': 'TOKEN_MALFORMED'};
      }
      await _prefs?.setString('jwt', _token!);
      
      // Decode JWT payload
      try {
        final parts = _token!.split('.');
        if (parts.length == 3) {
          final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
          _userRole = payload['rol'] ?? 'usuario';
          _userName = payload['username'] ?? username;
          _permissions = List<String>.from(payload['modules'] ?? []);
          await _prefs?.setString('userRole', _userRole!);
          await _prefs?.setString('userName', _userName!);
          await _prefs?.setStringList('permissions', _permissions);
        }
      } catch (e) {
        debugPrint("Error parsing JWT: $e");
      }
      return {'success': true, 'role': _userRole};
    }
    
    try {
      final errorData = jsonDecode(response.body);
      return {'success': false, 'error': errorData['error'] ?? 'Authentication failed'};
    } catch (_) {
      return {'success': false, 'error': 'SERVER_ERROR_${response.statusCode}'};
    }
  }

  void logout() { 
    _token = null; _userRole = null; _userName = null; _permissions = [];
    _prefs?.remove('jwt');
    _prefs?.remove('userRole');
    _prefs?.remove('userName');
    _prefs?.remove('permissions');
    // Limpiar cache offline al cerrar sesión
    OfflineCacheService.instance.clearAll();
  }

  // ═══════════════════════════════════════
  // CITAS
  // ═══════════════════════════════════════
  Future<List<dynamic>> getCitas() async {
    return _getListWithCache('/citas');
  }

  Future<Map<String, dynamic>?> createCita(Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.post(Uri.parse('$baseUrl/citas'), headers: _headers, body: jsonEncode(data));
    return jsonDecode(r.body);
  }

  Future<Map<String, dynamic>?> updateCita(int id, Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.put(Uri.parse('$baseUrl/citas/$id'), headers: _headers, body: jsonEncode(data));
    return jsonDecode(r.body);
  }

  Future<bool> cancelCita(int id) async {
    _requireOnline();
    final r = await http.delete(Uri.parse('$baseUrl/citas/$id'), headers: _headers);
    return r.statusCode == 200;
  }

  // ═══════════════════════════════════════
  // SERVICIOS
  // ═══════════════════════════════════════
  Future<List<dynamic>> getServicios() async {
    return _getListWithCache('/servicios');
  }

  Future<bool> createServicio(Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.post(Uri.parse('$baseUrl/servicios'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 201;
  }

  Future<bool> updateServicio(int id, Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.put(Uri.parse('$baseUrl/servicios/$id'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 200;
  }

  Future<bool> deleteServicio(int id) async {
    _requireOnline();
    final r = await http.delete(Uri.parse('$baseUrl/servicios/$id'), headers: _headers);
    return r.statusCode == 200;
  }

  Future<Map<String, dynamic>> uploadServiceImage(int serviceId, Uint8List bytes, String filename) async {
    _requireOnline();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/servicios/$serviceId/imagenes'));
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    final extension = filename.split('.').last.toLowerCase();
    request.files.add(http.MultipartFile.fromBytes(
      'image', 
      bytes, 
      filename: filename,
      contentType: MediaType('image', extension == 'jpg' ? 'jpeg' : extension),
    ));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    return {'error': 'Failed to upload image'};
  }

  Future<bool> deleteServiceImage(int imageId) async {
    _requireOnline();
    final r = await http.delete(Uri.parse('$baseUrl/servicios/imagenes/$imageId'), headers: _headers);
    return r.statusCode == 200;
  }

  // ═══════════════════════════════════════
  // VENTAS
  // ═══════════════════════════════════════
  Future<List<dynamic>> getVentas() async {
    return _getListWithCache('/ventas');
  }

  Future<List<dynamic>> getVentaDetalles(int ventaId) async {
    return _getListWithCache('/ventas/$ventaId/detalles');
  }

  Future<List<dynamic>> getHistory({String? status, String? search}) async {
    String path = '/citas/historial';
    List<String> params = [];
    if (status != null && status.isNotEmpty) params.add('status=$status');
    if (search != null && search.isNotEmpty) params.add('search=$search');
    if (params.isNotEmpty) path += '?${params.join('&')}';
    return _getListWithCache(path);
  }

  Future<Map<String, dynamic>?> createVenta(Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.post(Uri.parse('$baseUrl/ventas'), headers: _headers, body: jsonEncode(data));
    if (r.statusCode == 201) return jsonDecode(r.body);
    debugPrint("createVenta error [${r.statusCode}]: ${r.body}");
    return null;
  }

  // ═══════════════════════════════════════
  // PRODUCTOS
  // ═══════════════════════════════════════
  Future<List<dynamic>> getProductos() async {
    return _getListWithCache('/productos');
  }

  Future<bool> createProducto(Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.post(Uri.parse('$baseUrl/productos'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 201;
  }

  Future<bool> updateProducto(int id, Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.put(Uri.parse('$baseUrl/productos/$id'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 200;
  }

  Future<bool> deleteProducto(int id) async {
    _requireOnline();
    final r = await http.delete(Uri.parse('$baseUrl/productos/$id'), headers: _headers);
    return r.statusCode == 200;
  }

  Future<List<dynamic>> getAlertasStock() async {
    return _getListWithCache('/productos/alertas');
  }

  // ═══════════════════════════════════════
  // REPORTES
  // ═══════════════════════════════════════
  Future<List<dynamic>> getReporteIngresos({String periodo = 'dia'}) async {
    return _getListWithCache('/reportes/ingresos?periodo=$periodo');
  }

  Future<List<dynamic>> getReporteServiciosTop() async {
    return _getListWithCache('/reportes/servicios-top');
  }

  Future<List<dynamic>> getReporteEmpleados() async {
    return _getListWithCache('/reportes/empleados');
  }

  Future<List<dynamic>> getReporteClientesTop() async {
    return _getListWithCache('/reportes/clientes-top');
  }

  // ═══════════════════════════════════════
  // SUCURSALES (MAP LOCATIONS)
  // ═══════════════════════════════════════
  Future<List<dynamic>> getSucursales() async {
    return _getListWithCache('/monitoring/sucursales');
  }

  Future<Map<String, dynamic>?> createSucursal(Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.post(Uri.parse('$baseUrl/monitoring/sucursales'), headers: _headers, body: jsonEncode(data));
    if (r.statusCode == 201) return jsonDecode(r.body);
    return null;
  }

  Future<bool> updateSucursal(int id, Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.put(Uri.parse('$baseUrl/monitoring/sucursales/$id'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 200;
  }

  Future<bool> deleteSucursal(int id) async {
    _requireOnline();
    final r = await http.delete(Uri.parse('$baseUrl/monitoring/sucursales/$id'), headers: _headers);
    return r.statusCode == 200;
  }

  // ═══════════════════════════════════════
  // HOME / GALLERY
  // ═══════════════════════════════════════
  Future<List<dynamic>> getGalleryImages() async {
    return _getListWithCache('/home/gallery');
  }

  Future<Map<String, dynamic>?> uploadGalleryImage(Uint8List imageBytes, String filename, String description) async {
    _requireOnline();
    final uri = Uri.parse('$baseUrl/home/gallery/upload');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';

    req.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: filename));
    req.fields['description'] = description;

    final streamResponse = await req.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    debugPrint("Gallery upload error [${response.statusCode}]: ${response.body}");
    return null;
  }

  Future<bool> deleteGalleryImage(int id) async {
    _requireOnline();
    final r = await http.delete(Uri.parse('$baseUrl/home/gallery/$id'), headers: _headers);
    return r.statusCode == 200;
  }

  // ═══════════════════════════════════════
  // ROLES
  // ═══════════════════════════════════════
  Future<List<dynamic>> getRoles() async {
    return _getListWithCache('/roles');
  }

  Future<List<dynamic>> getModules() async {
    return _getListWithCache('/modules');
  }

  Future<bool> createRole(Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.post(Uri.parse('$baseUrl/roles'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 201;
  }

  Future<bool> updateRole(int id, Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.put(Uri.parse('$baseUrl/roles/$id'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 200;
  }

  Future<bool> deleteRole(int id) async {
    _requireOnline();
    final r = await http.delete(Uri.parse('$baseUrl/roles/$id'), headers: _headers);
    return r.statusCode == 200;
  }

  // ═══════════════════════════════════════
  // USUARIOS
  // ═══════════════════════════════════════
  Future<List<dynamic>> getUsers() async {
    // Debug: direct call with error logging to diagnose empty users
    try {
      final r = await http.get(Uri.parse('$baseUrl/users'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      debugPrint('[ApiService] GET /users -> status=${r.statusCode}, bodyLen=${r.body.length}');
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body);
        if (data is List) {
          debugPrint('[ApiService] GET /users -> ${data.length} usuarios recibidos');
          OfflineCacheService.instance.saveCache('/users', r.body);
          return data;
        } else {
          debugPrint('[ApiService] GET /users -> respuesta no es lista: ${r.body.substring(0, r.body.length.clamp(0, 200))}');
          return _fallbackFromCache('/users');
        }
      } else {
        debugPrint('[ApiService] GET /users ERROR: status=${r.statusCode} body=${r.body.substring(0, r.body.length.clamp(0, 500))}');
        return _fallbackFromCache('/users');
      }
    } catch (e) {
      debugPrint('[ApiService] GET /users EXCEPTION: $e');
      return _fallbackFromCache('/users');
    }
  }

  Future<List<dynamic>> getEmpleadosOnly() async {
    return _getListWithCache('/users/empleados');
  }

  Future<List<dynamic>> getClientesOnly() async {
    return _getListWithCache('/users/clientes');
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.post(Uri.parse('$baseUrl/users'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 201;
  }

  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.put(Uri.parse('$baseUrl/users/$id'), headers: _headers, body: jsonEncode(data));
    return r.statusCode == 200;
  }

  Future<bool> deleteUser(int id) async {
    _requireOnline();
    final r = await http.delete(Uri.parse('$baseUrl/users/$id'), headers: _headers);
    return r.statusCode == 200;
  }

  // ═══════════════════════════════════════
  // NOTIFICACIONES
  // ═══════════════════════════════════════
  Future<List<dynamic>> getNotifications({int? userId, String? search, bool unreadOnly = false}) async {
    final Map<String, String> queryParams = {};
    if (userId != null) queryParams['user_id'] = userId.toString();
    if (search != null) queryParams['search'] = search;
    if (unreadOnly) queryParams['unread_only'] = '1';

    final uri = Uri.parse('$baseUrl/notifications').replace(queryParameters: queryParams);
    
    // Build path for cache key
    String cachePath = '/notifications';
    if (queryParams.isNotEmpty) {
      cachePath += '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    }
    
    try {
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        OfflineCacheService.instance.saveCache(cachePath, response.body);
        return jsonDecode(response.body);
      }
      return _fallbackFromCache(cachePath);
    } catch (e) {
      return _fallbackFromCache(cachePath);
    }
  }

  int? get userId {
    if (_token == null) return null;
    try {
      final parts = _token!.split('.');
      final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      return payload['sub'];
    } catch (_) { return null; }
  }

  Future<int> getUnreadCount() async {
    final uid = userId;
    if (uid == null) return 0;
    try {
      final r = await http.get(Uri.parse('$baseUrl/notifications/$uid/unread'), headers: _headers)
          .timeout(const Duration(seconds: 5));
      if (r.statusCode == 200) {
        return jsonDecode(r.body)['count'] ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  Future<bool> markNotificationRead(int id) async {
    _requireOnline();
    final response = await http.patch(
      Uri.parse('$baseUrl/notifications/$id/read'),
      headers: _headers,
    );
    return response.statusCode == 200;
  }

  Future<bool> markAllNotificationsRead([int? userIdParam]) async {
    _requireOnline();
    final uid = userIdParam ?? userId;
    if (uid == null) return false;
    final response = await http.patch(
      Uri.parse('$baseUrl/notifications/$uid/read-all'),
      headers: _headers,
    );
    return response.statusCode == 200;
  }

  // ═══════════════════════════════════════
  // REGISTRO PÚBLICO
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    _requireOnline();
    final r = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(r.body);
  }

  // ═══════════════════════════════════════
  // CONFIGURACIÓN / LOGO
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> uploadLogo(Uint8List bytes, String filename) async {
    _requireOnline();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/settings/upload-logo'));
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    final extension = filename.split('.').last.toLowerCase();
    request.files.add(http.MultipartFile.fromBytes(
      'logo',
      bytes,
      filename: filename,
      contentType: MediaType('image', extension == 'jpg' ? 'jpeg' : extension),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    return {'error': 'Failed to upload logo'};
  }

  Future<Map<String, dynamic>> uploadProfilePhoto(Uint8List bytes, String filename) async {
    _requireOnline();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/profile/upload-photo'));
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    final extension = filename.split('.').last.toLowerCase();
    request.files.add(http.MultipartFile.fromBytes(
      'photo',
      bytes,
      filename: filename,
      contentType: MediaType('image', extension == 'jpg' ? 'jpeg' : extension),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    return {'error': 'Failed to upload photo'};
  }

  // ═══════════════════════════════════════════════
  // PAGOS (SIMULADO)
  // ═══════════════════════════════════════════════
  Future<Map<String, dynamic>?> initiatePayment(double amount, int servicioId) async {
    _requireOnline();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/init'),
        headers: _headers,
        body: jsonEncode({'amount': amount, 'servicio_id': servicioId}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { debugPrint("Error initiatePayment: $e"); }
    return null;
  }

  // ═══════════════════════════════════════
  // PERFIL
  // ═══════════════════════════════════════
  Future<Map<String, dynamic>> getProfile() async {
    return _getMapWithCache('/profile');
  }

  Future<Map<String, dynamic>> getUserProfile(int id) async {
    return _getMapWithCache('/users/$id');
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _requireOnline();
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/profile'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return false;
    }
  }

  Future<bool> updateFcmToken(String token) async {
    if (userId == null) return false;
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/users/$userId/fcm-token'),
        headers: _headers,
        body: jsonEncode({'fcm_token': token}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error updating FCM token: $e");
      return false;
    }
  }

  Future<List<dynamic>> getMyChats() async {
    return _getListWithCache('/chat/my-chats');
  }

  Future<List<dynamic>> getChatMessages(int citaId) async {
    return _getListWithCache('/chat/messages/$citaId');
  }

  Future<bool> sendChatMessage(int citaId, String message) async {
    _requireOnline();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/messages/$citaId'),
        headers: _headers,
        body: jsonEncode({'sender_id': userId, 'message': message}),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Error sending message: $e");
      return false;
    }
  }

  Future<bool> confirmPayment(String paymentRef) async {
    _requireOnline();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/confirm'),
        headers: _headers,
        body: jsonEncode({'payment_ref': paymentRef}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
    } catch (e) { debugPrint("Error confirmPayment: $e"); }
    return false;
  }

  // ═══════════════════════════════════════════════
  // PQRS (SOPORTE)
  // ═══════════════════════════════════════════════
  Future<List<dynamic>> getPqrs() async {
    _requireOnline();
    try {
      final response = await http.get(Uri.parse('$baseUrl/pqrs'), headers: _headers);
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { debugPrint("Error getPqrs: $e"); }
    return [];
  }

  Future<dynamic> getPqrsById(int id) async {
    _requireOnline();
    try {
      final response = await http.get(Uri.parse('$baseUrl/pqrs/$id'), headers: _headers);
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { debugPrint("Error getPqrsById: $e"); }
    return null;
  }

  Future<dynamic> createPqrs(Map<String, dynamic> data) async {
    _requireOnline();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pqrs'),
        headers: _headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) return jsonDecode(response.body);
      return jsonDecode(response.body);
    } catch (e) { 
      debugPrint("Error createPqrs: $e");
      return {'error': e.toString()};
    }
  }

  Future<bool> addPqrsRespuesta(int pqrsId, String mensaje) async {
    _requireOnline();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pqrs/$pqrsId/respuestas'),
        headers: _headers,
        body: jsonEncode({'mensaje': mensaje}),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Error addPqrsRespuesta: $e");
      return false;
    }
  }

  Future<bool> updatePqrsStatus(int id, String estado) async {
    _requireOnline();
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/pqrs/$id/status'),
        headers: _headers,
        body: jsonEncode({'estado': estado}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error updatePqrsStatus: $e");
      return false;
    }
  }
}
