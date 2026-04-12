import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_portoflue_cv/app.dart';
import 'package:flutter_portoflue_cv/core/routing/app_router.dart';
import 'package:flutter_portoflue_cv/core/routing/route_paths.dart';
import 'package:flutter_portoflue_cv/features/admin/presentation/providers/admin_session_provider.dart';

void main() {
  testWidgets('home page renders portfolio content', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PortfolioApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('I\'m Jensen'), findsOneWidget);
    expect(find.text('Software Developer'), findsOneWidget);
    expect(find.text('Selected projects'), findsOneWidget);
  });

  testWidgets('protected admin route redirects to login when signed out', (
    tester,
  ) async {
    late GoRouter router;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminSessionProvider.overrideWith(
            (ref) => AdminSessionNotifier(),
          ),
          routerConfigProvider.overrideWith((ref) {
            router = ref.watch(appRouterProvider);
            return router;
          }),
        ],
        child: const PortfolioApp(),
      ),
    );
    await tester.pumpAndSettle();

    router.go(RoutePaths.adminAddProject);
    await tester.pumpAndSettle();

    expect(find.text('Admin login'), findsOneWidget);
    expect(find.text('Enter admin area'), findsOneWidget);
  });
}
