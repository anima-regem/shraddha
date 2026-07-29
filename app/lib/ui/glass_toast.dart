import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'glass_panel.dart';

OverlayEntry? _activeToast;

/// Overlay-based frosted toast replacing SnackBar. Auto-dismisses.
void showGlassToast(
  BuildContext context,
  String message, {
  IconData icon = Icons.auto_awesome_rounded,
  Color color = AppColors.primarySoft,
}) {
  _activeToast?.remove();
  _activeToast = null;

  final overlay = Overlay.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (overlayContext) => _GlassToast(
      message: message,
      icon: icon,
      color: color,
      onDone: () {
        if (_activeToast == entry) _activeToast = null;
        entry.remove();
      },
    ),
  );
  _activeToast = entry;
  overlay.insert(entry);
}

class _GlassToast extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback onDone;

  const _GlassToast({
    required this.message,
    required this.icon,
    required this.color,
    required this.onDone,
  });

  @override
  State<_GlassToast> createState() => _GlassToastState();
}

class _GlassToastState extends State<_GlassToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(const Duration(milliseconds: 2600), () async {
      await _controller.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    return Positioned(
      left: 24,
      right: 24,
      bottom: 100 + MediaQuery.viewPaddingOf(context).bottom,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _controller,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.6), end: Offset.zero)
                .animate(curved),
            child: GlassPanel(
              blur: true,
              strong: true,
              radius: 20,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              glow: auroraGlow(widget.color, alpha: 0.25),
              child: Row(
                children: [
                  Icon(widget.icon, size: 20, color: widget.color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.aurora.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
