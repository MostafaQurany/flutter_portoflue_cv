import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';

class AboutSectionWidget extends StatelessWidget {
  const AboutSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (context) => const _AboutLayout(isDesktop: false),
      tabletBuilder: (context) => const _AboutLayout(isDesktop: false),
      desktopBuilder: (context) => const _AboutLayout(isDesktop: true),
    );
  }
}

class _AboutLayout extends StatelessWidget {
  const _AboutLayout({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final services = Column(
      children: const [
        _ServiceTile(
          icon: Icons.language_rounded,
          title: 'Website Development',
          description: 'Fast, maintainable websites with responsive structure and clear content hierarchy.',
          isLast: false,
        ),
        _ServiceTile(
          icon: Icons.phone_android_rounded,
          title: 'App Development',
          description: 'Flutter experiences that stay consistent across mobile, tablet, and web targets.',
          isLast: false,
        ),
        _ServiceTile(
          icon: Icons.cloud_done_rounded,
          title: 'Website Hosting',
          description: 'Deployment-ready builds, release discipline, and practical production preparation.',
          isLast: true,
        ),
      ],
    );

    final bio = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About me',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 18),
        Text(
          'I focus on structured Flutter applications, layered architecture, and interfaces that communicate value without noise. My work balances product clarity with engineering discipline so teams can ship quickly without sacrificing maintainability.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 28),
        const _StatsGrid(),
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
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(description, style: Theme.of(context).textTheme.bodyMedium),
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
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 640 ? 3 : 1;
        final aspectRatio = width > 640 ? 1.4 : 2.6;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
          children: const [
            _StatCard(value: '120+', label: 'Projects'),
            _StatCard(value: '95%', label: 'Client satisfaction'),
            _StatCard(value: '10+', label: 'Years of experience'),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final symbolIndex = value.indexOf(RegExp(r'[+%]'));
    final hasSymbol = symbolIndex != -1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineMedium,
                    children: [
                      TextSpan(
                        text: hasSymbol ? value.substring(0, symbolIndex) : value,
                      ),
                      if (hasSymbol)
                        TextSpan(
                          text: value.substring(symbolIndex),
                          style: const TextStyle(color: AppColors.primary),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 140,
                  child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
