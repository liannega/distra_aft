
import 'package:dsimcaf_1/domain/entities/api_entitie.dart';
import 'package:dsimcaf_1/domain/repositories/api_repository.dart';

class SaveApiConfigurationUseCase {
  final ApiConfigurationRepository repository;

  SaveApiConfigurationUseCase(this.repository);

  Future<void> call({
    required String baseUrl,
    required String apiUsername,
    required String apiPassword,
  }) async {
    // Validar credenciales primero
    final isValid = await repository.validateApiCredentials(
      baseUrl,
      apiUsername,
      apiPassword,
    );

    if (!isValid) {
      throw Exception('Credenciales del API incorrectas');
    }

    final configuration = ApiConfiguration(
      baseUrl: baseUrl,
      apiUsername: apiUsername,
      apiPassword: apiPassword,
      createdAt: DateTime.now(),
    );

    await repository.saveConfiguration(configuration);
  }
}
