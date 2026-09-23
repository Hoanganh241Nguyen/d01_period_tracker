import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../services/cycle_service.dart';
import '../../../../utils/constants/app_assets.dart';
import '../../../../utils/l10n.dart';
import '../../../../widgets/app_svg_icon.dart';
import '../../../cycle_phase/phase_content.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Obx(() {
      final info = CycleService.to.todayInfo.value;
      // Without data, show a general fact; otherwise the current phase's tip.
      final tip = info == null ? null : PhaseContent.of(info, l10n).tips.first;
      return _buildCard(context, colorScheme, l10n, tip, hasData: info != null);
    });
  }

  Widget _buildCard(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    PhaseTip? tip, {
    required bool hasData,
  }) {
    return Card(
      color: colorScheme.surface.withValues(alpha: 0.90),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSvgIcon(
              AppAssets.homeTip,
              size: 24,
              color: colorScheme.tertiary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip?.title ?? l10n.homeTipTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tip?.subtitle ?? l10n.homeTipBody,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => Get.toNamed<void>(
                        hasData ? Routes.cyclePhase : Routes.logPeriod,
                      ),
                      child: Text(l10n.homeTipSeeMore),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
