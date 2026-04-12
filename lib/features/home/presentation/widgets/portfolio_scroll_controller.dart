import 'package:flutter/widgets.dart';

import '../../domain/portfolio_section.dart';

class PortfolioScrollController {
  PortfolioScrollController();

  final scrollController = ScrollController();
  final Map<PortfolioSection, GlobalKey> sectionKeys = {
    for (final section in PortfolioSection.values) section: GlobalKey(),
  };

  Future<void> scrollTo(PortfolioSection section) async {
    final context = sectionKeys[section]?.currentContext;
    if (context == null) {
      return;
    }

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  void dispose() {
    scrollController.dispose();
  }
}
