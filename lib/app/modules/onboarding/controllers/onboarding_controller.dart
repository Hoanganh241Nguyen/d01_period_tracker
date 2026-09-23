import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/cycle_service.dart';

/// Onboarding goal ids; labels are resolved in the view via l10n.
enum OnboardingGoal { trackCycle, fertileWindow, logSymptoms, waterReminder }

/// Onboarding symptom ids; labels are resolved in the view via l10n.
enum OnboardingSymptom { cramps, backPain, fatigue, headache, moodSwings, acne }

class OnboardingController extends GetxController {
  static const totalSteps = 6;

  final pageController = PageController();
  final currentStep = 0.obs;
  final selectedGoal = OnboardingGoal.trackCycle.obs;
  final selectedSymptoms = <OnboardingSymptom>{}.obs;
  final periodLength = 5.obs;
  final cycleLength = 28.obs;
  final reminderEnabled = true.obs;

  /// Start of the most recent period; null when the user does not remember.
  final lastPeriodStart = Rxn<DateTime>();
  final isSaving = false.obs;

  final goals = OnboardingGoal.values;

  final symptoms = OnboardingSymptom.values;

  double get progress => (currentStep.value + 1) / totalSteps;
  bool get isLastStep => currentStep.value == totalSteps - 1;

  void goNext() {
    if (isLastStep) {
      finish();
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void goBack() {
    if (currentStep.value == 0) {
      return;
    }

    pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  void skip() => finish();

  /// Saves what the user entered (lengths are only saved as starting
  /// estimates; they are re-learned from logged periods) and opens home.
  Future<void> finish() async {
    if (isSaving.value) return;
    isSaving.value = true;
    try {
      await CycleService.to.completeOnboarding(
        cycleLength: cycleLength.value,
        periodLength: periodLength.value,
        lastPeriodStart: lastPeriodStart.value,
      );
      Get.offAllNamed(Routes.home);
    } finally {
      isSaving.value = false;
    }
  }

  void setLastPeriodStart(DateTime? date) => lastPeriodStart.value = date;

  void setStep(int index) => currentStep.value = index;

  void selectGoal(OnboardingGoal goal) => selectedGoal.value = goal;

  void toggleSymptom(OnboardingSymptom symptom) {
    if (selectedSymptoms.contains(symptom)) {
      selectedSymptoms.remove(symptom);
    } else {
      selectedSymptoms.add(symptom);
    }
    selectedSymptoms.refresh();
  }

  void setPeriodLength(double value) => periodLength.value = value.round();

  void setCycleLength(double value) => cycleLength.value = value.round();

  void setReminderEnabled(bool value) => reminderEnabled.value = value;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
