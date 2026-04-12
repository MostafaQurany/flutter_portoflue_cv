import 'package:flutter/widgets.dart';

import 'responsive_breakpoints.dart';

typedef ResponsiveWidgetBuilder = Widget Function(BuildContext context);

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  final ResponsiveWidgetBuilder mobileBuilder;
  final ResponsiveWidgetBuilder? tabletBuilder;
  final ResponsiveWidgetBuilder? desktopBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width <= ResponsiveBreakpoints.mobileMax) {
          return mobileBuilder(context);
        }

        if (width <= ResponsiveBreakpoints.tabletMax) {
          return (tabletBuilder ?? desktopBuilder ?? mobileBuilder)(context);
        }

        return (desktopBuilder ?? tabletBuilder ?? mobileBuilder)(context);
      },
    );
  }
}
