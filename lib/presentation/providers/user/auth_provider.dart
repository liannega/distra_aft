import 'package:dsimcaf_1/data/datasourse/api.dart';
import 'package:dsimcaf_1/data/models/auth_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dsimcaf_1/presentation/providers/api_configuration_provider.dart';

class AuthState {
  final bool isAuthenticated;
  final DistraUser? user;
  final String? token;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    DistraUser? user,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState()) {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    final apiConfig = ref.read(apiConfigurationProvider).configuration;
    if (apiConfig == null) return;

    try {
      final authRepository = ref.read(
        authRepositoryProvider(apiConfig.baseUrl),
      );
      final token = await authRepository.getStoredToken();
      final user = await authRepository.getStoredUser();

      if (token != null && user != null) {
        final isValid = await authRepository.validateToken(token);

        if (isValid) {
          state = AuthState(isAuthenticated: true, user: user, token: token);
        } else {
          await authRepository.clearAuthData();
        }
      }
    } catch (e) {
      // Error al cargar, mantener estado inicial
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final apiConfig = ref.read(apiConfigurationProvider).configuration;
      if (apiConfig == null) {
        throw Exception('Configuración del API no encontrada');
      }

      final loginUseCase = ref.read(loginUseCaseProvider(apiConfig.baseUrl));
      final authResponse = await loginUseCase.call(username, password);

      state = AuthState(
        isAuthenticated: true,
        user: authResponse.user,
        token: authResponse.token,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    final apiConfig = ref.read(apiConfigurationProvider).configuration;
    if (apiConfig != null) {
      final authRepository = ref.read(
        authRepositoryProvider(apiConfig.baseUrl),
      );
      await authRepository.clearAuthData();
    }
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});
