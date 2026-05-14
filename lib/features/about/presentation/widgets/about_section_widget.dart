import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../../../home/domain/profile_content.dart';
import '../../../home/presentation/providers/content_providers.dart';

class AboutSectionWidget extends ConsumerWidget {
  const AboutSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileContent = ref.watch(profileContentProvider);

    return profileContent.when(
      data: (content) => ResponsiveBuilder(
        mobileBuilder: (context) => AnimatedReveal(
          child: _AboutLayout(isDesktop: false, content: content),
        ),
        tabletBuilder: (context) => AnimatedReveal(
          child: _AboutLayout(isDesktop: false, content: content),
        ),
        desktopBuilder: (context) => AnimatedReveal(
          child: _AboutLayout(isDesktop: true, content: content),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _AboutLayout extends StatelessWidget {
  const _AboutLayout({required this.isDesktop, required this.content});

  final bool isDesktop;
  final ProfileContent content;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final services = Column(
      children: [
        for (var index = 0; index < content.services.length; index++)
          _ServiceTile(
            icon: _iconFor(content.services[index].icon),
            title: content.services[index].title,
            description: content.services[index].description,
            isLast: index == content.services.length - 1,
          ),
      ],
    );

    final bio = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.aboutTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          content.aboutSummary,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.8,
            color: palette.textMuted,
          ),
        ),
        const SizedBox(height: 40),
        _StatsGrid(stats: content.stats),
      ],
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [services, const SizedBox(height: 32), bio],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: services),
        const SizedBox(width: 40),
        Expanded(child: bio),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.isLast,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator with orange dot and vertical line
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.primarySoft,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          // Icon
          Icon(icon, color: palette.textPrimary, size: 28),
          const SizedBox(width: 16),
          // Texts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final List<ProfileStat> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 48,
      runSpacing: 32,
      children: stats
          .map((stat) => _StatCard(value: stat.value, label: stat.label))
          .toList(growable: false),
    );
  }
}

IconData _iconFor(String iconName) {
  return switch (iconName) {
    'language' => Icons.code_rounded,
    'phone_android' => Icons.smartphone_rounded,
    'cloud_done' => Icons.cloud_queue_rounded,
    _ => Icons.circle_outlined,
  };
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final symbolIndex = value.indexOf(RegExp(r'[+%]'));
    final hasSymbol = symbolIndex != -1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.palette.textPrimary,
            ),
            children: [
              TextSpan(
                text: hasSymbol ? value.substring(0, symbolIndex) : value,
              ),
              if (hasSymbol)
                TextSpan(
                  text: value.substring(symbolIndex),
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 120, // Let the text wrap naturally below the large number
          child: Text(
            label, 
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.palette.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
