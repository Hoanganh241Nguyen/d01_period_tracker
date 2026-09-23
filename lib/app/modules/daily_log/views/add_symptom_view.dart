import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/daily_log.dart';
import '../../../services/cycle_service.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/l10n.dart';
import '../../../utils/symptom_labels.dart' as labels;
import '../../../widgets/app_svg_icon.dart';

class AddSymptomView extends StatefulWidget {
  const AddSymptomView({super.key});

  @override
  State<AddSymptomView> createState() => _AddSymptomViewState();
}

class _AddSymptomViewState extends State<AddSymptomView> {
  final _cycle = CycleService.to;

  /// Actual today, computed fresh rather than read from the service's Rx
  /// value, which only rolls over when some screen calls refreshToday() —
  /// this one might be the first opened after midnight.
  DateTime get _realToday => CycleService.dateOnly(DateTime.now());

  late DateTime date = _realToday;
  FlowLevel? flowLevel;
  final moods = <String>{};
  final symptoms = <String>{};
  final noteController = TextEditingController();
  DailyLog _saved = const DailyLog();

  static const maxMoods = 3;

  static const moodIds = [
    'happy',
    'normal',
    'sad',
    'irritable',
    'anxious',
    'tired',
  ];

  /// Ids shared with the cycle phase screen, so both log the same symptom.
  static const symptomIds = [
    'cramps',
    'back_pain',
    'headache',
    'bloating',
    'breast_tenderness',
    'acne',
    'nausea',
    'cravings',
    'insomnia',
    'diarrhea',
    'fatigue',
    'mood_swings',
    'constipation',
    'dizziness',
    'hot_flashes',
    'chills',
    'pelvic_pain',
    'ovulation_pain',
    'vaginal_discharge',
    'spotting',
    'low_libido',
    'high_libido',
    'sore_throat',
    'body_aches',
    'tender_skin',
    'sleepy',
    'stress',
    'water_retention',
  ];

  String flowLabel(FlowLevel level) => labels.flowLabel(level, context.l10n);

  String moodLabel(String id) => labels.moodLabel(id, context.l10n);

  String symptomLabel(String id) => labels.symptomLabel(id, context.l10n);

  String symptomIconAsset(String id) => labels.symptomIconAsset(id);

  /// Built-in symptoms plus any other symptom already logged for this day.
  List<String> get symptomOptions => [
    ...symptomIds,
    ...symptoms.where((id) => !symptomIds.contains(id)),
  ];

  DailyLog get _current => DailyLog(
    flow: flowLevel,
    moods: {...moods},
    symptoms: {...symptoms},
    note: noteController.text,
  );

  bool get hasChanges {
    final current = _current;
    return current.flow != _saved.flow ||
        !setEquals(current.moods, _saved.moods) ||
        !setEquals(current.symptoms, _saved.symptoms) ||
        current.note.trim() != _saved.note.trim();
  }

  bool get isEmpty => _current.isEmpty;

  bool get isToday => date == _realToday;

  @override
  void initState() {
    super.initState();
    // In case this is the first screen opened since the app crossed
    // midnight in the background.
    _cycle.refreshToday();
    final args = Get.arguments;
    if (args is Map && args['date'] is DateTime) {
      final requested = CycleService.dateOnly(args['date'] as DateTime);
      if (!requested.isAfter(_realToday)) date = requested;
    }
    _load(date);
  }

  void _load(DateTime day) {
    final log = _cycle.dailyLogOn(day);
    date = day;
    _saved = log;
    flowLevel = log.flow;
    moods
      ..clear()
      ..addAll(log.moods);
    symptoms
      ..clear()
      ..addAll(log.symptoms);
    noteController.text = log.note;
  }

  void changeDay(int delta) {
    final next = DateTime(date.year, date.month, date.day + delta);
    if (next.isAfter(_realToday)) return;
    setState(() => _load(next));
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void toggleFlow(FlowLevel value) {
    setState(() {
      flowLevel = flowLevel == value ? null : value;
    });
  }

  void toggleMood(String id) {
    setState(() {
      if (moods.contains(id)) {
        moods.remove(id);
      } else if (moods.length < maxMoods) {
        moods.add(id);
      } else {
        _showSnack(context.l10n.dailyLogMaxMoods(maxMoods));
      }
    });
  }

  void toggleSymptom(String id) {
    setState(() {
      if (!symptoms.remove(id)) symptoms.add(id);
    });
  }

  void addCustomSymptom() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.dailyLogAddSymptom),
        content: TextField(
          controller: controller,
          maxLength: 20,
          autofocus: true,
          decoration: InputDecoration(
            hintText: context.l10n.dailyLogSymptomNameHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                setState(() => symptoms.add('${DailyLog.customPrefix}$value'));
              }
              Navigator.of(context).pop();
            },
            child: Text(context.l10n.dailyLogAdd),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  Future<void> save() async {
    final l10n = context.l10n;
    await _cycle.saveDailyLog(date, _current);
    Get.back<void>();
    Get.snackbar(
      l10n.dailyLogSavedTitle,
      l10n.dailyLogSavedMessage(l10n.dayMonth(date)),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final initialSection = (Get.arguments is Map)
        ? (Get.arguments as Map)['section']?.toString()
        : null;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFFFFF2F6)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: Image.asset(
              AppAssets.bgDailyLogSheet,
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
                    const Color(0xFFFFF2F6).withValues(alpha: 0.40),
                    const Color(0xFFFFF2F6).withValues(alpha: 0.94),
                    const Color(0xFFFFF2F6),
                  ],
                  stops: const [0.0, 0.32, 0.52],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _DailyLogAppBar(
                  initialSection: initialSection,
                  date: date,
                  isToday: isToday,
                  onPrevious: () => changeDay(-1),
                  onNext: isToday ? null : () => changeDay(1),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                    children: [
                      _SectionCard(
                        title: l10n.dailyLogFlow,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ChipWrap(
                              values: FlowLevel.values,
                              labelOf: flowLabel,
                              selectedValues: {?flowLevel},
                              onTap: toggleFlow,
                              iconAssetOf: labels.flowIconAsset,
                            ),
                            if (flowLevel == FlowLevel.spotting) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.dailyLogSpottingNotPeriod,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: l10n.dailyLogMood,
                        child: _ChipWrap(
                          values: moodIds,
                          labelOf: moodLabel,
                          selectedValues: moods,
                          onTap: toggleMood,
                          iconAssetOf: labels.moodIconAsset,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: l10n.dailyLogSymptoms,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final symptom in symptomOptions)
                              _SelectableChip(
                                label: symptomLabel(symptom),
                                selected: symptoms.contains(symptom),
                                iconAsset: symptomIconAsset(symptom),
                                onTap: () => toggleSymptom(symptom),
                              ),
                            _SelectableChip(
                              label: l10n.dailyLogAddSymptom,
                              selected: false,
                              icon: Icons.add,
                              onTap: addCustomSymptom,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: l10n.dailyLogNote,
                        child: TextField(
                          controller: noteController,
                          maxLines: 3,
                          maxLength: 500,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: l10n.dailyLogNoteHint,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  TextButton(
                    onPressed: !isEmpty
                        ? () {
                            setState(() {
                              flowLevel = null;
                              moods.clear();
                              symptoms.clear();
                              noteController.clear();
                            });
                          }
                        : null,
                    child: Text(l10n.dailyLogClearDay),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: hasChanges ? save : null,
                        child: Text(l10n.commonSave),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyLogAppBar extends StatelessWidget {
  const _DailyLogAppBar({
    required this.initialSection,
    required this.date,
    required this.isToday,
    required this.onPrevious,
    required this.onNext,
  });

  final String? initialSection;
  final DateTime date;
  final bool isToday;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.dailyLogPreviousDay,
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  isToday
                      ? l10n.dailyLogTodayDate(l10n.dayMonth(date))
                      : l10n.dailyLogDayDate(
                          l10n.weekdayLong(date.weekday),
                          l10n.dayMonth(date),
                        ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (initialSection != null)
                  Text(
                    initialSection!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.dailyLogNextDay,
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
          IconButton(
            tooltip: l10n.commonClose,
            onPressed: () => Get.back<void>(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ChipWrap<T> extends StatelessWidget {
  const _ChipWrap({
    required this.values,
    required this.labelOf,
    required this.selectedValues,
    required this.onTap,
    this.icon,
    this.iconAssetOf,
  });

  final List<T> values;
  final String Function(T) labelOf;
  final Set<T> selectedValues;
  final ValueChanged<T> onTap;
  final IconData? icon;
  final String Function(T)? iconAssetOf;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          _SelectableChip(
            label: labelOf(value),
            selected: selectedValues.contains(value),
            icon: icon,
            iconAsset: iconAssetOf?.call(value),
            onTap: () => onTap(value),
          ),
      ],
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.iconAsset,
  });

  final String label;
  final bool selected;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      selected: selected,
      avatar: selected
          ? Icon(Icons.check, size: 18, color: colorScheme.onPrimary)
          : iconAsset != null
          ? AppSvgIcon(iconAsset!, size: 18, color: colorScheme.primary)
          : Icon(icon, size: 18, color: colorScheme.primary),
      label: Text(label),
      selectedColor: colorScheme.primary,
      checkmarkColor: colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      onSelected: (_) => onTap(),
    );
  }
}
