import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/providers/content_providers.dart';
import '../../domain/project.dart';

const _projectsAssetPath = 'assets/data/projects.json';

final projectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final loader = ref.watch(jsonAssetLoaderProvider);
  final json = await loader.loadList(_projectsAssetPath);

  return json
      .whereType<Map<String, dynamic>>()
      .map(ProjectModel.fromJson)
      .toList(growable: false);
});
