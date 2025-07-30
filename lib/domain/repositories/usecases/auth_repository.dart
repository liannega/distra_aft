import 'package:dsimcaf_1/data/myDio/custom_response.dart';
import 'package:dsimcaf_1/domain/entities/auth_entitie.dart';

abstract class AuthRepository {
  Future<CustomResponse<AuthResponse>> login(String username, String password);
  Future<CustomResponse> clearAuthData();
}
