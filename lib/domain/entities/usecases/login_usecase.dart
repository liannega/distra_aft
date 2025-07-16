import 'package:dsimcaf_1/domain/entities/auth_entitie.dart';
import 'package:dsimcaf_1/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResponse> call(String username, String password) async {
    final response = await repository.login(username, password);

    // Guardar datos de autenticación
    await repository.saveAuthData(response.token, response.user);

    return response;
  }
}
