import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/design_system/atoms/section_heading.dart';
import '../../../../core/theme/app_theme.dart';
import 'project_image.dart';

class ProjectScreenshotsShowcase extends StatefulWidget {
  const ProjectScreenshotsShowcase({
    super.key,
    required this.screenshots,
    required this.height,
  });

  final List<String> screenshots;
  final double height;

  @override
  State<ProjectScreenshotsShowcase> createState() =>
      _ProjectScreenshotsShowcaseState();
}

class _ProjectScreenshotsShowcaseState extends State<ProjectScreenshotsShowcase> {
  late List<String> _activeScreenshots;

  @override
  void initState() {
    super.initState();
    _activeScreenshots = List.from(widget.screenshots);
  }

  void _handleImageError(String path) {
    if (mounted) {
      setState(() {
        _activeScreenshots.remove(path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activeScreenshots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(title: 'App Preview'),
        const SizedBox(height: 24),
        SizedBox(
          height: widget.height,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: _activeScreenshots.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final path = _activeScreenshots[index];
                return GestureDetector(
                  onTap: () => _openFullscreen(context, index),
                  child: _PhoneFrame(
                    imagePath: path,
                    height: widget.height,
                    onError: () => _handleImageError(path),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, curve: Curves.easeOut);
  }

  void _openFullscreen(BuildContext context, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        pageBuilder: (_, __, ___) => _FullscreenViewer(
          screenshots: _activeScreenshots,
          initialIndex: index,
        ),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({
    required this.imagePath,
    required this.height,
    required this.onError,
  });

  final String imagePath;
  final double height;
  final VoidCallback onError;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final width = height * 0.46;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: palette.shadow.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: palette.backgroundAlt,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: ProjectImage(
            imagePath: imagePath,
            fit: BoxFit.cover,
            onError: onError,
          ),
        ),
      ),
    );
  }
}

class _FullscreenViewer extends StatefulWidget {
  const _FullscreenViewer({
    required this.screenshots,
    required this.initialIndex,
  });

  final List<String> screenshots;
  final int initialIndex;

  @override
  State<_FullscreenViewer> createState() => _FullscreenViewerState();
}

class _FullscreenViewerState extends State<_FullscreenViewer> {
  late final PageController _ctrl;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _ctrl = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.screenshots.length,
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ProjectImage(
                        imagePath: widget.screenshots[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: Colors.white, size: 32),
              style: IconButton.styleFrom(backgroundColor: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
