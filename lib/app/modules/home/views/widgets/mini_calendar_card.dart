import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/cycle_day_info.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/cycle_service.dart';
import '../../../../utils/l10n.dart';
import '../../../../utils/theme/app_colors.dart';

/// The current week (Monday first) with logged, predicted and ovulation days.
class MiniCalendarCard extends StatelessWidget {
  const MiniCalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Obx(() {
      final cycle = CycleService.to;
      final today = cycle.today.value;
      // Read so the week rebuilds when periods are edited.
      cycle.periodDays.length;
      final days = [
        for (var i = 0; i < 7; i++)
          DateTime(today.year, today.month, today.day - today.weekday + 1 + i),
      ];

      return Card(
        color: colorScheme.surface.withValues(alpha: 0.92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homeCalendarMonthTitle('${today.month}'),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed<void>(Routes.logPeriod),
                    child: Text(l10n.homeCalendarTodayButton),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: l10n.weekdaysShort
                    .map((day) => WeekdayLabel(day))
                    .toList(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final day in days)
                    MiniDay(
                      day: day.day,
                      isPeriod:
                          cycle.periodDays.contains(day) &&
                          !cycle.isMidCycleBleeding(day),
                      isMidCycle: cycle.isMidCycleBleeding(day),
                      isPredicted: cycle.isPredictedPeriodDay(day),
                      isOvulation:
                          cycle.infoFor(day)?.phase == CyclePhase.ovulation,
                      isToday: day == today,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  LegendDot(
                    color: CycleColors.periodDay,
                    label: l10n.homeLegendPeriod,
                  ),
                  LegendDot(
                    color: CycleColors.predictedPeriod,
                    label: l10n.homeLegendPredicted,
                  ),
                  LegendDot(
                    color: CycleColors.periodDay,
                    label: l10n.homeLegendMidCycle,
                    outlined: true,
                  ),
                  LegendDot(
                    color: CycleColors.ovulationDay,
                    label: l10n.homeLegendOvulation,
                  ),
                  LegendDot(color: AppColors.primary, label: l10n.commonToday),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class WeekdayLabel extends StatelessWidget {
  const WeekdayLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class MiniDay extends StatelessWidget {
  const MiniDay({
    super.key,
    required this.day,
    this.isPeriod = false,
    this.isMidCycle = false,
    this.isPredicted = false,
    this.isOvulation = false,
    this.isToday = false,
  });

  final int day;
  final bool isPeriod;

  final bool isMidCycle;
  final bool isPredicted;
  final bool isOvulation;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = isPeriod
        ? CycleColors.periodDay
        : isPredicted
        ? CycleColors.predictedPeriod
        : isOvulation
        ? CycleColors.fertileWindow
        : Colors.transparent;
    final fg = isPeriod ? Colors.white : colorScheme.onSurface;

    return SizedBox(
      width: 34,
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : isMidCycle
                  ? Border.all(color: CycleColors.periodDay, width: 1.6)
                  : null,
            ),
            child: Text(
              '$day',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: fg,
                fontWeight: isPeriod || isToday
                    ? FontWeight.w800
                    : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: isOvulation
                  ? CycleColors.ovulationDay
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class LegendDot extends StatelessWidget {
  const LegendDot({
    super.key,
    required this.color,
    required this.label,
    this.outlined = false,
  });

  final Color color;
  final String label;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: outlined ? null : color,
            shape: BoxShape.circle,
            border: outlined ? Border.all(color: color, width: 1.2) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
