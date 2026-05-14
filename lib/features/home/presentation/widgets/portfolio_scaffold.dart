import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/responsive/responsive_breakpoints.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_container.dart';
import '../../../../core/widgets/brand_mark.dart';
import '../../domain/portfolio_section.dart';
import '../providers/portfolio_scroll_provider.dart';

class PortfolioScaffold extends ConsumerWidget {
  const PortfolioScaffold({
    super.key,
    required this.child,
    this.currentSection = PortfolioSection.home,
  });

  final Widget child;
  final PortfolioSection currentSection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(portfolioScrollControllerProvider);
    final palette = context.palette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > ResponsiveBreakpoints.tabletMax;

        return Scaffold(
          endDrawer: isDesktop
              ? null
              : _PortfolioDrawer(
                  onSectionSelected: (section) => scrollController.scrollTo(section),
                ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [palette.pageGradientStart, palette.pageGradientEnd],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SectionContainer(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
                    child: _TopNavigation(
                      isDesktop: isDesktop,
                      currentSection: currentSection,
                      onSectionSelected: (section) => scrollController.scrollTo(section),
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopNavigation extends ConsumerWidget {
  const _TopNavigation({
    required this.isDesktop,
    required this.currentSection,
    required this.onSectionSelected,
  });

  final bool isDesktop;
  final PortfolioSection currentSection;
  final ValueChanged<PortfolioSection> onSectionSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Row(
      children: [
        const BrandMark(compact: true),
        const Spacer(),
        if (isDesktop)
          Wrap(
            spacing: 20,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...PortfolioSection.values.map(
                (section) => TextButton(
                  onPressed: () => onSectionSelected(section),
                  child: Text(
                    section.localizedLabel(currentLocale),
                    style: TextStyle(
                      color: section == currentSection
                          ? Theme.of(context).colorScheme.primary
                          : context.palette.textMuted,
                      fontWeight: section == currentSection
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const _ThemeToggle(),
              //_LanguageToggle(),
            ],
          )
        else
          Row(
            children: [
              const _ThemeToggle(compact: true),
             // _LanguageToggle(),
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.menu_rounded),
                  );
                },
              ),
            ],
          ),
      ],
    );
  }
}

class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return TextButton.icon(
      onPressed: () {
        ref.read(localeProvider.notifier).state =
            currentLocale == AppLocale.en ? AppLocale.ar : AppLocale.en;
      },
      icon: const Icon(Icons.language, size: 18),
      label: Text(
        currentLocale == AppLocale.en ? 'AR' : 'EN',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}

class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;
    final palette = context.palette;

    return compact
        ? IconButton.outlined(
            onPressed: () => ref.read(themeModeProvider.notifier).state =
                isDark ? ThemeMode.light : ThemeMode.dark,
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            style: IconButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(color: palette.border),
            ),
          )
        : TextButton.icon(
            onPressed: () => ref.read(themeModeProvider.notifier).state =
                isDark ? ThemeMode.light : ThemeMode.dark,
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            label: Text(
              isDark ? 'Light' : 'Dark',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          );
  }
}

class _PortfolioDrawer extends ConsumerWidget {
  const _PortfolioDrawer({required this.onSectionSelected});

  final ValueChanged<PortfolioSection> onSectionSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);

    return Drawer(
      backgroundColor: context.palette.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandMark(compact: true),
              const SizedBox(height: 24),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: _ThemeToggle(),
              ),
              const SizedBox(height: 16),
              ...PortfolioSection.values.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(section.localizedLabel(currentLocale)),
                    onTap: () {
                      Navigator.of(context).pop();
                      onSectionSelected(section);
                    },
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () => context.go(RoutePaths.adminLogin),
                child: Text(strings.adminAccess),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
