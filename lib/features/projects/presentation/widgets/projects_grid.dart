import 'package:flutter/material.dart';

import '../../domain/project.dart';
import 'project_card.dart';

class ProjectsGrid extends StatelessWidget {
  const ProjectsGrid({
    super.key,
    required this.crossAxisCount,
    required this.projects,
  });

  final int crossAxisCount;
  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      return Column(
        children: [
          for (var index = 0; index < projects.length; index++) ...[
            if (index > 0) const SizedBox(height: 18),
            ProjectCard(
              project: projects[index],
              index: index,
              crossAxisCount: crossAxisCount,
            ),
          ],
        ],
      );
    }

    final aspectRatio = switch (crossAxisCount) {
      2 => 0.74,
      _ => 0.72,
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
        return ProjectCard(
          project: projects[index],
          index: index,
          crossAxisCount: crossAxisCount,
        );
      },
    );
  }
}
