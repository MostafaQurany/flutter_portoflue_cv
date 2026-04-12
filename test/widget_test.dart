import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_portoflue_cv/app.dart';
import 'package:flutter_portoflue_cv/core/routing/app_router.dart';
import 'package:flutter_portoflue_cv/core/routing/route_paths.dart';
import 'package:flutter_portoflue_cv/core/assets/json_asset_loader.dart';
import 'package:flutter_portoflue_cv/features/admin/presentation/providers/admin_session_provider.dart';
import 'package:flutter_portoflue_cv/features/home/presentation/providers/content_providers.dart';

class TestJsonAssetLoader extends JsonAssetLoader {
  const TestJsonAssetLoader();

  @override
  Future<Map<String, dynamic>> loadMap(String assetPath) async {
    if (assetPath == 'assets/data/profile.json') {
      return {
        'greeting': 'Hello',
        'name': "I'm Jensen",
        'role': 'Software Developer',
        'summary': 'Profile summary',
        'primaryCtaLabel': 'Got a project?',
        'secondaryCtaLabel': 'My resume',
        'stats': [
          {'value': '120+', 'label': 'Projects'},
          {'value': '95%', 'label': 'Client satisfaction'},
          {'value': '10+', 'label': 'Years of experience'},
        ],
        'techStack': ['Flutter', 'Dart'],
        'services': [
          {'title': 'Website Development', 'description': 'desc', 'icon': 'language'},
        ],
        'aboutTitle': 'About me',
        'aboutSummary': 'About summary',
      };
    }

    return {
      'title': "Let's build something solid",
      'summary': 'Contact summary',
      'items': [
        {'type': 'email', 'label': 'jensen.dev@mail.com'},
      ],
      'infoCards': [
        {'title': 'Delivery approach', 'description': 'desc'},
      ],
    };
  }

  @override
  Future<List<dynamic>> loadList(String assetPath) async {
    return [
      {
        'title': 'Commerce Dashboard',
        'description': 'Project description',
        'githubUrl': 'https://github.com/example/commerce-dashboard',
        'stack': ['Flutter'],
      },
    ];
  }
}

void main() {
  testWidgets('home page renders portfolio content', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: ProviderScope(
          overrides: [
            jsonAssetLoaderProvider.overrideWith((ref) => const TestJsonAssetLoader()),
          ],
          child: const PortfolioApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsWidgets);
    expect(find.text('Selected projects'), findsOneWidget);
  });

  testWidgets('protected admin route redirects to login when signed out', (
    tester,
  ) async {
    late GoRouter router;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: ProviderScope(
          overrides: [
            adminSessionProvider.overrideWith(
              (ref) => AdminSessionNotifier(),
            ),
            jsonAssetLoaderProvider.overrideWith((ref) => const TestJsonAssetLoader()),
            routerConfigProvider.overrideWith((ref) {
              router = ref.watch(appRouterProvider);
              return router;
            }),
          ],
          child: const PortfolioApp(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    router.go(RoutePaths.adminAddProject);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Admin login'), findsOneWidget);
    expect(find.text('Enter admin area'), findsOneWidget);
  });
}
