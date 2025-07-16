import 'dart:convert';
import 'package:http/http.dart' as http;

class DistraLoginResponse {
  final String token;
  final String type;
  final DistraUser user;

  DistraLoginResponse({
    required this.token,
    required this.type,
    required this.user,
  });

  factory DistraLoginResponse.fromJson(Map<String, dynamic> json) {
    return DistraLoginResponse(
      token: json['token'],
      type: json['type'],
      user: DistraUser.fromJson(json['user']),
    );
  }
}

class DistraUser {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final int accessLevel;
  final int isActive;

  DistraUser({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.accessLevel,
    required this.isActive,
  });

  factory DistraUser.fromJson(Map<String, dynamic> json) {
    return DistraUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      accessLevel: json['access_level'],
      isActive: json['is_active'],
    );
  }
}

class DistraApiService {
  final String baseUrl;

  DistraApiService({required this.baseUrl});

  Future<DistraLoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/login');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'X-CSRF-TOKEN': '',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return DistraLoginResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        throw Exception('Credenciales incorrectas');
      } else if (response.statusCode == 403) {
        throw Exception('Acceso denegado');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Error de conexión: $e');
      }
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final url = Uri.parse('$baseUrl/api/user');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
