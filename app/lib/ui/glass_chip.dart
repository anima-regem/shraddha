import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_panel.dart';
import 'pressable.dart';

/// Small tinted pill — tags, count badges and selectable choice chips.
class GlassChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  const GlassChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    final tint = color ?? AppColors.primary;

    Widget chip;
    if (selected) {
      chip = Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          boxShadow: auroraGlow(AppColors.primary, alpha: 0.4),
        ),
        child: _content(context, Colors.white),
      );
    } else {
      chip = Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: onTap != null
              ? tokens.glassFill
              : tint.withValues(alpha: tokens.isDark ? 0.16 : 0.14),
          border: Border.all(
            color: onTap != null
                ? tokens.strokeBottom
                : tint.withValues(alpha: 0.3),
          ),
        ),
        child: _content(context, onTap != null ? tokens.textPrimary : tint),
      );
    }

    return onTap != null ? Pressable(onTap: onTap, child: chip) : chip;
  }

  Widget _content(BuildContext context, Color fg) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 5),
        ],
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
