import '../../services/cycle_service.dart';
import 'daily_log.dart';

/// Variability level of cycle lengths (C) or period lengths (P), from 1
/// (stable) to 4 (severe). Rules follow assets/data/chart_insights.json.
enum Variability { stable, mild, notable, severe }

class LengthStats {
  const LengthStats({
    required this.values,
    required this.level,
    required this.outlier,
  });

  /// Up to the last [CycleInsights.window] values, oldest first.
  final List<int> values;
  final Variability level;

  /// The value that caused a notable/severe level (farthest from normal).
  final int outlier;

  int get min => values.reduce((a, b) => a < b ? a : b);
  int get max => values.reduce((a, b) => a > b ? a : b);
  int get range => max - min;
}

enum PatternTiming { duringPeriod, beforePeriod, midCycle }

/// A symptom that came back in at least [CycleInsights.minPatternCycles]
/// different cycles.
class SymptomPattern {
  const SymptomPattern({
    required this.symptomId,
    required this.timing,
    required this.cycleCount,
    required this.firstDay,
    required this.lastDay,
    required this.daysBeforePeriod,
    required this.cycleDay,
  });

  final String symptomId;
  final PatternTiming timing;
  final int cycleCount;

  /// For [PatternTiming.duringPeriod]: typical range of period days.
  final int firstDay;
  final int lastDay;

  /// For [PatternTiming.beforePeriod]: typical days before the next period.
  final int daysBeforePeriod;

  /// For [PatternTiming.midCycle]: typical cycle day.
  final int cycleDay;
}

class CycleInsights {
  CycleInsights._();

  /// Classification looks at the most recent 12 values.
  static const window = 12;
  static const minValues = 2;
  static const minPatternCycles = 2;

  /// Days before a period that count as "before the period" (PMS window).
  static const premenstrualDays = 7;

  /// Cycle length level (C1–C4); null with fewer than [minValues] cycles.
  static LengthStats? cycleStats(List<int> lengths) {
    final values = _recent(lengths);
    if (values.length < minValues) return null;
    final range = values.reduce(_max) - values.reduce(_min);
    bool normal(int v) => v >= 21 && v <= 35;

    final severe = values.where((v) => v >= 45 || v <= 18);
    if (severe.isNotEmpty) {
      return LengthStats(
        values: values,
        level: Variability.severe,
        outlier: _farthest(severe, 28),
      );
    }
    final notable = values.where(
      (v) => (v >= 36 && v <= 44) || v == 19 || v == 20,
    );
    if (notable.isNotEmpty || range > 14) {
      return LengthStats(
        values: values,
        level: Variability.notable,
        outlier: _farthest(notable.isNotEmpty ? notable : values, 28),
      );
    }
    return LengthStats(
      values: values,
      level: values.every(normal) && range <= 7
          ? Variability.stable
          : Variability.mild,
      outlier: _farthest(values, 28),
    );
  }

  /// Period length level (P1–P4); null with fewer than [minValues] periods.
  static LengthStats? periodStats(List<int> lengths) {
    final values = _recent(lengths);
    if (values.length < minValues) return null;
    final range = values.reduce(_max) - values.reduce(_min);

    final severe = values.where((v) => v > 9 || v < 2);
    if (severe.isNotEmpty) {
      return LengthStats(
        values: values,
        level: Variability.severe,
        outlier: _farthest(severe, 5),
      );
    }
    final notable = values.where((v) => v == 8 || v == 9);
    if (notable.isNotEmpty || range > 4) {
      return LengthStats(
        values: values,
        level: Variability.notable,
        outlier: _farthest(notable.isNotEmpty ? notable : values, 5),
      );
    }
    return LengthStats(
      values: values,
      level: range <= 2 ? Variability.stable : Variability.mild,
      outlier: _farthest(values, 5),
    );
  }

  /// Symptoms that recur across cycles, most frequent first.
  ///
  /// [periods] are cycle-starting periods (oldest first); a log belongs to the
  /// cycle whose period started on or before it. Logs before the first
  /// period are ignored.
  static List<SymptomPattern> patterns({
    required List<List<DateTime>> periods,
    required Map<DateTime, DailyLog> logs,
    int limit = 3,
  }) {
    final occurrences = <String, List<_Occurrence>>{};
    for (final entry in logs.entries) {
      if (entry.value.symptoms.isEmpty) continue;
      final date = entry.key;
      final index = periods.lastIndexWhere((p) => !p.first.isAfter(date));
      if (index < 0) continue;
      final period = periods[index];
      final next = index + 1 < periods.length ? periods[index + 1].first : null;
      final occurrence = _Occurrence(
        cycle: index,
        cycleDay: CycleService.daysBetween(period.first, date) + 1,
        periodLength: CycleService.daysBetween(period.first, period.last) + 1,
        daysBeforeNext: next == null
            ? null
            : CycleService.daysBetween(date, next),
      );
      for (final id in entry.value.symptoms) {
        (occurrences[id] ??= []).add(occurrence);
      }
    }

    final result = <SymptomPattern>[];
    occurrences.forEach((id, list) {
      final cycles = list.map((o) => o.cycle).toSet().length;
      if (cycles < minPatternCycles) return;

      final during = list.where((o) => o.cycleDay <= o.periodLength).toList();
      final before = list
          .where(
            (o) =>
                o.daysBeforeNext != null &&
                o.daysBeforeNext! <= premenstrualDays &&
                o.cycleDay > o.periodLength,
          )
          .toList();
      final PatternTiming timing;
      if (during.length * 2 > list.length) {
        timing = PatternTiming.duringPeriod;
      } else if (before.length * 2 > list.length) {
        timing = PatternTiming.beforePeriod;
      } else {
        timing = PatternTiming.midCycle;
      }
      final days = during.map((o) => o.cycleDay).toList()..sort();
      result.add(
        SymptomPattern(
          symptomId: id,
          timing: timing,
          cycleCount: cycles,
          firstDay: days.isEmpty ? 0 : days.first,
          lastDay: days.isEmpty ? 0 : days.last,
          daysBeforePeriod: _median(before.map((o) => o.daysBeforeNext!)),
          cycleDay: _median(list.map((o) => o.cycleDay)),
        ),
      );
    });
    result.sort((a, b) => b.cycleCount.compareTo(a.cycleCount));
    return result.take(limit).toList();
  }

  static List<int> _recent(List<int> values) =>
      values.length > window ? values.sublist(values.length - window) : values;

  static int _min(int a, int b) => a < b ? a : b;
  static int _max(int a, int b) => a > b ? a : b;

  static int _farthest(Iterable<int> values, int from) =>
      values.reduce((a, b) => (a - from).abs() >= (b - from).abs() ? a : b);

  static int _median(Iterable<int> values) {
    final sorted = values.toList()..sort();
    return sorted.isEmpty ? 0 : sorted[sorted.length ~/ 2];
  }
}

class _Occurrence {
  const _Occurrence({
    required this.cycle,
    required this.cycleDay,
    required this.periodLength,
    required this.daysBeforeNext,
  });

  final int cycle;
  final int cycleDay;
  final int periodLength;
  final int? daysBeforeNext;
}
