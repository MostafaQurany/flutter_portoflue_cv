import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final profileContentAsync = ref.watch(profileContentProvider);

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
                    margin: const EdgeInsets.only(right: 12),
                  ),
                  Text(content.name, style: theme.textTheme.displayMedium),
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
                      color: Colors.white,
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
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
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
                          color: primaryColor.withOpacity(0.15),
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
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ).animate(delay: 900.ms).fadeIn(duration: 800.ms).scale(),
                  
                  // Decorative accents (Chevrons)
                  Positioned(
                    left: 0,
                    top: 80,
                    child: Text('<', style: TextStyle(color: primaryColor.withOpacity(0.5), fontSize: 40, fontWeight: FontWeight.w300)),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 60,
                    child: Text('>', style: TextStyle(color: primaryColor.withOpacity(0.5), fontSize: 40, fontWeight: FontWeight.w300)),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: textContent,
                  ),
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error loading profile: $err')),
        );
      },
    );
  }
}
