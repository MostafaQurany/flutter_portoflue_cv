import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (context) => const _ContactLayout(isDesktop: false),
      tabletBuilder: (context) => const _ContactLayout(isDesktop: false),
      desktopBuilder: (context) => const _ContactLayout(isDesktop: true),
    );
  }
}

class _ContactLayout extends StatelessWidget {
  const _ContactLayout({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Let\'s build something solid', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text(
          'Available for product design reviews, Flutter delivery work, interface refreshes, and architecture cleanup for growing codebases.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _ContactChip(icon: Icons.email_outlined, label: 'jensen.dev@mail.com'),
            _ContactChip(icon: Icons.call_outlined, label: '+20 100 000 0000'),
            _ContactChip(icon: Icons.location_on_outlined, label: 'Remote / Cairo'),
          ],
        ),
      ],
    );

    final cards = Column(
      children: const [
        _InfoCard(
          title: 'Delivery approach',
          description: 'Feature-first Flutter structure, explicit states, small reusable widgets, and release-safe iteration.',
        ),
        SizedBox(height: 16),
        _InfoCard(
          title: 'Typical engagement',
          description: 'Portfolio sites, admin dashboards, mobile/web apps, and UI modernization with maintainable architecture.',
        ),
      ],
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [intro, const SizedBox(height: 24), cards],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: intro),
        const SizedBox(width: 24),
        Expanded(child: cards),
      ],
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
