import 'package:flutter/material.dart';

import 'mermaid_chart_view.dart';

class MermaidChartPlatform extends StatelessWidget {
  const MermaidChartPlatform({
    super.key,
    required this.source,
    required this.height,
  });

  final String source;
  final double height;

  @override
  Widget build(BuildContext context) {
    return MermaidChartView(source: source, height: height);
  }
}
