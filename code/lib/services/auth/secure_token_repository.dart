import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/auth/naver_tokens.dart';

class SecureTokenRepository {
  static const String tokensKey = 'naver_auth_tokens';

  /// Android에서 EncryptedSharedPreferences를 사용하도록 설정
  ///
  /// API 23+ (Android 6.0+)에서 AES-256 암호화를 사용합니다.
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final FlutterSecureStorage _storage;

  SecureTokenRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(aOptions: _androidOptions);

  Future<void> saveTokens(NaverTokens tokens) async {
    final jsonString = jsonEncode(tokens.toJson());
    await _storage.write(key: tokensKey, value: jsonString);
  }

  Future<NaverTokens?> getTokens() async {
    try {
      final jsonString = await _storage.read(key: tokensKey);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return NaverTokens.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: tokensKey);
  }

  Future<bool> hasTokens() async {
    return await _storage.containsKey(key: tokensKey);
  }
}
