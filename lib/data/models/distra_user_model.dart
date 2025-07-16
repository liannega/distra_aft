import 'package:dsimcaf_1/data/models/auth_model.dart';

class DistraUserModel extends DistraUser {
  DistraUserModel({
    required super.id,
    required super.name,
    required super.email,
    super.emailVerifiedAt,
    required super.createdAt,
    required super.updatedAt,
    required super.accessLevel,
    required super.isActive,
  });

  factory DistraUserModel.fromJson(Map<String, dynamic> json) {
    return DistraUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      accessLevel: json['access_level'] as int,
      isActive: json['is_active'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'access_level': accessLevel,
      'is_active': isActive,
    };
  }

  factory DistraUserModel.fromEntity(DistraUser entity) {
    return DistraUserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      emailVerifiedAt: entity.emailVerifiedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      accessLevel: entity.accessLevel,
      isActive: entity.isActive,
    );
  }
}
