import 'package:flutter/material.dart';

import '../../../../utils/constants/app_assets.dart';
import '../../../../utils/l10n.dart';
import '../../../../widgets/app_svg_icon.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.todayLabel,
    required this.onCalendarPressed,
  });

  final String todayLabel;
  final VoidCallback onCalendarPressed;

  static String _greeting(AppLocalizations l10n, int hour) => hour < 12
      ? l10n.homeGreetingMorning
      : hour < 18
      ? l10n.homeGreetingAfternoon
      : l10n.homeGreetingEvening;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(context.l10n, DateTime.now().hour),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                todayLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 44,
          height: 44,
          child: IconButton(
            tooltip: context.l10n.homeOpenCalendarTooltip,
            onPressed: onCalendarPressed,
            icon: const AppSvgIcon(AppAssets.homeCalendarButton, size: 22),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surface.withValues(alpha: 0.92),
            ),
          ),
        ),
      ],
    );
  }
}
