import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../ui/glass_panel.dart';

/// A glass slab that flips in 3D around the Y axis when [flipped] changes.
class FlipCard extends StatefulWidget {
  final String front;
  final String back;
  final String topic;
  final Color accent;
  final bool flipped;
  final VoidCallback onTap;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.topic,
    required this.accent,
    required this.flipped,
    required this.onTap,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: widget.flipped ? 1 : 0,
  );
  late final Animation<double> _angle = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutBack,
  );

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flipped != oldWidget.flipped) {
      widget.flipped ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _angle,
        builder: (context, _) {
          final angle = _angle.value * math.pi;
          final showBack = angle > math.pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _CardFace(
                      label: 'ANSWER',
                      text: widget.back,
                      topic: widget.topic,
                      accent: AppColors.success,
                      hint: 'How well did you know it?',
                    ),
                  )
                : _CardFace(
                    label: 'QUESTION',
                    text: widget.front,
                    topic: widget.topic,
                    accent: widget.accent,
                    hint: 'Tap to reveal',
                  ),
          );
        },
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final String label;
  final String text;
  final String topic;
  final Color accent;
  final String hint;

  const _CardFace({
    required this.label,
    required this.text,
    required this.topic,
    required this.accent,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return GlassPanel(
      blur: true,
      strong: true,
      radius: 30,
      tint: accent,
      padding: const EdgeInsets.all(24),
      glow: auroraGlow(accent, alpha: 0.30),
      child: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: accent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    topic,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                hint,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: tokens.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
