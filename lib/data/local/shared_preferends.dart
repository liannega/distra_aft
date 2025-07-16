import 'dart:convert';
import 'package:dsimcaf_1/data/models/api_configuration_model.dart';
import 'package:dsimcaf_1/data/models/distra_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataSource {
  static const String _apiConfigKey = 'api_configuration';
  static const String _authTokenKey = 'auth_token';
  static const String _authUserKey = 'auth_user';

  Future<ApiConfigurationModel?> getApiConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configString = prefs.getString(_apiConfigKey);
      if (configString != null) {
        final configJson = jsonDecode(configString);
        return ApiConfigurationModel.fromJson(configJson);
      }
      return null;
    } catch (e) {
      throw Exception('Error al cargar configuración: $e');
    }
  }

  Future<void> saveApiConfiguration(ApiConfigurationModel configuration) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configString = jsonEncode(configuration.toJson());
      await prefs.setString(_apiConfigKey, configString);
    } catch (e) {
      throw Exception('Error al guardar configuración: $e');
    }
  }

  Future<void> clearApiConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_apiConfigKey);
    } catch (e) {
      throw Exception('Error al limpiar configuración: $e');
    }
  }

  // Auth Data
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_authTokenKey);
    } catch (e) {
      throw Exception('Error al cargar token: $e');
    }
  }

  Future<DistraUserModel?> getAuthUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_authUserKey);

      if (userString != null) {
        final userJson = jsonDecode(userString);
        return DistraUserModel.fromJson(userJson);
      }
      return null;
    } catch (e) {
      throw Exception('Error al cargar usuario: $e');
    }
  }

  Future<void> saveAuthData(String token, DistraUserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authTokenKey, token);
      await prefs.setString(_authUserKey, jsonEncode(user.toJson()));
    } catch (e) {
      throw Exception('Error al guardar datos de autenticación: $e');
    }
  }

  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await prefs.remove(_authUserKey);
    } catch (e) {
      throw Exception('Error al limpiar datos de autenticación: $e');
    }
  }
}
