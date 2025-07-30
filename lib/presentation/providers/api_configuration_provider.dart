import 'package:dsimcaf_1/config/constants/shared_prefs_key.dart';
import 'package:dsimcaf_1/domain/entities/api_configuration_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  ApiConfigurationNotifier() : super(const ApiConfigurationState()) {
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      ApiConfiguration? configuration;
      final configString = prefs.getString(SharedPrefsKey.apiConfigKey);
      if (configString != null) {
        configuration = ApiConfiguration.fromJson(configString);
      }
      if (configuration != null) {
        state = state.copyWith(configuration: configuration);
      }
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        SharedPrefsKey.apiConfigKey,
        ApiConfiguration(
          baseUrl: baseUrl,
          apiUsername: apiUsername,
          apiPassword: apiPassword,
          createdAt: DateTime.now(),
        ).toJson(),
      );
      await _loadConfiguration();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> clearConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPrefsKey.apiConfigKey);
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
      return ApiConfigurationNotifier();
    });

final isApiConfiguredProvider = Provider<bool>((ref) {
  final state = ref.watch(apiConfigurationProvider);
  return state.configuration != null;
});
