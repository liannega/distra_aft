import 'package:dio/dio.dart';
import 'package:dsimcaf_1/data/datasourse/remote.dart';
import 'package:dsimcaf_1/data/local/shared_preferends.dart';
import 'package:dsimcaf_1/data/repositories/api_repository_impl.dart';
import 'package:dsimcaf_1/data/repositories/auth_repository_impl.dart';
import 'package:dsimcaf_1/domain/entities/usecases/login_usecase.dart';
import 'package:dsimcaf_1/domain/entities/usecases/save_api_usecase.dart';
import 'package:dsimcaf_1/domain/repositories/api_repository.dart';
import 'package:dsimcaf_1/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ),
  );

  return dio;
});

final sharedPreferencesDataSourceProvider =
    Provider<SharedPreferencesDataSource>((ref) {
      return SharedPreferencesDataSource();
    });

final distraApiDataSourceProvider = Provider<DistraApiDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return DistraApiDataSource(dio);
});

final apiConfigurationRepositoryProvider = Provider<ApiConfigurationRepository>(
  (ref) {
    final localDataSource = ref.watch(sharedPreferencesDataSourceProvider);
    final remoteDataSource = ref.watch(distraApiDataSourceProvider);

    return ApiConfigurationRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  },
);

final authRepositoryProvider = Provider.family<AuthRepository, String>((
  ref,
  baseUrl,
) {
  final localDataSource = ref.watch(sharedPreferencesDataSourceProvider);
  final remoteDataSource = ref.watch(distraApiDataSourceProvider);

  return AuthRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    baseUrl: baseUrl,
  );
});

final saveApiConfigurationUseCaseProvider =
    Provider<SaveApiConfigurationUseCase>((ref) {
      final repository = ref.watch(apiConfigurationRepositoryProvider);
      return SaveApiConfigurationUseCase(repository);
    });

final loginUseCaseProvider = Provider.family<LoginUseCase, String>((
  ref,
  baseUrl,
) {
  final repository = ref.watch(authRepositoryProvider(baseUrl));
  return LoginUseCase(repository);
});
