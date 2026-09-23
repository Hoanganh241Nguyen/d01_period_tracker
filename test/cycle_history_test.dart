import 'package:d01_period_tracker/app/data/models/cycle_history.dart';
import 'package:d01_period_tracker/app/data/models/daily_log.dart';
import 'package:d01_period_tracker/app/services/cycle_service.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime d(int month, int day, [int year = 2026]) => DateTime(year, month, day);

Set<DateTime> range(DateTime start, int length) => {
  for (var i = 0; i < length; i++)
    DateTime(start.year, start.month, start.day + i),
};

List<List<DateTime>> periodsOf(Set<DateTime> days, int cycleLength) =>
    CycleService.cyclePeriods(days, cycleLength: cycleLength);

void main() {
  group('history', () {
    test('a finished cycle gets its real length and an ovulation estimate', () {
      final days = {...range(d(7, 1), 5), ...range(d(7, 29), 4)};
      final history = CycleHistory.history(
        periods: periodsOf(days, 28),
        periodDays: days,
        logs: const {},
        today: d(8, 15),
        cycleLength: 28,
        periodLength: 5,
      );
      // Newest first: the running cycle (29/07 → today), then the finished one.
      expect(history, hasLength(2));
      final finished = history[1];
      expect(finished.status, CycleEntryStatus.finished);
      expect(finished.start, d(7, 1));
      expect(finished.end, d(7, 28));
      expect(finished.length, 28);
      expect(finished.periodLength, 5);
      // Ovulation day = cycleLength(28) − luteal(14) = day 14 → 14/07.
      expect(finished.ovulation, d(7, 14));
      expect(finished.fertileStart, d(7, 9));
    });

    test('the running cycle uses the cycle length and marks today', () {
      final days = range(d(7, 1), 5);
      final history = CycleHistory.history(
        periods: periodsOf(days, 28),
        periodDays: days,
        logs: const {},
        today: d(7, 10),
        cycleLength: 28,
        periodLength: 5,
      );
      final current = history.single;
      expect(current.status, CycleEntryStatus.current);
      expect(current.length, 10); // days so far
      expect(current.end, d(7, 28)); // expected end
      expect(current.ovulation, d(7, 14));
    });

    test('a late cycle has no ovulation estimate and no expected end', () {
      final days = range(d(7, 1), 5);
      final history = CycleHistory.history(
        periods: periodsOf(days, 28),
        periodDays: days,
        logs: const {},
        today: d(8, 5), // day 36, past the 28-day cycle length
        cycleLength: 28,
        periodLength: 5,
      );
      final late = history.single;
      expect(late.status, CycleEntryStatus.late);
      // Day cycleLength + 1 (29) is due, not late; lateness starts day 30.
      expect(late.daysLate, 7);
      expect(late.end, d(8, 5)); // today, not a guessed end
      expect(late.ovulation, isNull);
    });

    test('mid-cycle bleeding is not counted as the period and not confused '
        'with the next cycle', () {
      final days = {
        ...range(d(7, 1), 5),
        d(7, 20), // mid-cycle bleeding
        ...range(d(7, 29), 5), // next cycle, exactly at the cycle length
      };
      final history = CycleHistory.history(
        periods: periodsOf(days, 28),
        periodDays: days,
        logs: const {},
        today: d(8, 10),
        cycleLength: 28,
        periodLength: 5,
      );
      final finished = history.firstWhere(
        (e) => e.status == CycleEntryStatus.finished,
      );
      expect(finished.periodLength, 5); // the mid-cycle day is not counted
      expect(finished.midCycleDays, 1);
      final midCycleDay = finished.days.firstWhere(
        (day) => day.date == d(7, 20),
      );
      expect(midCycleDay.kind, HistoryDayKind.midCycle);
    });

    test('logged past days keep period and calculated cycle day numbers', () {
      final days = {...range(d(7, 1), 5), d(7, 20), ...range(d(7, 29), 5)};
      final history = CycleHistory.history(
        periods: periodsOf(days, 28),
        periodDays: days,
        logs: const {},
        today: d(8, 10),
        cycleLength: 28,
        periodLength: 5,
      );
      final marks = CycleHistory.dayMap(history);

      expect(marks[d(7, 3)]?.kind, HistoryDayKind.period);
      expect(marks[d(7, 3)]?.dayOfPeriod, 3);
      expect(marks[d(7, 3)]?.cycleDay, 3);
      expect(marks[d(7, 20)]?.kind, HistoryDayKind.midCycle);
      expect(marks[d(7, 20)]?.dayOfPeriod, 0);
      expect(marks[d(7, 20)]?.cycleDay, 20);
    });

    test('a gap over maxCycleDays is incomplete and carries no estimate', () {
      final days = {
        ...range(d(1, 1), 5),
        ...range(d(4, 1), 5),
      }; // 90 days apart
      final history = CycleHistory.history(
        periods: periodsOf(days, 28),
        periodDays: days,
        logs: const {},
        today: d(4, 10),
        cycleLength: 28,
        periodLength: 5,
      );
      final gap = history.firstWhere(
        (e) => e.status == CycleEntryStatus.incomplete,
      );
      expect(gap.ovulation, isNull);
      expect(gap.length, 90);
      // The bar is capped at maxCycleDays so it never outgrows the shared
      // day axis, but that still covers the whole opening period.
      expect(gap.days, hasLength(CycleService.maxCycleDays));
    });

    test(
      'the opening period of an incomplete gap still shows on the calendar',
      () {
        final days = {...range(d(1, 1), 5), ...range(d(4, 1), 5)};
        final history = CycleHistory.history(
          periods: periodsOf(days, 28),
          periodDays: days,
          logs: const {},
          today: d(4, 10),
          cycleLength: 28,
          periodLength: 5,
        );
        final marks = CycleHistory.dayMap(history);
        for (final day in range(d(1, 1), 5)) {
          expect(marks[day]?.kind, HistoryDayKind.period);
        }
      },
    );

    test('ovulation is not estimated outside the plausible cycle range', () {
      final days = {...range(d(1, 1), 3), ...range(d(1, 15), 3)};
      final short = CycleHistory.history(
        periods: periodsOf(days, 14),
        periodDays: days,
        logs: const {},
        today: d(1, 20),
        cycleLength: 14,
        periodLength: 3,
      );
      final finishedShort = short.firstWhere(
        (e) => e.status == CycleEntryStatus.finished,
      );
      expect(finishedShort.length, 14); // below minEstimable (21)
      expect(finishedShort.ovulation, isNull);
    });

    test('symptoms are attributed to the cycle they were logged in', () {
      final days = {...range(d(7, 1), 5), ...range(d(7, 29), 4)};
      final history = CycleHistory.history(
        periods: periodsOf(days, 28),
        periodDays: days,
        logs: {
          d(7, 3): const DailyLog(symptoms: {'cramps'}),
          d(8, 2): const DailyLog(
            symptoms: {'headache'},
          ), // in the running cycle
        },
        today: d(8, 15),
        cycleLength: 28,
        periodLength: 5,
      );
      final finished = history.firstWhere(
        (e) => e.status == CycleEntryStatus.finished,
      );
      final current = history.firstWhere((e) => e.isOngoing);
      expect(finished.symptoms, {'cramps'});
      expect(current.symptoms, {'headache'});
    });
  });

  group('forecast', () {
    test('predicts forecastCycles ahead from the last period start', () {
      final forecast = CycleHistory.forecast(
        lastPeriodStart: d(7, 1),
        today: d(7, 10),
        cycleLength: 28,
        periodLength: 5,
      );
      expect(forecast, hasLength(CycleHistory.forecastCycles));
      expect(forecast[0].start, d(7, 29));
      expect(forecast[1].start, d(8, 26));
      expect(
        forecast.every((e) => e.status == CycleEntryStatus.predicted),
        isTrue,
      );
    });

    test('predicted cycles show fertile windows and ovulation estimates', () {
      final forecast = CycleHistory.forecast(
        lastPeriodStart: d(7, 1),
        today: d(7, 10),
        cycleLength: 28,
        periodLength: 5,
      );
      expect(forecast.every((e) => e.ovulation != null), isTrue);
      expect(forecast.every((e) => e.fertileStart != null), isTrue);

      final days = CycleHistory.dayMap(forecast);
      expect(days[d(8, 11)]?.kind, HistoryDayKind.ovulation);
      expect(days[d(9, 8)]?.kind, HistoryDayKind.ovulation);
      expect(days[d(8, 6)]?.kind, HistoryDayKind.fertile);
      expect(days[d(8, 6)]?.predicted, isTrue);
    });

    test('can extend forecast beyond the default calendar range', () {
      final forecast = CycleHistory.forecast(
        lastPeriodStart: d(7, 1),
        today: d(7, 10),
        cycleLength: 28,
        periodLength: 5,
        cycles: 6,
      );
      expect(forecast, hasLength(6));
      expect(forecast.last.start, d(12, 16));
      expect(forecast.last.ovulation, d(12, 29));
    });

    test('no forecast once the current period is late', () {
      final forecast = CycleHistory.forecast(
        lastPeriodStart: d(7, 1),
        today: d(8, 5), // day 36 of a 28-day cycle: late
        cycleLength: 28,
        periodLength: 5,
      );
      expect(forecast, isEmpty);
    });
  });

  group('summary', () {
    test('null before any cycle has finished', () {
      final days = range(d(7, 1), 5);
      final history = CycleHistory.history(
        periods: periodsOf(days, 28),
        periodDays: days,
        logs: const {},
        today: d(7, 10),
        cycleLength: 28,
        periodLength: 5,
      );
      expect(CycleHistory.summary(history), isNull);
    });

    test(
      'median and range come from finished cycles only, not the running one',
      () {
        // Cycle 1: 01–05/01. Cycle 2 starts 26 days later (27/01), cycle 3
        // (running) starts 33 days after that (01/03) — both gaps clear a
        // 21-day cycle length. Only the first two are finished.
        final days = {
          ...range(d(1, 1), 5),
          ...range(d(1, 27), 5),
          ...range(d(3, 1), 5), // running
        };
        final history = CycleHistory.history(
          periods: periodsOf(days, 21),
          periodDays: days,
          logs: const {},
          today: d(3, 10),
          cycleLength: 21,
          periodLength: 5,
        );
        final summary = CycleHistory.summary(history)!;
        expect(summary.count, 2);
        expect(summary.shortest, 26);
        expect(summary.longest, 33);
        expect(summary.typical, 33);
      },
    );
  });
}
