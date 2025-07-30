import 'dart:convert';

class ApiConfiguration {
  final String baseUrl;
  final String apiUsername;
  final String apiPassword;
  final DateTime createdAt;

  const ApiConfiguration({
    required this.baseUrl,
    required this.apiUsername,
    required this.apiPassword,
    required this.createdAt,
  });

  ApiConfiguration copyWith({
    String? baseUrl,
    String? apiUsername,
    String? apiPassword,
    DateTime? createdAt,
  }) {
    return ApiConfiguration(
      baseUrl: baseUrl ?? this.baseUrl,
      apiUsername: apiUsername ?? this.apiUsername,
      apiPassword: apiPassword ?? this.apiPassword,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baseUrl': baseUrl,
      'apiUsername': apiUsername,
      'apiPassword': apiPassword,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ApiConfiguration.fromMap(Map<String, dynamic> map) {
    return ApiConfiguration(
      baseUrl: map['baseUrl'] ?? '',
      apiUsername: map['apiUsername'] ?? '',
      apiPassword: map['apiPassword'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiConfiguration.fromJson(String source) => ApiConfiguration.fromMap(json.decode(source));
}
