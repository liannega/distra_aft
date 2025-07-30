import 'package:dsimcaf_1/domain/entities/distra_entitie.dart';

class AuthResponse {
  final String token;
  final String type;
  final DistraUser user;

  const AuthResponse({
    required this.token,
    required this.type,
    required this.user,
  });

  AuthResponse copyWith({String? token, String? type, DistraUser? user}) {
    return AuthResponse(
      token: token ?? this.token,
      type: type ?? this.type,
      user: user ?? this.user,
    );
  }
}
