class AdminSession {
  const AdminSession({
    required this.isAuthenticated,
    required this.isConfigured,
  });

  final bool isAuthenticated;
  final bool isConfigured;

  AdminSession copyWith({
    bool? isAuthenticated,
    bool? isConfigured,
  }) {
    return AdminSession(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }
}
