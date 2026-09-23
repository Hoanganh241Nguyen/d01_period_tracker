import '../../services/cycle_service.dart';

/// What a tap did, so the screen can explain it.
enum PeriodTapOutcome {
  /// Future days cannot be logged.
  ignored,

  /// A new cycle was started and the usual period length was pre-filled.
  startedWithFill,

  /// A new cycle was started; filling stopped at today.
  startedUntilToday,

  /// The day falls inside the current cycle, before it is due, without
  /// touching its opening period, so it is mid-cycle bleeding.
  midCycle,

  /// The day was added to the end or start of an existing period.
  extended,

  /// The day joined two separately-logged blocks into one period.
  merged,

  /// Bleeding continued (or was bridged) up to the cycle length, so this
  /// tap's cycle now starts on [PeriodTapResult.newCycleStart].
  newCycleByLength,

  /// Only this day was removed.
  removed,

  /// This day and the pre-filled days that depended on it were removed.
  removedWithFill,
}

class PeriodTapResult {
  const PeriodTapResult(
    this.outcome, {
    this.count = 0,
    this.autoFilledCount = 0,
    this.cycleDay = 0,
    this.cycleLength = 0,
    this.newCycleStart,
    this.absorbedStarts = const [],
  });

  final PeriodTapOutcome outcome;

  /// Total days added or removed by this tap.
  final int count;

  /// Of [count], how many were filled in automatically rather than tapped
  /// or already logged (excludes the tapped day itself).
  final int autoFilledCount;

  /// For [PeriodTapOutcome.midCycle]: which day of its cycle the tapped day
  /// is.
  final int cycleDay;

  /// The cycle length used to decide where cycles start.
  final int cycleLength;

  /// For [PeriodTapOutcome.newCycleByLength]: the day that now opens the new
  /// cycle. It can differ from the tapped day — bridging a hole can push a
  /// bleeding day already on the calendar past the cycle length.
  final DateTime? newCycleStart;

  /// Starts that existed before this tap and are no longer a cycle's first
  /// day, because their days are now mid-cycle bleeding of an earlier cycle
  /// (sorted). A period whose start merely moved a day or two earlier is not
  /// included: it still opens the same period, just sooner.
  final List<DateTime> absorbedStarts;
}

/// Editing rules for the period calendar.
///
/// Cycles are split with [CycleService.cyclePeriods]: a logged day is day 1
/// of a new cycle only at least [cycleLength] days after the current cycle's
/// first day. Inside a cycle, days at most [CycleService.maxGapInPeriod]
/// apart belong to the same period, so a forgotten day never splits it.
///
/// Every tap is classified from what [CycleService.cyclePeriods] actually
/// says about [logged] after the change — never guessed from the tapped
/// day's position alone — so the reported outcome always matches the
/// calendar and the auto-fill.
///
/// Adding a day:
/// * Future day → ignored.
/// * Within the gap of a logged day → fill the hole between them. Whether it
///   extends the period, merges two separate blocks, opens a new cycle
///   (bleeding reached the cycle length) or turns out to be mid-cycle
///   bleeding follows from where the result lands, not from the tap itself.
/// * Isolated, inside the current cycle (before it is due) → mark only this
///   day as mid-cycle bleeding.
/// * Isolated otherwise → a new cycle starts: pre-fill the average period
///   length, stopping at today. If the fill reaches another logged block, it
///   bridges into it (joining them) rather than leaving a gap.
///
/// Either way, a period that used to open its own cycle can end up merely
/// mid-cycle bleeding of an earlier cycle — that is reported so the user is
/// not left guessing why a date stopped being "day 1".
///
/// Removing a day:
/// * A pre-filled day → remove it and the pre-filled days after it, up to
///   the first confirmed day, within the same period.
/// * The first day of a period → remove it and its own pre-filled days the
///   same way.
/// * Any other confirmed day → remove only that day.
class PeriodLogEditor {
  PeriodLogEditor({
    required this.logged,
    required this.autoFilled,
    required this.today,
    required int periodLength,
    required this.cycleLength,
  }) : fillLength = periodLength.clamp(minFill, maxFill);

  static const minFill = 2;
  static const maxFill = 10;

  final Set<DateTime> logged;

  /// Days added by auto-fill that the user has not touched yet.
  final Set<DateTime> autoFilled;
  final DateTime today;
  final int fillLength;
  final int cycleLength;

  static const _gap = CycleService.maxGapInPeriod;

  static DateTime _shift(DateTime day, int days) =>
      DateTime(day.year, day.month, day.day + days);

  static int _between(DateTime a, DateTime b) => CycleService.daysBetween(a, b);

  List<List<DateTime>> get _cycles =>
      CycleService.cyclePeriods(logged, cycleLength: cycleLength);

  Set<DateTime> get _cycleStarts => {for (final p in _cycles) p.first};

  PeriodTapResult tap(DateTime day) {
    if (day.isAfter(today)) {
      return const PeriodTapResult(PeriodTapOutcome.ignored);
    }
    return logged.contains(day) ? _remove(day) : _add(day);
  }

  PeriodTapResult _add(DateTime day) {
    final startsBefore = _cycleStarts;
    final before = _nearest(day, backward: true);
    final after = _nearest(day, backward: false);
    // Whether `before` and `after` were already part of the same logged
    // block, ignoring cycle boundaries — read before any mutation.
    final sameRunBefore =
        before != null && after != null && _sameRun(before, after);

    final PeriodTapOutcome outcome;
    var count = 0;
    var autoFilledCount = 0;
    var cycleDay = 0;
    DateTime? newCycleStart;

    if (before != null || after != null) {
      void fillRange(DateTime from, DateTime to) {
        for (var d = from; !d.isAfter(to); d = _shift(d, 1)) {
          if (logged.add(d)) {
            count++;
            if (d != day) {
              autoFilled.add(d);
              autoFilledCount++;
            }
          }
        }
      }

      fillRange(before != null ? _shift(before, 1) : day, day);
      fillRange(day, after != null ? _shift(after, -1) : day);
      autoFilled.remove(day);

      final cyclesAfter = _cycles;
      final owned = cyclesAfter.where((p) => p.contains(day)).toList();
      if (owned.isEmpty) {
        outcome = PeriodTapOutcome.midCycle;
        final owner = cyclesAfter.where((p) => !p.first.isAfter(day)).toList();
        if (owner.isNotEmpty) {
          cycleDay = _between(owner.last.first, day) + 1;
        }
      } else {
        final startsAfter = {for (final p in cyclesAfter) p.first};
        // A start merely replacing another (a period's own start moving a
        // day or two earlier) keeps the same number of cycles and is not a
        // new one — only count it when cycles were genuinely added, which a
        // set difference alone cannot tell apart from a plain replacement.
        if (startsAfter.length > startsBefore.length) {
          outcome = PeriodTapOutcome.newCycleByLength;
          newCycleStart =
              (startsAfter.difference(startsBefore).toList()..sort()).first;
        } else if (before != null && after != null && !sameRunBefore) {
          outcome = PeriodTapOutcome.merged;
        } else {
          outcome = PeriodTapOutcome.extended;
        }
      }
    } else {
      final owner = _owningCycleStart(day);
      if (owner != null) {
        logged.add(day);
        count = 1;
        outcome = PeriodTapOutcome.midCycle;
        cycleDay = _between(owner, day) + 1;
      } else {
        final started = _startCycle(day);
        outcome = started.outcome;
        count = started.count;
        autoFilledCount = started.autoFilledCount;
      }
    }

    return PeriodTapResult(
      outcome,
      count: count,
      autoFilledCount: autoFilledCount,
      cycleDay: cycleDay,
      cycleLength: cycleLength,
      newCycleStart: newCycleStart,
      absorbedStarts: _absorbedStarts(startsBefore, day),
    );
  }

  /// Fills forward from an isolated [day] (already known not to belong to
  /// any existing cycle) by up to [fillLength] days. If the fill reaches
  /// another logged block first, it bridges the remaining gap so the new
  /// period joins it, instead of leaving mid-cycle bleeding behind.
  ({PeriodTapOutcome outcome, int count, int autoFilledCount}) _startCycle(
    DateTime day,
  ) {
    logged.add(day);
    var count = 1;
    var autoFilledCount = 0;
    var outcome = PeriodTapOutcome.startedWithFill;
    for (var i = 1; i < fillLength; i++) {
      final next = _shift(day, i);
      if (next.isAfter(today)) {
        outcome = PeriodTapOutcome.startedUntilToday;
        break;
      }
      logged.add(next);
      autoFilled.add(next);
      count++;
      autoFilledCount++;

      final target = _nearest(next, backward: false);
      if (target != null) {
        for (var d = _shift(next, 1); d.isBefore(target); d = _shift(d, 1)) {
          if (logged.add(d)) {
            count++;
            autoFilled.add(d);
            autoFilledCount++;
          }
        }
        outcome = PeriodTapOutcome.merged;
        break;
      }
    }
    return (outcome: outcome, count: count, autoFilledCount: autoFilledCount);
  }

  /// Start of the cycle [day] falls inside (before that cycle is due), or
  /// null when [day] would open a new one.
  DateTime? _owningCycleStart(DateTime day) {
    for (final period in _cycles.reversed) {
      if (period.first.isAfter(day)) continue;
      return _between(period.first, day) < cycleLength ? period.first : null;
    }
    return null;
  }

  PeriodTapResult _remove(DateTime day) {
    final startsBefore = _cycleStarts;
    final cyclesBefore = _cycles;
    final owned = cyclesBefore.where((p) => p.contains(day)).toList();

    final List<DateTime> run;
    if (owned.isNotEmpty) {
      // A real period day: scope removal to just this cycle's period, never
      // touching another cycle's fill.
      run = owned.first;
    } else {
      // Mid-cycle bleeding: scope removal to the spotting days only (logged
      // days outside every cycle's opening period), so it can never reach
      // into a real period's own fill.
      final spotting = logged
          .where((d) => !cyclesBefore.any((p) => p.contains(d)))
          .toSet();
      run = CycleService.groupPeriods(
        spotting,
      ).firstWhere((r) => r.contains(day));
    }

    final wasAuto = autoFilled.contains(day);
    final isStart = run.first == day;
    final toRemove = <DateTime>{day};
    if (wasAuto || isStart) {
      // Remove the auto-filled days right after `day`, stopping at the
      // first confirmed one — a hole-fill created by a different tap stays.
      for (final d in run.where((d) => d.isAfter(day))) {
        if (!autoFilled.contains(d)) break;
        toRemove.add(d);
      }
    }

    logged.removeAll(toRemove);
    autoFilled.removeAll(toRemove);

    return PeriodTapResult(
      toRemove.length > 1
          ? PeriodTapOutcome.removedWithFill
          : PeriodTapOutcome.removed,
      count: toRemove.length,
      cycleLength: cycleLength,
      absorbedStarts: _absorbedStarts(startsBefore, day),
    );
  }

  /// Starts that existed before the tap, are after [day], and no longer open
  /// any cycle (their days are not inside any opening period any more).
  List<DateTime> _absorbedStarts(Set<DateTime> startsBefore, DateTime day) {
    final cyclesAfter = _cycles;
    return startsBefore
        .where((s) => s.isAfter(day) && !cyclesAfter.any((p) => p.contains(s)))
        .toList()
      ..sort();
  }

  /// Closest logged day within the in-period gap on one side of [day].
  DateTime? _nearest(DateTime day, {required bool backward}) {
    for (var i = 1; i <= _gap; i++) {
      final d = _shift(day, backward ? -i : i);
      if (logged.contains(d)) return d;
    }
    return null;
  }

  /// Whether [a] and [b] belong to the same day-gap block of [logged],
  /// ignoring cycle boundaries.
  bool _sameRun(DateTime a, DateTime b) {
    for (final run in CycleService.groupPeriods(logged)) {
      if (run.contains(a)) return run.contains(b);
    }
    return false;
  }
}
