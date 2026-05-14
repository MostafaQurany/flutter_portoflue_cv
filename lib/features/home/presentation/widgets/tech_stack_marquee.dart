import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/content_providers.dart';

class TechStackMarquee extends ConsumerWidget {
  const TechStackMarquee({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileContent = ref.watch(profileContentProvider);
    final palette = context.palette;

    return profileContent.when(
      data: (content) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.border),
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: content.techStack
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: palette.backgroundAlt,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
