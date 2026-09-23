import 'package:d01_period_tracker/app/modules/log_period/period_log_editor.dart';
import 'package:d01_period_tracker/app/services/cycle_service.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime d(int month, int day) => DateTime(2026, month, day);

Set<DateTime> range(DateTime from, int length) => {
  for (var i = 0; i < length; i++)
    DateTime(from.year, from.month, from.day + i),
};

void main() {
  late Set<DateTime> logged;
  late Set<DateTime> autoFilled;

  PeriodLogEditor editor({
    DateTime? today,
    int periodLength = 5,
    int cycleLength = 28,
  }) => PeriodLogEditor(
    logged: logged,
    autoFilled: autoFilled,
    today: today ?? d(9, 23),
    periodLength: periodLength,
    cycleLength: cycleLength,
  );

  List<DateTime> starts({int cycleLength = 28}) => [
    for (final p in CycleService.cyclePeriods(logged, cycleLength: cycleLength))
      p.first,
  ];

  setUp(() {
    logged = {};
    autoFilled = {};
  });

  group('adding — isolated day', () {
    test('future day is ignored', () {
      final r = editor().tap(d(9, 24));
      expect(r.outcome, PeriodTapOutcome.ignored);
      expect(logged, isEmpty);
    });

    test('first ever log fills the average period length', () {
      final r = editor().tap(d(9, 1));
      expect(r.outcome, PeriodTapOutcome.startedWithFill);
      expect(r.autoFilledCount, 4);
      expect(logged, range(d(9, 1), 5));
      expect(autoFilled, range(d(9, 2), 4));
      expect(r.absorbedStarts, isEmpty);
    });

    test('fill stops at today', () {
      final r = editor().tap(d(9, 21));
      expect(r.outcome, PeriodTapOutcome.startedUntilToday);
      expect(r.autoFilledCount, 2);
      expect(logged, range(d(9, 21), 3));
    });

    test('tapping today logs only today', () {
      final r = editor().tap(d(9, 23));
      expect(r.outcome, PeriodTapOutcome.startedUntilToday);
      expect(r.autoFilledCount, 0);
      expect(logged, {d(9, 23)});
    });

    test('day inside the current cycle, before it is due, is mid-cycle', () {
      logged.addAll(range(d(9, 1), 5));
      final r = editor().tap(d(9, 12));
      expect(r.outcome, PeriodTapOutcome.midCycle);
      expect(r.cycleDay, 12);
      expect(logged.difference(range(d(9, 1), 5)), {d(9, 12)});
      expect(starts(), [d(9, 1)]);
    });

    test('day at least a cycle length after the last start opens its own '
        'cycle', () {
      logged.addAll(range(d(8, 20), 5)); // 20–24/08
      final r = editor().tap(d(9, 17)); // 28 days later, exactly due
      expect(r.outcome, PeriodTapOutcome.startedWithFill);
      expect(logged.containsAll(range(d(9, 17), 5)), isTrue);
      expect(starts(), [d(8, 20), d(9, 17)]);
    });

    test('fill that reaches a later logged block bridges into it instead of '
        'leaving a gap', () {
      logged.addAll(range(d(8, 20), 5)); // 20–24/08
      final r = editor(periodLength: 5).tap(d(8, 17)); // isolated, 3 before
      expect(r.outcome, PeriodTapOutcome.merged);
      // 17,18 filled to bridge into the existing 20–24/08 block.
      expect(logged, range(d(8, 17), 8));
      expect(autoFilled, {d(8, 18), d(8, 19)});
      expect(r.autoFilledCount, 2);
      // The whole 17–24/08 run is stored, but only the first 7 days are the
      // opening period; day 8 is retained as bleeding inside the cycle.
      expect(CycleService.cyclePeriods(logged, cycleLength: 30).length, 1);
      expect(
        CycleService.cyclePeriods(logged, cycleLength: 30).single,
        range(d(8, 17), CycleService.maxOpeningPeriodDays).toList(),
      );
    });

    test('bridging into a block still counts as containing it, not '
        'absorbing it, since it stays part of an opening period', () {
      logged.addAll(range(d(8, 20), 5)); // the ONLY period so far: its own
      // cycle, starting 20/08.
      expect(starts(), [d(8, 20)]);
      final r = editor().tap(d(8, 17));
      expect(r.outcome, PeriodTapOutcome.merged);
      // 20/08 no longer opens a cycle, but its days are still part of the
      // (now earlier-starting) opening period, so nothing is "absorbed" —
      // same as a period whose start simply moves a day or two earlier.
      expect(starts(), [d(8, 17)]);
      expect(r.absorbedStarts, isEmpty);
    });
  });

  group('adding — touching a logged day', () {
    test('day right after a period extends it', () {
      logged.addAll(range(d(9, 1), 5)); // 1–5
      final r = editor().tap(d(9, 6));
      expect(r.outcome, PeriodTapOutcome.extended);
      expect(r.autoFilledCount, 0);
      expect(logged, range(d(9, 1), 6));
    });

    test('day before a period extends its start earlier without being '
        'reported as absorbing anything', () {
      logged.addAll(range(d(9, 3), 4));
      final r = editor().tap(d(9, 2));
      expect(r.outcome, PeriodTapOutcome.extended);
      expect(logged, range(d(9, 2), 5));
      expect(starts(), [d(9, 2)]);
      expect(r.absorbedStarts, isEmpty);
    });

    test('one-day hole between two adjacent logged days is a single period, '
        'so filling it is extending, not merging', () {
      logged.addAll({d(9, 1), d(9, 3), d(9, 4)});
      final r = editor().tap(d(9, 2));
      expect(r.outcome, PeriodTapOutcome.extended);
      expect(r.count, 1);
      expect(logged, range(d(9, 1), 4));
    });

    test('hole between two separately-logged blocks is a merge', () {
      logged.addAll({d(9, 1), d(9, 5)});
      final r = editor().tap(d(9, 3));
      expect(r.outcome, PeriodTapOutcome.merged);
      expect(r.count, 3);
      expect(logged, {d(9, 1), d(9, 2), d(9, 3), d(9, 4), d(9, 5)});
    });

    test('gap fill that reaches the cycle length opens a new cycle on the '
        'filled day, not the tapped day', () {
      logged.addAll({...range(d(9, 1), 5), d(9, 28)});
      expect(starts(), [d(9, 1)]); // 28/09 alone is too soon to open one
      final r = editor(today: d(10, 10)).tap(d(9, 30));
      expect(r.outcome, PeriodTapOutcome.newCycleByLength);
      // 29/09 is 28 days after 1/09 and gets auto-filled by the gap-fill.
      expect(r.newCycleStart, d(9, 29));
      expect(starts(), [d(9, 1), d(9, 29)]);
    });

    test('continuous bleeding filled up to the cycle length starts a new '
        'cycle on the tapped day itself', () {
      logged.addAll(range(d(9, 1), 27)); // 1–27/09
      final r = editor(today: d(10, 10)).tap(d(9, 29));
      // 28/09 is filled to bridge 27/09 and 29/09; 29/09 (the tap) is where
      // the cycle length is reached.
      expect(r.outcome, PeriodTapOutcome.newCycleByLength);
      expect(r.newCycleStart, d(9, 29));
      expect(starts(), [d(9, 1), d(9, 29)]);
    });

    test('touching a later period one day early only relocates its start '
        '— still two cycles, not a new one, and nothing absorbed', () {
      logged.addAll({...range(d(9, 1), 5), ...range(d(10, 1), 3)});
      expect(starts(), [d(9, 1), d(10, 1)]);
      final r = editor(today: d(10, 10)).tap(d(9, 30));
      // Same shape as extending a period's start a day earlier: still two
      // cycles, just the second one now starts 30/09 instead of 1/10.
      expect(r.outcome, PeriodTapOutcome.extended);
      expect(starts(), [d(9, 1), d(9, 30)]);
      expect(r.absorbedStarts, isEmpty);
    });
  });

  group('removing', () {
    test('removing the start of a fresh fill undoes the whole fill', () {
      editor().tap(d(9, 1));
      final r = editor().tap(d(9, 1));
      expect(r.outcome, PeriodTapOutcome.removedWithFill);
      expect(r.count, 5);
      expect(logged, isEmpty);
      expect(autoFilled, isEmpty);
    });

    test('removing a filled day trims the fill from there', () {
      editor().tap(d(9, 1)); // 1–5
      final r = editor().tap(d(9, 4));
      expect(r.outcome, PeriodTapOutcome.removedWithFill);
      expect(logged, range(d(9, 1), 3));
    });

    test('removing a confirmed middle day removes only that day', () {
      logged.addAll(range(d(9, 1), 5)); // loaded = confirmed
      final r = editor().tap(d(9, 3));
      expect(r.outcome, PeriodTapOutcome.removed);
      expect(logged, range(d(9, 1), 5)..remove(d(9, 3)));
    });

    test('removing a confirmed start keeps confirmed days', () {
      logged.addAll(range(d(9, 1), 5));
      final r = editor().tap(d(9, 1));
      expect(r.outcome, PeriodTapOutcome.removed);
      expect(logged, range(d(9, 2), 4));
    });

    test('removing a start only undoes the fill it anchored, not a hole-fill '
        'created by a later tap', () {
      logged.addAll(range(d(9, 1), 3)); // 1–3, confirmed
      editor().tap(d(9, 5)); // extends: fills 4 (hole) and 5 (tap)
      expect(autoFilled, {d(9, 4)});
      final r = editor().tap(d(9, 1)); // undo the start
      expect(r.outcome, PeriodTapOutcome.removed);
      expect(r.count, 1);
      // 4/09's fill was anchored on the 5/09 tap, not on 1/09; it stays.
      expect(logged, {d(9, 2), d(9, 3), d(9, 4), d(9, 5)});
    });

    test("removing mid-cycle spotting never touches the next cycle's own "
        'fill', () {
      logged.addAll(range(d(9, 1), 5)); // cycle 1
      editor(
        today: d(10, 10),
      ).tap(d(9, 29)); // starts cycle 2, fills 30/09–3/10
      editor(
        today: d(10, 10),
      ).tap(d(9, 27)); // mid-cycle bleeding, fills 28/09 to bridge 29/09
      expect(
        autoFilled.containsAll({
          d(9, 28),
          d(9, 30),
          d(10, 1),
          d(10, 2),
          d(10, 3),
        }),
        isTrue,
      );

      final r = editor(today: d(10, 10)).tap(d(9, 27)); // undo the spotting
      expect(r.outcome, PeriodTapOutcome.removedWithFill);
      expect(r.count, 2); // 27/09 and its own fill 28/09 only
      expect(logged.containsAll(range(d(9, 29), 5)), isTrue);
      expect(starts(), [d(9, 1), d(9, 29)]);
    });

    test("removing the anchor of a fill that stopped mid-cycle also removes "
        "only that cycle's own fill", () {
      logged.addAll(range(d(9, 1), 5)); // cycle 1
      editor(
        today: d(10, 10),
      ).tap(d(9, 29)); // starts cycle 2, fills 30/09–3/10
      editor(today: d(10, 10)).tap(d(9, 27)); // mid-cycle bleeding, fills 28/09

      final r = editor(
        today: d(10, 10),
      ).tap(d(9, 29)); // undo cycle 2's own start
      expect(r.outcome, PeriodTapOutcome.removedWithFill);
      expect(r.count, 5); // 29/09 and its own 30/09–3/10 fill
      expect(logged, {
        d(9, 1),
        d(9, 2),
        d(9, 3),
        d(9, 4),
        d(9, 5),
        d(9, 27),
        d(9, 28),
      });
      expect(starts(), [d(9, 1)]);
    });

    test('removing a confirmed start reports the cycle it used to open as '
        'absorbed once its days become mid-cycle bleeding', () {
      logged.addAll({...range(d(9, 1), 5), ...range(d(9, 29), 5)});
      expect(starts(), [d(9, 1), d(9, 29)]);
      final r = editor(today: d(10, 10)).tap(d(9, 1));
      // The cycle now starts 2/09; 29/09 alone is only 27 days later, so it
      // is dropped — but 30/09 alone is a full 28 days later and still
      // opens its own (shorter) cycle.
      expect(starts(), [d(9, 2), d(9, 30)]);
      expect(r.absorbedStarts, [d(9, 29)]);
    });
  });

  group('cyclePeriods (cycle-length-based splitting)', () {
    test('a period before the cycle length stays in the old cycle', () {
      final days = {...range(d(8, 1), 5), ...range(d(8, 20), 3)}; // 19 days
      final cycles = CycleService.cyclePeriods(days, cycleLength: 28);
      expect(cycles, hasLength(1)); // 20/08 is mid-cycle bleeding
      expect(cycles.single, range(d(8, 1), 5).toList());
    });

    test('a period at exactly the cycle length opens a new cycle', () {
      final days = {...range(d(8, 1), 5), ...range(d(8, 29), 3)}; // 28 days
      final cycles = CycleService.cyclePeriods(days, cycleLength: 28);
      expect(cycles.map((p) => p.first), [d(8, 1), d(8, 29)]);
    });
  });
}
