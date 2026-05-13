import 'package:flutter/material.dart';

import '../../../../shared/presentation/widgets/safe_asset_image.dart';

class ProjectImage extends StatelessWidget {
  const ProjectImage({
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
  Widget build(BuildContext context) {
    return SafeAssetImage(
      imagePath: imagePath,
      fit: fit,
      assetErrorLabel: assetErrorLabel,
      networkErrorLabel: networkErrorLabel,
      loadingBuilder: loadingBuilder,
      onError: onError,
    );
  }
}
