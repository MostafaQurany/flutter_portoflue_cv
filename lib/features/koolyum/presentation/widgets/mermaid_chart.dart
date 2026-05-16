import 'package:flutter/widgets.dart';

import 'mermaid_chart_stub.dart'
    if (dart.library.html) 'mermaid_chart_web.dart' as platform;

class MermaidChart extends StatelessWidget {
  const MermaidChart({
    super.key,
    required this.source,
    this.height = 320,
  });

  final String source;
  final double height;

  @override
  Widget build(BuildContext context) {
    return platform.MermaidChartPlatform(source: source, height: height);
  }
}
