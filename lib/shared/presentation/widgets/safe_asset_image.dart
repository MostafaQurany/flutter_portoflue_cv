import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/design_system/atoms/image_fallback.dart';
import '../../../core/theme/app_theme.dart';

/// Displays an image from either a local asset path or a
/// network URL. Falls back to [ImageFallback] on error.
class SafeAssetImage extends StatefulWidget {
  const SafeAssetImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.assetErrorLabel = 'Asset missing',
    this.networkErrorLabel = 'Image unavailable',
    this.loadingBuilder,
    this.onError,
  });

  final String imagePath;
  final BoxFit fit;
  final String assetErrorLabel;
  final String networkErrorLabel;
  final ImageLoadingBuilder? loadingBuilder;
  final VoidCallback? onError;

  @override
  State<SafeAssetImage> createState() => _SafeAssetImageState();
}

class _SafeAssetImageState extends State<SafeAssetImage> {
  bool _errorFired = false;

  bool get _isNetworkImage => widget.imagePath.startsWith('http');

  void _fireErrorOnce() {
    if (!_errorFired) {
      _errorFired = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onError?.call(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: widget.imagePath,
        fit: widget.fit,
        placeholder: (context, url) => _buildShimmer(context),
        errorWidget: (context, url, error) {
          _fireErrorOnce();
          return Container(); //ImageFallback(label: widget.networkErrorLabel);
        },
        fadeInDuration: const Duration(milliseconds: 500),
        fadeOutDuration: const Duration(milliseconds: 300),
      );
    }

    return Image.asset(
      widget.imagePath,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        _fireErrorOnce();
        return Container(); //ImageFallback(label: widget.assetErrorLabel);
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final palette = context.palette;

    return Shimmer.fromColors(
      baseColor: palette.surface.withValues(alpha: 0.6),
      highlightColor: palette.border.withValues(alpha: 0.35),
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
