import 'dart:convert';

import 'package:dsimcaf_1/domain/entities/distra_entitie.dart';

class DistraUserModel {

  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final int accessLevel;
  final int isActive;
  DistraUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.accessLevel,
    required this.isActive,
  });


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

  DistraUser toEntity() {
    return DistraUser(
      id: id,
      name: name,
      email: email,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      accessLevel: accessLevel,
      isActive: isActive,
    );
  }

  Map<String, dynamic> toMap() {
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

  factory DistraUserModel.fromMap(Map<String, dynamic> map) {
    return DistraUserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      emailVerifiedAt: map['email_verified_at'],
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      accessLevel: map['access_level']?.toInt() ?? 0,
      isActive: map['is_active']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DistraUserModel.fromJson(String source) => DistraUserModel.fromMap(json.decode(source));
}
