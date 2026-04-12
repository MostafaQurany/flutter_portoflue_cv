import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/project.dart';
import '../providers/projects_provider.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selected projects', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text(
          'A few recent builds that show how I structure products, interfaces, and maintainable delivery workflows.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        ResponsiveBuilder(
          mobileBuilder: (context) => _ProjectsGrid(crossAxisCount: 1, projects: projects),
          tabletBuilder: (context) => _ProjectsGrid(crossAxisCount: 2, projects: projects),
          desktopBuilder: (context) => _ProjectsGrid(crossAxisCount: 3, projects: projects),
        ),
      ],
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.crossAxisCount, required this.projects});

  final int crossAxisCount;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    final aspectRatio = switch (crossAxisCount) {
      1 => 0.98,
      2 => 0.82,
      _ => 0.78,
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [AppColors.primarySoft, AppColors.surfaceMuted],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    project.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 18),
                Text(project.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(project.description, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.stack
                      .map<Widget>(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _openRepository(context, project.githubUrl),
                  child: const Text('View repository'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openRepository(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null || !await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open repository link.')),
        );
      }
    }
  }
}
