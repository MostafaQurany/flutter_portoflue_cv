import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/admin_session.dart';

class AdminSessionNotifier extends StateNotifier<AdminSession> {
  AdminSessionNotifier() : super(const AdminSession(isAuthenticated: false));

  void signIn() {
    state = state.copyWith(isAuthenticated: true);
  }

  void signOut() {
    state = state.copyWith(isAuthenticated: false);
  }
}

final adminSessionProvider =
    StateNotifierProvider<AdminSessionNotifier, AdminSession>(
  (ref) => AdminSessionNotifier(),
);
