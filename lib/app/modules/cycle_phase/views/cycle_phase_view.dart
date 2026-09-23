import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/l10n.dart';
import '../../../widgets/no_cycle_data_card.dart';
import '../controllers/cycle_phase_controller.dart';
import '../phase_content.dart';
import 'widgets/conception_card.dart';
import 'widgets/phase_cards.dart';
import 'widgets/phase_hero.dart';
import 'widgets/phase_timeline.dart';

class CyclePhaseView extends GetView<CyclePhaseController> {
  const CyclePhaseView({super.key});

  static const _bg = Color(0xFFFFF4F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Image.asset(
              AppAssets.bgMedicalInfo,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _bg.withValues(alpha: 0.2),
                    _bg.withValues(alpha: 0.9),
                    _bg,
                  ],
                  stops: const [0, 0.3, 0.5],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Obx(() {
              final info = controller.info;
              final topBar = SliverToBoxAdapter(
                child: _TopBar(
                  isToday: controller.isToday,
                  date: controller.selectedDate,
                  onBack: Get.back,
                  onToday: controller.backToToday,
                ),
              );
              if (info == null) {
                return CustomScrollView(
                  slivers: [
                    topBar,
                    const SliverPadding(
                      padding: EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(child: NoCycleDataCard()),
                    ),
                  ],
                );
              }
              final content = PhaseContent.of(info, context.l10n);

              return CustomScrollView(
                slivers: [
                  topBar,
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    sliver: SliverList.list(
                      children: [
                        PhaseHero(
                          info: info,
                          content: content,
                          isToday: controller.isToday,
                        ),
                        const SizedBox(height: 14),
                        PhaseTimeline(
                          todayInfo: controller.todayInfo!,
                          selectedDay: info.cycleDay,
                          length: controller.timelineLength,
                          onSelect: controller.selectDay,
                        ),
                        const SizedBox(height: 14),
                        PhaseDescriptionCard(content: content),
                        const SizedBox(height: 14),
                        SymptomCard(
                          content: content,
                          isToday: controller.isToday,
                          loggedIds: controller.todaySymptoms.toSet(),
                          onToggle: controller.toggleSymptom,
                        ),
                        const SizedBox(height: 14),
                        ConceptionCard(
                          info: info,
                          todayDay: controller.todayInfo!.cycleDay,
                          length: controller.timelineLength,
                        ),
                        const SizedBox(height: 14),
                        PhaseTipsCard(content: content),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.phaseFooterDisclaimer(info.cycleLength),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.isToday,
    required this.date,
    required this.onBack,
    required this.onToday,
  });

  final bool isToday;
  final DateTime date;
  final VoidCallback onBack;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final dateLabel = l10n.phaseTopBarDate(
      l10n.weekdayShort(date.weekday),
      l10n.dayMonth(date),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.85),
            ),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? l10n.commonToday : l10n.phaseTopBarPreview,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2D2032),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isToday
                ? const SizedBox.shrink()
                : FilledButton.tonalIcon(
                    onPressed: onToday,
                    icon: const Icon(Icons.today_rounded, size: 18),
                    label: Text(l10n.phaseBackToToday),
                  ),
          ),
        ],
      ),
    );
  }
}
