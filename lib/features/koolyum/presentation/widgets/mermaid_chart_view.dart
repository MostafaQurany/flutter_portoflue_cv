import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MermaidChartView extends StatelessWidget {
  const MermaidChartView({
    super.key,
    required this.source,
    required this.height,
  });

  final String source;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final diagram = _FlowchartDiagram.parse(source);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.surface, palette.surfaceMuted],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Flow',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pan and zoom the drawn architecture map below.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: palette.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          if (diagram.nodes.isEmpty)
            _SourceFallback(source: source)
          else
            _FlowchartCanvas(
              diagram: diagram,
              minHeight: height,
            ),
          const SizedBox(height: 18),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            iconColor: Theme.of(context).colorScheme.primary,
            collapsedIconColor: palette.textMuted,
            title: Text(
              'Source flowchart TD',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
            children: [
              const SizedBox(height: 10),
              _SourceFallback(source: source),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlowchartCanvas extends StatelessWidget {
  const _FlowchartCanvas({
    required this.diagram,
    required this.minHeight,
  });

  final _FlowchartDiagram diagram;
  final double minHeight;

  static const double _nodeWidth = 220;
  static const double _nodeHeight = 96;
  static const double _horizontalGap = 110;
  static const double _verticalGap = 42;
  static const double _padding = 28;

  @override
  Widget build(BuildContext context) {
    final layout = _FlowchartLayout.build(
      diagram: diagram,
      nodeWidth: _nodeWidth,
      nodeHeight: _nodeHeight,
      horizontalGap: _horizontalGap,
      verticalGap: _verticalGap,
      padding: _padding,
      minHeight: minHeight,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: math.max(minHeight, layout.size.height),
        decoration: BoxDecoration(
          color: context.palette.background.withValues(alpha: 0.7),
        ),
        child: InteractiveViewer(
          constrained: false,
          minScale: 0.7,
          maxScale: 1.8,
          boundaryMargin: const EdgeInsets.all(80),
          child: SizedBox(
            width: layout.size.width,
            height: layout.size.height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _FlowchartPainter(
                      layout: layout,
                      palette: context.palette,
                      colorScheme: Theme.of(context).colorScheme,
                    ),
                  ),
                ),
                ...layout.nodeRects.entries.map(
                  (entry) => Positioned(
                    left: entry.value.left,
                    top: entry.value.top,
                    width: entry.value.width,
                    height: entry.value.height,
                    child: _DiagramNodeCard(node: entry.key),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiagramNodeCard extends StatelessWidget {
  const _DiagramNodeCard({required this.node});

  final _FlowNode node;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: palette.shadow.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                node.label,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              node.id,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: palette.textMuted,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowchartPainter extends CustomPainter {
  const _FlowchartPainter({
    required this.layout,
    required this.palette,
    required this.colorScheme,
  });

  final _FlowchartLayout layout;
  final AppThemePalette palette;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = palette.border.withValues(alpha: 0.25)
      ..strokeWidth = 1;
    const gridStep = 28.0;
    for (double x = 0; x <= size.width; x += gridStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += gridStep) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final linePaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.95)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashedPaint = Paint()
      ..color = palette.textMuted.withValues(alpha: 0.75)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final link in layout.links) {
      final sourceRect = layout.nodeRects[link.source]!;
      final targetRect = layout.nodeRects[link.target]!;
      final start = Offset(sourceRect.right, sourceRect.center.dy);
      final end = Offset(targetRect.left, targetRect.center.dy);
      final midX = (start.dx + end.dx) / 2;

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(midX - 14, start.dy)
        ..quadraticBezierTo(midX, start.dy, midX, start.dy + _bend(start.dy, end.dy))
        ..lineTo(midX, end.dy - _bend(start.dy, end.dy))
        ..quadraticBezierTo(midX, end.dy, midX + 14, end.dy)
        ..lineTo(end.dx, end.dy);

      canvas.drawPath(path, linePaint);
      _drawArrowHead(canvas, linePaint, end);

      if (link.label != null && link.label!.isNotEmpty) {
        _drawLabel(
          canvas,
          link.label!,
          Offset(midX, (start.dy + end.dy) / 2 - 18),
          dashedPaint,
        );
      }
    }
  }

  double _bend(double startY, double endY) {
    final delta = (endY - startY).abs();
    return math.min(math.max(delta / 4, 8), 28);
  }

  void _drawArrowHead(Canvas canvas, Paint paint, Offset end) {
    const size = 8.0;
    final path = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(end.dx - size, end.dy - size / 2)
      ..moveTo(end.dx, end.dy)
      ..lineTo(end.dx - size, end.dy + size / 2);
    canvas.drawPath(path, paint);
  }

  void _drawLabel(Canvas canvas, String text, Offset center, Paint helperPaint) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: palette.textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 180);

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: textPainter.width + 18,
        height: textPainter.height + 10,
      ),
      const Radius.circular(12),
    );

    canvas.drawRRect(
      rect,
      Paint()..color = palette.surface.withValues(alpha: 0.92),
    );
    canvas.drawRRect(rect, helperPaint);
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _FlowchartPainter oldDelegate) {
    return oldDelegate.layout != layout ||
        oldDelegate.palette != palette ||
        oldDelegate.colorScheme != colorScheme;
  }
}

class _SourceFallback extends StatelessWidget {
  const _SourceFallback({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(
          source,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            color: palette.textMuted,
            height: 1.55,
          ),
        ),
      ),
    );
  }
}

class _FlowchartLayout {
  const _FlowchartLayout({
    required this.size,
    required this.nodeRects,
    required this.links,
  });

  final Size size;
  final Map<_FlowNode, Rect> nodeRects;
  final List<_LaidOutLink> links;

  static _FlowchartLayout build({
    required _FlowchartDiagram diagram,
    required double nodeWidth,
    required double nodeHeight,
    required double horizontalGap,
    required double verticalGap,
    required double padding,
    required double minHeight,
  }) {
    final levels = _computeLevels(diagram);
    final grouped = <int, List<_FlowNode>>{};
    for (final node in diagram.nodes) {
      grouped.putIfAbsent(levels[node.id] ?? 0, () => <_FlowNode>[]).add(node);
    }

    final sortedLevels = grouped.keys.toList()..sort();
    final nodeRects = <_FlowNode, Rect>{};
    final maxRows = grouped.values.fold<int>(0, (max, group) => math.max(max, group.length));

    for (var levelIndex = 0; levelIndex < sortedLevels.length; levelIndex++) {
      final level = sortedLevels[levelIndex];
      final nodes = grouped[level]!;
      final x = padding + levelIndex * (nodeWidth + horizontalGap);
      final totalHeight = nodes.length * nodeHeight + (nodes.length - 1) * verticalGap;
      final baseY = math.max(padding, (math.max(minHeight, totalHeight + padding * 2) - totalHeight) / 2);

      for (var row = 0; row < nodes.length; row++) {
        final y = baseY + row * (nodeHeight + verticalGap);
        nodeRects[nodes[row]] = Rect.fromLTWH(x, y, nodeWidth, nodeHeight);
      }
    }

    final width = padding * 2 +
        (sortedLevels.isEmpty ? 0 : sortedLevels.length * nodeWidth + (sortedLevels.length - 1) * horizontalGap);
    final height = math.max(
      minHeight,
      padding * 2 + maxRows * nodeHeight + math.max(0, maxRows - 1) * verticalGap,
    );

    final links = <_LaidOutLink>[];
    for (final source in diagram.nodes) {
      final outgoing = diagram.linksBySource[source.id] ?? const <_FlowLink>[];
      for (final link in outgoing) {
        final target = diagram.nodeById[link.targetId];
        if (target == null) {
          continue;
        }
        links.add(
          _LaidOutLink(
            source: source,
            target: target,
            label: link.label,
          ),
        );
      }
    }

    return _FlowchartLayout(
      size: Size(width, height),
      nodeRects: nodeRects,
      links: links,
    );
  }

  static Map<String, int> _computeLevels(_FlowchartDiagram diagram) {
    final indegree = <String, int>{for (final node in diagram.nodes) node.id: 0};
    for (final links in diagram.linksBySource.values) {
      for (final link in links) {
        indegree[link.targetId] = (indegree[link.targetId] ?? 0) + 1;
      }
    }

    final levels = <String, int>{};
    final queue = <String>[
      ...indegree.entries.where((entry) => entry.value == 0).map((entry) => entry.key),
    ];
    for (final id in queue) {
      levels[id] = 0;
    }

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      final currentLevel = levels[current] ?? 0;
      for (final link in diagram.linksBySource[current] ?? const <_FlowLink>[]) {
        final nextLevel = currentLevel + 1;
        if ((levels[link.targetId] ?? -1) < nextLevel) {
          levels[link.targetId] = nextLevel;
        }
        indegree[link.targetId] = (indegree[link.targetId] ?? 1) - 1;
        if (indegree[link.targetId] == 0) {
          queue.add(link.targetId);
        }
      }
    }

    for (final node in diagram.nodes) {
      levels.putIfAbsent(node.id, () => 0);
    }
    return levels;
  }
}

class _FlowchartDiagram {
  const _FlowchartDiagram({
    required this.nodes,
    required this.linksBySource,
    required this.nodeLabels,
    required this.nodeById,
  });

  final List<_FlowNode> nodes;
  final Map<String, List<_FlowLink>> linksBySource;
  final Map<String, String> nodeLabels;
  final Map<String, _FlowNode> nodeById;

  static _FlowchartDiagram parse(String source) {
    final lines = source
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && !line.startsWith('flowchart'))
        .toList(growable: false);

    final nodeLabels = <String, String>{};
    final linksBySource = <String, List<_FlowLink>>{};
    final order = <String>[];

    for (final line in lines) {
      if (!line.contains('-->')) {
        continue;
      }

      final sourceId = _extractSourceId(line);
      final targetId = _extractTargetId(line);
      if (sourceId == null || targetId == null) {
        continue;
      }

      final sourceLabel = _extractNodeLabel(sourceId, line, source: true) ?? sourceId;
      final targetLabel = _extractNodeLabel(targetId, line, source: false) ?? targetId;
      nodeLabels[sourceId] = sourceLabel;
      nodeLabels[targetId] = targetLabel;

      if (!order.contains(sourceId)) {
        order.add(sourceId);
      }
      if (!order.contains(targetId)) {
        order.add(targetId);
      }

      final label = _extractLinkLabel(line);
      linksBySource.putIfAbsent(sourceId, () => <_FlowLink>[]).add(
            _FlowLink(targetId: targetId, label: label),
          );
    }

    final nodes = order
        .map((id) => _FlowNode(id: id, label: nodeLabels[id] ?? id))
        .toList(growable: false);

    return _FlowchartDiagram(
      nodes: nodes,
      linksBySource: linksBySource,
      nodeLabels: nodeLabels,
      nodeById: {for (final node in nodes) node.id: node},
    );
  }

  static String? _extractSourceId(String line) {
    final match = RegExp(r'^([A-Za-z0-9_]+)').firstMatch(line);
    return match?.group(1);
  }

  static String? _extractTargetId(String line) {
    final match = RegExp(r'-->\s*(?:\|[^|]+\|\s*)?([A-Za-z0-9_]+)').firstMatch(line);
    return match?.group(1);
  }

  static String? _extractLinkLabel(String line) {
    final match = RegExp(r'-->\s*\|([^|]+)\|').firstMatch(line);
    return match?.group(1)?.trim();
  }

  static String? _extractNodeLabel(String id, String line, {required bool source}) {
    final pattern = source
        ? RegExp('^$id(?:\\[|\\(|\\{)(.+?)(?:\\]|\\)|\\})')
        : RegExp('$id(?:\\[|\\(|\\{)(.+?)(?:\\]|\\)|\\})');
    final match = pattern.firstMatch(line);
    return match?.group(1)?.replaceAll('<br>', ' ').trim();
  }
}

class _FlowNode {
  const _FlowNode({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

class _FlowLink {
  const _FlowLink({
    required this.targetId,
    required this.label,
  });

  final String targetId;
  final String? label;
}

class _LaidOutLink {
  const _LaidOutLink({
    required this.source,
    required this.target,
    required this.label,
  });

  final _FlowNode source;
  final _FlowNode target;
  final String? label;
}
