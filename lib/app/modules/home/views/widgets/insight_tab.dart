import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/cycle_day_info.dart';
import '../../../../data/models/cycle_history.dart';
import '../../../../data/models/cycle_insights.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/cycle_service.dart';
import '../../../../utils/constants/app_assets.dart';
import '../../../../utils/l10n.dart';
import '../../../../utils/symptom_labels.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../widgets/no_cycle_data_card.dart';
import '../../../cycle_phase/phase_content.dart';
import 'cycle_history_card.dart';

class InsightTab extends StatelessWidget {
  const InsightTab({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFF2F6);

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: bg),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 180,
          child: Image.asset(
            AppAssets.bgStats,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  bg.withValues(alpha: 0.18),
                  bg.withValues(alpha: 0.86),
                  bg,
                ],
                stops: const [0, 0.28, 0.48],
              ),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Obx(() {
            final data = _InsightData.load(CycleService.to);

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                  sliver: SliverList.list(
                    children: [
                      const _Header(),
                      const SizedBox(height: 16),
                      if (data == null)
                        const NoCycleDataCard()
                      else ...[
                        _CycleAnalysisCards(data: data),
                        const SizedBox(height: 14),
                        _DualTrendCard(data: data),
                        const SizedBox(height: 14),
                        CycleHistoryCard(
                          history: data.history,
                          forecast: data.forecast,
                          cycleLength: data.cycleLength,
                        ),
                        const SizedBox(height: 14),
                        _CyclePhaseDescriptionCard(data: data),
                        const SizedBox(height: 14),
                        _CommonPatternsCard(data: data),
                        const SizedBox(height: 14),
                        _InsightList(data: data),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

/// Everything the tab shows, derived from logged data.
class _InsightData {
  const _InsightData({
    required this.info,
    required this.avgCycle,
    required this.avgPeriod,
    required this.recentCycles,
    required this.cycleStats,
    required this.periodStats,
    required this.patterns,
    required this.history,
    required this.forecast,
    required this.cycleLength,
  });

  /// Cycles shown on the trend chart.
  static const chartCycles = 6;

  final CycleDayInfo info;
  final int avgCycle;
  final int avgPeriod;
  final List<CycleRecord> recentCycles;
  final LengthStats? cycleStats;
  final LengthStats? periodStats;
  final List<SymptomPattern> patterns;
  final List<CycleHistoryEntry> history;
  final List<CycleHistoryEntry> forecast;

  /// The user's cycle length (predictions); not the learned average.
  final int cycleLength;

  /// Null until a period has been logged.
  static _InsightData? load(CycleService cycle) {
    final info = cycle.todayInfo.value;
    if (info == null) return null;
    final today = cycle.today.value;
    final periods = cycle.periods;
    final cycles = cycle.completedCycles;
    // A period that reaches yesterday or today may still be going on.
    final finishedLengths = [
      for (final p in periods)
        if (CycleService.daysBetween(p.last, today) > 1)
          CycleService.daysBetween(p.first, p.last) + 1,
    ];
    return _InsightData(
      info: info,
      avgCycle: cycle.averageCycleLength,
      avgPeriod: cycle.periodLength.value,
      recentCycles: cycles.length > chartCycles
          ? cycles.sublist(cycles.length - chartCycles)
          : cycles,
      cycleStats: CycleInsights.cycleStats([for (final c in cycles) c.length]),
      periodStats: CycleInsights.periodStats(finishedLengths),
      patterns: CycleInsights.patterns(periods: periods, logs: cycle.dailyLogs),
      history: CycleHistory.history(
        periods: periods,
        periodDays: cycle.periodDays,
        logs: cycle.dailyLogs,
        today: today,
        cycleLength: cycle.cycleLength.value,
        periodLength: cycle.periodLength.value,
      ),
      forecast: CycleHistory.forecast(
        lastPeriodStart: periods.last.first,
        today: today,
        cycleLength: cycle.cycleLength.value,
        periodLength: cycle.periodLength.value,
      ),
      cycleLength: cycle.cycleLength.value,
    );
  }
}

class _CycleAnalysisCards extends StatelessWidget {
  const _CycleAnalysisCards({required this.data});

  final _InsightData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Below CycleInsights.minValues finished periods/cycles, avgPeriod and
    // avgCycle can still just be the fallback setting, not a real average —
    // showing a card for that would look like data that isn't there yet.
    final cards = [
      if (data.periodStats case final stats?)
        _StatCard(
          icon: Icons.water_drop,
          iconColor: const Color(0xFFE91E63),
          iconBg: const Color(0xFFFFE4EC),
          badge: _Badge.of(stats, l10n, forPeriod: true),
          value: l10n.insightStatDays(data.avgPeriod),
          label: l10n.insightAvgPeriod,
          gradientColors: const [Color(0xFFFFF0F5), Color(0xFFFFE4EC)],
        ),
      if (data.cycleStats case final stats?)
        _StatCard(
          icon: Icons.calendar_month,
          iconColor: const Color(0xFF1976D2),
          iconBg: const Color(0xFFE3F2FD),
          badge: _Badge.of(stats, l10n, forPeriod: false),
          value: l10n.insightStatDays(data.avgCycle),
          label: l10n.insightAvgCycle,
          gradientColors: const [Color(0xFFF0F8FF), Color(0xFFE3F2FD)],
        ),
    ];
    if (cards.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: cards[i]),
        ],
      ],
    );
  }
}

/// Stat card badge: stable and mild variation are normal; notable and severe
/// variation need attention.
class _Badge {
  const _Badge(this.label, this.icon, this.color, this.background);

  final String label;
  final IconData icon;
  final Color color;
  final Color background;

  static _Badge of(
    LengthStats stats,
    AppLocalizations l10n, {
    required bool forPeriod,
  }) => switch (stats.level) {
    Variability.stable || Variability.mild => _Badge(
      l10n.insightBadgeNormal,
      Icons.check_circle,
      const Color(0xFF4CAF50),
      const Color(0xFFE8F5E9),
    ),
    Variability.notable || Variability.severe => _Badge(
      forPeriod ? l10n.insightBadgeAttention : l10n.insightBadgeIrregular,
      Icons.error,
      const Color(0xFFFB8C00),
      const Color(0xFFFFF3E0),
    ),
  };
}

class _DualTrendCard extends StatelessWidget {
  const _DualTrendCard({required this.data});

  final _InsightData data;

  String _summary(AppLocalizations l10n) {
    final c = data.cycleStats;
    final p = data.periodStats;
    if (c == null || p == null) return l10n.insightSummaryNotEnough;
    final n = c.values.length;
    final avgCycle = data.avgCycle;
    final avgPeriod = data.avgPeriod;
    return switch ((c.level.index, p.level.index)) {
      (0, 0) => l10n.insightSummaryC1P1(n, avgPeriod, avgCycle),
      (0, 1) => l10n.insightSummaryC1P2(avgCycle, p.min, p.max),
      (0, 2) => l10n.insightSummaryC1P3(p.outlier, avgCycle),
      (0, 3) => l10n.insightSummaryC1P4(l10n.commonDays(p.outlier), avgCycle),
      (1, 0) => l10n.insightSummaryC2P1(avgPeriod, c.min, c.max),
      (1, 1) => l10n.insightSummaryC2P2,
      (1, 2) => l10n.insightSummaryC2P3(p.outlier, c.min, c.max),
      (1, 3) => l10n.insightSummaryC2P4(
        l10n.commonDays(p.outlier),
        c.min,
        c.max,
      ),
      (2, 0) => l10n.insightSummaryC3P1(c.outlier, avgPeriod),
      (2, 1) => l10n.insightSummaryC3P2(c.outlier, p.min, p.max),
      (2, 2) => l10n.insightSummaryC3P3,
      (2, 3) => l10n.insightSummaryC3P4(l10n.commonDays(p.outlier), c.outlier),
      (3, 0) => l10n.insightSummaryC4P1(l10n.commonDays(c.outlier), avgPeriod),
      (3, 1) => l10n.insightSummaryC4P2(
        l10n.commonDays(c.outlier),
        p.min,
        p.max,
      ),
      (3, 2) => l10n.insightSummaryC4P3(l10n.commonDays(c.outlier), p.outlier),
      (3, 3) => l10n.insightSummaryC4P4,
      _ => l10n.insightSummaryNotEnough,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final cycles = data.recentCycles;

    return _InsightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: l10n.insightTrendTitle,
            action: cycles.isEmpty
                ? null
                : l10n.insightLastCycles(cycles.length),
          ),
          const SizedBox(height: 10),
          if (cycles.isEmpty)
            Text(
              l10n.insightTrendEmpty,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else ...[
            Row(
              children: [
                _LegendItem(
                  color: const Color(0xFF2196F3),
                  label: l10n.insightLegendCycleLength,
                ),
                const SizedBox(width: 16),
                _LegendItem(
                  color: CycleColors.periodDay,
                  label: l10n.insightLegendPeriod,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: CustomPaint(
                painter: _DualTrendPainter(
                  cycleLineColor: const Color(0xFF2196F3),
                  periodLineColor: CycleColors.periodDay,
                  gridColor: colorScheme.outline.withValues(alpha: 0.15),
                  cycleRangeBg: const Color(0xFFE3F2FD).withValues(alpha: 0.5),
                  periodRangeBg: const Color(0xFFFFEBEE).withValues(alpha: 0.5),
                  cycleValues: [for (final c in cycles) c.length.toDouble()],
                  periodValues: [
                    for (final c in cycles) c.periodLength.toDouble(),
                  ],
                  labels: [for (final c in cycles) l10n.dayMonth(c.start)],
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.insights, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _summary(l10n),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CyclePhaseDescriptionCard extends StatelessWidget {
  const _CyclePhaseDescriptionCard({required this.data});

  final _InsightData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = PhaseContent.of(data.info, context.l10n);

    return _InsightCard(
      child: InkWell(
        onTap: () => Get.toNamed<void>(Routes.cyclePhase),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(content.icon, color: content.color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.insightCurrentPhaseTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.outline),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              content.name,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: content.color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              content.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommonPatternsCard extends StatelessWidget {
  const _CommonPatternsCard({required this.data});

  final _InsightData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final patterns = data.patterns;

    return _InsightCard(
      child: InkWell(
        onTap: () => Get.toNamed<void>(Routes.cyclePhase),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: l10n.insightPatternsTitle),
            const SizedBox(height: 12),
            if (patterns.isEmpty)
              Text(
                l10n.insightPatternsEmpty,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else
              Row(
                children: [
                  for (var i = 0; i < patterns.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(child: _patternBox(patterns[i], l10n)),
                  ],
                  // Keep boxes the same width when fewer than three.
                  for (var i = patterns.length; i < 3; i++) ...[
                    const SizedBox(width: 8),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _patternBox(SymptomPattern pattern, AppLocalizations l10n) {
    final (subtitle, icon, color) = switch (pattern.timing) {
      PatternTiming.duringPeriod => (
        pattern.firstDay == pattern.lastDay
            ? l10n.insightPatternDuringDay(pattern.firstDay)
            : l10n.insightPatternCrampsSubtitle(
                pattern.firstDay,
                pattern.lastDay,
              ),
        Icons.water_drop,
        CycleColors.periodDay,
      ),
      PatternTiming.beforePeriod => (
        l10n.insightPatternPmsSubtitle(pattern.daysBeforePeriod),
        Icons.bolt,
        const Color(0xFFFFA55D),
      ),
      PatternTiming.midCycle => (
        l10n.insightPatternCycleDay(pattern.cycleDay),
        Icons.mood,
        CycleColors.ovulationDay,
      ),
    };
    return _PatternBox(
      icon: icon,
      title: symptomLabel(pattern.symptomId, l10n),
      subtitle: subtitle,
      color: color,
    );
  }
}

class _InsightList extends StatelessWidget {
  const _InsightList({required this.data});

  final _InsightData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final content = PhaseContent.of(data.info, l10n);

    return _InsightCard(
      child: InkWell(
        onTap: () => Get.toNamed<void>(Routes.cyclePhase),
        child: Column(
          children: [
            _SectionHeader(title: l10n.insightTipsTitle),
            const SizedBox(height: 8),
            for (var i = 0; i < content.tips.length; i++) ...[
              if (i > 0) const _InsightDivider(),
              _InsightRow(
                icon: content.tips[i].icon,
                title: content.tips[i].title,
                subtitle: content.tips[i].subtitle,
                color: content.color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.insightTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF2D2032),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.insightSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          l10n.insightTagline,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colorScheme.primary,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.badge,
    required this.value,
    required this.label,
    required this.gradientColors,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final _Badge badge;
  final String value;
  final String label;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badge.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badge.icon, size: 12, color: badge.color),
                    const SizedBox(width: 4),
                    Text(
                      badge.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badge.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2D2032),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF7A6877),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFF7A6877),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PatternBox extends StatelessWidget {
  const _PatternBox({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 8,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        foregroundColor: color,
        child: Icon(icon),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
    );
  }
}

class _InsightDivider extends StatelessWidget {
  const _InsightDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        if (action != null)
          Text(
            '$action ›',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          Icon(Icons.chevron_right, color: colorScheme.outline),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
  }
}

class _DualTrendPainter extends CustomPainter {
  const _DualTrendPainter({
    required this.cycleLineColor,
    required this.periodLineColor,
    required this.gridColor,
    required this.cycleRangeBg,
    required this.periodRangeBg,
    required this.cycleValues,
    required this.periodValues,
    required this.labels,
  });

  final List<double> cycleValues;
  final List<double> periodValues;
  final List<String> labels;

  final Color cycleLineColor;
  final Color periodLineColor;
  final Color gridColor;
  final Color cycleRangeBg;
  final Color periodRangeBg;

  @override
  void paint(Canvas canvas, Size size) {
    const maxY = 60.0;
    const leftPad = 28.0;
    const rightPad = 12.0;
    const topPad = 14.0;
    const bottomPad = 26.0;

    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final dashPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final labelPainter = TextPainter(textDirection: TextDirection.ltr);

    // Y-Axis Grid Lines: 60, 40, 20, 10
    const gridTicks = [60.0, 40.0, 20.0, 10.0];
    for (final tick in gridTicks) {
      final y = topPad + chartHeight * (1 - tick / maxY);
      var startX = leftPad;
      while (startX < size.width - rightPad) {
        canvas.drawLine(Offset(startX, y), Offset(startX + 4, y), dashPaint);
        startX += 8;
      }

      labelPainter.text = TextSpan(
        text: tick == 60 ? '60+' : '${tick.round()}',
        style: const TextStyle(fontSize: 9, color: Color(0xFF857377)),
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(0, y - labelPainter.height / 2));
    }

    // Target shaded ranges
    // Cycle normal range band (21-35 days)
    final cycleRangeTop = topPad + chartHeight * (1 - 35 / maxY);
    final cycleRangeBottom = topPad + chartHeight * (1 - 21 / maxY);
    canvas.drawRect(
      Rect.fromLTRB(
        leftPad,
        cycleRangeTop,
        size.width - rightPad,
        cycleRangeBottom,
      ),
      Paint()..color = cycleRangeBg,
    );

    // Period normal range band (3-7 days)
    final periodRangeTop = topPad + chartHeight * (1 - 7 / maxY);
    final periodRangeBottom = topPad + chartHeight * (1 - 3 / maxY);
    canvas.drawRect(
      Rect.fromLTRB(
        leftPad,
        periodRangeTop,
        size.width - rightPad,
        periodRangeBottom,
      ),
      Paint()..color = periodRangeBg,
    );

    // Map value to Offset
    Offset getPoint(int index, double value) {
      // A single cycle is drawn in the middle.
      final x = cycleValues.length == 1
          ? leftPad + chartWidth / 2
          : leftPad + chartWidth * index / (cycleValues.length - 1);
      final clampedValue = value.clamp(0.0, maxY);
      final y = topPad + chartHeight * (1 - clampedValue / maxY);
      return Offset(x, y);
    }

    final cyclePoints = [
      for (var i = 0; i < cycleValues.length; i++) getPoint(i, cycleValues[i]),
    ];
    final periodPoints = [
      for (var i = 0; i < periodValues.length; i++)
        getPoint(i, periodValues[i]),
    ];

    // Helper to draw a line graph
    void drawLineGraph(List<Offset> points, List<double> values, Color color) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final pt in points.skip(1)) {
        path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = 2.4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );

      final dotPaint = Paint()..color = color;
      final whitePaint = Paint()..color = Colors.white;

      for (var i = 0; i < points.length; i++) {
        final pt = points[i];
        canvas.drawCircle(pt, 5, dotPaint);
        canvas.drawCircle(pt, 2.5, whitePaint);

        labelPainter.text = TextSpan(
          text: '${values[i].round()}',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        );
        labelPainter.layout();
        labelPainter.paint(
          canvas,
          Offset(pt.dx - labelPainter.width / 2, pt.dy - 15),
        );
      }
    }

    // Draw lines
    drawLineGraph(cyclePoints, cycleValues, cycleLineColor);
    drawLineGraph(periodPoints, periodValues, periodLineColor);

    // Draw X-axis date labels
    for (var i = 0; i < labels.length; i++) {
      final x = cyclePoints[i].dx;
      labelPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(fontSize: 9, color: Color(0xFF857377)),
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(x - labelPainter.width / 2, size.height - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DualTrendPainter oldDelegate) {
    return oldDelegate.cycleLineColor != cycleLineColor ||
        !listEquals(oldDelegate.cycleValues, cycleValues) ||
        !listEquals(oldDelegate.periodValues, periodValues) ||
        !listEquals(oldDelegate.labels, labels) ||
        oldDelegate.periodLineColor != periodLineColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.cycleRangeBg != cycleRangeBg ||
        oldDelegate.periodRangeBg != periodRangeBg;
  }
}
