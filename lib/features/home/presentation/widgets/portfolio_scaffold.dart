import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class _TopNavigation extends StatelessWidget {
  const _TopNavigation({
    required this.isDesktop,
    required this.currentSection,
    required this.onSectionSelected,
  });

  final bool isDesktop;
  final PortfolioSection currentSection;
  final ValueChanged<PortfolioSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BrandMark(),
        const Spacer(),
        if (isDesktop)
          Wrap(
            spacing: 20,
            children: PortfolioSection.values
                .map(
                  (section) => TextButton(
                    onPressed: () => onSectionSelected(section),
                    child: Text(
                      section.label,
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
                )
                .toList(),
          )
        else
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.menu_rounded),
              );
            },
          ),
      ],
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
          TextSpan(text: 'Jensen'),
          TextSpan(
            text: '.',
            style: TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _PortfolioDrawer extends StatelessWidget {
  const _PortfolioDrawer({required this.onSectionSelected});

  final ValueChanged<PortfolioSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
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
                    title: Text(section.label),
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
                child: const Text('Admin access'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
