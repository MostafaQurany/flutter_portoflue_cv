import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TechStackMarquee extends StatelessWidget {
  const TechStackMarquee({super.key});

  static const List<String> _items = [
    'HTML5',
    'CSS',
    'Javascript',
    'Node.js',
    'React',
    'Git',
    'Github',
    'Flutter',
    'Dart',
    'Docker',
    'FastAPI',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _items
            .map(
              (item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(999),
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
    );
  }
}
