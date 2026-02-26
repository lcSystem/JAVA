import 'dart:convert';
import 'package:http/http.dart' as http;
import '../persistence/sqlite_database_service.dart';
import '../services/local_persistence_service.dart';

class DeltaSyncService {
  final String _baseUrl;
  final String _token; // JWT Token
  final SqliteDatabaseService _dbService;
  final LocalPersistenceService _localPrefs;

  static const String _syncKey = 'last_sync_timestamp';

  DeltaSyncService(this._baseUrl, this._token, this._dbService, this._localPrefs);

  Future<void> syncMessages() async {
    // 1. Obtener el último timestamp de sincronización
    String? lastSync = await _localPrefs.getSecure(_syncKey);
    // Si es la primera vez, el servidor debería manejar un default (ej. hace 30 días)
    // o enviamos un valor base.
    String since = lastSync ?? '2000-01-01T00:00:00';

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/chat/sync?since=$since'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> messages = json.decode(response.body);
        
        String? latestTimestamp = lastSync;

        for (var msg in messages) {
          await _dbService.insertMessage(msg);
          
          // Actualizamos el cursor de sincronización
          String currentTimestamp = msg['timestamp'];
          if (latestTimestamp == null || currentTimestamp.compareTo(latestTimestamp) > 0) {
            latestTimestamp = currentTimestamp;
          }
        }

        if (latestTimestamp != null) {
          await _localPrefs.saveSecure(_syncKey, latestTimestamp);
        }
      }
    } catch (e) {
      print('Error en sincronización incremental: $e');
    }
  }
}
