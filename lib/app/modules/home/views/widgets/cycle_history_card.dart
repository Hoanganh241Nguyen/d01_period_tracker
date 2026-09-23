import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/cycle_history.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/l10n.dart';
import '../../../../utils/symptom_labels.dart';
import '../../../cycle_phase/phase_content.dart';

const _ink = Color(0xFF2D2032);
const _muted = Color(0xFF7A6877);
const _track = Color(0xFFEFE6EA);
const _lateDot = Color(0xFFB8A9AF);
const _warning = Color(0xFFFB8C00);

/// One timeline for the past and the next few cycles: upcoming cycles above a
/// "today" divider, the running cycle and past cycles below it. Every cycle
/// is a bar on a shared day axis, so long and short cycles stand out.
class CycleHistoryCard extends StatefulWidget {
  const CycleHistoryCard({
    super.key,
    required this.history,
    required this.forecast,
    required this.cycleLength,
  });

  /// Newest first, starting with the running cycle.
  final List<CycleHistoryEntry> history;

  /// Soonest first.
  final List<CycleHistoryEntry> forecast;

  /// The user's cycle length, used for predictions.
  final int cycleLength;

  @override
  State<CycleHistoryCard> createState() => _CycleHistoryCardState();
}

class _CycleHistoryCardState extends State<CycleHistoryCard> {
  /// Running cycle plus five past cycles before "show all".
  static const _collapsedRows = 6;

  /// The axis always fits at least this many days and at most the longest
  /// cycle that is still counted.
  static const _minAxisDays = 35;
  static const _maxAxisDays = 60;

  final _expanded = <DateTime>{};
  var _showAll = false;

  void _toggle(DateTime start) => setState(() {
    if (!_expanded.remove(start)) _expanded.add(start);
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final summary = CycleHistory.summary(widget.history);
    final past = _showAll
        ? widget.history
        : widget.history.take(_collapsedRows).toList();
    final upcoming = widget.forecast.reversed.toList(); // farthest on top
    final visible = [...upcoming, ...past];
    final axisDays = visible
        .map((e) => e.days.length)
        .fold(_minAxisDays, math.max)
        .clamp(_minAxisDays, _maxAxisDays);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final pxPerDay = constraints.maxWidth / axisDays;
          Widget row(CycleHistoryEntry entry) => _CycleRow(
            entry: entry,
            pxPerDay: pxPerDay,
            typical: summary?.typical,
            cycleLength: widget.cycleLength,
            expanded: _expanded.contains(entry.start),
            onTap: () => _toggle(entry.start),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.cycleHistoryTitle,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.cycleHistoryLegendTooltip,
                    onPressed: () => _showLegend(context),
                    icon: const Icon(Icons.info_outline_rounded, size: 20),
                  ),
                ],
              ),
              Text(
                _summaryText(l10n, summary),
                style: textTheme.bodySmall?.copyWith(
                  color: _muted,
                  height: 1.35,
                ),
              ),
              if (upcoming.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.cycleHistoryUpcoming.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: _muted,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                for (final entry in upcoming) row(entry),
              ],
              _TodayDivider(label: l10n.commonToday),
              for (var i = 0; i < past.length; i++) ...[
                if (i > 0 && past[i].start.year != past[i - 1].start.year)
                  _YearDivider(year: past[i].start.year),
                row(past[i]),
              ],
              if (widget.history.length > _collapsedRows)
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    child: Text(
                      _showAll
                          ? l10n.cycleHistoryShowLess
                          : l10n.cycleHistoryShowAll(widget.history.length),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _summaryText(AppLocalizations l10n, CycleSummary? summary) {
    if (summary == null) return l10n.cycleHistoryNeedMore;
    String range(int min, int max) =>
        min == max ? l10n.commonDays(min) : l10n.cycleHistoryDayRange(min, max);
    return '${l10n.cycleHistorySummary(summary.count, range(summary.shortest, summary.longest), summary.typical)}'
        ' · ${l10n.cycleHistorySummaryPeriod(range(summary.shortestPeriod, summary.longestPeriod))}';
  }

  void _showLegend(BuildContext context) {
    final l10n = context.l10n;
    HistoryDay day(HistoryDayKind kind, {bool predicted = false}) =>
        HistoryDay(DateTime(2000), kind, predicted: predicted);
    final items = <(List<HistoryDay>, String)>[
      (
        List.filled(4, day(HistoryDayKind.period)),
        l10n.cycleHistoryLegendPeriod,
      ),
      (
        List.filled(4, day(HistoryDayKind.period, predicted: true)),
        l10n.cycleHistoryLegendPredicted,
      ),
      (
        [
          day(HistoryDayKind.other),
          day(HistoryDayKind.midCycle),
          day(HistoryDayKind.other),
          day(HistoryDayKind.other),
        ],
        l10n.cycleHistoryLegendMidCycle,
      ),
      (
        List.filled(4, day(HistoryDayKind.fertile)),
        l10n.cycleHistoryLegendFertile,
      ),
      (
        [
          day(HistoryDayKind.fertile),
          day(HistoryDayKind.ovulation),
          day(HistoryDayKind.other),
          day(HistoryDayKind.other),
        ],
        l10n.cycleHistoryLegendOvulation,
      ),
      (
        List.filled(
          4,
          HistoryDay(DateTime(2000), HistoryDayKind.other, late: true),
        ),
        l10n.cycleHistoryLegendLate,
      ),
    ];

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
                l10n.cycleHistoryLegendTooltip,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              for (final (days, label) in items)
                _LegendRow(
                  sample: SizedBox(
                    width: 44,
                    height: 24,
                    child: CustomPaint(
                      painter: _CycleBarPainter(days: days, pxPerDay: 11),
                    ),
                  ),
                  label: label,
                ),
              _LegendRow(
                sample: SizedBox(
                  width: 44,
                  height: 24,
                  child: CustomPaint(
                    painter: _CycleBarPainter(
                      days: List.filled(4, day(HistoryDayKind.other)),
                      pxPerDay: 11,
                      typicalLength: 2,
                    ),
                  ),
                ),
                label: l10n.cycleHistoryLegendTypical,
              ),
              _LegendRow(
                sample: SizedBox(
                  width: 44,
                  height: 24,
                  child: CustomPaint(
                    painter: _CycleBarPainter(
                      days: List.filled(4, day(HistoryDayKind.other)),
                      pxPerDay: 11,
                      todayIndex: 1,
                    ),
                  ),
                ),
                label: l10n.commonToday,
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

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.sample, required this.label});

  final Widget sample;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          sample,
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _TodayDivider extends StatelessWidget {
  const _TodayDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Divider(color: color.withValues(alpha: 0.4))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(child: Divider(color: color.withValues(alpha: 0.4))),
        ],
      ),
    );
  }
}

class _YearDivider extends StatelessWidget {
  const _YearDivider({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2),
      child: Text(
        '$year',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: _muted,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CycleRow extends StatelessWidget {
  const _CycleRow({
    required this.entry,
    required this.pxPerDay,
    required this.typical,
    required this.cycleLength,
    required this.expanded,
    required this.onTap,
  });

  final CycleHistoryEntry entry;
  final double pxPerDay;

  /// Typical cycle length, drawn as a guide line; null before any cycle ends.
  final int? typical;
  final int cycleLength;
  final bool expanded;
  final VoidCallback onTap;

  bool get _predicted => entry.status == CycleEntryStatus.predicted;

  /// A single cycle outside both the consumer (21–35) and the clinical
  /// (24–38) ranges; informational only.
  bool get _outsideCommonRange =>
      entry.status == CycleEntryStatus.finished &&
      (entry.length < 21 || entry.length > 38);

  String _title(AppLocalizations l10n) => switch (entry.status) {
    CycleEntryStatus.predicted => l10n.cycleHistoryAround(
      l10n.dayMonth(entry.start),
    ),
    CycleEntryStatus.current || CycleEntryStatus.late =>
      l10n.cycleHistoryRangeNow(l10n.dayMonth(entry.start)),
    _ => l10n.cycleHistoryRange(
      l10n.dayMonth(entry.start),
      l10n.dayMonth(entry.end),
    ),
  };

  String _subtitle(AppLocalizations l10n) {
    if (entry.status == CycleEntryStatus.incomplete) {
      return l10n.cycleHistoryMissing;
    }
    if (_predicted) {
      return l10n.cycleHistoryPredictedPeriodDays(entry.periodLength);
    }
    final period = l10n.cycleHistoryPeriodDays(entry.periodLength);
    return entry.midCycleDays == 0
        ? period
        : '$period · ${l10n.cycleHistoryMidCycleDays(entry.midCycleDays)}';
  }

  String? _difference(AppLocalizations l10n) {
    final typical = this.typical;
    if (typical == null || entry.status != CycleEntryStatus.finished) {
      return null;
    }
    final diff = entry.length - typical;
    return diff > 0
        ? l10n.cycleHistoryDiffLonger(diff)
        : diff < 0
        ? l10n.cycleHistoryDiffShorter(-diff)
        : l10n.cycleHistoryDiffSame;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final lengthText = entry.status == CycleEntryStatus.current
        ? l10n.cycleHistoryCurrentDay(entry.length)
        : l10n.commonDays(entry.length);

    return Semantics(
      button: true,
      expanded: expanded,
      label: l10n.cycleHistoryRowSemantics(
        _title(l10n),
        lengthText,
        [_subtitle(l10n), ?_difference(l10n)].join('. '),
      ),
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Opacity(
          opacity: _predicted ? 0.75 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _title(l10n),
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                    ),
                    _Trailing(
                      entry: entry,
                      typical: typical,
                      outsideCommonRange: _outsideCommonRange,
                    ),
                    Icon(
                      expanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: 20,
                      color: _muted,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(l10n),
                  style: textTheme.bodySmall?.copyWith(color: _muted),
                ),
                if (entry.days.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  RepaintBoundary(
                    child: SizedBox(
                      height: 24,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _CycleBarPainter(
                          days: entry.days,
                          pxPerDay: pxPerDay,
                          typicalLength: typical,
                          // For a running cycle, length is days so far.
                          todayIndex: entry.isOngoing ? entry.length - 1 : null,
                        ),
                      ),
                    ),
                  ),
                ],
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: expanded
                      ? _Details(
                          entry: entry,
                          cycleLength: cycleLength,
                          difference: _difference(l10n),
                          outsideCommonRange: _outsideCommonRange,
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    required this.entry,
    required this.typical,
    required this.outsideCommonRange,
  });

  final CycleHistoryEntry entry;
  final int? typical;
  final bool outsideCommonRange;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final primary = Theme.of(context).colorScheme.primary;

    return switch (entry.status) {
      CycleEntryStatus.current => _Chip(
        label: l10n.cycleHistoryCurrentDay(entry.length),
        color: primary,
      ),
      CycleEntryStatus.late => _Chip(
        label: l10n.cycleHistoryLate(entry.daysLate),
        color: _warning,
      ),
      CycleEntryStatus.predicted => _Chip(
        label: l10n.cycleHistoryPredicted,
        color: _muted,
        outlined: true,
      ),
      CycleEntryStatus.incomplete => const Icon(
        Icons.help_outline_rounded,
        size: 18,
        color: _warning,
      ),
      CycleEntryStatus.finished => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (outsideCommonRange)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.error_outline_rounded,
                size: 16,
                color: _warning,
              ),
            ),
          Text(
            l10n.commonDays(entry.length),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: _ink,
            ),
          ),
          if (typical != null) ...[
            const SizedBox(width: 6),
            _DiffBadge(diff: entry.length - typical!),
          ],
        ],
      ),
    };
  }
}

/// "+3" / "−2" / "±0" against the typical length.
class _DiffBadge extends StatelessWidget {
  const _DiffBadge({required this.diff});

  final int diff;

  @override
  Widget build(BuildContext context) {
    final text = diff > 0
        ? '+$diff'
        : diff < 0
        ? '−${-diff}'
        : '±0';
    final color = diff.abs() > 7 ? _warning : _muted;
    return _Chip(label: text, color: color, outlined: true, dense: true);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    this.outlined = false,
    this.dense = false,
  });

  final String label;
  final Color color;
  final bool outlined;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 6 : 8, vertical: 2),
      decoration: BoxDecoration(
        color: outlined ? null : color.withValues(alpha: 0.12),
        border: outlined
            ? Border.all(color: color.withValues(alpha: 0.6))
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    required this.entry,
    required this.cycleLength,
    required this.difference,
    required this.outsideCommonRange,
  });

  final CycleHistoryEntry entry;
  final int cycleLength;
  final String? difference;
  final bool outsideCommonRange;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    String range(DateTime from, DateTime to) => from == to
        ? l10n.dayMonth(from)
        : l10n.cycleHistoryRange(l10n.dayMonth(from), l10n.dayMonth(to));

    if (entry.status == CycleEntryStatus.incomplete) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.cycleHistoryMissingDetail(entry.length),
              style: textTheme.bodySmall?.copyWith(color: _ink, height: 1.4),
            ),
            TextButton.icon(
              onPressed: () => Get.toNamed<void>(Routes.logPeriod),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l10n.cycleHistoryAddPeriod),
            ),
          ],
        ),
      );
    }

    final predicted = entry.status == CycleEntryStatus.predicted;
    final symptoms = entry.symptoms.toList();
    final rows = <(String, String)>[
      (
        predicted
            ? l10n.cycleHistoryDetailExpectedPeriod
            : l10n.cycleHistoryDetailPeriod,
        range(entry.start, entry.periodEnd ?? entry.start),
      ),
      (
        l10n.cycleHistoryDetailOvulation,
        entry.ovulation == null
            ? l10n.cycleHistoryCannotEstimate
            : predicted
            ? l10n.dayMonth(entry.ovulation!)
            : l10n.cycleHistoryNotConfirmed(l10n.dayMonth(entry.ovulation!)),
      ),
      if (entry.fertileStart != null)
        (
          l10n.cycleHistoryDetailFertile,
          range(entry.fertileStart!, entry.fertileEnd!),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: PhaseContent.menstrualColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: textTheme.bodySmall?.copyWith(color: _muted),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        value,
                        textAlign: TextAlign.right,
                        style: textTheme.bodySmall?.copyWith(
                          color: _ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!predicted) ...[
              const SizedBox(height: 4),
              Text(
                l10n.cycleHistoryDetailSymptoms,
                style: textTheme.bodySmall?.copyWith(color: _muted),
              ),
              const SizedBox(height: 6),
              if (symptoms.isEmpty)
                Text(
                  l10n.cycleHistoryNoSymptoms,
                  style: textTheme.bodySmall?.copyWith(color: _ink),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final id in symptoms.take(3))
                      _Chip(
                        label: symptomLabel(id, l10n),
                        color: PhaseContent.menstrualColor,
                      ),
                    if (symptoms.length > 3)
                      _Chip(
                        label: '+${symptoms.length - 3}',
                        color: _muted,
                        outlined: true,
                      ),
                  ],
                ),
            ],
            if (entry.status == CycleEntryStatus.late) ...[
              const SizedBox(height: 8),
              Text(
                l10n.cycleHistoryLateDetail(cycleLength),
                style: textTheme.bodySmall?.copyWith(color: _ink, height: 1.4),
              ),
            ],
            if (difference != null) ...[
              const SizedBox(height: 8),
              Text(
                difference!,
                style: textTheme.bodySmall?.copyWith(
                  color: _ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            if (outsideCommonRange) ...[
              const SizedBox(height: 6),
              Text(
                l10n.cycleHistoryOutsideRange,
                style: textTheme.bodySmall?.copyWith(color: _ink, height: 1.4),
              ),
            ],
            if (predicted) ...[
              const SizedBox(height: 4),
              Text(
                l10n.cycleHistoryForecastNote(cycleLength),
                style: textTheme.bodySmall?.copyWith(
                  color: _muted,
                  height: 1.4,
                ),
              ),
            ],
            if (entry.ovulation != null) ...[
              const SizedBox(height: 6),
              Text(
                l10n.cycleHistoryDisclaimer,
                style: textTheme.labelSmall?.copyWith(
                  color: _muted,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Draws one cycle as a continuous bar. Kinds differ by shape as well as
/// color: solid period, outlined predicted days, hatched fertile days, a
/// diamond above estimated ovulation, a dot for bleeding between periods and
/// dotted late days.
class _CycleBarPainter extends CustomPainter {
  const _CycleBarPainter({
    required this.days,
    required this.pxPerDay,
    this.typicalLength,
    this.todayIndex,
  });

  final List<HistoryDay> days;
  final double pxPerDay;
  final int? typicalLength;
  final int? todayIndex;

  static const _barTop = 8.0;
  static const _barHeight = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final visible = math.min(days.length, (size.width / pxPerDay).floor());
    final gap = pxPerDay > 5 ? 1.0 : 0.5;
    final bar = Rect.fromLTWH(0, _barTop, visible * pxPerDay, _barHeight);

    // Merge equal neighbours into runs so the bar reads as segments.
    var runStart = 0;
    for (var i = 1; i <= visible; i++) {
      if (i < visible && _sameRun(days[i], days[runStart])) continue;
      final rect = Rect.fromLTRB(
        runStart * pxPerDay,
        bar.top,
        i * pxPerDay - gap,
        bar.bottom,
      );
      _paintRun(canvas, rect, days[runStart]);
      runStart = i;
    }

    for (var i = 0; i < visible; i++) {
      final day = days[i];
      final cx = (i + 0.5) * pxPerDay;
      if (day.kind == HistoryDayKind.midCycle) {
        canvas.drawCircle(
          Offset(cx, bar.center.dy),
          math.min(pxPerDay / 2, 3.5),
          Paint()..color = PhaseContent.menstrualColor,
        );
      }
      if (day.kind == HistoryDayKind.ovulation) {
        _paintDiamond(canvas, Offset(cx, 3.5));
      }
    }

    if (days.length > visible) {
      // Cycle longer than the axis: show that it continues.
      final x = visible * pxPerDay;
      canvas.drawPath(
        Path()
          ..moveTo(x - 5, bar.top - 1)
          ..lineTo(x, bar.center.dy)
          ..lineTo(x - 5, bar.bottom + 1),
        Paint()
          ..color = _muted
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
    }

    final typical = typicalLength;
    if (typical != null && typical * pxPerDay <= size.width) {
      final x = typical * pxPerDay - gap / 2;
      final paint = Paint()
        ..color = _ink.withValues(alpha: 0.45)
        ..strokeWidth = 1.2;
      for (var y = 0.0; y < size.height; y += 4) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x, math.min(y + 2, size.height)),
          paint,
        );
      }
    }

    final today = todayIndex;
    if (today != null && today >= 0 && today < visible) {
      final cx = (today + 0.5) * pxPerDay;
      canvas.drawPath(
        Path()
          ..moveTo(cx, bar.bottom + 1.5)
          ..lineTo(cx - 4, bar.bottom + 7)
          ..lineTo(cx + 4, bar.bottom + 7)
          ..close(),
        Paint()..color = _ink,
      );
    }
  }

  static bool _sameRun(HistoryDay a, HistoryDay b) =>
      _base(a) == _base(b) && a.predicted == b.predicted && a.late == b.late;

  /// Mid-cycle bleeding and ovulation sit on top of their base segment.
  static HistoryDayKind _base(HistoryDay day) => switch (day.kind) {
    HistoryDayKind.midCycle => HistoryDayKind.other,
    HistoryDayKind.ovulation => HistoryDayKind.fertile,
    final kind => kind,
  };

  void _paintRun(Canvas canvas, Rect rect, HistoryDay day) {
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));
    final kind = _base(day);

    if (day.late) {
      final paint = Paint()..color = _lateDot;
      for (var x = rect.left + 2; x < rect.right; x += 5) {
        canvas.drawCircle(Offset(x, rect.center.dy), 1.4, paint);
      }
      return;
    }

    switch (kind) {
      case HistoryDayKind.period:
        const color = PhaseContent.menstrualColor;
        if (day.predicted) {
          canvas.drawRRect(
            rrect,
            Paint()..color = color.withValues(alpha: 0.12),
          );
          _paintDashedOutline(canvas, rrect, color);
        } else {
          canvas.drawRRect(rrect, Paint()..color = color);
        }
      case HistoryDayKind.fertile:
        const color = PhaseContent.fertileColor;
        canvas.drawRRect(
          rrect,
          Paint()..color = color.withValues(alpha: day.predicted ? 0.08 : 0.16),
        );
        canvas.save();
        canvas.clipRRect(rrect);
        final hatch = Paint()
          ..color = color.withValues(alpha: day.predicted ? 0.45 : 0.85)
          ..strokeWidth = 1.2;
        for (var x = rect.left - rect.height; x < rect.right; x += 4) {
          canvas.drawLine(
            Offset(x, rect.bottom),
            Offset(x + rect.height, rect.top),
            hatch,
          );
        }
        canvas.restore();
      default:
        if (day.predicted) {
          _paintDashedOutline(canvas, rrect, _lateDot);
        } else {
          canvas.drawRRect(rrect, Paint()..color = _track);
        }
    }
  }

  void _paintDashedOutline(Canvas canvas, RRect rrect, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()..addRRect(rrect.deflate(0.5));
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 5) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + 2.5, metric.length)),
          paint,
        );
      }
    }
  }

  void _paintDiamond(Canvas canvas, Offset center) {
    const r = 3.5;
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r, center.dy)
      ..close();
    // Outlined: the day is always an estimate, never a measurement.
    canvas
      ..drawPath(path, Paint()..color = Colors.white)
      ..drawPath(
        path,
        Paint()
          ..color = PhaseContent.ovulationColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
  }

  @override
  bool shouldRepaint(covariant _CycleBarPainter old) =>
      old.days != days ||
      old.pxPerDay != pxPerDay ||
      old.typicalLength != typicalLength ||
      old.todayIndex != todayIndex;
}
