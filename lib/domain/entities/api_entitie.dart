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
}
