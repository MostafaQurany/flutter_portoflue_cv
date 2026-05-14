import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/content_providers.dart';

class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  Future<void> _launchResume() async {
    final url = Uri.parse('assets/docs/resume.pdf');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;

        return profileContentAsync.when(
          data: (content) {
            final textContent = [
              // "Hello." with animated orange dot
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(content.greeting, style: theme.textTheme.displayLarge),
                  Text(
                        '.',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: primaryColor,
                        ),
                      )
                      .animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      )
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.2, 1.2),
                        duration: 1.seconds,
                      ),
                ],
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),

              // Horizontal line and Name
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Container(
                    width: 40,
                    height: 2,
                    color: primaryColor,
                    margin: EdgeInsets.only(
                      right: currentLocale == AppLocale.en ? 12 : 0,
                      left: currentLocale == AppLocale.ar ? 12 : 0,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      content.name,
                      style: theme.textTheme.displayMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 12),

              Text(
                    content.role,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 32),

              // Call to action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    child: Text(content.primaryCtaLabel),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: _launchResume,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: palette.textPrimary,
                      side: BorderSide(color: palette.border),
                    ),
                    child: Text(content.secondaryCtaLabel),
                  ),
                ],
              ).animate(delay: 600.ms).fadeIn(duration: 500.ms).scale(),
            ];

            // Custom Avatar layout resembling Jensen Omega design
            final avatar = SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Outer glowing circle
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: palette.heroGlow,
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ).animate(delay: 800.ms).fadeIn(duration: 800.ms).scale(),
                  
                  // Secondary concentric circle
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(alpha: 0.14),
                    ),
                  ).animate(delay: 900.ms).fadeIn(duration: 800.ms).scale(),
                  
                  // Decorative accents (Chevrons)
                  Positioned(
                    left: currentLocale == AppLocale.en ? 0 : null,
                    right: currentLocale == AppLocale.ar ? 0 : null,
                    top: 80,
                    child: Text(currentLocale == AppLocale.en ? '<' : '>', style: TextStyle(color: primaryColor.withValues(alpha: 0.5), fontSize: 40, fontWeight: FontWeight.w300)),
                  ),
                  Positioned(
                    right: currentLocale == AppLocale.en ? 0 : null,
                    left: currentLocale == AppLocale.ar ? 0 : null,
                    bottom: 60,
                    child: Text(currentLocale == AppLocale.en ? '>' : '<', style: TextStyle(color: primaryColor.withValues(alpha: 0.5), fontSize: 40, fontWeight: FontWeight.w300)),
                  ),

                  // User portrait (background-removed image)
                  Positioned(
                    bottom: -30, // Make image pop slightly out of the bottom bound
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: Image.asset(
                        'assets/images/me_nobg.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 100),
                      ),
                    ).animate(delay: 1100.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                  ),
                ],
              ),
            );

            if (isDesktop) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: textContent,
                    ),
                  ),
                  const SizedBox(width: 24),
                  avatar,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatar, 
                const SizedBox(height: 64), 
                ...textContent,
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator(color: primaryColor)),
          error: (err, stack) => Center(child: Text('${strings.error}: $err')),
        );
      },
    );
  }
}
