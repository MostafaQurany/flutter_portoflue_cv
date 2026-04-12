import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/pages/add_project_screen.dart';
import '../../features/admin/presentation/pages/admin_login_screen.dart';
import '../../features/admin/presentation/providers/admin_session_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'route_paths.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(adminSessionProvider);

  return GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.adminLogin,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.adminAddProject,
        builder: (context, state) => const AddProjectScreen(),
      ),
    ],
    redirect: (context, state) {
      final onProtectedAdminRoute =
          state.matchedLocation == RoutePaths.adminAddProject;
      final onLoginRoute = state.matchedLocation == RoutePaths.adminLogin;

      if (onProtectedAdminRoute && !session.isAuthenticated) {
        return RoutePaths.adminLogin;
      }

      if (onLoginRoute && session.isAuthenticated) {
        return RoutePaths.adminAddProject;
      }

      return null;
    },
  );
});
