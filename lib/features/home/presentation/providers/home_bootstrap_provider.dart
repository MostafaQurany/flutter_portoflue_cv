import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../projects/presentation/providers/projects_provider.dart';
import 'content_providers.dart';

final homeBootstrapProvider = FutureProvider<void>((ref) async {
  await Future.wait([
    ref.watch(profileContentProvider.future),
    ref.watch(contactContentProvider.future),
    ref.watch(projectsProvider.future),
  ]);
});
