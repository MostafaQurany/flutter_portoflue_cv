import 'package:flutter/material.dart';

import '../../../../core/design_system/atoms/project_chip.dart';

class ProjectTechnologyWrap extends StatelessWidget {
  const ProjectTechnologyWrap({super.key, required this.technologies});

  final List<String> technologies;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technology stack',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: technologies
              .map<Widget>((item) => ProjectChip(label: item))
              .toList(),
        ),
      ],
    );
  }
}
