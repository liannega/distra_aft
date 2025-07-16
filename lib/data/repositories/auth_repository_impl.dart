import 'package:dsimcaf_1/data/datasourse/remote.dart';
import 'package:dsimcaf_1/data/local/shared_preferends.dart';
import 'package:dsimcaf_1/data/models/auth_model.dart';
import 'package:dsimcaf_1/data/models/distra_user_model.dart';
import 'package:dsimcaf_1/domain/entities/auth_entitie.dart';
import 'package:dsimcaf_1/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferencesDataSource localDataSource;
  final DistraApiDataSource remoteDataSource;
  final String baseUrl;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.baseUrl,
  });

  @override
  Future<AuthResponse> login(String username, String password) async {
    return await remoteDataSource.login(
      baseUrl: baseUrl,
      username: username,
      password: password,
    );
  }

  @override
  Future<bool> validateToken(String token) async {
    return await remoteDataSource.validateToken(
      baseUrl: baseUrl,
      token: token,
    );
  }

  @override
  Future<DistraUser?> getCurrentUser() async {
    final token = await getStoredToken();
    if (token != null) {
      return await remoteDataSource.getCurrentUser(
        baseUrl: baseUrl,
        token: token,
      );
    }
    return null;
  }

  @override
  Future<void> saveAuthData(String token, DistraUser user) async {
    final userModel = DistraUserModel.fromEntity(user);
    await localDataSource.saveAuthData(token, userModel);
  }

  @override
  Future<void> clearAuthData() async {
    await localDataSource.clearAuthData();
  }

  @override
  Future<String?> getStoredToken() async {
    return await localDataSource.getAuthToken();
  }

  @override
  Future<DistraUser?> getStoredUser() async {
    return await localDataSource.getAuthUser();
  }
}
