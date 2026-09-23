import 'package:flutter/material.dart';

import '../../../../data/models/cycle_day_info.dart';
import '../../../../utils/l10n.dart';
import '../../phase_content.dart';
import 'phase_cards.dart';

/// Horizontal strip of every day in the cycle, coloured by phase.
class PhaseTimeline extends StatefulWidget {
  const PhaseTimeline({
    super.key,
    required this.todayInfo,
    required this.selectedDay,
    required this.length,
    required this.onSelect,
  });

  final CycleDayInfo todayInfo;
  final int selectedDay;
  final int length;
  final ValueChanged<int> onSelect;

  @override
  State<PhaseTimeline> createState() => _PhaseTimelineState();
}

class _PhaseTimelineState extends State<PhaseTimeline> {
  static const _cellWidth = 38.0;
  static const _gap = 6.0;

  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollTo(widget.todayInfo.cycleDay, animate: false),
    );
  }

  @override
  void didUpdateWidget(covariant PhaseTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
      _scrollTo(widget.selectedDay);
    }
  }

  void _scrollTo(int day, {bool animate = true}) {
    if (!_scroll.hasClients) return;
    final viewport = _scroll.position.viewportDimension;
    final target =
        ((day - 1) * (_cellWidth + _gap) - viewport / 2 + _cellWidth / 2).clamp(
          0.0,
          _scroll.position.maxScrollExtent,
        );
    if (animate) {
      _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scroll.jumpTo(target);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final info = widget.todayInfo;

    return PhaseCard(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: CardTitle(
              icon: Icons.linear_scale_rounded,
              title: l10n.phaseTimelineTitle,
              trailing: l10n.phaseTimelineHint,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 74,
            child: ListView.separated(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: widget.length,
              separatorBuilder: (_, _) => const SizedBox(width: _gap),
              itemBuilder: (context, index) {
                final day = index + 1;
                return _DayCell(
                  day: day,
                  color: PhaseContent.colorOf(info.phaseOf(day)),
                  isOvulation: info.phaseOf(day) == CyclePhase.ovulation,
                  isToday: day == info.cycleDay,
                  isSelected: day == widget.selectedDay,
                  onTap: () => widget.onSelect(day),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _Legend(
                  PhaseContent.menstrualColor,
                  l10n.phaseMenstrualShortName,
                ),
                _Legend(
                  PhaseContent.follicularColor,
                  l10n.phaseFollicularShortName,
                ),
                _Legend(PhaseContent.fertileColor, l10n.phaseFertileShortName),
                _Legend(
                  PhaseContent.ovulationColor,
                  l10n.phaseOvulationShortName,
                ),
                _Legend(PhaseContent.lutealColor, l10n.phaseLutealShortName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.color,
    required this.isOvulation,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  final int day;
  final Color color;
  final bool isOvulation;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: _PhaseTimelineState._cellWidth,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _PhaseTimelineState._cellWidth,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
                border: isToday
                    ? Border.all(color: const Color(0xFF2D2032), width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                  if (isOvulation)
                    Icon(
                      Icons.egg_alt_rounded,
                      size: 12,
                      color: isSelected ? Colors.white : color,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isToday ? context.l10n.phaseTimelineTodayMark : '',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2D2032),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(this.color, this.label);

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: const Color(0xFF7A6877)),
        ),
      ],
    );
  }
}
