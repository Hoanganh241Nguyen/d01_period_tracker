import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavIcon extends StatelessWidget {
  const NavIcon({super.key, required this.assetPath, this.selected = false});

  final String assetPath;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SvgPicture.asset(
      assetPath,
      width: 28,
      height: 28,
      colorFilter: ColorFilter.mode(
        selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        BlendMode.srcIn,
      ),
    );
  }
}
