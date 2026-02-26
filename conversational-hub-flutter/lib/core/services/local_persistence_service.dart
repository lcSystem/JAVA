import 'package:shared_preferences/shared_preferences.dart';
import 'encryption_service.dart';

class LocalPersistenceService {
  final EncryptionService _encryptionService;
  
  LocalPersistenceService(this._encryptionService);

  Future<void> saveSecure(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedValue = _encryptionService.encryptData(value);
    await prefs.setString(key, encryptedValue);
  }

  Future<String?> getSecure(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedValue = prefs.getString(key);
    if (encryptedValue == null) return null;
    return _encryptionService.decryptData(encryptedValue);
  }

  Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
