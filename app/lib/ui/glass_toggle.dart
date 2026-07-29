import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_panel.dart';
import 'pressable.dart';

/// Custom animated switch with a glowing gradient track when on.
class GlassToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GlassToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return Pressable(
      onTap: () => onChanged(!value),
      pressedScale: 0.94,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        width: 54,
        height: 32,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: value
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent])
              : null,
          color: value ? null : tokens.glassFillStrong,
          border: Border.all(
            color: value
                ? Colors.white.withValues(alpha: 0.3)
                : tokens.strokeBottom,
          ),
          boxShadow: value ? auroraGlow(AppColors.primary, alpha: 0.4) : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutBack,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? Colors.white
                  : tokens.textSecondary.withValues(alpha: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
