import 'package:flutter/material.dart';

/// Custom page transition: fade-through with a gentle scale + rise.
Route<T> auroraRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.97, end: 1.0).animate(curved),
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.02), end: Offset.zero)
                .animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}
