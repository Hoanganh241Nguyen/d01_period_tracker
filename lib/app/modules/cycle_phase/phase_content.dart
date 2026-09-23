import 'package:flutter/material.dart';

import '../../data/models/cycle_day_info.dart';
import '../../utils/l10n.dart';

class PhaseSymptom {
  const PhaseSymptom(this.id, this.label, this.icon);

  final String id;
  final String label;
  final IconData icon;
}

enum HormoneTrend { low, rising, high, peak, falling }

class HormoneState {
  const HormoneState(this.name, this.trend);

  final String name;
  final HormoneTrend trend;
}

class PhaseTip {
  const PhaseTip(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;
}

class PhaseContent {
  const PhaseContent({
    required this.name,
    required this.shortName,
    required this.color,
    required this.icon,
    required this.description,
    required this.symptoms,
    required this.symptomNote,
    required this.hormones,
    required this.tips,
  });

  final String name;
  final String shortName;
  final Color color;
  final IconData icon;
  final String description;
  final List<PhaseSymptom> symptoms;
  final String symptomNote;
  final List<HormoneState> hormones;
  final List<PhaseTip> tips;

  static const menstrualColor = Color(0xFFE5486F);
  static const follicularColor = Color(0xFF4FA3E0);
  static const fertileColor = Color(0xFF3FB39B);
  static const ovulationColor = Color(0xFF8E63CE);
  static const lutealColor = Color(0xFFF2A541);
  static const lateColor = Color(0xFF9E8C92);

  static Color colorOf(CyclePhase phase) => switch (phase) {
    CyclePhase.menstrual => menstrualColor,
    CyclePhase.follicular => follicularColor,
    CyclePhase.fertile => fertileColor,
    CyclePhase.ovulation => ovulationColor,
    CyclePhase.luteal => lutealColor,
    CyclePhase.late => lateColor,
  };

  static PhaseContent of(CycleDayInfo info, AppLocalizations l10n) {
    switch (info.phase) {
      case CyclePhase.menstrual:
        return _menstrual(l10n);
      case CyclePhase.follicular:
        return _follicular(l10n);
      case CyclePhase.fertile:
        return _fertile(l10n);
      case CyclePhase.ovulation:
        return _ovulation(l10n);
      case CyclePhase.luteal:
        return info.isPmsWindow ? _pms(l10n) : _luteal(l10n);
      case CyclePhase.late:
        return _late(l10n);
    }
  }

  static PhaseContent _menstrual(AppLocalizations l10n) => PhaseContent(
    name: l10n.phaseMenstrualName,
    shortName: l10n.phaseMenstrualShortName,
    color: menstrualColor,
    icon: Icons.water_drop_rounded,
    description: l10n.phaseMenstrualDescription,
    symptoms: [
      PhaseSymptom('cramps', l10n.phaseSymptomCramps, Icons.bolt_rounded),
      PhaseSymptom(
        'back_pain',
        l10n.phaseSymptomBackPain,
        Icons.accessibility_new_rounded,
      ),
      PhaseSymptom(
        'fatigue',
        l10n.phaseSymptomFatigue,
        Icons.battery_2_bar_rounded,
      ),
      PhaseSymptom(
        'headache',
        l10n.phaseSymptomHeadache,
        Icons.psychology_alt_rounded,
      ),
      PhaseSymptom(
        'bloating',
        l10n.phaseSymptomBloating,
        Icons.bubble_chart_rounded,
      ),
      PhaseSymptom(
        'mood_swings',
        l10n.phaseSymptomMoodSwings,
        Icons.mood_bad_rounded,
      ),
    ],
    symptomNote: l10n.phaseMenstrualSymptomNote,
    hormones: const [
      HormoneState('Estrogen', HormoneTrend.low),
      HormoneState('Progesterone', HormoneTrend.low),
    ],
    tips: [
      PhaseTip(
        Icons.local_fire_department_rounded,
        l10n.phaseMenstrualTip1Title,
        l10n.phaseMenstrualTip1Subtitle,
      ),
      PhaseTip(
        Icons.restaurant_rounded,
        l10n.phaseMenstrualTip2Title,
        l10n.phaseMenstrualTip2Subtitle,
      ),
      PhaseTip(
        Icons.bedtime_rounded,
        l10n.phaseMenstrualTip3Title,
        l10n.phaseMenstrualTip3Subtitle,
      ),
    ],
  );

  static PhaseContent _follicular(AppLocalizations l10n) => PhaseContent(
    name: l10n.phaseFollicularName,
    shortName: l10n.phaseFollicularShortName,
    color: follicularColor,
    icon: Icons.spa_rounded,
    description: l10n.phaseFollicularDescription,
    symptoms: [
      PhaseSymptom('energetic', l10n.phaseSymptomEnergetic, Icons.bolt_rounded),
      PhaseSymptom(
        'good_mood',
        l10n.phaseSymptomGoodMood,
        Icons.sentiment_satisfied_rounded,
      ),
      PhaseSymptom(
        'clear_skin',
        l10n.phaseSymptomClearSkin,
        Icons.face_retouching_natural_rounded,
      ),
      PhaseSymptom(
        'focus',
        l10n.phaseSymptomFocus,
        Icons.center_focus_strong_rounded,
      ),
    ],
    symptomNote: l10n.phaseFollicularSymptomNote,
    hormones: const [
      HormoneState('Estrogen', HormoneTrend.rising),
      HormoneState('FSH', HormoneTrend.rising),
      HormoneState('Progesterone', HormoneTrend.low),
    ],
    tips: [
      PhaseTip(
        Icons.fitness_center_rounded,
        l10n.phaseFollicularTip1Title,
        l10n.phaseFollicularTip1Subtitle,
      ),
      PhaseTip(
        Icons.eco_rounded,
        l10n.phaseFollicularTip2Title,
        l10n.phaseFollicularTip2Subtitle,
      ),
    ],
  );

  static PhaseContent _fertile(AppLocalizations l10n) => PhaseContent(
    name: l10n.phaseFertileName,
    shortName: l10n.phaseFertileShortName,
    color: fertileColor,
    icon: Icons.eco_rounded,
    description: l10n.phaseFertileDescription,
    symptoms: [
      PhaseSymptom(
        'egg_white_mucus',
        l10n.phaseSymptomEggWhiteMucus,
        Icons.opacity_rounded,
      ),
      PhaseSymptom(
        'high_libido',
        l10n.phaseSymptomHighLibido,
        Icons.favorite_rounded,
      ),
      PhaseSymptom(
        'breast_tenderness',
        l10n.phaseSymptomBreastTendernessMild,
        Icons.healing_rounded,
      ),
      PhaseSymptom('energetic', l10n.phaseSymptomEnergetic, Icons.bolt_rounded),
    ],
    symptomNote: l10n.phaseFertileSymptomNote,
    hormones: const [
      HormoneState('Estrogen', HormoneTrend.high),
      HormoneState('LH', HormoneTrend.rising),
      HormoneState('Progesterone', HormoneTrend.low),
    ],
    tips: [
      PhaseTip(
        Icons.shield_rounded,
        l10n.phaseFertileTip1Title,
        l10n.phaseFertileTip1Subtitle,
      ),
      PhaseTip(
        Icons.thermostat_rounded,
        l10n.phaseFertileTip2Title,
        l10n.phaseFertileTip2Subtitle,
      ),
    ],
  );

  static PhaseContent _ovulation(AppLocalizations l10n) => PhaseContent(
    name: l10n.phaseOvulationName,
    shortName: l10n.phaseOvulationShortName,
    color: ovulationColor,
    icon: Icons.egg_alt_rounded,
    description: l10n.phaseOvulationDescription,
    symptoms: [
      PhaseSymptom(
        'ovulation_pain',
        l10n.phaseSymptomOvulationPain,
        Icons.bolt_rounded,
      ),
      PhaseSymptom(
        'egg_white_mucus',
        l10n.phaseSymptomEggWhiteMucus,
        Icons.opacity_rounded,
      ),
      PhaseSymptom(
        'high_libido',
        l10n.phaseSymptomHighLibido,
        Icons.favorite_rounded,
      ),
      PhaseSymptom(
        'bloating',
        l10n.phaseSymptomBloating,
        Icons.bubble_chart_rounded,
      ),
    ],
    symptomNote: l10n.phaseOvulationSymptomNote,
    hormones: const [
      HormoneState('LH', HormoneTrend.peak),
      HormoneState('Estrogen', HormoneTrend.high),
      HormoneState('Progesterone', HormoneTrend.rising),
    ],
    tips: [
      PhaseTip(
        Icons.favorite_rounded,
        l10n.phaseOvulationTip1Title,
        l10n.phaseOvulationTip1Subtitle,
      ),
      PhaseTip(
        Icons.water_drop_rounded,
        l10n.phaseOvulationTip2Title,
        l10n.phaseOvulationTip2Subtitle,
      ),
    ],
  );

  static PhaseContent _luteal(AppLocalizations l10n) => PhaseContent(
    name: l10n.phaseLutealName,
    shortName: l10n.phaseLutealShortName,
    color: lutealColor,
    icon: Icons.wb_twilight_rounded,
    description: l10n.phaseLutealDescription,
    symptoms: [
      PhaseSymptom('cravings', l10n.phaseSymptomCravings, Icons.cookie_rounded),
      PhaseSymptom('sleepy', l10n.phaseSymptomSleepy, Icons.bedtime_rounded),
      PhaseSymptom(
        'bloating',
        l10n.phaseSymptomBloating,
        Icons.bubble_chart_rounded,
      ),
      PhaseSymptom(
        'breast_tenderness',
        l10n.phaseSymptomBreastTenderness,
        Icons.healing_rounded,
      ),
    ],
    symptomNote: l10n.phaseLutealSymptomNote,
    hormones: const [
      HormoneState('Progesterone', HormoneTrend.high),
      HormoneState('Estrogen', HormoneTrend.rising),
      HormoneState('LH', HormoneTrend.low),
    ],
    tips: [
      PhaseTip(
        Icons.self_improvement_rounded,
        l10n.phaseLutealTip1Title,
        l10n.phaseLutealTip1Subtitle,
      ),
      PhaseTip(
        Icons.restaurant_rounded,
        l10n.phaseLutealTip2Title,
        l10n.phaseLutealTip2Subtitle,
      ),
    ],
  );

  static PhaseContent _pms(AppLocalizations l10n) => PhaseContent(
    name: l10n.phaseLutealName,
    shortName: l10n.phasePmsShortName,
    color: lutealColor,
    icon: Icons.wb_twilight_rounded,
    description: l10n.phasePmsDescription,
    symptoms: [
      PhaseSymptom(
        'breast_tenderness',
        l10n.phaseSymptomBreastTenderness,
        Icons.healing_rounded,
      ),
      PhaseSymptom('acne', l10n.phaseSymptomAcne, Icons.face_rounded),
      PhaseSymptom(
        'irritable',
        l10n.phaseSymptomIrritable,
        Icons.sentiment_dissatisfied_rounded,
      ),
      PhaseSymptom(
        'bloating',
        l10n.phaseSymptomBloating,
        Icons.bubble_chart_rounded,
      ),
      PhaseSymptom(
        'fatigue',
        l10n.phaseSymptomFatigue,
        Icons.battery_2_bar_rounded,
      ),
      PhaseSymptom(
        'headache',
        l10n.phaseSymptomHeadache,
        Icons.psychology_alt_rounded,
      ),
    ],
    symptomNote: l10n.phasePmsSymptomNote,
    hormones: const [
      HormoneState('Progesterone', HormoneTrend.falling),
      HormoneState('Estrogen', HormoneTrend.falling),
    ],
    tips: [
      PhaseTip(
        Icons.no_food_rounded,
        l10n.phasePmsTip1Title,
        l10n.phasePmsTip1Subtitle,
      ),
      PhaseTip(
        Icons.inventory_2_rounded,
        l10n.phasePmsTip2Title,
        l10n.phasePmsTip2Subtitle,
      ),
    ],
  );

  static PhaseContent _late(AppLocalizations l10n) => PhaseContent(
    name: l10n.phaseLateName,
    shortName: l10n.phaseLateShortName,
    color: lateColor,
    icon: Icons.schedule_rounded,
    description: l10n.phaseLateDescription,
    symptoms: [
      PhaseSymptom(
        'breast_tenderness',
        l10n.phaseSymptomBreastTenderness,
        Icons.healing_rounded,
      ),
      PhaseSymptom(
        'fatigue',
        l10n.phaseSymptomFatigue,
        Icons.battery_2_bar_rounded,
      ),
      PhaseSymptom('nausea', l10n.phaseSymptomNausea, Icons.sick_rounded),
      PhaseSymptom(
        'bloating',
        l10n.phaseSymptomBloating,
        Icons.bubble_chart_rounded,
      ),
    ],
    symptomNote: l10n.phaseLateSymptomNote,
    hormones: const [HormoneState('Progesterone', HormoneTrend.high)],
    tips: [
      PhaseTip(
        Icons.event_note_rounded,
        l10n.phaseLateTip1Title,
        l10n.phaseLateTip1Subtitle,
      ),
      PhaseTip(
        Icons.science_rounded,
        l10n.phaseLateTip2Title,
        l10n.phaseLateTip2Subtitle,
      ),
    ],
  );
}

class ConceptionContent {
  const ConceptionContent(this.label, this.color, this.message);

  final String label;
  final Color color;
  final String message;

  static ConceptionContent of(ConceptionLevel level, AppLocalizations l10n) =>
      switch (level) {
        ConceptionLevel.low => ConceptionContent(
          l10n.phaseConceptionLowLabel,
          const Color(0xFF4FA3E0),
          l10n.phaseConceptionLowMessage,
        ),
        ConceptionLevel.medium => ConceptionContent(
          l10n.phaseConceptionMediumLabel,
          const Color(0xFFF2A541),
          l10n.phaseConceptionMediumMessage,
        ),
        ConceptionLevel.high => ConceptionContent(
          l10n.phaseConceptionHighLabel,
          const Color(0xFF3FB39B),
          l10n.phaseConceptionHighMessage,
        ),
        ConceptionLevel.peak => ConceptionContent(
          l10n.phaseConceptionPeakLabel,
          const Color(0xFF8E63CE),
          l10n.phaseConceptionPeakMessage,
        ),
      };
}

/// One-line summary of where [info] is in the cycle.
String phaseStatusLine(CycleDayInfo info, AppLocalizations l10n) =>
    switch (info.phase) {
      CyclePhase.menstrual => l10n.phaseHeroStatusMenstrual(
        info.dayInPhase,
        info.periodLength,
      ),
      CyclePhase.follicular => l10n.phaseHeroStatusFollicular(
        info.daysToOvulation,
      ),
      CyclePhase.fertile => l10n.phaseHeroStatusFertile(info.daysToOvulation),
      CyclePhase.ovulation => l10n.phaseHeroStatusOvulation,
      CyclePhase.luteal => l10n.phaseHeroStatusLuteal(info.daysToNextPeriod),
      CyclePhase.late => l10n.phaseHeroStatusLate(info.daysLate),
    };
