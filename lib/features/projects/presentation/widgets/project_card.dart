import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/design_system/atoms/project_chip.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/project.dart';
import 'project_card_hero.dart';

class ProjectCard extends ConsumerWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.crossAxisCount,
  });

  final ProjectModel project;
  final int index;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompact = crossAxisCount == 1;
    final technologyPreviewCount = crossAxisCount == 1 ? 3 : 2;
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);
    final palette = context.palette;
    final detailsPath = RoutePaths.projectDetailsById(project.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(detailsPath),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectCardHero(project: project, compact: isCompact),
              SizedBox(height: isCompact ? 14 : 18),
              Text(
                project.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: isCompact ? 4 : 6),
              Text(
                project.title,
                maxLines: isCompact ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: isCompact ? 8 : 10),
              Text(
                project.cardDescription,
                maxLines: isCompact ? 3 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: isCompact ? 14 : 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.technologies
                    .take(technologyPreviewCount)
                    .map<Widget>(
                      (item) => ProjectChip(label: item, compact: true),
                    )
                    .toList(),
              ),
              SizedBox(height: isCompact ? 14 : 18),
              if (project.technologies.length > technologyPreviewCount)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '+${project.technologies.length - technologyPreviewCount} ${strings.moreTechnologies}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.textMuted),
                  ),
                ),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: isCompact ? double.infinity : 168,
                    child: OutlinedButton(
                      onPressed: () => context.push(detailsPath),
                      child: Text(strings.viewDetails),
                    ),
                  ),
                  if (_hasExternalLinks(project))
                    IconButton.filledTonal(
                      onPressed: () => _openPrimaryLink(context, strings),
                      icon: const Icon(Icons.open_in_new_rounded),
                      tooltip: 'Open project link',
                    ),
                ],
              ),
              if (!_hasExternalLinks(project))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    strings.moreInDetails,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.textMuted),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasExternalLinks(ProjectModel project) {
    return project.links.githubUrl.isNotEmpty ||
        project.links.googlePlay.isNotEmpty ||
        project.links.appStore.isNotEmpty;
  }

  Future<void> _openPrimaryLink(BuildContext context, AppStrings strings) async {
    final url = project.links.googlePlay.isNotEmpty
        ? project.links.googlePlay
        : project.links.appStore.isNotEmpty
        ? project.links.appStore
        : project.links.githubUrl;
    final uri = Uri.tryParse(url);

    if (uri == null || !await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.unableToOpenLink)),
        );
      }
    }
  }
}
