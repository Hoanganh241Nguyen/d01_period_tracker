import 'package:d01_period_tracker/app/data/models/cycle_day_info.dart';
import 'package:d01_period_tracker/app/data/models/cycle_insights.dart';
import 'package:d01_period_tracker/app/data/models/daily_log.dart';
import 'package:d01_period_tracker/app/data/providers/local_storage_provider.dart';
import 'package:d01_period_tracker/app/services/cycle_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

DateTime _daysFromToday(int days) {
  final t = _today();
  return DateTime(t.year, t.month, t.day + days);
}

DateTime _shift(DateTime day, int days) =>
    DateTime(day.year, day.month, day.day + days);

Set<DateTime> _period(DateTime start, int length) => {
  for (var i = 0; i < length; i++)
    DateTime(start.year, start.month, start.day + i),
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CycleService cycle;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
    Get.put(await LocalStorageProvider.create());
    cycle = await CycleService().init();
  });

  group('without data', () {
    test('nothing is invented', () {
      expect(cycle.hasData, isFalse);
      expect(cycle.todayInfo.value, isNull);
      expect(cycle.nextPeriodStart, isNull);
      expect(cycle.infoFor(_today()), isNull);
    });

    test('onboarding without a date only saves the estimates', () async {
      await cycle.completeOnboarding(cycleLength: 30, periodLength: 6);
      expect(cycle.onboardingDone, isTrue);
      expect(cycle.cycleLength.value, 30);
      expect(cycle.periodLength.value, 6);
      expect(cycle.todayInfo.value, isNull);
    });
  });

  group('onboarding with a last period date', () {
    test('logs the period and computes today', () async {
      final start = _daysFromToday(-10);
      await cycle.completeOnboarding(
        cycleLength: 28,
        periodLength: 5,
        lastPeriodStart: start,
      );
      expect(cycle.periodDays, _period(start, 5));
      expect(cycle.todayInfo.value!.cycleDay, 11);
      expect(cycle.nextPeriodStart, _daysFromToday(18));
      expect(cycle.isPredictedPeriodDay(_daysFromToday(18)), isTrue);
      expect(cycle.isPredictedPeriodDay(_daysFromToday(23)), isFalse);
    });

    test('a period that started yesterday is not cut short', () async {
      await cycle.completeOnboarding(
        cycleLength: 28,
        periodLength: 5,
        lastPeriodStart: _daysFromToday(-1),
      );
      // Only yesterday and today can be logged; the rest is predicted.
      expect(cycle.periodDays, hasLength(2));
      expect(cycle.periodLength.value, 5);
      expect(cycle.todayInfo.value!.phase, CyclePhase.menstrual);
      expect(cycle.isPredictedPeriodDay(_daysFromToday(3)), isTrue);
    });

    test('today is not shown as period unless today is logged', () async {
      await cycle.savePeriodDays({_daysFromToday(-1)});
      expect(cycle.todayInfo.value!.cycleDay, 2);
      expect(cycle.todayInfo.value!.phase, CyclePhase.follicular);
      expect(cycle.isPredictedPeriodDay(_daysFromToday(27)), isTrue);
    });
  });

  group('learning from logged periods', () {
    test('averages come from finished cycles', () async {
      final first = _daysFromToday(-65);
      final second = _daysFromToday(-35);
      final third = _daysFromToday(-5);
      await cycle.savePeriodDays({
        ..._period(first, 4),
        ..._period(second, 6),
        ..._period(third, 4),
      });
      // The cycle length is the user's setting, never re-learned.
      expect(cycle.cycleLength.value, CycleService.defaultCycleLength);
      expect(cycle.periodLength.value, 5);
      expect(cycle.completedCycles.map((c) => c.length), [30, 30]);
      expect(cycle.todayInfo.value!.cycleDay, 6);
    });

    test(
      'a period before the set cycle length stays in the old cycle',
      () async {
        await cycle.completeOnboarding(
          cycleLength: 30,
          periodLength: 5,
          lastPeriodStart: _daysFromToday(-40),
        );
        // 28 days later: a normal cycle for many, but the user set 30.
        await cycle.savePeriodDays({
          ...cycle.periodDays,
          ..._period(_daysFromToday(-12), 2),
        });
        expect(cycle.periods, hasLength(1));
        expect(cycle.cycleLength.value, 30);
        expect(cycle.todayInfo.value!.isLate, isTrue);
      },
    );

    test('spotting does not restart the cycle', () async {
      final start = _daysFromToday(-12);
      await cycle.savePeriodDays({..._period(start, 5), _daysFromToday(-1)});
      expect(cycle.periods, hasLength(1));
      expect(cycle.todayInfo.value!.cycleDay, 13);
    });

    test('late period is reported, not rolled into a new cycle', () async {
      await cycle.completeOnboarding(
        cycleLength: 28,
        periodLength: 5,
        lastPeriodStart: _daysFromToday(-31),
      );
      final info = cycle.todayInfo.value!;
      expect(info.isLate, isTrue);
      // Day cycleLength + 1 (29) is due, not late; lateness starts day 30.
      expect(info.daysLate, 3);
      expect(cycle.nextPeriodStart, isNull);
    });
  });

  group('cycle length setting', () {
    test('a learned value left by an old version is reset', () async {
      // The state found on the test device: cycle length 15 learned by an
      // earlier version, plus its legacy key.
      SharedPreferences.setMockInitialValues({
        'cycle_length': 15,
        'last_period_start': '2026-09-16',
      });
      Get.reset();
      Get.put(await LocalStorageProvider.create());
      final migrated = await CycleService().init();
      expect(migrated.cycleLength.value, CycleService.defaultCycleLength);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('cycle_length'), CycleService.defaultCycleLength);
      expect(prefs.containsKey('last_period_start'), isFalse);
    });

    test('a valid setting is kept', () async {
      SharedPreferences.setMockInitialValues({'cycle_length': 32});
      Get.reset();
      Get.put(await LocalStorageProvider.create());
      final kept = await CycleService().init();
      expect(kept.cycleLength.value, 32);
    });

    test('a stale learned period length is recomputed from periodDays on '
        'load', () async {
      // The state found on a test device: a 13-day logged block plus some
      // scattered mid-cycle bleeding, but 'period_length' stuck at 8 from
      // before all of it was logged (or from an older version of the
      // averaging logic) — never recomputed since, because nothing has
      // re-saved periodDays since then.
      final start = _daysFromToday(-22); // so today is cycle day 23
      final periodDays = [
        for (var i = 0; i < 13; i++)
          LocalStorageProvider.dateKey(_shift(start, i)),
        LocalStorageProvider.dateKey(_shift(start, 15)),
        LocalStorageProvider.dateKey(_shift(start, 16)),
        LocalStorageProvider.dateKey(_shift(start, 19)),
        LocalStorageProvider.dateKey(_shift(start, 21)),
      ];
      SharedPreferences.setMockInitialValues({
        'cycle_length': 28,
        'period_length': 8,
        'period_days': periodDays,
      });
      Get.reset();
      Get.put(await LocalStorageProvider.create());
      final healed = await CycleService().init();

      // The 13-day block is a messy continuous log. Only the first 7 days
      // count as the opening period; the rest is bleeding inside the cycle.
      expect(healed.periods, hasLength(1));
      expect(healed.periodLength.value, CycleService.maxOpeningPeriodDays);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('period_length'), CycleService.maxOpeningPeriodDays);
      // The ring's own numbers stay correct and consistent throughout.
      expect(healed.todayInfo.value!.cycleDay, 23);
      expect(healed.todayInfo.value!.daysToNextPeriod, 6);
    });

    test(
      'messy continuous bleeding after day 7 is mid-cycle, not period',
      () async {
        final start = _daysFromToday(-8);
        await cycle.savePeriodDays(_period(start, 9));

        expect(cycle.periods.single, _period(start, 7).toList());
        expect(cycle.todayInfo.value!.cycleDay, 9);
        expect(cycle.todayInfo.value!.phase, isNot(CyclePhase.menstrual));
        expect(cycle.isMidCycleBleeding(_today()), isTrue);
      },
    );

    test('changing it re-splits cycles and flags mid-cycle bleeding', () async {
      final start = _daysFromToday(-21);
      await cycle.savePeriodDays({
        ..._period(start, 5),
        ..._period(_daysFromToday(-6), 3), // day 16–18 of the cycle
        _today(),
      });
      await cycle.setCycleLength(21);
      expect(cycle.periods, hasLength(2)); // today is day 22 → new cycle
      expect(cycle.todayInfo.value!.cycleDay, 1);

      await cycle.setCycleLength(28);
      expect(cycle.periods, hasLength(1));
      expect(cycle.todayInfo.value!.cycleDay, 22);
      expect(cycle.isMidCycleBleeding(_today()), isTrue);
      expect(cycle.isMidCycleBleeding(start), isFalse);
    });
  });

  group('daily log', () {
    test('a real flow marks a period day, spotting does not', () async {
      final day = _daysFromToday(-2);
      await cycle.saveDailyLog(day, const DailyLog(flow: FlowLevel.spotting));
      expect(cycle.periodDays, isEmpty);
      await cycle.saveDailyLog(day, const DailyLog(flow: FlowLevel.medium));
      expect(cycle.periodDays, {day});
    });

    test('logs survive a reload', () async {
      await cycle.toggleTodaySymptom('cramps');
      final reloaded = await CycleService().init();
      expect(reloaded.todaySymptoms, {'cramps'});
    });
  });

  group('insights', () {
    test('cycle and period variability levels', () {
      expect(CycleInsights.cycleStats([28]), isNull);
      expect(CycleInsights.cycleStats([28, 29, 27])!.level, Variability.stable);
      expect(CycleInsights.cycleStats([24, 34])!.level, Variability.mild);
      expect(CycleInsights.cycleStats([28, 38])!.level, Variability.notable);
      final severe = CycleInsights.cycleStats([28, 50, 29])!;
      expect(severe.level, Variability.severe);
      expect(severe.outlier, 50);

      expect(CycleInsights.periodStats([5, 6])!.level, Variability.stable);
      expect(CycleInsights.periodStats([3, 6])!.level, Variability.mild);
      expect(CycleInsights.periodStats([5, 8])!.level, Variability.notable);
      expect(CycleInsights.periodStats([5, 11])!.level, Variability.severe);
    });

    test('symptoms recurring in two cycles become patterns', () {
      final a = DateTime(2026, 7, 1);
      final b = DateTime(2026, 7, 29);
      final c = DateTime(2026, 8, 26);
      final periods = [
        _period(a, 5).toList(),
        _period(b, 5).toList(),
        _period(c, 5).toList(),
      ];
      final patterns = CycleInsights.patterns(
        periods: periods,
        logs: {
          DateTime(2026, 7, 1): const DailyLog(symptoms: {'cramps'}),
          DateTime(2026, 7, 30): const DailyLog(symptoms: {'cramps'}),
          DateTime(2026, 7, 26): const DailyLog(symptoms: {'acne'}),
          DateTime(2026, 8, 24): const DailyLog(symptoms: {'acne'}),
          DateTime(2026, 7, 15): const DailyLog(symptoms: {'headache'}),
        },
      );
      final byId = {for (final p in patterns) p.symptomId: p};
      expect(byId.keys, containsAll(['cramps', 'acne']));
      expect(byId.containsKey('headache'), isFalse);
      expect(byId['cramps']!.timing, PatternTiming.duringPeriod);
      expect(byId['cramps']!.firstDay, 1);
      expect(byId['cramps']!.lastDay, 2);
      expect(byId['acne']!.timing, PatternTiming.beforePeriod);
      expect(byId['acne']!.daysBeforePeriod, 3);
    });
  });
}
