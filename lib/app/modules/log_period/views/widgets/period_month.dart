import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../utils/l10n.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../controllers/log_period_controller.dart';

const _ink = Color(0xFF2D2032);
const _muted = Color(0xFF9A8A90);
const _period = CycleColors.periodDay;

class PeriodMonthSliver extends StatelessWidget {
  const PeriodMonthSliver({
    super.key,
    required this.month,
    required this.today,
    required this.marks,
    required this.onTap,
  });

  final DateTime month;
  final DateTime today;
  final Map<DateTime, PeriodMark> marks;
  final ValueChanged<DateTime> onTap;

  static const headerHeight = 48.0;
  static const rowHeight = 64.0;

  static int _daysIn(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;

  // Monday-first grid: weekday 1 (Mon) has no leading blanks.
  static int _leadingOf(DateTime month) => month.weekday - 1;

  /// Exact height of a month, used to scroll straight to the current month.
  static double heightOf(DateTime month) =>
      headerHeight +
      ((_leadingOf(month) + _daysIn(month)) / 7).ceil() * rowHeight;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _daysIn(month);
    final leading = _leadingOf(month);
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
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: isCurrentMonth ? _period : _ink,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    required this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isFuture;
  final PeriodMark? mark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLogged = mark?.type == PeriodMarkType.logged;
    final isPredicted = mark?.type == PeriodMarkType.predicted;

    final numberColor = isLogged
        ? _period
        : isFuture
        ? _muted.withValues(alpha: 0.7)
        : _ink;
    final isMidCycle = mark?.isMidCycle ?? false;
    final status = isMidCycle
        ? 'midCycle'
        : isLogged
        ? 'logged'
        : isPredicted
        ? 'predicted'
        : 'none';

    return Semantics(
      button: !isFuture,
      selected: isLogged,
      label: context.l10n.logPeriodDaySemantics(date.day, date.month, status),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isFuture ? null : onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 12,
              child: isToday
                  ? Text(
                      context.l10n.commonToday,
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        height: 1.2,
                        fontWeight: FontWeight.w900,
                        color: _ink,
                      ),
                    )
                  : null,
            ),
            Text(
              '${date.day}',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: isLogged || isToday
                    ? FontWeight.w900
                    : FontWeight.w600,
                color: numberColor,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 34,
              height: 22,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (isMidCycle)
                    _MidCycleDot(autoFilled: mark!.isAutoFilled)
                  else if (isLogged)
                    _LoggedDot(autoFilled: mark!.isAutoFilled)
                  else if (isPredicted)
                    const _DashedDot()
                  else if (!isFuture)
                    _EmptyDot(highlight: isToday),
                  if (mark != null && !isMidCycle)
                    Positioned(
                      right: 0,
                      top: -2,
                      child: Text(
                        '${mark!.dayOfPeriod}',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: _period.withValues(alpha: isLogged ? 1 : 0.6),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoggedDot extends StatelessWidget {
  const _LoggedDot({this.autoFilled = false});

  /// Auto-filled days are drawn lighter until the user confirms them.
  final bool autoFilled;

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: autoFilled ? 0.55 : 1, child: _dot());
  }

  Widget _dot() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6F9C), _period],
        ),
        boxShadow: [
          BoxShadow(
            color: _period.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
    );
  }
}

/// Bleeding logged before the cycle's expected end: not a new period.
class _MidCycleDot extends StatelessWidget {
  const _MidCycleDot({this.autoFilled = false});

  final bool autoFilled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: autoFilled ? 0.55 : 1,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: _period, width: 1.6),
        ),
        child: const Icon(Icons.water_drop_rounded, size: 12, color: _period),
      ),
    );
  }
}

class _EmptyDot extends StatelessWidget {
  const _EmptyDot({required this.highlight});

  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.7),
        border: Border.all(
          color: highlight ? _period : _muted.withValues(alpha: 0.6),
          width: highlight ? 1.8 : 1.2,
        ),
      ),
    );
  }
}

class _DashedDot extends StatelessWidget {
  const _DashedDot();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _DashedCirclePainter(_period)),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawCircle(
      rect.center,
      size.width / 2,
      Paint()..color = color.withValues(alpha: 0.1),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    const dashes = 10;
    const sweep = 2 * math.pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect.deflate(0.7), i * sweep, sweep * 0.55, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}

enum PeriodLegendType { logged, autoFilled, midCycle, predicted }

class PeriodLegend extends StatelessWidget {
  const PeriodLegend({super.key, required this.type, required this.label});

  final PeriodLegendType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.8,
          child: switch (type) {
            PeriodLegendType.logged => const _LoggedDot(),
            PeriodLegendType.autoFilled => const _LoggedDot(autoFilled: true),
            PeriodLegendType.midCycle => const _MidCycleDot(),
            PeriodLegendType.predicted => const _DashedDot(),
          },
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: const Color(0xFF7A6877),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
