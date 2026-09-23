import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../services/cycle_service.dart';
import '../../../../utils/constants/app_assets.dart';
import '../../controllers/home_controller.dart';
import '../../../cycle_phase/phase_content.dart';
import '../../../../utils/l10n.dart';
import '../../../../widgets/app_svg_icon.dart';

class StatusCards extends StatelessWidget {
  const StatusCards({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Obx(() {
      final cycle = CycleService.to;
      final info = cycle.todayInfo.value;
      // The hero already invites the user to log a first period.
      if (info == null) return const SizedBox.shrink();
      final content = PhaseContent.of(info, l10n);

      return Column(
        children: [
          StatusTile(
            assetPath: AppAssets.homeCycleDay,
            title: l10n.homeStatusCycleDay(info.cycleDay),
            subtitle: l10n.homeStatusAverageCycle(
              l10n.commonDays(cycle.averageCycleLength),
            ),
            // Cycle stats live on the insights tab.
            onTap: () => Get.find<HomeController>().selectTab(2),
          ),
          const SizedBox(height: 10),
          StatusTile(
            assetPath: AppAssets.homePhase,
            title: content.name,
            subtitle: phaseStatusLine(info, l10n),
            onTap: () => Get.toNamed<void>(Routes.cyclePhase),
          ),
        ],
      );
    });
  }
}

class StatusTile extends StatelessWidget {
  const StatusTile({
    super.key,
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String assetPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        minVerticalPadding: 10,
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.primary,
          child: AppSvgIcon(assetPath, size: 22, color: colorScheme.primary),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(subtitle),
        trailing: AppSvgIcon(
          AppAssets.homeChevronRight,
          size: 22,
          color: colorScheme.outline,
        ),
        onTap: onTap,
      ),
    );
  }
}
