import 'package:dio/dio.dart';
import 'package:dsimcaf_1/config/constants/shared_prefs_key.dart';
import 'package:dsimcaf_1/data/models/auth_model.dart';
import 'package:dsimcaf_1/data/myDio/custom_response.dart';
import 'package:dsimcaf_1/data/myDio/my_dio.dart';
import 'package:dsimcaf_1/domain/entities/auth_entitie.dart';
import 'package:dsimcaf_1/domain/repositories/usecases/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi extends AuthRepository {
  final MyDio _dio;
  AuthApi(this._dio);

  final String localPath = "auth";

  @override
  Future<CustomResponse> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPrefsKey.authTokenKey);
      _dio.updateToken("");
      return CustomResponse(statusCode: 200);
    } catch (e) {
      return CustomResponse(
        statusCode: 400,
        message: 'Error al limpiar datos de autenticación: $e',
      );
    }
  }

  @override
  Future<CustomResponse<AuthResponse>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await _dio.request(
        requestType: RequestType.POST,
        path: 'login',
        data: {'username': username, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRF-TOKEN': '',
          },
        ),
      );
      final authResponse = AuthResponseModel.fromMap(response);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefsKey.authTokenKey, authResponse.token);
      await prefs.setString(SharedPrefsKey.currentUserDataKey, authResponse.user.toJson());
      _dio.updateToken(authResponse.token);
      return CustomResponse(
        statusCode: 200,
        data: authResponse.toEntity(),
      );
    } on CustomDioError catch (e) {
      return CustomResponse(statusCode: e.code, message: e.message);
    } catch (e) {
      return CustomResponse(statusCode: 400, message: e.toString());
    }
  }

}
