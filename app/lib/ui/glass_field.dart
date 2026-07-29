import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_panel.dart';

/// Frosted text input replacing the Material TextField decoration.
class GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final TextInputType? keyboardType;

  const GlassField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.aurora;
    return GlassPanel(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: tokens.textSecondary),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              autocorrect: false,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: tokens.textPrimary),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                hintText: hint,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                        color: tokens.textSecondary.withValues(alpha: 0.7)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
