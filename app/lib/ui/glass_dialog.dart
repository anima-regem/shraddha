import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_panel.dart';

/// Frosted dialog replacing AlertDialog. [actions] are laid out in a row,
/// each expanded (pass GlassButtons).
Future<T?> showGlassDialog<T>({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  List<Widget> actions = const [],
}) {
  final tokens = context.aurora;
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: tokens.isDark
        ? Colors.black.withValues(alpha: 0.60)
        : const Color(0xFF1B1E33).withValues(alpha: 0.30),
    transitionDuration: const Duration(milliseconds: 240),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: Tween(begin: 0.9, end: 1.0).animate(curved), child: child),
      );
    },
    pageBuilder: (dialogContext, animation, secondaryAnimation) => SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: GlassPanel(
            blur: true,
            strong: true,
            radius: 28,
            padding: const EdgeInsets.all(22),
            glow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(dialogContext).textTheme.headlineSmall),
                  if (message != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      message,
                      style: Theme.of(dialogContext)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: dialogContext.aurora.textSecondary,
                            height: 1.45,
                          ),
                    ),
                  ],
                  if (content != null) ...[
                    const SizedBox(height: 12),
                    content,
                  ],
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        for (var i = 0; i < actions.length; i++) ...[
                          if (i > 0) const SizedBox(width: 10),
                          Expanded(child: actions[i]),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
