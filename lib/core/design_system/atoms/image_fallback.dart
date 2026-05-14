import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ImageFallback extends StatelessWidget {
  const ImageFallback({
    super.key,
    required this.label,
    this.icon = Icons.photo_library_outlined,
    this.borderRadius = 16,
  });

  final String label;
  final IconData icon;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: palette.border),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: palette.textMuted, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}
