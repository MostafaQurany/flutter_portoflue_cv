import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/admin_session.dart';

class AdminSessionNotifier extends StateNotifier<AdminSession> {
  AdminSessionNotifier()
      : super(
          AdminSession(
            isAuthenticated: false,
            isConfigured: _username.isNotEmpty && _password.isNotEmpty,
          ),
        );

  static const String _username = String.fromEnvironment(
    'PORTFOLIO_ADMIN_USERNAME',
  );
  static const String _password = String.fromEnvironment(
    'PORTFOLIO_ADMIN_PASSWORD',
  );

  bool signIn({
    required String username,
    required String password,
  }) {
    if (!state.isConfigured) {
      return false;
    }

    final isValidUser = username.trim() == _username;
    final isValidPassword = password == _password;
    if (!isValidUser || !isValidPassword) {
      return false;
    }

    state = state.copyWith(isAuthenticated: true);
    return true;
  }

  void signOut() {
    state = state.copyWith(isAuthenticated: false);
  }
}

final adminSessionProvider =
    StateNotifierProvider<AdminSessionNotifier, AdminSession>(
  (ref) => AdminSessionNotifier(),
);
