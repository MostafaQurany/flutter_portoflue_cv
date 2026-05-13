import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/responsive/responsive_breakpoints.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/section_container.dart';
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E232B), Color(0xFF171C23)],
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
        const _BrandMark(),
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
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontWeight: section == currentSection
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              _LanguageToggle(),
            ],
          )
        else
          Row(
            children: [
              _LanguageToggle(),
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
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        );

    return RichText(
      text: TextSpan(
        style: style,
        children: const [
          TextSpan(text: 'Mostafa'),
          TextSpan(
            text: '.',
            style: TextStyle(color: AppColors.primary),
          ),
        ],
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
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BrandMark(),
              const SizedBox(height: 24),
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
