import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  final _storage = const FlutterSecureStorage();
  static const _keyAlias = 'chat_encryption_key';
  
  encrypt.Key? _key;
  // Usamos un IV fijo para simplicidad en la persistencia local por dispositivo, 
  // aunque para máxima seguridad se recomienda uno por mensaje.
  final _iv = encrypt.IV.fromLength(16);

  Future<void> init() async {
    String? base64Key = await _storage.read(key: _keyAlias);
    if (base64Key == null) {
      final newKey = encrypt.Key.fromSecureRandom(32);
      base64Key = newKey.base64;
      await _storage.write(key: _keyAlias, value: base64Key);
    }
    _key = encrypt.Key.fromBase64(base64Key);
  }

  String encryptData(String plainText) {
    if (_key == null) return plainText; // Fallback si no está inicializado
    final encrypter = encrypt.Encrypter(encrypt.AES(_key!));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedBase64) {
    if (_key == null) return encryptedBase64;
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key!));
      return encrypter.decrypt64(encryptedBase64, iv: _iv);
    } catch (e) {
      return "Error: Mensaje cifrado ilegible";
    }
  }
}
