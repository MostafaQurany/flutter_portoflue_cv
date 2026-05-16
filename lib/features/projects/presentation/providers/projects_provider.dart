import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../home/presentation/providers/content_providers.dart';
import '../../domain/project.dart';

final projectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final loader = ref.watch(jsonAssetLoaderProvider);
  final locale = ref.watch(localeProvider);
  final suffix = locale == AppLocale.en ? 'en' : 'ar';
  final json = await loader.loadList('assets/data/projects_$suffix.json');

  final projects = json
      .whereType<Map<String, dynamic>>()
      .map(ProjectModel.fromJson)
      .toList(growable: false);

  final usedIds = <String>{};
  return projects.indexed.map((entry) {
    final index = entry.$1;
    final project = entry.$2;
    var normalizedId = project.id.trim();
    if (normalizedId.isEmpty || usedIds.contains(normalizedId)) {
      normalizedId = 'project-$index';
    }
    usedIds.add(normalizedId);
    if (normalizedId == project.id) {
      return project;
    }
    return project.copyWith(id: normalizedId);
  }).toList(growable: false);
});
