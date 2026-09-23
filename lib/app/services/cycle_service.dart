import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/models/cycle_day_info.dart';
import '../data/models/daily_log.dart';
import '../data/providers/local_storage_provider.dart';

/// A finished cycle: from one period start to the next.
class CycleRecord {
  const CycleRecord({
    required this.start,
    required this.length,
    required this.periodLength,
  });

  final DateTime start;
  final int length;
  final int periodLength;
}

/// Single source of truth for everything the user logged, and for what is
/// derived from it (current cycle day, averages, predictions).
///
/// Nothing is invented: until a period is logged, [todayInfo] is null and
/// screens show an empty state.
class CycleService extends GetxService with WidgetsBindingObserver {
  static CycleService get to => Get.find();

  static const defaultCycleLength = 28;
  static const defaultPeriodLength = 5;

  /// Range the user can pick the cycle length from (onboarding, log screen).
  static const minCycleSetting = 21;
  static const maxCycleSetting = 35;

  /// Range the user can pick the period length from (onboarding, settings);
  /// also the range the learned average and the log screen's auto-fill are
  /// kept within, so every screen predicts the same period length.
  static const minPeriodSetting = 2;
  static const maxPeriodSetting = 10;

  /// Logged days at most this many days apart belong to the same period, so
  /// one forgotten day does not start a new cycle.
  static const maxGapInPeriod = 2;

  /// Days after this are still saved as bleeding logs, but no longer extend
  /// the opening period that drives the Home phase/ring. This keeps messy
  /// month-long logs from making the app say the user is on a normal period
  /// forever.
  static const maxOpeningPeriodDays = 7;

  /// Longer gaps are treated as missing data, not as a cycle.
  static const maxCycleDays = 60;

  /// How many recent cycles the averages are based on.
  static const averageWindow = 6;

  final _storage = LocalStorageProvider.to;

  final today = dateOnly(DateTime.now()).obs;
  final periodDays = <DateTime>{}.obs;
  final dailyLogs = <DateTime, DailyLog>{}.obs;

  /// Cycle length set by the user. It is not re-learned from logged data:
  /// a new cycle only starts [cycleLength] days after the previous one.
  final cycleLength = defaultCycleLength.obs;

  /// Average period length; starts from the user's value, then learned.
  final periodLength = defaultPeriodLength.obs;

  /// Today's position in the cycle; null until a period has been logged.
  final todayInfo = Rxn<CycleDayInfo>();

  Future<CycleService> init() async {
    await _migrate();
    await _load();
    // So `today` rolls over when the app is reopened after being left in the
    // background across midnight, not just when a screen happens to call
    // refreshToday() itself.
    WidgetsBinding.instance.addObserver(this);
    return this;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refreshToday();
  }

  /// Earlier versions overwrote the cycle length with a learned average,
  /// which could fall outside what the user can set. Such a value is not the
  /// user's choice, so it falls back to the default.
  Future<void> _migrate() async {
    final storedCycle = _storage.cycleLength;
    if (storedCycle != null && !isValidCycleSetting(storedCycle)) {
      await _storage.setCycleLength(defaultCycleLength);
    }
    final storedPeriod = _storage.periodLength;
    if (storedPeriod != null && !isValidPeriodSetting(storedPeriod)) {
      await _storage.setPeriodLength(defaultPeriodLength);
    }
    if (_storage.hasLegacyData) await _storage.removeLegacyData();
  }

  static bool isValidCycleSetting(int days) =>
      days >= minCycleSetting && days <= maxCycleSetting;

  static bool isValidPeriodSetting(int days) =>
      days >= minPeriodSetting && days <= maxPeriodSetting;

  bool get hasData => periodDays.isNotEmpty;

  bool get onboardingDone => _storage.onboardingDone;

  /// Periods that start a cycle, oldest first (spotting excluded).
  List<List<DateTime>> get periods =>
      cyclePeriods(periodDays, cycleLength: cycleLength.value);

  /// Finished cycles, oldest first.
  List<CycleRecord> get completedCycles {
    final all = periods;
    return [
      for (var i = 0; i + 1 < all.length; i++)
        if (daysBetween(all[i].first, all[i + 1].first) <= maxCycleDays)
          CycleRecord(
            start: all[i].first,
            length: daysBetween(all[i].first, all[i + 1].first),
            periodLength: daysBetween(all[i].first, all[i].last) + 1,
          ),
    ];
  }

  /// Average length of the recent finished cycles, for display; falls back to
  /// the user's setting until a cycle has been completed.
  int get averageCycleLength {
    final cycles = completedCycles;
    return cycles.isEmpty
        ? cycleLength.value
        : _recentAverage([for (final c in cycles) c.length]);
  }

  DailyLog get todayLog => dailyLogs[today.value] ?? const DailyLog();

  Set<String> get todaySymptoms => todayLog.symptoms;

  Future<void> _load() async {
    periodDays
      ..clear()
      ..addAll(_storage.periodDays);
    dailyLogs
      ..clear()
      ..addAll(_storage.dailyLogs);
    cycleLength.value = _storage.cycleLength ?? defaultCycleLength;
    periodLength.value = _storage.periodLength ?? defaultPeriodLength;
    // The learned period length is only ever recomputed when periodDays
    // changes; if it was computed by an older version of this logic (or a
    // day was ever edited outside the normal save path), it can drift from
    // what the current periodDays would actually produce. Re-derive it now
    // so what is shown always matches what was logged.
    await _relearnPeriodLength();
    refreshToday();
  }

  /// Recomputes today's snapshot. Call it when a screen opens so the state
  /// rolls over correctly after midnight.
  void refreshToday() {
    void apply() {
      today.value = dateOnly(DateTime.now());
      todayInfo.value = infoFor(today.value);
    }

    // Rx updates during build would trigger "setState during build".
    if (WidgetsBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => apply());
    } else {
      apply();
    }
  }

  /// Position of [date] in its cycle, or null before the first logged period.
  ///
  /// Past cycles use their real length; the current cycle uses the user's
  /// cycle length.
  /// Future dates past the current cycle roll into predicted cycles, unless
  /// the period is already late (then no further cycle is predicted). A
  /// predicted cycle's period always uses the learned [periodLength], the
  /// same value every other screen predicts with (see [CycleHistory]).
  CycleDayInfo? infoFor(DateTime date) {
    final all = periods;
    final index = all.lastIndexWhere((p) => !p.first.isAfter(date));
    if (index < 0) return null;

    final period = all[index];
    final start = period.first;
    final isCurrent = index == all.length - 1;
    final span = daysBetween(start, period.last) + 1;

    final length = isCurrent
        ? cycleLength.value
        : daysBetween(start, all[index + 1].first);

    var day = daysBetween(start, date) + 1;
    final todayDay = daysBetween(start, today.value) + 1;
    // Whether [date] was rolled past the current cycle into a predicted one.
    final predicted =
        isCurrent &&
        date.isAfter(today.value) &&
        day > length &&
        todayDay <= length;
    if (predicted) day = (day - 1) % length + 1;

    return CycleDayInfo(
      cycleDay: day,
      cycleLength: length,
      periodLength: date.isAfter(today.value) ? periodLength.value : span,
    );
  }

  /// Bleeding logged inside a cycle but outside the period that opened it
  /// (before the cycle length was reached).
  bool isMidCycleBleeding(DateTime date) =>
      periodDays.contains(date) && !periods.any((p) => p.contains(date));

  /// Changes the user's cycle length; cycles are re-split right away and the
  /// learned period length is recomputed to match the new split.
  Future<void> setCycleLength(int days) async {
    final value = days.clamp(minCycleSetting, maxCycleSetting);
    await _storage.setCycleLength(value);
    cycleLength.value = value;
    await _relearnPeriodLength();
    refreshToday();
  }

  /// Sets the default period length directly (e.g. from Settings). It still
  /// gets refined the next time a finished period is logged.
  Future<void> setPeriodLength(int days) async {
    final value = days.clamp(minPeriodSetting, maxPeriodSetting);
    await _storage.setPeriodLength(value);
    periodLength.value = value;
    refreshToday();
  }

  bool isPredictedPeriodDay(DateTime date) =>
      date.isAfter(today.value) &&
      !periodDays.contains(date) &&
      infoFor(date)?.phase == CyclePhase.menstrual;

  /// Expected start of the next period; null without data or when late.
  DateTime? get nextPeriodStart {
    final info = todayInfo.value;
    if (info == null || info.isLate) return null;
    final t = today.value;
    return DateTime(t.year, t.month, t.day + info.daysToNextPeriod);
  }

  Future<void> completeOnboarding({
    required int cycleLength,
    required int periodLength,
    DateTime? lastPeriodStart,
  }) async {
    final cycleValue = cycleLength.clamp(minCycleSetting, maxCycleSetting);
    final periodValue = periodLength.clamp(minPeriodSetting, maxPeriodSetting);
    await _storage.setCycleLength(cycleValue);
    await _storage.setPeriodLength(periodValue);
    this.cycleLength.value = cycleValue;
    this.periodLength.value = periodValue;
    if (lastPeriodStart != null) {
      final start = dateOnly(lastPeriodStart);
      await savePeriodDays({
        for (var i = 0; i < periodValue; i++)
          if (!_shift(start, i).isAfter(today.value)) _shift(start, i),
      });
    }
    await _storage.setOnboardingDone();
    refreshToday();
  }

  /// Saves the logged days and re-learns the average period length. The
  /// cycle length stays the user's setting.
  Future<void> savePeriodDays(Set<DateTime> days) async {
    await _storage.setPeriodDays(days);
    periodDays
      ..clear()
      ..addAll(days);
    await _relearnPeriodLength();
    refreshToday();
  }

  /// Averages the finished opening periods under the current cycle split and
  /// stores the result, clamped to [minPeriodSetting]–[maxPeriodSetting] so
  /// it always agrees with what the onboarding/settings slider and the log
  /// screen's auto-fill allow. Does nothing without a finished period.
  Future<void> _relearnPeriodLength() async {
    // A period that reaches yesterday or today may still be going on, so it
    // does not count towards the average length.
    final finished = periods
        .where((p) => daysBetween(p.last, today.value) > 1)
        .toList();
    if (finished.isEmpty) return;
    final value = _recentAverage([
      for (final p in finished) daysBetween(p.first, p.last) + 1,
    ]).clamp(minPeriodSetting, maxPeriodSetting);
    periodLength.value = value;
    await _storage.setPeriodLength(value);
  }

  DailyLog dailyLogOn(DateTime date) =>
      dailyLogs[dateOnly(date)] ?? const DailyLog();

  /// Saves the log for [date]. Logging a real flow also marks the day as a
  /// period day; spotting does not.
  Future<void> saveDailyLog(DateTime date, DailyLog log) async {
    final day = dateOnly(date);
    await _storage.setDailyLog(day, log);
    if (log.isEmpty) {
      dailyLogs.remove(day);
    } else {
      dailyLogs[day] = log;
    }
    if (log.isBleeding && !periodDays.contains(day)) {
      await savePeriodDays({...periodDays, day});
    }
  }

  Future<void> toggleTodaySymptom(String id) {
    final log = todayLog;
    final symptoms = {...log.symptoms};
    if (!symptoms.remove(id)) symptoms.add(id);
    return saveDailyLog(today.value, log.copyWith(symptoms: symptoms));
  }

  /// Erases every logged period day and daily log, and resets the cycle and
  /// period length back to their defaults. Language, theme, onboarding and
  /// reminder preferences are untouched. Irreversible.
  Future<void> clearAllData() async {
    await _storage.clearCycleData();
    periodDays.clear();
    dailyLogs.clear();
    cycleLength.value = defaultCycleLength;
    periodLength.value = defaultPeriodLength;
    refreshToday();
  }

  static int _recentAverage(List<int> values) {
    final recent = values.length > averageWindow
        ? values.sublist(values.length - averageWindow)
        : values;
    return (recent.reduce((a, b) => a + b) / recent.length).round();
  }

  static DateTime _shift(DateTime day, int days) =>
      DateTime(day.year, day.month, day.day + days);

  /// Splits logged days into cycles and returns the period that opens each
  /// one, oldest first.
  ///
  /// A logged day is day 1 of a new cycle only when it is at least
  /// [cycleLength] days after the current cycle's first day. Before that it
  /// belongs to the current cycle: it extends the opening period when it is
  /// at most [maxGapInPeriod] days after it, otherwise it is spotting (not
  /// part of the returned period). Continuous bleeding that runs past the
  /// expected date is split there.
  static List<List<DateTime>> cyclePeriods(
    Iterable<DateTime> days, {
    required int cycleLength,
  }) {
    final sorted = days.toList()..sort();
    final result = <List<DateTime>>[];
    var periodOpen = false;
    for (final day in sorted) {
      if (result.isEmpty ||
          daysBetween(result.last.first, day) >= cycleLength) {
        result.add([day]);
        periodOpen = true;
      } else if (periodOpen &&
          daysBetween(result.last.last, day) <= maxGapInPeriod &&
          daysBetween(result.last.first, day) < maxOpeningPeriodDays) {
        result.last.add(day);
      } else {
        // Spotting ends the opening period for the rest of the cycle.
        periodOpen = false;
      }
    }
    return result;
  }

  /// Splits logged days into periods (see [maxGapInPeriod]).
  static List<List<DateTime>> groupPeriods(Iterable<DateTime> days) {
    final sorted = days.toList()..sort();
    final periods = <List<DateTime>>[];
    for (final day in sorted) {
      if (periods.isNotEmpty &&
          daysBetween(periods.last.last, day) <= maxGapInPeriod) {
        periods.last.add(day);
      } else {
        periods.add([day]);
      }
    }
    return periods;
  }

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Whole calendar days from [from] to [to], unaffected by DST shifts.
  static int daysBetween(DateTime from, DateTime to) => DateTime.utc(
    to.year,
    to.month,
    to.day,
  ).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
}
