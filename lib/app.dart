import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/localization/app_locale.dart';
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
    final currentAppLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Mostafa Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: resolvedRouter,
      locale: currentAppLocale.locale,
      supportedLocales: AppLocale.values.map((e) => e.locale).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: currentAppLocale.direction,
          child: child!,
        );
      },
    );
  }
}
