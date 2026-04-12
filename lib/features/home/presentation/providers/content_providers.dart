import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/assets/json_asset_loader.dart';
import '../../domain/contact_content.dart';
import '../../domain/profile_content.dart';

const _profileAssetPath = 'assets/data/profile.json';
const _contactAssetPath = 'assets/data/contact.json';

final jsonAssetLoaderProvider = Provider<JsonAssetLoader>((ref) {
  return const JsonAssetLoader();
});

final profileContentProvider = FutureProvider<ProfileContent>((ref) async {
  final loader = ref.watch(jsonAssetLoaderProvider);
  final json = await loader.loadMap(_profileAssetPath);
  return ProfileContent.fromJson(json);
});

final contactContentProvider = FutureProvider<ContactContent>((ref) async {
  final loader = ref.watch(jsonAssetLoaderProvider);
  final json = await loader.loadMap(_contactAssetPath);
  return ContactContent.fromJson(json);
});
