import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/l10n.dart';
import '../../../widgets/app_background.dart';
import '../../../services/cycle_service.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      body: AppBackground(
        assetPath: AppAssets.bgSplashOnboarding,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Obx(
                  () => Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: IconButton(
                              tooltip: l10n.commonBack,
                              onPressed: controller.currentStep.value == 0
                                  ? null
                                  : controller.goBack,
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: controller.progress,
                                minHeight: 8,
                                backgroundColor:
                                    colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: controller.skip,
                            child: Text(l10n.onboardingSkip),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.onboardingStepProgress(
                            controller.currentStep.value + 1,
                            OnboardingController.totalSteps,
                          ),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.setStep,
                  children: const [
                    _WelcomeStep(),
                    _GoalStep(),
                    _LastPeriodStep(),
                    _CycleStep(),
                    _SymptomsStep(),
                    _ReminderStep(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: controller.goNext,
                      child: Text(
                        controller.isLastStep
                            ? l10n.onboardingStart
                            : l10n.commonContinue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _goalLabel(AppLocalizations l10n, OnboardingGoal goal) => switch (goal) {
  OnboardingGoal.trackCycle => l10n.onboardingGoalTrackCycle,
  OnboardingGoal.fertileWindow => l10n.onboardingGoalFertileWindow,
  OnboardingGoal.logSymptoms => l10n.onboardingGoalLogSymptoms,
  OnboardingGoal.waterReminder => l10n.onboardingGoalWaterReminder,
};

String _symptomLabel(AppLocalizations l10n, OnboardingSymptom symptom) =>
    switch (symptom) {
      OnboardingSymptom.cramps => l10n.onboardingSymptomCramps,
      OnboardingSymptom.backPain => l10n.onboardingSymptomBackPain,
      OnboardingSymptom.fatigue => l10n.onboardingSymptomFatigue,
      OnboardingSymptom.headache => l10n.onboardingSymptomHeadache,
      OnboardingSymptom.moodSwings => l10n.onboardingSymptomMoodSwings,
      OnboardingSymptom.acne => l10n.onboardingSymptomAcne,
    };

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 36, color: colorScheme.primary),
        ),
        const SizedBox(height: 24),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 28),
        child,
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _StepScaffold(
      icon: Icons.favorite,
      title: l10n.onboardingWelcomeTitle,
      subtitle: l10n.onboardingWelcomeSubtitle,
      child: _InfoCard(
        title: l10n.onboardingWelcomePrivacyTitle,
        body: l10n.onboardingWelcomePrivacyBody,
        icon: Icons.lock_outline,
      ),
    );
  }
}

class _GoalStep extends GetView<OnboardingController> {
  const _GoalStep();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _StepScaffold(
      icon: Icons.flag_outlined,
      title: l10n.onboardingGoalTitle,
      subtitle: l10n.onboardingGoalSubtitle,
      child: Obx(
        () => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: controller.goals.map((goal) {
            final selected = controller.selectedGoal.value == goal;
            return ChoiceChip(
              selected: selected,
              label: Text(_goalLabel(l10n, goal)),
              avatar: selected
                  ? Icon(
                      Icons.check,
                      size: 18,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : null,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              labelStyle: TextStyle(
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (_) => controller.selectGoal(goal),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _LastPeriodStep extends GetView<OnboardingController> {
  const _LastPeriodStep();

  static const _maxDaysBack = 90;

  Future<void> _pickDate(BuildContext context) async {
    final today = CycleService.to.today.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.lastPeriodStart.value ?? today,
      firstDate: DateTime(today.year, today.month, today.day - _maxDaysBack),
      lastDate: today,
    );
    if (picked != null) controller.setLastPeriodStart(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _StepScaffold(
      icon: Icons.calendar_month_outlined,
      title: l10n.onboardingLastPeriodTitle,
      subtitle: l10n.onboardingLastPeriodSubtitle,
      child: Obx(() {
        final date = controller.lastPeriodStart.value;
        return Column(
          children: [
            _DateTile(
              date: date,
              selected: date != null,
              onTap: () => _pickDate(context),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(
                  date == null
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(l10n.onboardingDontRemember),
                subtitle: Text(l10n.onboardingDontRememberHint),
                onTap: () => controller.setLastPeriodStart(null),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CycleStep extends GetView<OnboardingController> {
  const _CycleStep();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _StepScaffold(
      icon: Icons.tune,
      title: l10n.onboardingCycleTitle,
      subtitle: l10n.onboardingCycleSubtitle,
      child: Obx(
        () => Column(
          children: [
            _SliderCard(
              title: l10n.onboardingPeriodLengthLabel,
              value: controller.periodLength.value,
              min: 2,
              max: 10,
              onChanged: controller.setPeriodLength,
            ),
            const SizedBox(height: 12),
            _SliderCard(
              title: l10n.onboardingCycleLengthLabel,
              value: controller.cycleLength.value,
              min: CycleService.minCycleSetting.toDouble(),
              max: CycleService.maxCycleSetting.toDouble(),
              onChanged: controller.setCycleLength,
            ),
          ],
        ),
      ),
    );
  }
}

class _SymptomsStep extends GetView<OnboardingController> {
  const _SymptomsStep();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _StepScaffold(
      icon: Icons.spa_outlined,
      title: l10n.onboardingSymptomsTitle,
      subtitle: l10n.onboardingSymptomsSubtitle,
      child: Obx(
        () => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: controller.symptoms.map((symptom) {
            final selected = controller.selectedSymptoms.contains(symptom);
            return FilterChip(
              selected: selected,
              label: Text(_symptomLabel(l10n, symptom)),
              avatar: selected
                  ? Icon(
                      Icons.check,
                      size: 18,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : null,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              labelStyle: TextStyle(
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (_) => controller.toggleSymptom(symptom),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ReminderStep extends GetView<OnboardingController> {
  const _ReminderStep();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _StepScaffold(
      icon: Icons.notifications_active_outlined,
      title: l10n.onboardingReminderTitle,
      subtitle: l10n.onboardingReminderSubtitle,
      child: Obx(
        () => Column(
          children: [
            SwitchListTile(
              value: controller.reminderEnabled.value,
              onChanged: controller.setReminderEnabled,
              title: Text(l10n.onboardingDailyReminderTitle),
              subtitle: Text(l10n.onboardingDailyReminderSubtitle),
              secondary: const Icon(Icons.alarm),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              title: l10n.onboardingReminderInfoTitle,
              body: l10n.onboardingReminderInfoBody,
              icon: Icons.settings_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface.withValues(alpha: 0.88),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  /// Null until the user picks a date.
  final DateTime? date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final date = this.date;

    return Card(
      color: selected
          ? colorScheme.primary.withValues(alpha: 0.16)
          : colorScheme.surface.withValues(alpha: 0.86),
      child: ListTile(
        minVerticalPadding: 12,
        leading: CircleAvatar(
          backgroundColor: selected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          foregroundColor: selected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
          child: date == null
              ? const Icon(Icons.edit_calendar_rounded)
              : Text('${date.day}'),
        ),
        title: Text(
          date == null
              ? l10n.onboardingPickDate
              : l10n.onboardingDateTileTitle(
                  l10n.weekdayLong(date.weekday),
                  l10n.dayMonth(date),
                ),
        ),
        subtitle: Text(l10n.onboardingDateTileSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  const _SliderCard({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String title;
  final int value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final valueLabel = context.l10n.commonDays(value);

    return Card(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.88),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  valueLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: min,
              max: max,
              divisions: (max - min).round(),
              label: valueLabel,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
