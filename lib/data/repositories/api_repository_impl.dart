import 'package:dsimcaf_1/data/datasourse/remote.dart';
import 'package:dsimcaf_1/data/local/shared_preferends.dart';
import 'package:dsimcaf_1/data/models/api_configuration_model.dart';
import 'package:dsimcaf_1/domain/entities/api_entitie.dart';
import 'package:dsimcaf_1/domain/repositories/api_repository.dart';

class ApiConfigurationRepositoryImpl implements ApiConfigurationRepository {
  final SharedPreferencesDataSource localDataSource;
  final DistraApiDataSource remoteDataSource;

  ApiConfigurationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<ApiConfiguration?> getConfiguration() async {
    return await localDataSource.getApiConfiguration();
  }

  @override
  Future<void> saveConfiguration(ApiConfiguration configuration) async {
    final model = ApiConfigurationModel.fromEntity(configuration);
    await localDataSource.saveApiConfiguration(model);
  }

  @override
  Future<void> clearConfiguration() async {
    await localDataSource.clearApiConfiguration();
  }

  @override
  Future<bool> validateApiCredentials(String baseUrl, String username, String password) async {
    return await remoteDataSource.validateApiCredentials(
      baseUrl: baseUrl,
      username: username,
      password: password,
    );
  }
}
