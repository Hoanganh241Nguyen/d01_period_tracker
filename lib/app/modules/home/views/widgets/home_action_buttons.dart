import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/app_assets.dart';
import '../../../../utils/l10n.dart';
import '../../../../widgets/app_svg_icon.dart';
import '../../controllers/home_controller.dart';
import 'home_sheets.dart';

class HomeActionButtons extends GetView<HomeController> {
  const HomeActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _HomeActionButton(
            assetPath: AppAssets.homeAnalysis,
            label: l10n.homeActionCycleAnalysis,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            onTap: () => controller.selectTab(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HomeActionButton(
            assetPath: AppAssets.homeSymptom,
            label: l10n.homeActionAddSymptoms,
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.primary,
            onTap: () =>
                showDailyLogSheet(context, section: l10n.homeSectionSymptoms),
          ),
        ),
      ],
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  const _HomeActionButton({
    required this.assetPath,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final String assetPath;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSvgIcon(assetPath, color: foregroundColor, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
