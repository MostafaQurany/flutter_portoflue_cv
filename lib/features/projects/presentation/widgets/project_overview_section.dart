import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ProjectOverviewSection extends StatelessWidget {
  const ProjectOverviewSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: palette.textMuted,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}
