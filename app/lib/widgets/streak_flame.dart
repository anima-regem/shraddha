import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/theme.dart';

/// Pulsing flame with the current streak count.
class StreakFlame extends StatelessWidget {
  final int streak;
  final double iconSize;

  const StreakFlame({super.key, required this.streak, this.iconSize = 28});

  @override
  Widget build(BuildContext context) {
    final active = streak > 0;
    final color = active ? AppColors.warning : Colors.grey;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department_rounded,
                color: color, size: iconSize)
            .animate(
              onPlay: (c) => active ? c.repeat(reverse: true) : null,
            )
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.15, 1.15),
              duration: 700.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(width: 4),
        Text(
          '$streak',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
