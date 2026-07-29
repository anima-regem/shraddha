import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_panel.dart';

/// Floating frosted bottom sheet replacing showModalBottomSheet styling.
Future<T?> showGlassSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  final tokens = context.aurora;
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    elevation: 0,
    isScrollControlled: true,
    barrierColor: tokens.isDark
        ? Colors.black.withValues(alpha: 0.55)
        : const Color(0xFF1B1E33).withValues(alpha: 0.28),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: SafeArea(
        top: false,
        child: GlassPanel(
          blur: true,
          strong: true,
          radius: 30,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          glow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: sheetContext.aurora.textSecondary
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    ),
  );
}
