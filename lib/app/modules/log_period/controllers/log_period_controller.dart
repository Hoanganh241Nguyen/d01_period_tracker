import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/cycle_service.dart';
import '../../../utils/l10n.dart';
import '../period_log_editor.dart';

enum PeriodMarkType { logged, predicted }

class PeriodMark {
  const PeriodMark(this.type, this.dayOfPeriod, {this.isAutoFilled = false});

  final PeriodMarkType type;

  /// Logged by auto-fill and not confirmed by the user yet.
  final bool isAutoFilled;

  /// 1-based index of the day inside the period that opens its cycle; 0 for
  /// mid-cycle bleeding (logged before the cycle's expected end).
  final int dayOfPeriod;

  bool get isMidCycle => type == PeriodMarkType.logged && dayOfPeriod == 0;
}

class LogPeriodController extends GetxController {
  final _cycle = CycleService.to;

  static const monthsBack = 12;
  static const monthsAhead = 3;
  static const predictedCycles = 3;

  final logged = <DateTime>{}.obs;
  final autoFilled = <DateTime>{}.obs;

  /// Result of the last tap; the view turns it into an explanation (e.g. how
  /// many days were auto-filled).
  final hint = Rxn<PeriodTapResult>();
  late Set<DateTime> _initial;
  final isSaving = false.obs;

  DateTime get today => _cycle.today.value;

  int get periodLength => _cycle.periodLength.value;

  int get cycleLength => _cycle.cycleLength.value;

  bool get isDirty => !setEquals(logged, _initial);

  /// First day of every month shown, oldest first.
  List<DateTime> get months => [
    for (var i = -monthsBack; i <= monthsAhead; i++)
      DateTime(today.year, today.month + i),
  ];

  @override
  void onInit() {
    super.onInit();
    _cycle.refreshToday();
    _initial = _cycle.periodDays.toSet();
    logged.addAll(_initial);
    // A cycle-length change re-splits every cycle, so a hint explaining the
    // previous tap (e.g. "before the 28-day mark") can turn misleading.
    ever(_cycle.cycleLength, (_) => hint.value = null);
  }

  bool isFuture(DateTime day) => day.isAfter(today);

  void toggle(DateTime day) {
    final result = PeriodLogEditor(
      logged: logged,
      autoFilled: autoFilled,
      today: today,
      periodLength: periodLength,
      cycleLength: cycleLength,
    ).tap(day);
    hint.value = result;
  }

  /// Logged days plus predictions (rest of the current period and the next
  /// few periods), keyed by date.
  Map<DateTime, PeriodMark> get marks {
    final result = <DateTime, PeriodMark>{};
    final cycles = CycleService.cyclePeriods(logged, cycleLength: cycleLength);
    final opening = {for (final p in cycles) ...p};
    final starts = [for (final p in cycles) p.first];

    for (final day in logged) {
      // Numbered from the start of its cycle; mid-cycle bleeding has no number.
      final start = starts.lastWhere((s) => !s.isAfter(day));
      result[day] = PeriodMark(
        PeriodMarkType.logged,
        opening.contains(day) ? CycleService.daysBetween(start, day) + 1 : 0,
        isAutoFilled: autoFilled.contains(day),
      );
    }
    if (cycles.isEmpty) return result;

    final lastPeriod = cycles.last;
    final lastStart = lastPeriod.first;
    void predict(DateTime start, int fromIndex) {
      for (var i = fromIndex; i < periodLength; i++) {
        final day = DateTime(start.year, start.month, start.day + i);
        if (isFuture(day) && !result.containsKey(day)) {
          result[day] = PeriodMark(PeriodMarkType.predicted, i + 1);
        }
      }
    }

    // Remaining days of a period that is still going on.
    if (CycleService.daysBetween(lastPeriod.last, today) <= 1) {
      predict(
        lastStart,
        CycleService.daysBetween(lastStart, lastPeriod.last) + 1,
      );
    }
    // When the period is late its start date is unknown: predict nothing.
    // (Day cycleLength+1, i.e. daysBetween == cycleLength, is only "due
    // today" — see CycleDayInfo.isLate — so predictions still show then.)
    if (CycleService.daysBetween(lastStart, today) > cycleLength) {
      return result;
    }
    for (var k = 1; k <= predictedCycles; k++) {
      predict(
        DateTime(
          lastStart.year,
          lastStart.month,
          lastStart.day + cycleLength * k,
        ),
        0,
      );
    }
    return result;
  }

  Future<void> save() async {
    if (isSaving.value) return;
    isSaving.value = true;
    try {
      await _cycle.savePeriodDays(logged.toSet());
      _initial = logged.toSet();
      autoFilled.clear();
      Get.back<void>();
      Get.snackbar(
        appL10n.logPeriodSavedTitle,
        appL10n.logPeriodSavedMessage,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } finally {
      isSaving.value = false;
    }
  }
}
