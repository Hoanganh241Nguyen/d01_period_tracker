import 'package:flutter/material.dart';

import '../../../../data/models/cycle_day_info.dart';
import '../../../../utils/l10n.dart';
import '../../phase_content.dart';
import 'phase_cards.dart';

class ConceptionCard extends StatelessWidget {
  const ConceptionCard({
    super.key,
    required this.info,
    required this.todayDay,
    required this.length,
  });

  final CycleDayInfo info;
  final int todayDay;
  final int length;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final level = info.conceptionLevel;
    final content = ConceptionContent.of(level, l10n);

    return PhaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CardTitle(
                  icon: Icons.child_friendly_rounded,
                  title: l10n.phaseConceptionTitle,
                  color: content.color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: content.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  content.label,
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final l in ConceptionLevel.values) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 6,
                    decoration: BoxDecoration(
                      color: l.index <= level.index
                          ? content.color
                          : content.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                if (l != ConceptionLevel.values.last) const SizedBox(width: 4),
              ],
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: CustomPaint(
              painter: _ConceptionChartPainter(
                info: info,
                todayDay: todayDay,
                length: length,
                lineColor: PhaseContent.ovulationColor,
                windowColor: PhaseContent.fertileColor,
                markerColor: content.color,
                windowLabel: l10n.phaseConceptionChartWindow,
                ovulationLabel: l10n.phaseOvulationShortName,
                firstDayLabel: l10n.phaseDayLabel(1),
                lastDayLabel: l10n.phaseDayLabel(length),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content.message,
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFF7A6877),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConceptionChartPainter extends CustomPainter {
  const _ConceptionChartPainter({
    required this.info,
    required this.todayDay,
    required this.length,
    required this.lineColor,
    required this.windowColor,
    required this.markerColor,
    required this.windowLabel,
    required this.ovulationLabel,
    required this.firstDayLabel,
    required this.lastDayLabel,
  });

  final CycleDayInfo info;
  final int todayDay;
  final int length;
  final Color lineColor;
  final Color windowColor;
  final Color markerColor;
  final String windowLabel;
  final String ovulationLabel;
  final String firstDayLabel;
  final String lastDayLabel;

  static const _maxChance = 0.35;
  static const _leftPad = 4.0;
  static const _topPad = 20.0;
  static const _bottomPad = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _leftPad * 2;
    final chartHeight = size.height - _topPad - _bottomPad;
    final baseY = _topPad + chartHeight;

    double xOf(num day) =>
        _leftPad + chartWidth * (day - 1) / (length - 1).clamp(1, 1000);
    double yOf(double chance) =>
        _topPad + chartHeight * (1 - chance / _maxChance);

    // Fertile window band.
    final windowStart = info.fertileStart.clamp(1, length);
    final windowEnd = info.ovulationDay.clamp(1, length);
    final bandRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        xOf(windowStart - 0.5),
        _topPad - 6,
        xOf(windowEnd + 0.5),
        baseY,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      bandRect,
      Paint()..color = windowColor.withValues(alpha: 0.1),
    );
    _drawText(
      canvas,
      windowLabel,
      Offset(bandRect.center.dx, _topPad - 18),
      windowColor,
      center: true,
    );

    // Baseline.
    canvas.drawLine(
      Offset(_leftPad, baseY),
      Offset(size.width - _leftPad, baseY),
      Paint()
        ..color = const Color(0xFFEADDE2)
        ..strokeWidth = 1,
    );

    // Smooth curve through daily probabilities.
    final points = [
      for (var d = 1; d <= length; d++)
        Offset(xOf(d), yOf(info.conceptionChanceOf(d))),
    ];
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final midX = (p0.dx + p1.dx) / 2;
      line.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }
    final area = Path.from(line)
      ..lineTo(points.last.dx, baseY)
      ..lineTo(points.first.dx, baseY)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lineColor.withValues(alpha: 0.35),
            lineColor.withValues(alpha: 0.02),
          ],
        ).createShader(Rect.fromLTRB(0, _topPad, size.width, baseY)),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );

    // Today marker (dashed) when previewing another day.
    if (todayDay != info.cycleDay && todayDay <= length) {
      final x = xOf(todayDay);
      var y = _topPad;
      final dash = Paint()
        ..color = const Color(0xFF2D2032).withValues(alpha: 0.35)
        ..strokeWidth = 1.2;
      while (y < baseY) {
        canvas.drawLine(Offset(x, y), Offset(x, (y + 4).clamp(0, baseY)), dash);
        y += 8;
      }
    }

    // Selected day marker.
    final day = info.cycleDay.clamp(1, length);
    final point = Offset(xOf(day), yOf(info.conceptionChanceOf(day)));
    canvas.drawLine(
      Offset(point.dx, point.dy),
      Offset(point.dx, baseY),
      Paint()
        ..color = markerColor
        ..strokeWidth = 1.6,
    );
    canvas.drawCircle(point, 7, Paint()..color = Colors.white);
    canvas.drawCircle(point, 5, Paint()..color = markerColor);

    // X-axis labels.
    const labelColor = Color(0xFF857377);
    _drawText(canvas, firstDayLabel, Offset(_leftPad, baseY + 5), labelColor);
    _drawText(
      canvas,
      ovulationLabel,
      Offset(xOf(info.ovulationDay), baseY + 5),
      lineColor,
      center: true,
    );
    _drawText(
      canvas,
      lastDayLabel,
      Offset(size.width - _leftPad, baseY + 5),
      labelColor,
      alignRight: true,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset at,
    Color color, {
    bool center = false,
    bool alignRight = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = at.dx;
    if (center) dx -= painter.width / 2;
    if (alignRight) dx -= painter.width;
    painter.paint(canvas, Offset(dx, at.dy));
  }

  @override
  bool shouldRepaint(covariant _ConceptionChartPainter oldDelegate) {
    return oldDelegate.info.cycleDay != info.cycleDay ||
        oldDelegate.info.cycleLength != info.cycleLength ||
        oldDelegate.todayDay != todayDay ||
        oldDelegate.length != length ||
        oldDelegate.markerColor != markerColor ||
        oldDelegate.windowLabel != windowLabel ||
        oldDelegate.ovulationLabel != ovulationLabel ||
        oldDelegate.firstDayLabel != firstDayLabel ||
        oldDelegate.lastDayLabel != lastDayLabel;
  }
}
