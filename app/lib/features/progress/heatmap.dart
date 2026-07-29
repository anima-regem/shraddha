import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/stats_logic.dart';

/// GitHub-style contribution heatmap in aurora colors. Scrollable
/// horizontally, most recent week on the right. High-intensity cells glow.
/// Tapping a cell reveals its date + count below.
class ActivityHeatmap extends StatefulWidget {
  final Map<DateTime, int> byDay;
  final int weeks;

  const ActivityHeatmap({super.key, required this.byDay, this.weeks = 26});

  @override
  State<ActivityHeatmap> createState() => _ActivityHeatmapState();
}

class _ActivityHeatmapState extends State<ActivityHeatmap> {
  DateTime? _selected;

  static const _cell = 14.0;
  static const _gap = 3.0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    final today = dateOnly(DateTime.now());
    final totalDays = widget.weeks * 7;
    final gridEnd = today.add(Duration(days: 6 - (today.weekday - 1) % 7));
    final gridStart = gridEnd.subtract(Duration(days: totalDays - 1));

    final columns = <Widget>[];
    for (var w = 0; w < widget.weeks; w++) {
      final cells = <Widget>[];
      for (var d = 0; d < 7; d++) {
        final day = gridStart.add(Duration(days: w * 7 + d));
        if (day.isAfter(today)) {
          cells.add(const SizedBox(width: _cell, height: _cell));
        } else {
          final count = widget.byDay[day] ?? 0;
          final level = heatLevel(count);
          final selected = _selected == day;
          cells.add(
            GestureDetector(
              onTap: () {
                Haptics.tap();
                setState(() => _selected = selected ? null : day);
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 250 + w * 18),
                curve: Curves.easeOutBack,
                builder: (context, v, child) => Transform.scale(
                  scale: v.clamp(0.0, 1.0),
                  child: child,
                ),
                child: Container(
                  width: _cell,
                  height: _cell,
                  decoration: BoxDecoration(
                    color: level == 0
                        ? tokens.heatEmpty
                        : tokens.heatScale[level],
                    borderRadius: BorderRadius.circular(3.5),
                    border: selected
                        ? Border.all(color: AppColors.accent, width: 1.6)
                        : null,
                    boxShadow: level >= 3
                        ? [
                            BoxShadow(
                              color: tokens.heatScale[level]
                                  .withValues(alpha: 0.55),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          );
        }
        if (d < 6) cells.add(const SizedBox(height: _gap));
      }
      columns.add(Column(mainAxisSize: MainAxisSize.min, children: cells));
      if (w < widget.weeks - 1) columns.add(const SizedBox(width: _gap));
    }

    final selectedCount = _selected == null ? 0 : (widget.byDay[_selected] ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(children: columns),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.4),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: _selected == null
              ? _Legend(key: const ValueKey('legend'))
              : Row(
                  key: ValueKey(_selected),
                  children: [
                    const Icon(Icons.event_rounded,
                        size: 16, color: AppColors.primarySoft),
                    const SizedBox(width: 6),
                    Text(
                      '${DateFormat('d MMM yyyy').format(_selected!)} — '
                      '$selectedCount ${selectedCount == 1 ? 'review' : 'reviews'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: tokens.textPrimary,
                          ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return Row(
      children: [
        Text('Less', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 6),
        for (var i = 0; i < 5; i++) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: i == 0 ? tokens.heatEmpty : tokens.heatScale[i],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(width: 3),
        ],
        const SizedBox(width: 3),
        Text('More', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
