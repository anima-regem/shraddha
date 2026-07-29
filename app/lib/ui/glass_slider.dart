import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Custom slider: gradient active track + glowing thumb, optional
/// discrete divisions.
class GlassSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const GlassSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
  });

  void _handle(double dx, double width) {
    var ratio = (dx / width).clamp(0.0, 1.0);
    if (divisions != null && divisions! > 0) {
      ratio = (ratio * divisions!).round() / divisions!;
    }
    onChanged(min + ratio * (max - min));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    final ratio = ((value - min) / (max - min)).clamp(0.0, 1.0);
    const thumbSize = 24.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _handle(d.localPosition.dx, width),
          onHorizontalDragUpdate: (d) => _handle(d.localPosition.dx, width),
          child: SizedBox(
            height: 40,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: tokens.glassFill,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: tokens.strokeBottom, width: 0.8),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 60),
                  left: ratio * (width - thumbSize),
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                          color: AppColors.primarySoft, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.55),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
