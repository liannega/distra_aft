import 'package:dsimcaf_1/domain/entities/api_entitie.dart';

class ApiConfigurationModel extends ApiConfiguration {
  const ApiConfigurationModel({
    required super.baseUrl,
    required super.apiUsername,
    required super.apiPassword,
    required super.createdAt,
  });

  factory ApiConfigurationModel.fromJson(Map<String, dynamic> json) {
    return ApiConfigurationModel(
      baseUrl: json['baseUrl'] as String,
      apiUsername: json['apiUsername'] as String,
      apiPassword: json['apiPassword'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'apiUsername': apiUsername,
      'apiPassword': apiPassword,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ApiConfigurationModel.fromEntity(ApiConfiguration entity) {
    return ApiConfigurationModel(
      baseUrl: entity.baseUrl,
      apiUsername: entity.apiUsername,
      apiPassword: entity.apiPassword,
      createdAt: entity.createdAt,
    );
  }
}
