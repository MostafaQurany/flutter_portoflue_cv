import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/assets/json_asset_loader.dart';
import '../../../../core/localization/app_locale.dart';
import '../../domain/contact_content.dart';
import '../../domain/profile_content.dart';

final jsonAssetLoaderProvider = Provider<JsonAssetLoader>((ref) {
  return const JsonAssetLoader();
});

final profileContentProvider = FutureProvider<ProfileContent>((ref) async {
  final loader = ref.watch(jsonAssetLoaderProvider);
  final locale = ref.watch(localeProvider);
  final suffix = locale == AppLocale.en ? 'en' : 'ar';
  final json = await loader.loadMap('assets/data/profile_$suffix.json');
  return ProfileContent.fromJson(json);
});

final contactContentProvider = FutureProvider<ContactContent>((ref) async {
  final loader = ref.watch(jsonAssetLoaderProvider);
  final locale = ref.watch(localeProvider);
  final suffix = locale == AppLocale.en ? 'en' : 'ar';
  final json = await loader.loadMap('assets/data/contact_$suffix.json');
  return ContactContent.fromJson(json);
});
