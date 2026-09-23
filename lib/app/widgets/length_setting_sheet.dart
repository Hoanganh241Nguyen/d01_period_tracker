import 'package:flutter/material.dart';

import '../services/cycle_service.dart';
import '../utils/l10n.dart';

/// Bottom sheet to change a day-count setting (cycle length, period length)
/// within a fixed range, shared by the log screen and Settings.
Future<void> showLengthSettingSheet(
  BuildContext context, {
  required String title,
  required String help,
  required int initial,
  required int min,
  required int max,
  required Future<void> Function(int) onSave,
}) {
  var value = initial;

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final l10n = context.l10n;
        final textTheme = Theme.of(context).textTheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  help,
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7A6877),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    l10n.commonDays(value),
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Slider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max - min,
                  label: l10n.commonDays(value),
                  onChanged: (v) => setState(() => value = v.round()),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () async {
                      await onSave(value);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: Text(l10n.commonSave),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Future<void> showCycleLengthSheet(BuildContext context) {
  final cycle = CycleService.to;
  final l10n = context.l10n;
  return showLengthSettingSheet(
    context,
    title: l10n.logPeriodCycleLengthTitle,
    help: l10n.logPeriodCycleLengthHelp,
    initial: cycle.cycleLength.value,
    min: CycleService.minCycleSetting,
    max: CycleService.maxCycleSetting,
    onSave: cycle.setCycleLength,
  );
}

Future<void> showPeriodLengthSheet(BuildContext context) {
  final cycle = CycleService.to;
  final l10n = context.l10n;
  return showLengthSettingSheet(
    context,
    title: l10n.settingsPeriodLengthTitle,
    help: l10n.settingsPeriodLengthHelp,
    initial: cycle.periodLength.value,
    min: CycleService.minPeriodSetting,
    max: CycleService.maxPeriodSetting,
    onSave: cycle.setPeriodLength,
  );
}
