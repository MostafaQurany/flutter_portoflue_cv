import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

final routerConfigProvider = Provider<GoRouter>((ref) {
  return ref.watch(appRouterProvider);
});

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key, this.router});

  final GoRouter? router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedRouter = router ?? ref.watch(routerConfigProvider);

    return MaterialApp.router(
      title: 'Mostafa Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: resolvedRouter,
    );
  }
}
