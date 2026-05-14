import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../providers/projects_provider.dart';
import 'projects_grid.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);

    return projectsAsync.when(
      data: (projects) => AnimatedReveal(
        delay: const Duration(milliseconds: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.selectedProjects,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              strings.projectsSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ResponsiveBuilder(
              mobileBuilder: (context) =>
                  ProjectsGrid(crossAxisCount: 1, projects: projects),
              tabletBuilder: (context) =>
                  ProjectsGrid(crossAxisCount: 2, projects: projects),
              desktopBuilder: (context) =>
                  ProjectsGrid(crossAxisCount: 3, projects: projects),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => Text(
        strings.errorLoadingProjects,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
