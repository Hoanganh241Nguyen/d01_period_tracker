import '../data/models/cycle_day_info.dart';
import '../data/models/daily_log.dart';
import '../modules/cycle_phase/phase_content.dart';
import 'l10n.dart';

/// Display name for any symptom id logged anywhere in the app: the daily log
/// list, the cycle phase screen, or a custom symptom typed by the user.
String symptomLabel(String id, AppLocalizations l10n) {
  if (id.startsWith(DailyLog.customPrefix)) {
    return id.substring(DailyLog.customPrefix.length);
  }
  final known = switch (id) {
    'cramps' => l10n.dailyLogSymptomCramps,
    'back_pain' => l10n.dailyLogSymptomBackPain,
    'headache' => l10n.dailyLogSymptomHeadache,
    'bloating' => l10n.dailyLogSymptomBloating,
    'breast_tenderness' => l10n.dailyLogSymptomBreastTenderness,
    'acne' => l10n.dailyLogSymptomAcne,
    'nausea' => l10n.dailyLogSymptomNausea,
    'cravings' => l10n.dailyLogSymptomCravings,
    'insomnia' => l10n.dailyLogSymptomInsomnia,
    'diarrhea' => l10n.dailyLogSymptomDiarrhea,
    'fatigue' => _localized(l10n, vi: 'Mệt mỏi', en: 'Fatigue'),
    'mood_swings' => _localized(
      l10n,
      vi: 'Dễ thay đổi tâm trạng',
      en: 'Mood swings',
    ),
    'constipation' => _localized(l10n, vi: 'Táo bón', en: 'Constipation'),
    'dizziness' => _localized(l10n, vi: 'Chóng mặt', en: 'Dizziness'),
    'hot_flashes' => _localized(l10n, vi: 'Bốc hoả', en: 'Hot flashes'),
    'chills' => _localized(l10n, vi: 'Ớn lạnh', en: 'Chills'),
    'pelvic_pain' => _localized(l10n, vi: 'Đau vùng chậu', en: 'Pelvic pain'),
    'ovulation_pain' => _localized(
      l10n,
      vi: 'Đau rụng trứng',
      en: 'Ovulation pain',
    ),
    'vaginal_discharge' => _localized(l10n, vi: 'Khí hư', en: 'Discharge'),
    'spotting' => _localized(l10n, vi: 'Ra máu lấm tấm', en: 'Spotting'),
    'low_libido' => _localized(l10n, vi: 'Giảm ham muốn', en: 'Low libido'),
    'high_libido' => _localized(l10n, vi: 'Tăng ham muốn', en: 'High libido'),
    'sore_throat' => _localized(l10n, vi: 'Đau họng', en: 'Sore throat'),
    'body_aches' => _localized(l10n, vi: 'Đau nhức người', en: 'Body aches'),
    'tender_skin' => _localized(l10n, vi: 'Da nhạy cảm', en: 'Tender skin'),
    'sleepy' => _localized(l10n, vi: 'Buồn ngủ', en: 'Sleepy'),
    'stress' => _localized(l10n, vi: 'Căng thẳng', en: 'Stress'),
    'water_retention' => _localized(
      l10n,
      vi: 'Giữ nước',
      en: 'Water retention',
    ),
    _ => null,
  };
  return known ?? _phaseSymptomLabels(l10n)[id] ?? l10n.dailyLogSymptomOther;
}

String symptomIconAsset(String id) {
  if (id.startsWith(DailyLog.customPrefix)) {
    return 'assets/icons/ic_home_add.svg';
  }
  return switch (id) {
    'cramps' => 'assets/icons/symptom_cramps.svg',
    'back_pain' => 'assets/icons/symptom_back_pain.svg',
    'headache' => 'assets/icons/symptom_headache.svg',
    'bloating' => 'assets/icons/symptom_bloating.svg',
    'breast_tenderness' => 'assets/icons/symptom_breast_tenderness.svg',
    'acne' => 'assets/icons/symptom_acne.svg',
    'nausea' => 'assets/icons/symptom_nausea.svg',
    'cravings' => 'assets/icons/symptom_cravings.svg',
    'insomnia' => 'assets/icons/symptom_insomnia.svg',
    'diarrhea' || 'constipation' => 'assets/icons/symptom_diarrhea.svg',
    'fatigue' || 'sleepy' => 'assets/icons/symptom_fatigue.svg',
    'mood_swings' => 'assets/icons/symptom_mood_swings.svg',
    'dizziness' => 'assets/icons/symptom_dizziness.svg',
    'hot_flashes' => 'assets/icons/symptom_hot_flashes.svg',
    'chills' => 'assets/icons/symptom_chills.svg',
    'pelvic_pain' => 'assets/icons/symptom_pelvic_pain.svg',
    'ovulation_pain' => 'assets/icons/symptom_ovulation_pain.svg',
    'vaginal_discharge' => 'assets/icons/symptom_vaginal_discharge.svg',
    'spotting' => 'assets/icons/symptom_vaginal_discharge.svg',
    'low_libido' || 'high_libido' => 'assets/icons/symptom_libido.svg',
    'sore_throat' => 'assets/icons/symptom_sore_throat.svg',
    'body_aches' => 'assets/icons/symptom_body_aches.svg',
    'tender_skin' => 'assets/icons/symptom_tender_skin.svg',
    'stress' => 'assets/icons/symptom_stress.svg',
    'water_retention' => 'assets/icons/symptom_water_retention.svg',
    _ => 'assets/icons/ic_symptoms.svg',
  };
}

String _localized(
  AppLocalizations l10n, {
  required String vi,
  required String en,
}) => l10n.localeName.startsWith('vi') ? vi : en;

String flowLabel(FlowLevel level, AppLocalizations l10n) => switch (level) {
  FlowLevel.spotting => l10n.dailyLogFlowSpotting,
  FlowLevel.light => l10n.dailyLogFlowLight,
  FlowLevel.medium => l10n.dailyLogFlowMedium,
  FlowLevel.heavy => l10n.dailyLogFlowHeavy,
  FlowLevel.prolonged => l10n.dailyLogFlowProlonged,
};

String flowIconAsset(FlowLevel level) => switch (level) {
  FlowLevel.spotting => 'assets/icons/log_flow_spotting.svg',
  FlowLevel.light => 'assets/icons/log_flow_light.svg',
  FlowLevel.medium => 'assets/icons/log_flow_medium.svg',
  FlowLevel.heavy => 'assets/icons/log_flow_heavy.svg',
  FlowLevel.prolonged => 'assets/icons/log_flow_prolonged.svg',
};

String moodLabel(String id, AppLocalizations l10n) => switch (id) {
  'happy' => l10n.dailyLogMoodHappy,
  'normal' => l10n.dailyLogMoodNormal,
  'sad' => l10n.dailyLogMoodSad,
  'irritable' => l10n.dailyLogMoodIrritable,
  'anxious' => l10n.dailyLogMoodAnxious,
  _ => l10n.dailyLogMoodTired,
};

String moodIconAsset(String id) => switch (id) {
  'happy' => 'assets/icons/log_mood_happy.svg',
  'normal' => 'assets/icons/log_mood_normal.svg',
  'sad' => 'assets/icons/log_mood_sad.svg',
  'irritable' => 'assets/icons/log_mood_irritable.svg',
  'anxious' => 'assets/icons/log_mood_anxious.svg',
  _ => 'assets/icons/log_mood_tired.svg',
};

/// Labels of the symptoms suggested on the cycle phase screen, collected by
/// walking one sample cycle (every phase, plus a late day).
Map<String, String> _phaseSymptomLabels(AppLocalizations l10n) {
  final labels = <String, String>{};
  for (var day = 1; day <= 29; day++) {
    final info = CycleDayInfo(cycleDay: day, cycleLength: 28, periodLength: 5);
    for (final symptom in PhaseContent.of(info, l10n).symptoms) {
      labels.putIfAbsent(symptom.id, () => symptom.label);
    }
  }
  return labels;
}
