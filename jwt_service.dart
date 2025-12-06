import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtService {
  static const String _secret = 'farmbridge-secret-key';

  String createToken(String userId, String phone) {
    final jwt = JWT({
      'userId': userId,
      'phone': phone,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });
    return jwt.sign(SecretKey(_secret));
  }

  Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secret));
      return jwt.payload;
    } catch (e) {
      return null;
    }
  }
}