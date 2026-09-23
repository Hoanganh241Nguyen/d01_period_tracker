enum CyclePhase { menstrual, follicular, fertile, ovulation, luteal, late }

enum ConceptionLevel { low, medium, high, peak }

/// Snapshot of a single day inside a cycle.
///
/// Ovulation is estimated at 14 days before the next period (the luteal phase
/// is the most constant part of the cycle), the fertile window covers the 5
/// days before ovulation plus ovulation day.
class CycleDayInfo {
  const CycleDayInfo({
    required this.cycleDay,
    required this.cycleLength,
    required this.periodLength,
  });

  static const lutealLength = 14;
  static const fertileDaysBeforeOvulation = 5;
  static const pmsDays = 5;

  final int cycleDay;
  final int cycleLength;
  final int periodLength;

  int get ovulationDay {
    final day = cycleLength - lutealLength;
    return day <= periodLength ? periodLength + 1 : day;
  }

  int get fertileStart => ovulationDay - fertileDaysBeforeOvulation;

  /// Day [cycleLength] + 1 is the day the next period is due, not yet late —
  /// [isLate] only becomes true the day after that.
  bool get isLate => cycleDay > cycleLength + 1;

  int get daysLate => isLate ? cycleDay - cycleLength - 1 : 0;

  int get daysToNextPeriod => isLate ? 0 : cycleLength - cycleDay + 1;

  int get daysToOvulation => ovulationDay - cycleDay;

  CyclePhase get phase => phaseOf(cycleDay);

  /// Late luteal days, where PMS symptoms are most common.
  bool get isPmsWindow =>
      phase == CyclePhase.luteal && daysToNextPeriod <= pmsDays;

  /// 1-based index of [cycleDay] inside its current phase.
  int get dayInPhase {
    switch (phase) {
      case CyclePhase.menstrual:
        return cycleDay;
      case CyclePhase.follicular:
        return cycleDay - periodLength;
      case CyclePhase.fertile:
        return cycleDay -
            (fertileStart > periodLength ? fertileStart : periodLength + 1) +
            1;
      case CyclePhase.ovulation:
        return 1;
      case CyclePhase.luteal:
        return cycleDay - ovulationDay;
      case CyclePhase.late:
        return daysLate;
    }
  }

  CyclePhase phaseOf(int day) {
    // Day cycleLength + 1 (the period is due) reads as an extension of the
    // luteal phase, not as late yet — see [isLate].
    if (day > cycleLength + 1) return CyclePhase.late;
    if (day <= periodLength) return CyclePhase.menstrual;
    if (day == ovulationDay) return CyclePhase.ovulation;
    if (day >= fertileStart && day < ovulationDay) return CyclePhase.fertile;
    if (day < fertileStart) return CyclePhase.follicular;
    return CyclePhase.luteal;
  }

  ConceptionLevel get conceptionLevel => conceptionLevelOf(cycleDay);

  ConceptionLevel conceptionLevelOf(int day) {
    final offset = day - ovulationDay;
    if (day > cycleLength) return ConceptionLevel.low;
    if (offset == 0) return ConceptionLevel.peak;
    if (offset == -1 || offset == -2) return ConceptionLevel.high;
    if (offset >= -fertileDaysBeforeOvulation && offset <= 1) {
      return ConceptionLevel.medium;
    }
    return ConceptionLevel.low;
  }

  /// Approximate per-day probability of conception (0–1), relative to
  /// ovulation. Based on the shape reported by Wilcox et al. (NEJM, 1995).
  double conceptionChanceOf(int day) {
    const byOffset = {
      -5: 0.10,
      -4: 0.16,
      -3: 0.14,
      -2: 0.27,
      -1: 0.31,
      0: 0.33,
      1: 0.05,
    };
    return byOffset[day - ovulationDay] ?? 0.01;
  }

  CycleDayInfo copyWith({int? cycleDay}) => CycleDayInfo(
    cycleDay: cycleDay ?? this.cycleDay,
    cycleLength: cycleLength,
    periodLength: periodLength,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CycleDayInfo &&
          runtimeType == other.runtimeType &&
          cycleDay == other.cycleDay &&
          cycleLength == other.cycleLength &&
          periodLength == other.periodLength;

  @override
  int get hashCode => Object.hash(cycleDay, cycleLength, periodLength);
}
