import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/project.dart';
import '../providers/projects_provider.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  const ProjectDetailsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: projectsAsync.when(
        data: (projects) {
          final index = int.tryParse(projectId);
          if (index == null || index < 0 || index >= projects.length) {
            return const Center(
              child: Text(
                'Project not found.',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            );
          }

          final project = projects[index];
          return _ProjectDetailsLayout(project: project);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const Center(
          child: Text(
            'Unable to load project details.',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailsLayout extends StatelessWidget {
  const _ProjectDetailsLayout({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: project.stack
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 32),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 48),
          
          if (project.screenshots.isNotEmpty) ...[
            Text(
              'Screenshots',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 400,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: project.screenshots.length,
                separatorBuilder: (context, index) => const SizedBox(width: 24),
                itemBuilder: (context, index) {
                  return Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      project.screenshots[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: Icon(Icons.broken_image_rounded, size: 48, color: AppColors.textMuted),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
          
          const SizedBox(height: 64),
          if (project.githubUrl.isNotEmpty) ...[
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.tryParse(project.githubUrl);
                  if (uri != null) {
                    await launchUrl(uri);
                  }
                },
                icon: const Icon(Icons.code_rounded),
                label: const Text('View Repository'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                ),
              ),
            ),
          ],
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
