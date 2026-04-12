import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (context) => const _HeroColumnLayout(isDesktop: false),
      tabletBuilder: (context) => const _HeroColumnLayout(isDesktop: false),
      desktopBuilder: (context) => const _HeroColumnLayout(isDesktop: true),
    );
  }
}

class _HeroColumnLayout extends StatelessWidget {
  const _HeroColumnLayout({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final spacing = isDesktop ? 48.0 : 28.0;

    final textBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ).copyWith(color: AppColors.textPrimary).letSpan(
                [
                  const TextSpan(text: 'Hello'),
                  const TextSpan(
                    text: '.',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
        ),
        const SizedBox(height: 18),
        Text(
          'I\'m Jensen',
          style: isDesktop
              ? Theme.of(context).textTheme.displayLarge
              : Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Software Developer',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 18),
        Text(
          'I build deliberate digital products with clean architecture, resilient state, and interfaces that feel sharp on every screen.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Got a project?'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text('My resume'),
            ),
          ],
        ),
      ],
    );

    const avatarBlock = _ProfileAvatarWidget();

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBlock,
          SizedBox(height: spacing),
          avatarBlock,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: textBlock),
        SizedBox(width: spacing),
        const Expanded(flex: 5, child: _ProfileAvatarWidget()),
      ],
    );
  }
}

class _ProfileAvatarWidget extends StatelessWidget {
  const _ProfileAvatarWidget();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 28,
            right: 32,
            child: Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 42,
            child: Transform.rotate(
              angle: -0.15,
              child: Icon(
                Icons.double_arrow_rounded,
                size: 92,
                color: AppColors.textMuted.withValues(alpha: 0.22),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primarySoft, AppColors.surface],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.72,
            heightFactor: 0.72,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.62,
            heightFactor: 0.62,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                'J',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 92,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on TextStyle {
  TextSpan letSpan(List<InlineSpan> children) {
    return TextSpan(style: this, children: children);
  }
}
