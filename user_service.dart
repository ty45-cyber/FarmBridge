import '../models/user.dart';
import '../repositories/user_repository.dart';
import 'jwt_service.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserService {
  final UserRepository _userRepository = UserRepository();
  final JwtService _jwtService = JwtService();

  User register(RegisterRequest request) {
    final hashedPassword = sha256.convert(utf8.encode(request.password)).toString();
    final user = User(
      id: '',
      name: request.name,
      phone: request.phone,
      password: hashedPassword,
      role: request.role,
    );
    return _userRepository.save(user);
  }

  String? authenticate(String phone, String password) {
    final user = _userRepository.findByPhone(phone);
    if (user == null) return null;
    
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();
    if (user.password != hashedPassword) return null;
    
    return _jwtService.createToken(user.id, user.phone);
  }
}