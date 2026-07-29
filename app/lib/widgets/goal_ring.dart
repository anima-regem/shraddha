import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Animated circular progress ring with a gradient sweep and a subtle
/// celebratory glow once the goal is reached.
class GoalRing extends StatelessWidget {
  final double progress; // 0..1
  final double size;
  final Widget? center;

  const GoalRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    final complete = progress >= 1.0;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: complete
              ? [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.45),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]
              : const [],
        ),
        child: CustomPaint(
          size: Size.square(size),
          painter: _RingPainter(
            value: value,
            complete: complete,
            trackColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.08),
          ),
          child: SizedBox.square(
            dimension: size,
            child: Center(child: center),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final bool complete;
  final Color trackColor;

  _RingPainter({
    required this.value,
    required this.complete,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.09;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.width - stroke) / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (value <= 0) return;

    final sweep = 2 * math.pi * value;
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + 2 * math.pi,
      colors: complete
          ? const [AppColors.success, Color(0xFF82A892), AppColors.success]
          : const [AppColors.primary, AppColors.accent, AppColors.primary],
      transform: const GradientRotation(-math.pi / 2),
    );
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.complete != complete;
}
