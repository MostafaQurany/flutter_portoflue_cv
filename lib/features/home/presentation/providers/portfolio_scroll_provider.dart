import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/portfolio_scroll_controller.dart';

final portfolioScrollControllerProvider = Provider<PortfolioScrollController>((ref) {
  final controller = PortfolioScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});
