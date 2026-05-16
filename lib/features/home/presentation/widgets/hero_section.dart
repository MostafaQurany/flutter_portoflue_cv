import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../../domain/portfolio_section.dart';
import '../providers/content_providers.dart';
import '../providers/portfolio_scroll_provider.dart';

class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  static final Uri _resumeUri = Uri.parse(
    'https://drive.google.com/file/d/12vhcLK7UiC5YUQNmFFE1iqo3cBDnqiUa/view?usp=sharing',
  );

  Future<void> _launchResume() async {
    if (await canLaunchUrl(_resumeUri)) {
      await launchUrl(_resumeUri, webOnlyWindowName: '_blank');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final palette = context.palette;
    final profileContentAsync = ref.watch(profileContentProvider);
    final currentLocale = ref.watch(localeProvider);
    final strings = AppStrings.of(currentLocale);
    final scrollController = ref.watch(portfolioScrollControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth <= 380;
        final isDesktop = constraints.maxWidth > 800;
        final avatarSize = isDesktop
            ? 300.0
            : isNarrow
            ? 188.0
            : 220.0;
        final outerRingSize = isDesktop
            ? 250.0
            : isNarrow
            ? 164.0
            : 190.0;
        final innerRingSize = isDesktop
            ? 200.0
            : isNarrow
            ? 132.0
            : 150.0;
        final imageMaxHeight = isDesktop
            ? 280.0
            : isNarrow
            ? 184.0
            : 210.0;
        final horizontalLineWidth = isDesktop ? 40.0 : 24.0;
        final contentAlignment = isDesktop
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center;
        final ctaAlignment = isDesktop
            ? WrapAlignment.start
            : WrapAlignment.center;
        final helloStyle = isNarrow
            ? theme.textTheme.displaySmall
            : theme.textTheme.displayLarge;
        final nameStyle = isNarrow
            ? theme.textTheme.headlineMedium
            : theme.textTheme.displayMedium;
        final roleStyle = isNarrow
            ? theme.textTheme.titleLarge
            : theme.textTheme.headlineSmall;
        final introGap = isNarrow ? 24.0 : 32.0;
        final contentSpacing = isNarrow ? 10.0 : 12.0;

        return profileContentAsync.when(
          data: (content) {
            final textContent = [
              AnimatedReveal(
                child: Wrap(
                  alignment: ctaAlignment,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 2,
                  children: [
                    Text(
                      content.greeting,
                      style: helloStyle,
                      textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                    ),
                    _HeroPulseDot(style: helloStyle),
                  ],
                ),
              ),

              SizedBox(height: isNarrow ? 6 : 8),

              AnimatedReveal(
                delay: const Duration(milliseconds: 90),
                child: Wrap(
                  alignment: ctaAlignment,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Container(
                      width: horizontalLineWidth,
                      height: 2,
                      color: primaryColor,
                      margin: EdgeInsets.only(
                        right: currentLocale == AppLocale.en ? 12 : 0,
                        left: currentLocale == AppLocale.ar ? 12 : 0,
                      ),
                    ),
                    Text(
                      content.name,
                      style: nameStyle,
                      textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: contentSpacing),

              AnimatedReveal(
                delay: const Duration(milliseconds: 160),
                child: Text(
                  content.role,
                  style: roleStyle?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
                  textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                ),
              ),

              SizedBox(height: contentSpacing),

              AnimatedReveal(
                delay: const Duration(milliseconds: 220),
                child: Text(
                  content.summary,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: palette.textMuted,
                    height: 1.6,
                  ),
                  textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                ),
              ),

              SizedBox(height: introGap),

              AnimatedReveal(
                delay: const Duration(milliseconds: 300),
                child: Wrap(
                  alignment: ctaAlignment,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          scrollController.scrollTo(PortfolioSection.contacts),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 18 : 24,
                          vertical: isNarrow ? 14 : 18,
                        ),
                      ),
                      child: Text(content.primaryCtaLabel),
                    ),
                    OutlinedButton(
                      onPressed: _launchResume,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: palette.textPrimary,
                        side: BorderSide(color: palette.border),
                        padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 18 : 24,
                          vertical: isNarrow ? 14 : 18,
                        ),
                      ),
                      child: Text(content.secondaryCtaLabel),
                    ),
                  ],
                ),
              ),
            ];

            final avatar = AnimatedReveal(
              delay: const Duration(milliseconds: 260),
              beginOffset: const Offset(0, 0.04),
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: outerRingSize,
                      height: outerRingSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: palette.heroGlow,
                            blurRadius: isNarrow ? 28 : 40,
                            spreadRadius: isNarrow ? 2 : 8,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: innerRingSize,
                      height: innerRingSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withValues(alpha: 0.14),
                      ),
                    ),

                    Positioned(
                      left: currentLocale == AppLocale.en ? 0 : null,
                      right: currentLocale == AppLocale.ar ? 0 : null,
                      top: isNarrow ? 56 : 80,
                      child: Text(
                        currentLocale == AppLocale.en ? '<' : '>',
                        style: TextStyle(
                          color: primaryColor.withValues(alpha: 0.45),
                          fontSize: isNarrow ? 28 : 40,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Positioned(
                      right: currentLocale == AppLocale.en ? 0 : null,
                      left: currentLocale == AppLocale.ar ? 0 : null,
                      bottom: isNarrow ? 42 : 60,
                      child: Text(
                        currentLocale == AppLocale.en ? '>' : '<',
                        style: TextStyle(
                          color: primaryColor.withValues(alpha: 0.45),
                          fontSize: isNarrow ? 28 : 40,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: isNarrow ? -20 : -30,
                    //   child: ConstrainedBox(
                    //     constraints: BoxConstraints(maxHeight: imageMaxHeight),
                    //     child: Image.asset(
                    //       'assets/images/me_nobg.png',
                    //       fit: BoxFit.contain,
                    //       errorBuilder: (context, error, stackTrace) =>
                    //           const Icon(Icons.person, size: 100),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );

            if (isDesktop) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: contentAlignment,
                      children: textContent,
                    ),
                  ),
                  const SizedBox(width: 24),
                  avatar,
                ],
              );
            }

            return Column(
              crossAxisAlignment: contentAlignment,
              children: [
                avatar,
                SizedBox(height: isNarrow ? 40 : 56),
                ...textContent,
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (err, stack) => Center(child: Text('${strings.error}: $err')),
        );
      },
    );
  }
}

class _HeroPulseDot extends StatefulWidget {
  const _HeroPulseDot({required this.style});

  final TextStyle? style;

  @override
  State<_HeroPulseDot> createState() => _HeroPulseDotState();
}

class _HeroPulseDotState extends State<_HeroPulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 1,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacity = Tween<double>(
      begin: 0.72,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Text(
          '.',
          style: widget.style?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
