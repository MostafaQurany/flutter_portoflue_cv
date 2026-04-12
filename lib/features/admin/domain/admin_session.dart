class AdminSession {
  const AdminSession({required this.isAuthenticated});

  final bool isAuthenticated;

  AdminSession copyWith({bool? isAuthenticated}) {
    return AdminSession(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
