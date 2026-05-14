import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
      loading: () => const SizedBox.shrink(),
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
                  item: item,
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
  const _ContactChip({required this.item});

  final ContactItem item;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final actionUri = _buildActionUri(item);
    final canOpen = actionUri != null;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _contactIcon(item.type),
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: SelectableText(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Copy',
              child: IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => _copyValue(context),
                icon: const Icon(Icons.content_copy_rounded, size: 18),
              ),
            ),
            if (canOpen)
              Tooltip(
                message: 'Open',
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _openValue(context, actionUri),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyValue(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: item.label));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${item.label}')),
    );
  }

  Future<void> _openValue(BuildContext context, Uri? actionUri) async {
    if (actionUri == null) {
      return;
    }

    final didLaunch = await launchUrl(actionUri);
    if (didLaunch || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unable to open ${item.label}')),
    );
  }
}

Uri? _buildActionUri(ContactItem item) {
  final value = item.label.trim();

  return switch (item.type) {
    'email' => Uri(
        scheme: 'mailto',
        path: value,
      ),
    'phone' => Uri(
        scheme: 'tel',
        path: value,
      ),
    'linkedin' || 'github' => Uri.tryParse(
        value.startsWith('http') ? value : 'https://$value',
      ),
    'location' => Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: '/maps/search/',
        queryParameters: {'api': '1', 'query': value},
      ),
    _ => null,
  };
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
