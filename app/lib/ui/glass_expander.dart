import 'package:flutter/material.dart';

import '../core/haptics.dart';
import '../core/theme.dart';
import 'glass_panel.dart';
import 'pressable.dart';

/// Custom expansion tile: glass panel with an AnimatedSize reveal.
class GlassExpander extends StatefulWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget child;

  const GlassExpander({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  State<GlassExpander> createState() => _GlassExpanderState();
}

class _GlassExpanderState extends State<GlassExpander> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return GlassPanel(
      padding: EdgeInsets.zero,
      radius: 20,
      child: Column(
        children: [
          Pressable(
            onTap: () {
              Haptics.tap();
              setState(() => _open = !_open);
            },
            pressedScale: 0.99,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  widget.leading,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          maxLines: _open ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: tokens.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _open
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: widget.child,
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
