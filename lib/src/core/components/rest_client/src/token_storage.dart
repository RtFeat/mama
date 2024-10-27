import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh/fresh.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mama/src/data.dart';

class TokenStorageImpl implements TokenStorage<OAuth2Token> {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static const _accessToken = 'access';
  static const _refreshToken = 'refresh';

  @override
  Future<void> delete() async {
    await storage.delete(key: _accessToken);
    await storage.delete(key: _refreshToken);
  }

  @override
  Future<OAuth2Token?> read() async {
    final String? accessToken = await storage.read(key: _accessToken);
    final String? refreshToken = await storage.read(key: _refreshToken);

    if (accessToken == null || refreshToken == null) {
      return null;
    }
    logger.info('Access token: $accessToken');
    logger.info('Refresh token: $refreshToken');

    if (!_isValidToken(refreshToken)) {
      await delete();
      return null;
    }

    if (!_isValidToken(accessToken)) {
      await storage.delete(key: _accessToken);
    }

    // final Map<String, dynamic> decodedToken = JwtDecoder.decode(refreshToken);

    // final start = DateTime.parse("${decodedToken['iat']}");

    // final expirationDate = start.add(const Duration(days: 1));

    // final bool isExpired = DateTime.now().isAfter(expirationDate);

    // if (isExpired) {
    //   await delete();
    //   return null;
    // }

    return OAuth2Token(accessToken: accessToken, refreshToken: refreshToken);
  }

  bool _isValidToken(String token) {
    try {
      JwtDecoder.decode(token);
      logger.info('Token is valid');
      return true; // Если удалось, токен корректен
    } catch (e) {
      logger.error('Token is invalid');
      return false; // Если ошибка, токен некорректен
    }
  }

  @override
  Future<void> write(token) async {
    await storage.write(key: _accessToken, value: token.accessToken);
    await storage.write(key: _refreshToken, value: token.refreshToken);
  }
}
