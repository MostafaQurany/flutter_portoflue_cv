import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/project.dart';
import 'project_image.dart';

class ProjectDetailsHeader extends StatelessWidget {
  const ProjectDetailsHeader({super.key, required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: palette.border),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.surface, palette.surfaceMuted],
        ),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: palette.border),
            ),
            child: ProjectImage(imagePath: project.logo, fit: BoxFit.contain),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.subtitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  project.title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  project.cardDescription,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
