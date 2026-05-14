import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../../domain/contact_content.dart';
import '../providers/content_providers.dart';

class ContactSection extends ConsumerWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactContent = ref.watch(contactContentProvider);

    return contactContent.when(
      data: (content) => ResponsiveBuilder(
        mobileBuilder: (context) => AnimatedReveal(
          delay: const Duration(milliseconds: 180),
          child: _ContactLayout(isDesktop: false, content: content),
        ),
        tabletBuilder: (context) => AnimatedReveal(
          delay: const Duration(milliseconds: 180),
          child: _ContactLayout(isDesktop: false, content: content),
        ),
        desktopBuilder: (context) => AnimatedReveal(
          delay: const Duration(milliseconds: 180),
          child: _ContactLayout(isDesktop: true, content: content),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _ContactLayout extends StatelessWidget {
  const _ContactLayout({required this.isDesktop, required this.content});

  final bool isDesktop;
  final ContactContent content;

  @override
  Widget build(BuildContext context) {
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text(
          content.summary,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: content.items
              .map(
                (item) => _ContactChip(
                  icon: _contactIcon(item.type),
                  label: item.label,
                ),
              )
              .toList(growable: false),
        ),
      ],
    );

    final cards = Column(
      children: [
        for (var index = 0; index < content.infoCards.length; index++) ...[
          if (index > 0) const SizedBox(height: 16),
          _InfoCard(
            title: content.infoCards[index].title,
            description: content.infoCards[index].description,
          ),
        ],
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

IconData _contactIcon(String type) {
  return switch (type) {
    'email' => Icons.email_outlined,
    'phone' => Icons.call_outlined,
    'location' => Icons.location_on_outlined,
    _ => Icons.info_outline,
  };
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
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
