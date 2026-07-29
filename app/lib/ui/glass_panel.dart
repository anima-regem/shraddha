import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'pressable.dart';

/// The core glass surface: translucent fill, 1px gradient "refraction"
/// border, optional backdrop blur, optional color tint sheen and glow.
///
/// Keep [blur] false for panels inside scrolling lists (translucency alone
/// reads as glass over the aurora); reserve true for floating chrome
/// (dock, sheets, dialogs, cards that overlap content).
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final bool blur;
  final bool strong;
  final Color? tint;
  final List<BoxShadow>? glow;
  final VoidCallback? onTap;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.radius = 24,
    this.blur = false,
    this.strong = false,
    this.tint,
    this.glow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    final fill = strong ? tokens.glassFillStrong : tokens.glassFill;
    final sheen = tint ?? Colors.white;
    final innerRadius = BorderRadius.circular(radius - 1);

    Widget inner = Container(
      decoration: BoxDecoration(
        borderRadius: innerRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              sheen.withValues(alpha: tokens.isDark ? 0.035 : 0.08),
              fill,
            ),
            fill,
          ],
        ),
      ),
      child: Stack(
        children: [
          if (tint != null)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: innerRadius,
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.6,
                      colors: [
                        tint!.withValues(alpha: tokens.isDark ? 0.10 : 0.08),
                        tint!.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );

    if (blur) {
      inner = ClipRRect(
        borderRadius: innerRadius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: tokens.blurSigma,
            sigmaY: tokens.blurSigma,
          ),
          child: inner,
        ),
      );
    } else {
      inner = ClipRRect(borderRadius: innerRadius, child: inner);
    }

    Widget panel = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tint == null
                ? tokens.strokeTop
                : Color.alphaBlend(
                    tint!.withValues(alpha: 0.20),
                    tokens.strokeTop,
                  ),
            tokens.strokeBottom,
          ],
        ),
        boxShadow: glow,
      ),
      padding: const EdgeInsets.all(1),
      child: inner,
    );

    if (onTap != null) {
      panel = Pressable(onTap: onTap, child: panel);
    }
    return panel;
  }
}

/// Convenience shadows that retain depth without turning every accent into a
/// neon halo.
List<BoxShadow> auroraGlow(Color color, {double alpha = 0.35}) => [
  BoxShadow(
    color: color.withValues(alpha: alpha * 0.42),
    blurRadius: 18,
    spreadRadius: -2,
    offset: const Offset(0, 8),
  ),
];
