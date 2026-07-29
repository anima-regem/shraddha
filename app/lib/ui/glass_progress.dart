import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Animated gradient progress bar replacing LinearProgressIndicator.
class GlassProgressBar extends StatelessWidget {
  final double value; // 0..1
  final double height;
  final List<Color> colors;

  const GlassProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.colors = const [AppColors.primary, AppColors.accent],
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Container(
        height: height,
        decoration: BoxDecoration(
          color: tokens.glassFill,
          borderRadius: BorderRadius.circular(height),
          border: Border.all(color: tokens.strokeBottom, width: 0.8),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: v,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height),
                gradient: LinearGradient(colors: colors),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rotating gradient arc replacing CircularProgressIndicator.
class AuroraSpinner extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const AuroraSpinner({super.key, this.size = 36, this.strokeWidth = 3.5});

  @override
  State<AuroraSpinner> createState() => _AuroraSpinnerState();
}

class _AuroraSpinnerState extends State<AuroraSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Transform.rotate(
        angle: _controller.value * 2 * math.pi,
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _ArcPainter(strokeWidth: widget.strokeWidth),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double strokeWidth;

  _ArcPainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [
          Color(0x00FFFFFF),
          AppColors.primary,
          AppColors.accent,
        ],
        stops: [0.15, 0.7, 1.0],
      ).createShader(rect);
    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      0.3,
      2 * math.pi * 0.78,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => false;
}
