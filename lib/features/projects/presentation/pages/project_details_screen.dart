import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_builder.dart';
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
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
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

          return _ProjectDetailsLayout(project: projects[index]);
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

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (context) => _ProjectDetailsContent(
        project: project,
        horizontalPadding: 20,
        screenshotHeight: 280,
      ),
      tabletBuilder: (context) => _ProjectDetailsContent(
        project: project,
        horizontalPadding: 28,
        screenshotHeight: 340,
      ),
      desktopBuilder: (context) => _ProjectDetailsContent(
        project: project,
        horizontalPadding: 48,
        screenshotHeight: 420,
      ),
    );
  }
}

class _ProjectDetailsContent extends StatelessWidget {
  const _ProjectDetailsContent({
    required this.project,
    required this.horizontalPadding,
    required this.screenshotHeight,
  });

  final ProjectModel project;
  final double horizontalPadding;
  final double screenshotHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroHeader(project: project),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _InfoCard(
                    title: 'Project type',
                    value: project.subtitle,
                    icon: Icons.layers_outlined,
                  ),
                  _InfoCard(
                    title: 'Technology count',
                    value: '${project.technologies.length} tools',
                    icon: Icons.memory_rounded,
                  ),
                  _InfoCard(
                    title: 'Media items',
                    value: '${project.screenshots.length} screenshots',
                    icon: Icons.photo_library_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Overview',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                project.fullDescription,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 32),
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
                children: project.technologies
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          item,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (_hasLinks(project)) ...[
                const SizedBox(height: 32),
                Text(
                  'Project links',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (project.links.googlePlay.isNotEmpty)
                      _LinkButton(
                        label: 'Google Play',
                        icon: Icons.android_rounded,
                        url: project.links.googlePlay,
                      ),
                    if (project.links.appStore.isNotEmpty)
                      _LinkButton(
                        label: 'App Store',
                        icon: Icons.phone_iphone_rounded,
                        url: project.links.appStore,
                      ),
                    if (project.links.githubUrl.isNotEmpty)
                      _LinkButton(
                        label: 'GitHub',
                        icon: Icons.code_rounded,
                        url: project.links.githubUrl,
                      ),
                  ],
                ),
              ],
              if (project.screenshots.isNotEmpty) ...[
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Screenshots',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      'Swipe to explore',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ScreenshotsGallery(
                  screenshots: project.screenshots,
                  screenshotHeight: screenshotHeight,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _hasLinks(ProjectModel project) {
    return project.links.googlePlay.isNotEmpty ||
        project.links.appStore.isNotEmpty ||
        project.links.githubUrl.isNotEmpty;
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surfaceMuted],
        ),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
            ),
            child: _ProjectImage(
              imagePath: project.logo,
              fit: BoxFit.contain,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.subtitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  project.title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  project.cardDescription,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  final String label;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _openUrl(context, url),
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null || !await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open $label link.')),
        );
      }
    }
  }
}

class _ScreenshotsGallery extends StatefulWidget {
  const _ScreenshotsGallery({
    required this.screenshots,
    required this.screenshotHeight,
  });

  final List<String> screenshots;
  final double screenshotHeight;

  @override
  State<_ScreenshotsGallery> createState() => _ScreenshotsGalleryState();
}

class _ScreenshotsGalleryState extends State<_ScreenshotsGallery> {
  late final PageController _pageController;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_pageController.hasClients) {
      return;
    }

    setState(() {
      _page = _pageController.page ?? _pageController.initialPage.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = _page.round().clamp(0, widget.screenshots.length - 1);
    final viewportFraction = _viewportFraction(context);
    final availableWidth = math.max(MediaQuery.sizeOf(context).width - 44, 280.0);
    final cardWidth = availableWidth * viewportFraction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            children: [
              SizedBox(
                height: widget.screenshotHeight + 52,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primarySoft,
                                  AppColors.background.withValues(alpha: 0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ),
                        PageView.builder(
                          controller: _pageController,
                          padEnds: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.screenshots.length,
                          itemBuilder: (context, index) {
                            final distance = (_page - index).abs();
                            final scale = 1 - (distance * 0.14).clamp(0.0, 0.14);
                            final translateX = (index - _page) * (cardWidth * 0.18);
                            final opacity = 1 - (distance * 0.35).clamp(0.0, 0.35);

                            return Transform.translate(
                              offset: Offset(translateX, 0),
                              child: Transform.scale(
                                scale: scale,
                                child: Opacity(
                                  opacity: opacity,
                                  child: Center(
                                    child: SizedBox(
                                      width: cardWidth,
                                      child: _ScreenshotCard(
                                        imagePath: widget.screenshots[index],
                                        index: index,
                                        screenshotHeight: widget.screenshotHeight,
                                        isActive: distance < 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _GalleryArrowButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: currentIndex > 0
                        ? () => _animateToPage(currentIndex - 1)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Screen ${currentIndex + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.screenshots.length} previews in this gallery',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Row(
                    children: List.generate(widget.screenshots.length, (index) {
                      final isActive = index == currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.only(left: 8),
                        width: isActive ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 14),
                  _GalleryArrowButton(
                    icon: Icons.arrow_forward_rounded,
                    onPressed: currentIndex < widget.screenshots.length - 1
                        ? () => _animateToPage(currentIndex + 1)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _viewportFraction(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 700) {
      return 0.88;
    }
    if (width < 1100) {
      return 0.54;
    }
    return 0.36;
  }
  Future<void> _animateToPage(int page) {
    return _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }
}

class _ScreenshotCard extends StatelessWidget {
  const _ScreenshotCard({
    required this.imagePath,
    required this.index,
    required this.screenshotHeight,
    required this.isActive,
  });

  final String imagePath;
  final int index;
  final double screenshotHeight;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: screenshotHeight + 12,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isActive
                ? const [AppColors.primarySoft, AppColors.surface]
                : const [AppColors.surfaceMuted, AppColors.surface],
          ),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isActive ? 0.28 : 0.18),
              blurRadius: isActive ? 28 : 16,
              offset: Offset(0, isActive ? 16 : 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _ProjectImage(
                imagePath: imagePath,
                fit: BoxFit.contain,
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    _DeviceDot(color: Colors.red.shade300),
                    const SizedBox(width: 6),
                    _DeviceDot(color: Colors.amber.shade300),
                    const SizedBox(width: 6),
                    _DeviceDot(color: Colors.green.shade300),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Screen ${index + 1}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Text(
                    isActive ? 'Focused preview' : 'Gallery preview',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryArrowButton extends StatelessWidget {
  const _GalleryArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        disabledBackgroundColor: AppColors.surfaceMuted,
        disabledForegroundColor: AppColors.textMuted,
      ),
    );
  }
}

class _DeviceDot extends StatelessWidget {
  const _DeviceDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ProjectImage extends StatelessWidget {
  const _ProjectImage({required this.imagePath, this.fit = BoxFit.cover});

  final String imagePath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final normalizedPath = imagePath.startsWith('assets/')
        ? imagePath.substring('assets/'.length)
        : imagePath;

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => const _ImageFallback(),
      );
    }

    return Image.asset(
      normalizedPath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const _ImageFallback(),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image_rounded,
        size: 44,
        color: AppColors.textMuted,
      ),
    );
  }
}
