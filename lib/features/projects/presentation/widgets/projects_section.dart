import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../../domain/project.dart';
import '../providers/projects_provider.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return projectsAsync.when(
      data: (projects) => AnimatedReveal(
        delay: const Duration(milliseconds: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected projects',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Each entry now pulls from the enriched project dataset, including logos, platform links, longer descriptions, and technology stacks.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ResponsiveBuilder(
              mobileBuilder: (context) =>
                  _ProjectsGrid(crossAxisCount: 1, projects: projects),
              tabletBuilder: (context) =>
                  _ProjectsGrid(crossAxisCount: 2, projects: projects),
              desktopBuilder: (context) =>
                  _ProjectsGrid(crossAxisCount: 3, projects: projects),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text(
        'Unable to load projects data.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.crossAxisCount, required this.projects});

  final int crossAxisCount;
  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    final aspectRatio = switch (crossAxisCount) {
      1 => 0.72,
      2 => 0.68,
      _ => 0.66,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push('/project/$index'),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProjectCardHero(project: project),
                  const SizedBox(height: 18),
                  Text(
                    project.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project.cardDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies
                        .take(crossAxisCount == 1 ? 3 : 2)
                        .map<Widget>(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(item),
                          ),
                        )
                        .toList(),
                  ),
                  const Spacer(),
                  if (project.technologies.length > (crossAxisCount == 1 ? 3 : 2))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '+${project.technologies.length - (crossAxisCount == 1 ? 3 : 2)} more technologies',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/project/$index'),
                          child: const Text('View details'),
                        ),
                      ),
                      if (_hasExternalLinks(project)) ...[
                        const SizedBox(width: 12),
                        IconButton.filledTonal(
                          onPressed: () => _openPrimaryLink(context, project),
                          icon: const Icon(Icons.open_in_new_rounded),
                          tooltip: 'Open project link',
                        ),
                      ],
                    ],
                  ),
                  if (!_hasExternalLinks(project))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'More in details page.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _hasExternalLinks(ProjectModel project) {
    return project.links.githubUrl.isNotEmpty ||
        project.links.googlePlay.isNotEmpty ||
        project.links.appStore.isNotEmpty;
  }

  Future<void> _openPrimaryLink(BuildContext context, ProjectModel project) async {
    final url = project.links.googlePlay.isNotEmpty
        ? project.links.googlePlay
        : project.links.appStore.isNotEmpty
            ? project.links.appStore
            : project.links.githubUrl;
    final uri = Uri.tryParse(url);

    if (uri == null || !await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open project link.')),
        );
      }
    }
  }
}

class _ProjectCardHero extends StatelessWidget {
  const _ProjectCardHero({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primarySoft, AppColors.surfaceMuted],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -18,
            right: -18,
            child: Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: _ProjectImage(
                      imagePath: project.logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  project.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
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

class _ProjectImage extends StatelessWidget {
  const _ProjectImage({required this.imagePath, this.fit = BoxFit.cover});

  final String imagePath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final normalizedPath = imagePath.startsWith('assets/')
        ? imagePath.substring('assets/'.length)
        : imagePath;

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const _ProjectImageFallback(
          label: 'Image unavailable',
        ),
      );
    }

    return Image.asset(
      normalizedPath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const _ProjectImageFallback(
        label: 'Asset missing',
      ),
    );
  }
}

class _ProjectImageFallback extends StatelessWidget {
  const _ProjectImageFallback({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.photo_library_outlined,
            color: AppColors.textMuted,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
