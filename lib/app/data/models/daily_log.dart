/// Menstrual flow logged for a day. Spotting is not counted as a period day.
enum FlowLevel { spotting, light, medium, heavy, prolonged }

/// Everything the user logged for one calendar day. Moods and symptoms are
/// stored as stable ids (never translated labels); custom symptoms typed by
/// the user are stored with the [customPrefix].
class DailyLog {
  const DailyLog({
    this.flow,
    this.moods = const {},
    this.symptoms = const {},
    this.note = '',
  });

  static const customPrefix = 'custom:';

  final FlowLevel? flow;
  final Set<String> moods;
  final Set<String> symptoms;
  final String note;

  bool get isEmpty =>
      flow == null && moods.isEmpty && symptoms.isEmpty && note.trim().isEmpty;

  /// Whether the flow means the day is a period day.
  bool get isBleeding => flow != null && flow != FlowLevel.spotting;

  DailyLog copyWith({
    FlowLevel? Function()? flow,
    Set<String>? moods,
    Set<String>? symptoms,
    String? note,
  }) => DailyLog(
    flow: flow != null ? flow() : this.flow,
    moods: moods ?? this.moods,
    symptoms: symptoms ?? this.symptoms,
    note: note ?? this.note,
  );

  Map<String, dynamic> toJson() => {
    if (flow != null) 'flow': flow!.name,
    if (moods.isNotEmpty) 'moods': moods.toList(),
    if (symptoms.isNotEmpty) 'symptoms': symptoms.toList(),
    if (note.trim().isNotEmpty) 'note': note.trim(),
  };

  factory DailyLog.fromJson(Map<String, dynamic> json) => DailyLog(
    flow: FlowLevel.values.asNameMap()[json['flow']],
    moods: {...?(json['moods'] as List?)?.cast<String>()},
    symptoms: {...?(json['symptoms'] as List?)?.cast<String>()},
    note: json['note'] as String? ?? '',
  );
}
