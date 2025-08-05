import 'package:dsimcaf_1/data/api/models/distra_user_model.dart';
import 'package:dsimcaf_1/domain/entities/auth_entitie.dart';

class AuthResponseModel {
  final String token;
  final String type;
  final DistraUserModel user;

  const AuthResponseModel({
    required this.token,
    required this.type,
    required this.user,
  });

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthResponseModel(
      token: map['token'] ?? '',
      type: map['type'] ?? '',
      user: DistraUserModel.fromMap(map['user']),
    );
  }

  AuthResponse toEntity() {
    return AuthResponse(token: token, type: type, user: user.toEntity());
  }
}
