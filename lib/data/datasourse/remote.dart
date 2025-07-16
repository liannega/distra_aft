import 'package:dio/dio.dart';
import 'package:dsimcaf_1/data/models/auth_response_model.dart';
import 'package:dsimcaf_1/data/models/distra_user_model.dart';

class DistraApiDataSource {
  final Dio _dio;

  DistraApiDataSource(this._dio);

  Future<bool> validateApiCredentials({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (username.toLowerCase() == 'admin' && password == 'admin123') {
        return true;
      } else if (username.toLowerCase() == 'distra_api' &&
          password == 'DistraAPI2024') {
        return true;
      } else if (username.toLowerCase() == 'api_user' &&
          password == 'SecurePass123') {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception('Error de conexión al validar credenciales: $e');
    }
  }

  Future<AuthResponseModel> login({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    try {
      String correctedBaseUrl = baseUrl;
      if (!correctedBaseUrl.endsWith('/')) {
        correctedBaseUrl += '/';
      }

      final loginUrl = '${correctedBaseUrl}login';

      print('🔗 URL de login: $loginUrl'); // Debug

      final response = await _dio.post(
        loginUrl,
        data: {'username': username, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRF-TOKEN': '',
          },
        ),
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Error de autenticación: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Credenciales incorrectas');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Acceso denegado');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Endpoint no encontrado - Verifique la URL del API');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<bool> validateToken({
    required String baseUrl,
    required String token,
  }) async {
    try {
      String correctedBaseUrl = baseUrl;
      if (!correctedBaseUrl.endsWith('/')) {
        correctedBaseUrl += '/';
      }

      final response = await _dio.get(
        '${correctedBaseUrl}user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<DistraUserModel> getCurrentUser({
    required String baseUrl,
    required String token,
  }) async {
    try {
      String correctedBaseUrl = baseUrl;
      if (!correctedBaseUrl.endsWith('/')) {
        correctedBaseUrl += '/';
      }

      final response = await _dio.get(
        '${correctedBaseUrl}user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DistraUserModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener usuario: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
