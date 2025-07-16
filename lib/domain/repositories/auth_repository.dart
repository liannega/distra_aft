import 'package:dsimcaf_1/data/models/auth_model.dart';
import 'package:dsimcaf_1/domain/entities/auth_entitie.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String username, String password);
  Future<bool> validateToken(String token);
  Future<DistraUser?> getCurrentUser();
  Future<void> saveAuthData(String token, DistraUser user);
  Future<void> clearAuthData();
  Future<String?> getStoredToken();
  Future<DistraUser?> getStoredUser();
}
