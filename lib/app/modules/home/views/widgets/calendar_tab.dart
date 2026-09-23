import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../data/models/cycle_history.dart';
import '../../../../data/models/daily_log.dart';
import '../../../../services/cycle_service.dart';
import '../../../../utils/constants/app_assets.dart';
import '../../../../utils/l10n.dart';
import '../../../../utils/symptom_labels.dart';
import '../../../../widgets/app_background.dart';
import 'home_sheets.dart';

const _ink = Color(0xFF2D2032);
const _muted = Color(0xFF7A6877);
const _calendarPeriod = Color(0xFFD65F87);
const _calendarPeriodSoft = Color(0xFFFFE6EF);
const _calendarFertile = Color(0xFF7BB7A6);
const _calendarFertileSoft = Color(0xFFDCEFEA);
const _calendarOvulation = Color(0xFFA489D8);
const _calendarOvulationSoft = Color(0xFFE8DDF8);
const _logDot = Color(0xFF9A7BC7);
const _calendarTitleStyle = TextStyle(
  color: _ink,
  fontSize: 25,
  height: 1.04,
  fontWeight: FontWeight.w800,
);
const _calendarSubtitleStyle = TextStyle(
  color: _muted,
  fontSize: 12,
  height: 1.22,
  fontWeight: FontWeight.w400,
);
const _calendarMonthStyle = TextStyle(
  color: _ink,
  fontSize: 14,
  height: 1.2,
  fontWeight: FontWeight.w800,
);

/// Full calendar: every day colored by what CycleHistory says about it
/// (logged period, mid-cycle bleeding, predicted period, possible fertile
/// days, estimated ovulation), plus a dot for any day with a daily log.
/// Tapping a day opens its details.
class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  static const _monthsBack = 24;
  static const _headerHeight = 44.0;
  static const _rowHeight = 60.0;

  late final ScrollController _scroll;

  List<DateTime> _months(DateTime today) => [
    for (var i = -_monthsBack; i <= _monthsAheadThroughNextYear(today); i++)
      DateTime(today.year, today.month + i),
  ];

  static int _monthsAheadThroughNextYear(DateTime today) =>
      (today.year + 1 - today.year) * 12 + (12 - today.month);

  static DateTime _lastVisibleDay(DateTime today) =>
      DateTime(today.year + 2, 1, 0);

  static int _forecastCyclesThrough(DateTime from, DateTime to, int length) {
    final days = to.difference(from).inDays + 1;
    final cycles = (days + length - 1) ~/ length;
    return cycles < CycleHistory.forecastCycles
        ? CycleHistory.forecastCycles
        : cycles;
  }

  static int _daysIn(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;
  static int _leadingOf(DateTime month) => month.weekday - 1;
  static double _heightOf(DateTime month) =>
      _headerHeight +
      ((_leadingOf(month) + _daysIn(month)) / 7).ceil() * _rowHeight;

  @override
  void initState() {
    super.initState();
    final cycle = CycleService.to;
    cycle.refreshToday();
    final today = cycle.today.value;
    var offset = 0.0;
    for (final month in _months(today)) {
      if (month.year == today.year && month.month == today.month) break;
      offset += _heightOf(month);
    }
    _scroll = ScrollController(
      initialScrollOffset: (offset - _rowHeight * 2).clamp(
        0.0,
        double.infinity,
      ),
    );
  }

  void _jumpToToday(DateTime today) {
    final months = _months(today);
    var offset = 0.0;
    for (final month in months) {
      if (month.year == today.year && month.month == today.month) break;
      offset += _heightOf(month);
    }
    _scroll.animateTo(
      (offset - _rowHeight * 2).clamp(0.0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppBackground(
      assetPath: AppAssets.bgCalendar,
      overlayColor: const Color(0xFFFFFBFF).withValues(alpha: 0.68),
      child: SafeArea(
        child: Obx(() {
          final cycle = CycleService.to;
          final today = cycle.today.value;
          final periods = cycle.periods;
          final marks = cycle.hasData
              ? CycleHistory.dayMap([
                  ...CycleHistory.history(
                    periods: periods,
                    periodDays: cycle.periodDays,
                    logs: cycle.dailyLogs,
                    today: today,
                    cycleLength: cycle.cycleLength.value,
                    periodLength: cycle.periodLength.value,
                  ),
                  ...CycleHistory.forecast(
                    lastPeriodStart: periods.last.first,
                    today: today,
                    cycleLength: cycle.cycleLength.value,
                    periodLength: cycle.periodLength.value,
                    cycles: _forecastCyclesThrough(
                      periods.last.first,
                      _lastVisibleDay(today),
                      cycle.cycleLength.value,
                    ),
                  ),
                ])
              : const <DateTime, HistoryDay>{};
          // Read so the calendar rebuilds after any log changes.
          cycle.dailyLogs.length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 10, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.homeTabCalendar,
                            style: _calendarTitleStyle,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.calendarSubtitle,
                            style: _calendarSubtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    _CalendarHeaderIconButton(
                      tooltip: l10n.calendarJumpToToday,
                      onPressed: () => _jumpToToday(today),
                      assetPath: AppAssets.calendarHeaderToday,
                    ),
                    const SizedBox(width: 2),
                    _CalendarHeaderIconButton(
                      tooltip: l10n.calendarLegendTooltip,
                      onPressed: () => _showLegend(context),
                      assetPath: AppAssets.calendarHeaderInfo,
                    ),
                  ],
                ),
              ),
              const _WeekdayRow(),
              Expanded(
                child: CustomScrollView(
                  controller: _scroll,
                  slivers: [
                    for (final month in _months(today))
                      _MonthSliver(
                        month: month,
                        today: today,
                        marks: marks,
                        hasLog: (d) => cycle.dailyLogOn(d).isNotEmptyLog,
                        headerHeight: _headerHeight,
                        rowHeight: _rowHeight,
                        onTap: (day) =>
                            _showDayDetail(context, day, marks[day]),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showDayDetail(BuildContext context, DateTime day, HistoryDay? mark) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _DayDetailSheet(day: day, mark: mark),
    );
  }

  void _showLegend(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.calendarLegendTooltip,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              _LegendRow(
                dot: const _KindDot(kind: HistoryDayKind.period),
                label: l10n.cycleHistoryLegendPeriod,
              ),
              _LegendRow(
                dot: const _KindDot(
                  kind: HistoryDayKind.period,
                  predicted: true,
                ),
                label: l10n.cycleHistoryLegendPredicted,
              ),
              _LegendRow(
                dot: const _KindDot(kind: HistoryDayKind.midCycle),
                label: l10n.cycleHistoryLegendMidCycle,
              ),
              _LegendRow(
                dot: const _KindDot(kind: HistoryDayKind.fertile),
                label: l10n.cycleHistoryLegendFertile,
              ),
              _LegendRow(
                dot: const _KindDot(kind: HistoryDayKind.ovulation),
                label: l10n.cycleHistoryLegendOvulation,
              ),
              _LegendRow(
                dot: const _KindDot(kind: HistoryDayKind.other, late: true),
                label: l10n.cycleHistoryLegendLate,
              ),
              _LegendRow(
                dot: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: _logDot,
                    shape: BoxShape.circle,
                  ),
                ),
                label: l10n.calendarLegendLogged,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.cycleHistoryDisclaimer,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: _muted, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarHeaderIconButton extends StatelessWidget {
  const _CalendarHeaderIconButton({
    required this.tooltip,
    required this.onPressed,
    required this.assetPath,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: _calendarPeriodSoft.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(
              child: SvgPicture.asset(
                assetPath,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  _calendarPeriod,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on DailyLog {
  bool get isNotEmptyLog => !isEmpty;
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    final labels = context.l10n.weekdaysShort;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _ink.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: i == DateTime.sunday - 1
                      ? _calendarPeriod
                      : _muted.withValues(alpha: 0.9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.dot, required this.label});

  final Widget dot;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 20, child: Center(child: dot)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _MonthSliver extends StatelessWidget {
  const _MonthSliver({
    required this.month,
    required this.today,
    required this.marks,
    required this.hasLog,
    required this.headerHeight,
    required this.rowHeight,
    required this.onTap,
  });

  final DateTime month;
  final DateTime today;
  final Map<DateTime, HistoryDay> marks;
  final bool Function(DateTime) hasLog;
  final double headerHeight;
  final double rowHeight;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _CalendarTabState._daysIn(month);
    final leading = _CalendarTabState._leadingOf(month);
    final isCurrentMonth =
        month.year == today.year && month.month == today.month;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: headerHeight,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
            child: Text(
              context.l10n.monthYear(month),
              style: _calendarMonthStyle.copyWith(
                color: isCurrentMonth ? _calendarPeriod : _ink,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: rowHeight,
            ),
            itemCount: leading + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leading) return const SizedBox.shrink();
              final date = DateTime(
                month.year,
                month.month,
                index - leading + 1,
              );
              return _DayCell(
                date: date,
                isToday: date == today,
                isFuture: date.isAfter(today),
                mark: marks[date],
                hasLog: hasLog(date),
                onTap: () => onTap(date),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.isToday,
    required this.isFuture,
    required this.mark,
    required this.hasLog,
    required this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isFuture;
  final HistoryDay? mark;
  final bool hasLog;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final kind = mark?.kind ?? HistoryDayKind.other;
    final late = mark?.late ?? false;
    final filled = kind == HistoryDayKind.period && !(mark?.predicted ?? false);
    final loggedBleeding =
        (kind == HistoryDayKind.period || kind == HistoryDayKind.midCycle) &&
        !(mark?.predicted ?? false);
    final loggedAny = hasLog || loggedBleeding;
    final badge = mark == null
        ? null
        : kind == HistoryDayKind.period
        ? mark!.dayOfPeriod
        : mark!.cycleDay;
    final showBadge =
        badge != null && badge > 0 && kind != HistoryDayKind.other;

    return Semantics(
      button: true,
      label: context.l10n.commonDayMonth('${date.day}', '${date.month}'),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 34,
              height: 34,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  _KindDot(
                    kind: kind,
                    predicted: mark?.predicted ?? false,
                    late: late,
                    size: 34,
                  ),
                  Text(
                    '${date.day}',
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      height: 1,
                      fontWeight: filled || isToday
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: filled
                          ? Colors.white
                          : isFuture
                          ? _muted.withValues(alpha: 0.74)
                          : _ink,
                    ),
                  ),
                  if (isToday)
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                  if (showBadge)
                    Positioned(
                      right: -2,
                      top: -4,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 13),
                        height: 13,
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: filled
                              ? Colors.white
                              : _calendarPeriodSoft.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: filled
                                ? Colors.white
                                : _calendarPeriod.withValues(alpha: 0.28),
                            width: 0.7,
                          ),
                        ),
                        child: Text(
                          '$badge',
                          textAlign: TextAlign.center,
                          style: textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                            height: 1.2,
                            fontWeight: FontWeight.w900,
                            color: filled ? _calendarPeriod : _muted,
                          ),
                        ),
                      ),
                    ),
                  if (loggedAny)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: _logDot,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.2),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 9),
          ],
        ),
      ),
    );
  }
}

/// The colored dot/ring/hatch behind a day number, or shown standalone in the
/// legend. Mirrors the encoding used by the cycle-history bars: solid for
/// logged, outlined/dashed for predicted or estimated, dotted for late.
class _KindDot extends StatelessWidget {
  const _KindDot({
    required this.kind,
    this.predicted = false,
    this.late = false,
    this.size = 20,
  });

  final HistoryDayKind kind;
  final bool predicted;
  final bool late;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (late) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _muted.withValues(alpha: 0.5),
            width: 1.2,
            style: BorderStyle.solid,
          ),
        ),
      );
    }
    return switch (kind) {
      HistoryDayKind.period => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: predicted ? _calendarPeriodSoft : _calendarPeriod,
          border: predicted
              ? Border.all(color: _calendarPeriod, width: 1.4)
              : null,
        ),
      ),
      HistoryDayKind.midCycle => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _calendarPeriodSoft,
          border: Border.all(color: _calendarPeriod, width: 1.2),
        ),
      ),
      HistoryDayKind.fertile => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _calendarFertileSoft.withValues(alpha: predicted ? 0.74 : 1),
          border: predicted
              ? Border.all(color: _calendarFertile, width: 1.1)
              : null,
        ),
      ),
      HistoryDayKind.ovulation => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: predicted ? _calendarOvulationSoft : _calendarOvulation,
        ),
      ),
      HistoryDayKind.other => const SizedBox.shrink(),
    };
  }
}

class _DayDetailSheet extends StatelessWidget {
  const _DayDetailSheet({required this.day, required this.mark});

  final DateTime day;
  final HistoryDay? mark;

  String? _kindLabel(AppLocalizations l10n) {
    if (mark == null) return null;
    return switch (mark!.kind) {
      HistoryDayKind.period =>
        mark!.predicted
            ? l10n.cycleHistoryLegendPredicted
            : l10n.cycleHistoryLegendPeriod,
      HistoryDayKind.midCycle => l10n.cycleHistoryLegendMidCycle,
      HistoryDayKind.fertile => l10n.cycleHistoryLegendFertile,
      HistoryDayKind.ovulation => l10n.cycleHistoryLegendOvulation,
      HistoryDayKind.other => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final cycle = CycleService.to;
    final today = cycle.today.value;
    final isFuture = day.isAfter(today);
    final log = isFuture ? const DailyLog() : cycle.dailyLogOn(day);
    final kindLabel = _kindLabel(l10n);
    final kindColor = switch (mark?.kind) {
      HistoryDayKind.period || HistoryDayKind.midCycle => _calendarPeriod,
      HistoryDayKind.fertile => _calendarFertile,
      HistoryDayKind.ovulation => _calendarOvulation,
      _ => null,
    };
    final chips = [
      if (log.flow != null)
        (Icons.water_drop_rounded, flowLabel(log.flow!, l10n)),
      for (final id in log.moods) (Icons.mood_rounded, moodLabel(id, l10n)),
      for (final id in log.symptoms)
        (Icons.spa_rounded, symptomLabel(id, l10n)),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.weekdayLong(day.weekday)}, ${l10n.dayMonth(day)}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            if (kindLabel != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: kindColor?.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  kindLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: kindColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            if (kindLabel != null) const SizedBox(height: 14),
            if (!isFuture && chips.isEmpty && log.note.trim().isEmpty)
              Text(
                l10n.calendarDetailNoLog,
                style: textTheme.bodyMedium?.copyWith(color: _muted),
              ),
            if (chips.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (icon, label) in chips)
                    Chip(
                      avatar: Icon(icon, size: 16),
                      label: Text(label),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            if (log.note.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l10n.dailyLogNote,
                style: textTheme.labelMedium?.copyWith(
                  color: _muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(log.note.trim(), style: textTheme.bodyMedium),
            ],
            if (!isFuture) ...[
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDailyLogSheet(context, date: day);
                  },
                  icon: const Icon(Icons.edit_note_rounded, size: 20),
                  label: Text(l10n.calendarLogButton),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
