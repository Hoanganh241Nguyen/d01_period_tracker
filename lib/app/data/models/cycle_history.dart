import 'dart:math' as math;

import '../../services/cycle_service.dart';
import 'cycle_day_info.dart';
import 'daily_log.dart';

/// What a single day of a cycle bar represents.
enum HistoryDayKind { period, midCycle, fertile, ovulation, other }

class HistoryDay {
  const HistoryDay(
    this.date,
    this.kind, {
    this.predicted = false,
    this.late = false,
    this.cycleDay = 0,
    this.dayOfPeriod = 0,
  });

  final DateTime date;
  final HistoryDayKind kind;

  /// Not happened yet: drawn as an outline instead of a filled cell.
  final bool predicted;

  /// Past the expected end of a cycle whose next period has not come.
  final bool late;

  /// 1-based day inside the cycle. Used by full calendars to show calculated
  /// cycle position even when no bleeding was logged on that date.
  final int cycleDay;

  /// 1-based day inside the period, or 0 when the date is not part of the
  /// period that opens the cycle.
  final int dayOfPeriod;
}

enum CycleEntryStatus {
  /// A cycle that ended when the next period started.
  finished,

  /// The cycle running today, not late yet.
  current,

  /// The cycle running today, already longer than the cycle length.
  late,

  /// A future cycle, predicted from the cycle length.
  predicted,

  /// The gap to the next period is too long to be one cycle (a period was
  /// probably not logged), so no bar is drawn and it is left out of stats.
  incomplete,
}

class CycleHistoryEntry {
  const CycleHistoryEntry({
    required this.start,
    required this.end,
    required this.length,
    required this.periodLength,
    required this.status,
    required this.days,
    this.periodEnd,
    this.ovulation,
    this.fertileStart,
    this.fertileEnd,
    this.daysLate = 0,
    this.midCycleDays = 0,
    this.symptoms = const {},
  });

  final DateTime start;

  /// Last day of the cycle (the day before the next period). For the current
  /// cycle this is the expected last day; for a late cycle it is today.
  final DateTime end;

  /// Days in the cycle; for the running cycle, days so far.
  final int length;

  /// Days of bleeding in the period that opened the cycle.
  final int periodLength;

  /// Last day of that period (expected, for a predicted cycle).
  final DateTime? periodEnd;

  final CycleEntryStatus status;

  /// One entry per cycle day; empty for [CycleEntryStatus.incomplete].
  final List<HistoryDay> days;

  /// Estimated ovulation day and possible fertile days (5 days before the
  /// estimated ovulation plus that day). Null when no estimate is shown.
  final DateTime? ovulation;
  final DateTime? fertileStart;
  final DateTime? fertileEnd;

  final int daysLate;

  /// Bleeding days logged in the cycle outside its opening period.
  final int midCycleDays;

  /// Symptom ids logged during the cycle (up to today), most logged first.
  final Set<String> symptoms;

  bool get isOngoing =>
      status == CycleEntryStatus.current || status == CycleEntryStatus.late;
}

/// Typical values over the recent finished cycles.
class CycleSummary {
  const CycleSummary({
    required this.count,
    required this.shortest,
    required this.longest,
    required this.typical,
    required this.shortestPeriod,
    required this.longestPeriod,
  });

  final int count;
  final int shortest;
  final int longest;

  /// Median length; robust to a single unusual cycle.
  final int typical;
  final int shortestPeriod;
  final int longestPeriod;
}

/// Builds the cycle history and the short forecast from logged data.
///
/// Ovulation is a calendar estimate (14 days before the next period). Real
/// luteal phases vary (about 7–17 days), so it is always labelled as an
/// estimate, only shown for cycles of [minEstimable]–[maxEstimable] days,
/// and never presented as confirmed.
class CycleHistory {
  CycleHistory._();

  /// Future cycles shown; dates further ahead are too uncertain.
  static const forecastCycles = 3;

  /// Flattens cycle entries (as returned by [history] and [forecast]) into
  /// one lookup by date, for screens that just need "what is this day" (e.g.
  /// a full calendar) rather than the cycle-by-cycle breakdown.
  static Map<DateTime, HistoryDay> dayMap(Iterable<CycleHistoryEntry> entries) {
    final map = <DateTime, HistoryDay>{};
    for (final entry in entries) {
      for (final day in entry.days) {
        map[day.date] = day;
      }
    }
    return map;
  }

  /// Cycle lengths for which an ovulation estimate is shown.
  static const minEstimable = 21;
  static const maxEstimable = 45;

  /// Finished cycles the summary looks at.
  static const summaryWindow = 6;

  /// Cycles from newest to oldest, including the one running today.
  ///
  /// [periods] are the periods that open each cycle, as split by
  /// [CycleService.cyclePeriods] with [cycleLength].
  static List<CycleHistoryEntry> history({
    required List<List<DateTime>> periods,
    required Set<DateTime> periodDays,
    required Map<DateTime, DailyLog> logs,
    required DateTime today,
    required int cycleLength,
    required int periodLength,
  }) {
    final result = <CycleHistoryEntry>[];
    for (var i = 0; i < periods.length; i++) {
      final period = periods[i];
      final start = period.first;
      final span = _between(start, period.last) + 1;

      if (i < periods.length - 1) {
        final next = periods[i + 1].first;
        final length = _between(start, next);
        final end = _shift(next, -1);
        final symptoms = _symptoms(logs, start, end);
        if (length > CycleService.maxCycleDays) {
          // The gap is too long to trust as a real cycle length, so no
          // fertile/ovulation estimate is shown. The bar is still capped at
          // maxCycleDays: long enough to cover the logged opening period
          // (and any mid-cycle bleeding soon after) without stretching the
          // shared day axis every other row is drawn against.
          result.add(
            _entry(
              start: start,
              end: end,
              length: length,
              periodLength: span,
              status: CycleEntryStatus.incomplete,
              barLength: math.min(length, CycleService.maxCycleDays),
              info: CycleDayInfo(
                cycleDay: 1,
                cycleLength: length,
                periodLength: span,
              ),
              showFertile: false,
              period: period,
              periodDays: periodDays,
              today: today,
              symptoms: symptoms,
            ),
          );
          continue;
        }
        final estimable = length >= minEstimable && length <= maxEstimable;
        result.add(
          _entry(
            start: start,
            end: end,
            length: length,
            periodLength: span,
            status: CycleEntryStatus.finished,
            barLength: length,
            info: CycleDayInfo(
              cycleDay: 1,
              cycleLength: length,
              periodLength: span,
            ),
            showFertile: estimable,
            period: period,
            periodDays: periodDays,
            today: today,
            symptoms: symptoms,
          ),
        );
        continue;
      }

      // The cycle running today. Day cycleLength + 1 is the day the period is
      // due, not yet late — see CycleDayInfo.isLate.
      final daysSoFar = _between(start, today) + 1;
      final ongoing = _between(period.last, today) <= 1;
      final bleeding = ongoing && span < periodLength ? periodLength : span;
      final late = daysSoFar > cycleLength + 1;
      final barLength = late ? daysSoFar : math.max(daysSoFar, cycleLength);
      result.add(
        _entry(
          start: start,
          end: late ? today : _shift(start, barLength - 1),
          length: daysSoFar,
          periodLength: span,
          status: late ? CycleEntryStatus.late : CycleEntryStatus.current,
          barLength: barLength,
          info: CycleDayInfo(
            cycleDay: 1,
            cycleLength: cycleLength,
            periodLength: bleeding,
          ),
          // Once late, the estimate made from the cycle length was evidently
          // off for this cycle, so none is shown.
          showFertile: !late,
          period: period,
          periodDays: periodDays,
          today: today,
          symptoms: _symptoms(logs, start, today),
          daysLate: late ? daysSoFar - cycleLength - 1 : 0,
        ),
      );
    }
    return result.reversed.toList();
  }

  /// Up to [forecastCycles] cycles after the current one, soonest first.
  /// Empty when the current period is late: the next start is unknown.
  /// Possible fertile days and ovulation are drawn as estimates for every
  /// forecast cycle shown in the calendar.
  static List<CycleHistoryEntry> forecast({
    required DateTime lastPeriodStart,
    required DateTime today,
    required int cycleLength,
    required int periodLength,
    int cycles = forecastCycles,
  }) {
    if (_between(lastPeriodStart, today) + 1 > cycleLength) return const [];
    final info = CycleDayInfo(
      cycleDay: 1,
      cycleLength: cycleLength,
      periodLength: periodLength,
    );
    return [
      for (var k = 1; k <= cycles; k++)
        _entry(
          start: _shift(lastPeriodStart, cycleLength * k),
          end: _shift(lastPeriodStart, cycleLength * (k + 1) - 1),
          length: cycleLength,
          periodLength: periodLength,
          status: CycleEntryStatus.predicted,
          barLength: cycleLength,
          info: info,
          showFertile: true,
          period: const [],
          periodDays: const {},
          today: today,
          symptoms: const {},
        ),
    ];
  }

  /// Typical lengths over the last [summaryWindow] finished cycles; null
  /// before any cycle has finished.
  static CycleSummary? summary(List<CycleHistoryEntry> history) {
    final finished = history
        .where((e) => e.status == CycleEntryStatus.finished)
        .take(summaryWindow)
        .toList();
    if (finished.isEmpty) return null;
    final lengths = [for (final e in finished) e.length]..sort();
    final periods = [for (final e in finished) e.periodLength]..sort();
    return CycleSummary(
      count: finished.length,
      shortest: lengths.first,
      longest: lengths.last,
      typical: lengths[lengths.length ~/ 2],
      shortestPeriod: periods.first,
      longestPeriod: periods.last,
    );
  }

  static CycleHistoryEntry _entry({
    required DateTime start,
    required DateTime end,
    required int length,
    required int periodLength,
    required CycleEntryStatus status,
    required int barLength,
    required CycleDayInfo info,
    required bool showFertile,
    required List<DateTime> period,
    required Set<DateTime> periodDays,
    required DateTime today,
    required Set<String> symptoms,
    int daysLate = 0,
  }) {
    final predictedCycle = status == CycleEntryStatus.predicted;
    final days = <HistoryDay>[];
    var midCycle = 0;
    for (var d = 1; d <= barLength; d++) {
      final date = _shift(start, d - 1);
      final future = predictedCycle || date.isAfter(today);
      // Day cycleLength + 1 (the period is due) is not yet late — matches
      // CycleDayInfo.isLate.
      final late = d > info.cycleLength + 1;
      HistoryDayKind kind;
      if (!future && periodDays.contains(date)) {
        // Bleeding outside the period that opened the cycle.
        final inPeriod =
            period.isNotEmpty &&
            !date.isBefore(period.first) &&
            !date.isAfter(period.last);
        kind = inPeriod ? HistoryDayKind.period : HistoryDayKind.midCycle;
        if (!inPeriod) midCycle++;
      } else if (late) {
        kind = HistoryDayKind.other;
      } else {
        kind = switch (info.phaseOf(d)) {
          // Past days only count as period days when they were logged.
          CyclePhase.menstrual =>
            future ? HistoryDayKind.period : HistoryDayKind.other,
          CyclePhase.fertile when showFertile => HistoryDayKind.fertile,
          CyclePhase.ovulation when showFertile => HistoryDayKind.ovulation,
          _ => HistoryDayKind.other,
        };
      }
      days.add(
        HistoryDay(
          date,
          kind,
          predicted: future,
          late: late,
          cycleDay: d,
          dayOfPeriod: kind == HistoryDayKind.period ? d : 0,
        ),
      );
    }

    DateTime? ovulation;
    DateTime? fertileStart;
    if (showFertile) {
      ovulation = _shift(start, info.ovulationDay - 1);
      fertileStart = _shift(
        start,
        (info.fertileStart < 1 ? 1 : info.fertileStart) - 1,
      );
    }
    return CycleHistoryEntry(
      start: start,
      end: end,
      length: length,
      periodLength: periodLength,
      // Logged end, or the expected end for a predicted cycle.
      periodEnd: period.isEmpty ? _shift(start, periodLength - 1) : period.last,
      status: status,
      days: days,
      ovulation: ovulation,
      fertileStart: fertileStart,
      fertileEnd: ovulation,
      daysLate: daysLate,
      midCycleDays: midCycle,
      symptoms: symptoms,
    );
  }

  /// Symptom ids logged between [from] and [to], most frequent first.
  static Set<String> _symptoms(
    Map<DateTime, DailyLog> logs,
    DateTime from,
    DateTime to,
  ) {
    final counts = <String, int>{};
    for (final entry in logs.entries) {
      if (entry.key.isBefore(from) || entry.key.isAfter(to)) continue;
      for (final id in entry.value.symptoms) {
        counts[id] = (counts[id] ?? 0) + 1;
      }
    }
    final ids = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    return ids.toSet();
  }

  static DateTime _shift(DateTime day, int days) =>
      DateTime(day.year, day.month, day.day + days);

  static int _between(DateTime a, DateTime b) => CycleService.daysBetween(a, b);
}
