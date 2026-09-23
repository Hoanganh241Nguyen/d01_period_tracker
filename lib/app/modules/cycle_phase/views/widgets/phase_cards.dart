import 'package:flutter/material.dart';

import '../../../../utils/l10n.dart';
import '../../phase_content.dart';

const _ink = Color(0xFF2D2032);
const _muted = Color(0xFF7A6877);

class PhaseCard extends StatelessWidget {
  const PhaseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class CardTitle extends StatelessWidget {
  const CardTitle({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.color,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Icon(icon, size: 20, color: accent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: _ink,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: _muted),
          ),
      ],
    );
  }
}

class PhaseDescriptionCard extends StatelessWidget {
  const PhaseDescriptionCard({super.key, required this.content});

  final PhaseContent content;

  @override
  Widget build(BuildContext context) {
    return PhaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(
            icon: Icons.menu_book_rounded,
            title: context.l10n.phaseDescriptionTitle,
            color: content.color,
          ),
          const SizedBox(height: 10),
          Text(
            content.description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _muted, height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.phaseHormonesTitle,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final hormone in content.hormones)
                _HormoneChip(hormone: hormone),
            ],
          ),
        ],
      ),
    );
  }
}

class _HormoneChip extends StatelessWidget {
  const _HormoneChip({required this.hormone});

  final HormoneState hormone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, icon, color) = switch (hormone.trend) {
      HormoneTrend.low => (
        l10n.phaseHormoneLow,
        Icons.south_rounded,
        const Color(0xFF4FA3E0),
      ),
      HormoneTrend.rising => (
        l10n.phaseHormoneRising,
        Icons.north_east_rounded,
        const Color(0xFF3FB39B),
      ),
      HormoneTrend.high => (
        l10n.phaseHormoneHigh,
        Icons.north_rounded,
        const Color(0xFFF2A541),
      ),
      HormoneTrend.peak => (
        l10n.phaseHormonePeak,
        Icons.keyboard_double_arrow_up_rounded,
        const Color(0xFF8E63CE),
      ),
      HormoneTrend.falling => (
        l10n.phaseHormoneFalling,
        Icons.south_east_rounded,
        const Color(0xFFE5486F),
      ),
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${hormone.name} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                TextSpan(
                  text: label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  const SymptomCard({
    super.key,
    required this.content,
    required this.isToday,
    required this.loggedIds,
    required this.onToggle,
  });

  final PhaseContent content;
  final bool isToday;
  final Set<String> loggedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final loggedCount = content.symptoms
        .where((s) => loggedIds.contains(s.id))
        .length;

    return PhaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(
            icon: Icons.healing_rounded,
            title: l10n.phaseSymptomsTitle,
            color: content.color,
          ),
          const SizedBox(height: 4),
          Text(
            isToday
                ? l10n.phaseSymptomsHintToday
                : l10n.phaseSymptomsHintPreview,
            style: textTheme.labelSmall?.copyWith(color: _muted),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final symptom in content.symptoms)
                _SymptomChip(
                  symptom: symptom,
                  color: content.color,
                  selected: isToday && loggedIds.contains(symptom.id),
                  enabled: isToday,
                  onTap: () => onToggle(symptom.id),
                ),
            ],
          ),
          if (isToday && loggedCount > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: content.color,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.phaseSymptomsLoggedCount(loggedCount),
                  style: textTheme.labelMedium?.copyWith(
                    color: content.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: content.color.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, size: 18, color: content.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    content.symptomNote,
                    style: textTheme.bodySmall?.copyWith(
                      color: _ink,
                      height: 1.4,
                    ),
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

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({
    required this.symptom,
    required this.color,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final PhaseSymptom symptom;
  final Color color;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color : color.withValues(alpha: 0.08),
      shape: StadiumBorder(
        side: BorderSide(color: color.withValues(alpha: selected ? 0 : 0.2)),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.check_rounded : symptom.icon,
                size: 16,
                color: selected ? Colors.white : color,
              ),
              const SizedBox(width: 6),
              Text(
                symptom.label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : _ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhaseTipsCard extends StatelessWidget {
  const PhaseTipsCard({super.key, required this.content});

  final PhaseContent content;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PhaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(
            icon: Icons.favorite_rounded,
            title: context.l10n.phaseTipsTitle,
            color: content.color,
          ),
          const SizedBox(height: 6),
          for (final tip in content.tips)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: content.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(tip.icon, size: 20, color: content.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.title,
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tip.subtitle,
                          style: textTheme.bodySmall?.copyWith(color: _muted),
                        ),
                      ],
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
