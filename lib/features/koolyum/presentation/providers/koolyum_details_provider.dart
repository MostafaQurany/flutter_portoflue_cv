import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../home/presentation/providers/content_providers.dart';
import '../../domain/koolyum_details.dart';

final koolyumDetailsProvider = FutureProvider<KoolyumDetailsModel>((ref) async {
  final loader = ref.watch(jsonAssetLoaderProvider);
  final locale = ref.watch(localeProvider);
  final suffix = locale == AppLocale.en ? 'en' : 'ar';
  final json = await loader.loadMap('assets/data/koolyum_$suffix.json');
  return KoolyumDetailsModel.fromJson(json);
});
