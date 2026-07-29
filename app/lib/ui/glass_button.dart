import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_panel.dart';
import 'pressable.dart';

enum GlassButtonVariant { primary, glass, ghost, danger }

/// Custom button family. `primary` is a restrained tonal pill; `glass` is a
/// frosted pill; `ghost` is bare text; `danger` is red-tinted glass.
class GlassButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final GlassButtonVariant variant;
  final bool expand;
  final Widget? leading; // overrides icon (e.g. spinner)

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = GlassButtonVariant.primary,
    this.expand = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    final enabled = onPressed != null;

    final Color fg = switch (variant) {
      GlassButtonVariant.primary => Colors.white,
      GlassButtonVariant.glass => tokens.textPrimary,
      GlassButtonVariant.ghost => tokens.textSecondary,
      GlassButtonVariant.danger => AppColors.error,
    };

    final textStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: fg, letterSpacing: 0.2);

    final row = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    const pad = EdgeInsets.symmetric(horizontal: 22, vertical: 15);

    Widget button = switch (variant) {
      GlassButtonVariant.primary => Container(
        padding: pad,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.accent],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          boxShadow: enabled
              ? auroraGlow(AppColors.primary, alpha: 0.45)
              : null,
        ),
        child: row,
      ),
      GlassButtonVariant.glass => GlassPanel(
        padding: pad,
        radius: 18,
        strong: true,
        child: row,
      ),
      GlassButtonVariant.danger => GlassPanel(
        padding: pad,
        radius: 18,
        tint: AppColors.error,
        child: row,
      ),
      GlassButtonVariant.ghost => Padding(padding: pad, child: row),
    };

    button = Opacity(opacity: enabled ? 1 : 0.45, child: button);
    return Pressable(onTap: onPressed, child: button);
  }
}
