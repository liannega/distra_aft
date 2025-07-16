import 'package:dsimcaf_1/domain/entities/api_entitie.dart';

abstract class ApiConfigurationRepository {
  Future<ApiConfiguration?> getConfiguration();
  Future<void> saveConfiguration(ApiConfiguration configuration);
  Future<void> clearConfiguration();
  Future<bool> validateApiCredentials(
    String baseUrl,
    String username,
    String password,
  );
}
