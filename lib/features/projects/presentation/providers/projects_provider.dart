import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../home/presentation/providers/content_providers.dart';
import '../../domain/project.dart';

final projectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final loader = ref.watch(jsonAssetLoaderProvider);
  final locale = ref.watch(localeProvider);
  final suffix = locale == AppLocale.en ? 'en' : 'ar';
  final json = await loader.loadList('assets/data/projects_$suffix.json');

  return json
      .whereType<Map<String, dynamic>>()
      .map(ProjectModel.fromJson)
      .toList(growable: false);
});
