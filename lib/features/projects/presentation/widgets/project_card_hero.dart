import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/project.dart';
import 'project_image.dart';

class ProjectCardHero extends StatelessWidget {
  const ProjectCardHero({
    super.key,
    required this.project,
    this.compact = false,
  });

  final ProjectModel project;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      height: compact ? 152 : 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primarySoft, palette.surfaceMuted],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: compact ? -12 : -18,
            right: compact ? -12 : -18,
            child: Container(
              width: compact ? 72 : 92,
              height: compact ? 72 : 92,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: ProjectImage(
                      imagePath: project.logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: compact ? 8 : 12),
                Text(
                  project.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
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
