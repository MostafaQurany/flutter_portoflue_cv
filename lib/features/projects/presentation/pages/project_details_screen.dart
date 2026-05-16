import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/design_system/molecules/project_info_card.dart';
import '../../../../core/design_system/molecules/project_link_button.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/project.dart';
import '../../../koolyum/presentation/pages/koolyum_project_details_page.dart';
import '../providers/projects_provider.dart';
import '../widgets/project_details_header.dart';
import '../widgets/project_overview_section.dart';
import '../widgets/project_screenshots_showcase.dart';
import '../widgets/project_technology_wrap.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  const ProjectDetailsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: palette.textPrimary,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }

            context.go(RoutePaths.home);
          },
        ),
      ),
      body: projectsAsync.when(
        data: (projects) {
          ProjectModel? project;
          for (final item in projects) {
            if (item.id == projectId) {
              project = item;
              break;
            }
          }

          if (project == null) {
            return Center(
              child: Text(
                strings.projectNotFound,
                style: TextStyle(color: palette.textPrimary),
              ),
            );
          }

          if (project.detailsType == ProjectDetailsType.externalServerEcosystem) {
            return KoolyumProjectDetailsPage(project: project);
          }

          return _ProjectDetailsLayout(project: project);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            strings.errorLoadingDetails,
            style: TextStyle(color: palette.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailsLayout extends StatelessWidget {
  const _ProjectDetailsLayout({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (context) => _ProjectDetailsContent(
        project: project,
        horizontalPadding: 20,
        screenshotHeight: 320,
      ),
      tabletBuilder: (context) => _ProjectDetailsContent(
        project: project,
        horizontalPadding: 28,
        screenshotHeight: 380,
      ),
      desktopBuilder: (context) => _ProjectDetailsContent(
        project: project,
        horizontalPadding: 48,
        screenshotHeight: 440,
      ),
    );
  }
}

class _ProjectDetailsContent extends ConsumerWidget {
  const _ProjectDetailsContent({
    required this.project,
    required this.horizontalPadding,
    required this.screenshotHeight,
  });

  final ProjectModel project;
  final double horizontalPadding;
  final double screenshotHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectDetailsHeader(project: project),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ProjectInfoCard(
                    title: strings.projectType,
                    value: project.subtitle,
                    icon: Icons.layers_outlined,
                  ),
                  ProjectInfoCard(
                    title: strings.technologyCount,
                    value: '${project.technologies.length} ${strings.tools}',
                    icon: Icons.memory_rounded,
                  ),
                  ProjectInfoCard(
                    title: strings.mediaItems,
                    value: '${project.screenshots.length} ${strings.screenshots}',
                    icon: Icons.photo_library_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ProjectOverviewSection(description: project.fullDescription),
              const SizedBox(height: 32),
              ProjectTechnologyWrap(technologies: project.technologies),
              if (_hasLinks(project)) ...[
                const SizedBox(height: 32),
                Text(
                  strings.projectLinks,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (project.links.googlePlay.isNotEmpty)
                      ProjectLinkButton(
                        label: 'Google Play',
                        icon: Icons.android_rounded,
                        url: project.links.googlePlay,
                      ),
                    if (project.links.appStore.isNotEmpty)
                      ProjectLinkButton(
                        label: 'App Store',
                        icon: Icons.phone_iphone_rounded,
                        url: project.links.appStore,
                      ),
                    if (project.links.githubUrl.isNotEmpty)
                      ProjectLinkButton(
                        label: 'GitHub',
                        icon: Icons.code_rounded,
                        url: project.links.githubUrl,
                      ),
                  ],
                ),
              ],
              if (project.screenshots.isNotEmpty) ...[
                const SizedBox(height: 48),
                ProjectScreenshotsShowcase(
                  screenshots: project.screenshots,
                  height: screenshotHeight,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _hasLinks(ProjectModel project) {
    return project.links.googlePlay.isNotEmpty ||
        project.links.appStore.isNotEmpty ||
        project.links.githubUrl.isNotEmpty;
  }
}
