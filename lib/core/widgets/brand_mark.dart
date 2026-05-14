import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  static const _svgPath = 'assets/images/my_prand/gemini-svg (1).svg';
  static const _pngPath = 'assets/images/my_prand/Code_Generated_Image (1).png';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final logoSize = compact ? 34.0 : 42.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize + 14,
          height: logoSize + 14,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.border),
            boxShadow: [
              BoxShadow(
                color: palette.shadow.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SvgPicture.asset(
            _svgPath,
            fit: BoxFit.contain,
            placeholderBuilder: (_) => Image.asset(_pngPath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mostafa Qurany',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
                height: 1,
              ),
            ),
            if (!compact)
              Text(
                'Flutter Mobile Developer',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
