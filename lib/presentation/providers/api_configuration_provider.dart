import 'package:dsimcaf_1/data/datasourse/api.dart';
import 'package:dsimcaf_1/domain/entities/api_entitie.dart';
import 'package:dsimcaf_1/domain/entities/usecases/save_api_usecase.dart';
import 'package:dsimcaf_1/domain/repositories/api_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiConfigurationState {
  final ApiConfiguration? configuration;
  final bool isLoading;
  final String? error;

  const ApiConfigurationState({
    this.configuration,
    this.isLoading = false,
    this.error,
  });

  get baseUrl => null;

  ApiConfigurationState copyWith({
    ApiConfiguration? configuration,
    bool? isLoading,
    String? error,
  }) {
    return ApiConfigurationState(
      configuration: configuration ?? this.configuration,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ApiConfigurationNotifier extends StateNotifier<ApiConfigurationState> {
  final SaveApiConfigurationUseCase _saveConfigurationUseCase;
  final ApiConfigurationRepository _repository;

  ApiConfigurationNotifier(this._saveConfigurationUseCase, this._repository)
    : super(const ApiConfigurationState()) {
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    try {
      final configuration = await _repository.getConfiguration();
      state = state.copyWith(configuration: configuration);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> saveConfiguration({
    required String baseUrl,
    required String apiUsername,
    required String apiPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _saveConfigurationUseCase.call(
        baseUrl: baseUrl,
        apiUsername: apiUsername,
        apiPassword: apiPassword,
      );

      await _loadConfiguration();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> clearConfiguration() async {
    try {
      await _repository.clearConfiguration();
      state = state.copyWith(configuration: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final apiConfigurationProvider =
    StateNotifierProvider<ApiConfigurationNotifier, ApiConfigurationState>((
      ref,
    ) {
      final saveConfigurationUseCase = ref.watch(
        saveApiConfigurationUseCaseProvider,
      );
      final repository = ref.watch(apiConfigurationRepositoryProvider);

      return ApiConfigurationNotifier(saveConfigurationUseCase, repository);
    });

final isApiConfiguredProvider = Provider<bool>((ref) {
  final state = ref.watch(apiConfigurationProvider);
  return state.configuration != null;
});
