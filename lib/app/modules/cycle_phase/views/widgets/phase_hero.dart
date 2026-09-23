import 'package:flutter/material.dart';

import '../../../../data/models/cycle_day_info.dart';
import '../../../../utils/l10n.dart';
import '../../phase_content.dart';

class PhaseHero extends StatelessWidget {
  const PhaseHero({
    super.key,
    required this.info,
    required this.content,
    required this.isToday,
  });

  final CycleDayInfo info;
  final PhaseContent content;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final color = content.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.95),
            Color.lerp(Colors.white, color, 0.16)!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: (info.cycleDay / info.cycleLength).clamp(0.0, 1.0),
                  strokeWidth: 7,
                  strokeCap: StrokeCap.round,
                  backgroundColor: color.withValues(alpha: 0.14),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${info.cycleDay}',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: color,
                          height: 1,
                        ),
                      ),
                      Text(
                        l10n.phaseHeroCycleLength(info.cycleLength),
                        style: textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF7A6877),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(content.icon, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        isToday
                            ? l10n.commonToday
                            : l10n.phaseDayLabel(info.cycleDay),
                        style: textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content.name,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2D2032),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phaseStatusLine(info, l10n),
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7A6877),
                    height: 1.3,
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
