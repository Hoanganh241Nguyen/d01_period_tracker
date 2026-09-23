import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    required this.assetPath,
    required this.child,
    this.overlayColor,
    super.key,
  });

  final String assetPath;
  final Widget child;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(assetPath, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            color: overlayColor ?? Colors.white.withValues(alpha: 0.48),
          ),
        ),
        child,
      ],
    );
  }
}
