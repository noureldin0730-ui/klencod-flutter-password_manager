import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CryptoService {
  static final _storage = const FlutterSecureStorage();
  static const _keyName = 'master_key_v1';

  static Future<Encrypter> _getEncrypter() async {
    String? base64Key = await _storage.read(key: _keyName);
    if (base64Key == null) {
      final key = Key.fromSecureRandom(32);
      base64Key = base64Encode(key.bytes);
      await _storage.write(key: _keyName, value: base64Key);
    }
    return Encrypter(AES(Key.fromBase64(base64Key)));
  }

  static Future<Map<String, String>> encrypt(String plainText) async {
    final encrypter = await _getEncrypter();
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return {
      'encryptedPassword': encrypted.base64,
      'iv': iv.base64,
    };
  }

  static Future<String> decrypt(String encryptedBase64, String ivBase64) async {
    try {
      final encrypter = await _getEncrypter();
      final iv = IV.fromBase64(ivBase64);
      return encrypter.decrypt64(encryptedBase64, iv: iv);
    } catch (e) {
      return 'Error decrypting';
    }
  }
}