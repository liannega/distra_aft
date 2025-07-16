import 'package:dsimcaf_1/domain/entities/auth_entitie.dart';
import 'package:dsimcaf_1/data/models/distra_user_model.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.token,
    required super.type,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String,
      type: json['type'] as String,
      user: DistraUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
      'user': (user as DistraUserModel).toJson(),
    };
  }
}
