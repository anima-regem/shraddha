import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Slowly drifting, low-contrast slate light behind every screen. The
/// restrained tones keep the glass material visible without competing with
/// study content.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _AuroraPainter(
            t: _controller.value,
            bg: tokens.bg,
            orbs: [tokens.orb1, tokens.orb2, tokens.orb3],
            opacity: tokens.orbOpacity,
          ),
        ),
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double t;
  final Color bg;
  final List<Color> orbs;
  final double opacity;

  _AuroraPainter({
    required this.t,
    required this.bg,
    required this.orbs,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = bg);

    final phase = t * 2 * math.pi;
    // Anchor + wander parameters per orb (fractions of screen size).
    final specs = [
      (anchor: const Offset(0.15, 0.12), wander: 0.10, speed: 1.0, r: 0.62),
      (anchor: const Offset(0.92, 0.42), wander: 0.12, speed: -0.7, r: 0.55),
      (anchor: const Offset(0.30, 0.95), wander: 0.09, speed: 0.5, r: 0.58),
    ];

    for (var i = 0; i < orbs.length; i++) {
      final spec = specs[i];
      final a = phase * spec.speed + i * 2.1;
      final center = Offset(
        (spec.anchor.dx + math.cos(a) * spec.wander) * size.width,
        (spec.anchor.dy + math.sin(a * 1.3) * spec.wander) * size.height,
      );
      final radius = size.shortestSide * spec.r;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orbs[i].withValues(alpha: opacity),
            orbs[i].withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.bg != bg;
}
