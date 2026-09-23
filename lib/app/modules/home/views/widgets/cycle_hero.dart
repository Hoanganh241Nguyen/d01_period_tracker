import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/cycle_day_info.dart';
import '../../../../services/cycle_service.dart';
import '../../../../utils/constants/app_assets.dart';
import '../../../../utils/l10n.dart';
import '../../../../widgets/app_svg_icon.dart';
import 'home_sheets.dart';

enum _CycleIssueLevel { normal, attention, warning }

class CycleHero extends StatelessWidget {
  const CycleHero({super.key});

  static const _typicalMaxPeriodDays = 7;
  static const _attentionColor = Color(0xFFE5486F);
  static const _warningColor = Color(0xFFCC2B3F);
  static const _attentionTrack = Color(0xFFFFD7E2);
  static const _warningTrack = Color(0xFFFFD1D6);

  static _CycleIssueLevel _issueLevel({
    required CycleDayInfo? info,
    required bool midCycleToday,
    required bool prolongedBleedingToday,
  }) {
    if (info == null) return _CycleIssueLevel.normal;
    if (info.isLate) return _CycleIssueLevel.warning;
    if (midCycleToday || prolongedBleedingToday) {
      return _CycleIssueLevel.attention;
    }
    return _CycleIssueLevel.normal;
  }

  static Color _levelColor(ColorScheme colorScheme, _CycleIssueLevel level) =>
      switch (level) {
        _CycleIssueLevel.normal => colorScheme.primary,
        _CycleIssueLevel.attention => _attentionColor,
        _CycleIssueLevel.warning => _warningColor,
      };

  static Color _levelTrack(ColorScheme colorScheme, _CycleIssueLevel level) =>
      switch (level) {
        _CycleIssueLevel.normal => colorScheme.primaryContainer,
        _CycleIssueLevel.attention => _attentionTrack,
        _CycleIssueLevel.warning => _warningTrack,
      };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return SizedBox(
      height: 262,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 26,
            top: 8,
            child: InkWell(
              borderRadius: BorderRadius.circular(120),
              onTap: () => showPeriodLogSnack(context),
              child: Obx(() {
                final cycle = CycleService.to;
                final info = cycle.todayInfo.value;
                final midCycleToday = cycle.isMidCycleBleeding(
                  cycle.today.value,
                );
                final prolongedBleedingToday =
                    info?.phase == CyclePhase.menstrual &&
                    info!.dayInPhase > _typicalMaxPeriodDays;
                final issueLevel = _issueLevel(
                  info: info,
                  midCycleToday: midCycleToday,
                  prolongedBleedingToday: prolongedBleedingToday,
                );
                final ringColor = _levelColor(colorScheme, issueLevel);
                return CustomPaint(
                  painter: CycleRingPainter(
                    trackColor: _levelTrack(colorScheme, issueLevel),
                    progressColor: ringColor,
                    progress: info == null
                        ? 0
                        : (info.cycleDay / info.cycleLength).clamp(0.0, 1.0),
                  ),
                  child: SizedBox(
                    width: 190,
                    height: 190,
                    child: _RingContent(
                      info: info,
                      nextPeriod: cycle.nextPeriodStart,
                      midCycleToday: midCycleToday,
                      prolongedBleedingToday: prolongedBleedingToday,
                      accentColor: ringColor,
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            right: -6,
            bottom: 0,
            child: Image.asset(
              AppAssets.girlHome,
              width: 164,
              height: 164,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 26,
            top: 208,
            width: 190,
            child: Obx(() {
              final cycle = CycleService.to;
              return LogPeriodButton(
                info: cycle.todayInfo.value,
                todayLogged: cycle.periodDays.contains(cycle.today.value),
              );
            }),
          ),
          Positioned(
            right: 20,
            top: 34,
            child: Transform.rotate(
              angle: -0.08,
              child: Text(
                l10n.homeEncouragement,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Entry point to the period log; its label follows the current period state.
class LogPeriodButton extends StatelessWidget {
  const LogPeriodButton({
    super.key,
    required this.info,
    this.todayLogged = false,
  });

  /// Null before the first period is logged.
  final CycleDayInfo? info;

  /// Bleeding is already logged for today.
  final bool todayLogged;

  (String, String) _content(AppLocalizations l10n) {
    final info = this.info;
    if (info == null) {
      return (l10n.homeLogFirstPeriod, AppAssets.homeAdd);
    }
    if (info.isLate) {
      return (l10n.homeLogPeriodLate, AppAssets.homeCycleDay);
    }
    if (info.phase == CyclePhase.menstrual) {
      return (
        l10n.homeLogPeriodUpdate(info.dayInPhase),
        AppAssets.homeUpdatePeriod,
      );
    }
    if (todayLogged) {
      return (l10n.homeLogPeriodUpdateToday, AppAssets.homeUpdatePeriod);
    }
    if (info.isPmsWindow) {
      return (l10n.homeLogPeriodEarly, AppAssets.homeCycleDay);
    }
    return (l10n.homeLogPeriod, AppAssets.homeAdd);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (label, icon) = _content(context.l10n);
    // Filled when logging is most likely needed, outlined otherwise.
    final info = this.info;
    final emphasized =
        info == null ||
        todayLogged ||
        info.isLate ||
        info.isPmsWindow ||
        info.phase == CyclePhase.menstrual;

    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(44)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12),
      ),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
      ),
    );
    final child = FittedBox(fit: BoxFit.scaleDown, child: Text(label));
    void onPressed() => showPeriodLogSnack(context);

    return emphasized
        ? FilledButton.icon(
            style: style,
            onPressed: onPressed,
            icon: AppSvgIcon(icon, size: 20, color: colorScheme.onPrimary),
            label: child,
          )
        : OutlinedButton.icon(
            style: style.copyWith(
              backgroundColor: WidgetStatePropertyAll(
                Colors.white.withValues(alpha: 0.85),
              ),
              side: WidgetStatePropertyAll(
                BorderSide(color: colorScheme.primary, width: 1.4),
              ),
            ),
            onPressed: onPressed,
            icon: AppSvgIcon(icon, size: 20, color: colorScheme.primary),
            label: child,
          );
  }
}

class CycleRingPainter extends CustomPainter {
  const CycleRingPainter({
    required this.trackColor,
    required this.progressColor,
    required this.progress,
  });

  final Color trackColor;
  final Color progressColor;

  /// Share of the cycle already passed, 0–1.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - 14) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [progressColor.withValues(alpha: 0.65), progressColor],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    if (progress > 0) {
      // Start at 12 o'clock and run clockwise.
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CycleRingPainter oldDelegate) {
    return oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.progress != progress;
  }
}

class _RingContent extends StatelessWidget {
  const _RingContent({
    required this.info,
    required this.nextPeriod,
    required this.midCycleToday,
    required this.prolongedBleedingToday,
    required this.accentColor,
  });

  final CycleDayInfo? info;
  final DateTime? nextPeriod;

  /// Today has bleeding logged that does not start a new cycle.
  final bool midCycleToday;
  final bool prolongedBleedingToday;
  final Color accentColor;

  String _prolongedBleedingTitle(AppLocalizations l10n) =>
      l10n.localeName.startsWith('vi')
      ? 'Ra máu kéo dài'
      : 'Prolonged bleeding';

  String _prolongedBleedingHint(AppLocalizations l10n) =>
      l10n.localeName.startsWith('vi')
      ? 'Đã quá 7 ngày, hãy theo dõi thêm'
      : 'Over 7 days, keep tracking';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final info = this.info;

    final (String top, String main, String bottom) = switch (info) {
      null => ('', l10n.homeRingEmptyTitle, l10n.homeRingEmptySubtitle),
      CycleDayInfo(isLate: true) => (
        l10n.homeRingLatePrefix,
        l10n.commonDays(info.daysLate),
        l10n.homeRingLateHint,
      ),
      CycleDayInfo() when midCycleToday => (
        l10n.homeRingMidCyclePrefix,
        l10n.homeRingDay(info.cycleDay),
        l10n.homeRingNextPeriodOn(l10n.dayMonth(nextPeriod!)),
      ),
      CycleDayInfo(phase: CyclePhase.menstrual) when prolongedBleedingToday => (
        _prolongedBleedingTitle(l10n),
        l10n.homeRingDay(info.dayInPhase),
        _prolongedBleedingHint(l10n),
      ),
      CycleDayInfo(phase: CyclePhase.menstrual) => (
        l10n.homeRingPeriodPrefix,
        l10n.homeRingDay(info.dayInPhase),
        l10n.homeRingPeriodOf(info.periodLength),
      ),
      _ => (
        l10n.homeCycleRemainingPrefix,
        l10n.commonDays(info.daysToNextPeriod),
        '${l10n.homeCycleUntilNextPeriod}\n'
            '${l10n.homeCycleExpectedDate(l10n.dayMonth(nextPeriod!))}',
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (top.isNotEmpty)
            Text(
              top,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              main,
              textAlign: TextAlign.center,
              style:
                  (info == null ? textTheme.titleLarge : textTheme.displaySmall)
                      ?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w900,
                      ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            bottom,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
