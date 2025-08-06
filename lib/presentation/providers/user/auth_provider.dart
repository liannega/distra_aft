import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dsimcaf_1/config/constants/shared_prefs_key.dart';
import 'package:dsimcaf_1/domain/entities/distra_entitie.dart';
import 'package:dsimcaf_1/domain/repositories/remote/usecases/auth_repository.dart';
import 'package:dsimcaf_1/presentation/providers/api_configuration_provider.dart';
import 'package:dsimcaf_1/presentation/providers/data/api_provider.dart';

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
    ValueGetter<DistraUser?>? user,
    ValueGetter<String?>? token,
    bool? isLoading,
    ValueGetter<String?>? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user != null ? user() : this.user,
      token: token != null ? token() : this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  final AuthRepository _authRepository;

  AuthNotifier(this.ref, this._authRepository) : super(const AuthState()) {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    final apiConfig = ref.read(apiConfigurationProvider).configuration;
    if (apiConfig == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(SharedPrefsKey.authTokenKey);
      DistraUser? user;
      try {
        user = DistraUser.fromJson(
          prefs.getString(SharedPrefsKey.currentUserDataKey)!,
        );
      } on Exception catch (_) {}

      if (token != null && user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: () => user,
          token: () => token,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          user: () => null,
          token: () => null,
        );
        await _authRepository.clearAuthData();
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
      final res = await _authRepository.login(username, password);

      if (res.isOkAndDataNotNull) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: () => res.data!.user,
          token: () => res.data!.token,
        );
      } else {
        state = state.copyWith(isLoading: false, error: () => res.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: () => e.toString());
    }
  }

  Future<void> logout() async {
    final apiConfig = ref.read(apiConfigurationProvider).configuration;
    if (apiConfig != null) {
      await _authRepository.clearAuthData();
    }
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref, ref.read(apiProvider).authRepository),
);

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});
