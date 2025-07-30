import 'dart:convert';

class DistraUser {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final int accessLevel;
  final int isActive;

  const DistraUser({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.accessLevel,
    required this.isActive,
  });

  DistraUser copyWith({
    int? id,
    String? name,
    String? email,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    int? accessLevel,
    int? isActive,
  }) {
    return DistraUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accessLevel: accessLevel ?? this.accessLevel,
      isActive: isActive ?? this.isActive,
    );
  }

  factory DistraUser.fromMap(Map<String, dynamic> map) {
    return DistraUser(
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

  factory DistraUser.fromJson(String source) => DistraUser.fromMap(json.decode(source));
}
