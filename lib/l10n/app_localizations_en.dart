// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Period Tracker';

  @override
  String get commonToday => 'Today';

  @override
  String get commonSave => 'Save';

  @override
  String get commonBack => 'Back';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonCancel => 'Cancel';

  @override
  String commonDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String commonMonthYear(String month, String year) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'January',
      '2': 'February',
      '3': 'March',
      '4': 'April',
      '5': 'May',
      '6': 'June',
      '7': 'July',
      '8': 'August',
      '9': 'September',
      '10': 'October',
      '11': 'November',
      'other': 'December',
    });
    return '$_temp0 $year';
  }

  @override
  String commonDayMonth(String day, String month) {
    return '$day/$month';
  }

  @override
  String get weekdayShortMon => 'Mo';

  @override
  String get weekdayShortTue => 'Tu';

  @override
  String get weekdayShortWed => 'We';

  @override
  String get weekdayShortThu => 'Th';

  @override
  String get weekdayShortFri => 'Fr';

  @override
  String get weekdayShortSat => 'Sa';

  @override
  String get weekdayShortSun => 'Su';

  @override
  String get weekdayLongMon => 'Monday';

  @override
  String get weekdayLongTue => 'Tuesday';

  @override
  String get weekdayLongWed => 'Wednesday';

  @override
  String get weekdayLongThu => 'Thursday';

  @override
  String get weekdayLongFri => 'Friday';

  @override
  String get weekdayLongSat => 'Saturday';

  @override
  String get weekdayLongSun => 'Sunday';

  @override
  String get homeTabHome => 'Home';

  @override
  String get homeTabCalendar => 'Calendar';

  @override
  String get homeTabInsights => 'Insights';

  @override
  String get homeTabSettings => 'Settings';

  @override
  String get homeLogTodayTooltip => 'Log today';

  @override
  String homeTodayWithWeekdayDate(String weekday, String date) {
    return 'Today, $weekday, $date';
  }

  @override
  String get homeGreetingMorning => 'Good morning 🌸';

  @override
  String get homeOpenCalendarTooltip => 'Open calendar';

  @override
  String get homeCycleRemainingPrefix => 'Only';

  @override
  String get homeCycleUntilNextPeriod => 'until your next period';

  @override
  String homeCycleExpectedDate(String date) {
    return 'Expected: $date';
  }

  @override
  String get homeEncouragement => 'You\'re doing\ngreat!';

  @override
  String get homeLogPeriodLate => 'Period started? Log it now';

  @override
  String homeLogPeriodUpdate(int day) {
    return 'Update period • Day $day';
  }

  @override
  String get homeLogPeriodEarly => 'Bleeding? Log it';

  @override
  String get homeLogPeriod => 'Log period';

  @override
  String get homeActionCycleAnalysis => 'Cycle analysis';

  @override
  String get homeActionAddSymptoms => 'Add symptoms';

  @override
  String get homeSectionDailyLog => 'Daily log';

  @override
  String get homeSectionSymptoms => 'Symptoms';

  @override
  String homeCalendarMonthTitle(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'January',
      '2': 'February',
      '3': 'March',
      '4': 'April',
      '5': 'May',
      '6': 'June',
      '7': 'July',
      '8': 'August',
      '9': 'September',
      '10': 'October',
      '11': 'November',
      '12': 'December',
      'other': 'Month $month',
    });
    return '$_temp0 calendar';
  }

  @override
  String get homeCalendarTodayButton => 'Full calendar ›';

  @override
  String get homeLegendPeriod => 'Period';

  @override
  String get homeLegendPredicted => 'Predicted';

  @override
  String get homeLegendOvulation => 'Ovulation';

  @override
  String homeStatusCycleDay(int day) {
    return 'Cycle day $day';
  }

  @override
  String homeStatusAverageCycle(String length) {
    return 'Average cycle: $length';
  }

  @override
  String get homeTipTitle => 'Today\'s tip';

  @override
  String get homeTipBody =>
      'Stress, lack of sleep or weight changes can delay your period by a few days.';

  @override
  String get homeTipSeeMore => 'Learn more';

  @override
  String get insightTitle => 'Cycle analysis';

  @override
  String get insightSubtitle => 'Track your cycle length & period duration.';

  @override
  String get insightTagline => 'Understand your body,\nlove yourself ♥';

  @override
  String get insightBadgeNormal => 'Normal';

  @override
  String get insightBadgeIrregular => 'Irregular';

  @override
  String insightStatDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Days',
      one: '1 Day',
    );
    return '$_temp0';
  }

  @override
  String get insightAvgPeriod => 'Average period';

  @override
  String get insightAvgCycle => 'Average cycle';

  @override
  String get insightTrendTitle => 'Cycle & period trends';

  @override
  String insightLastCycles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Last $count cycles',
      one: 'Last cycle',
    );
    return '$_temp0';
  }

  @override
  String get insightLegendCycleLength => 'Cycle length (days)';

  @override
  String get insightLegendPeriod => 'Period (days)';

  @override
  String get insightCurrentPhaseTitle => 'Current phase analysis';

  @override
  String get insightPatternsTitle => 'Common patterns';

  @override
  String insightPatternPmsSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days before your period',
      one: '1 day before your period',
    );
    return '$_temp0';
  }

  @override
  String insightPatternCrampsSubtitle(int startDay, int endDay) {
    return 'Days $startDay – $endDay of your period';
  }

  @override
  String get insightTipsTitle => 'Tips for you';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Step $current/$total';
  }

  @override
  String get onboardingStart => 'Start using the app';

  @override
  String get onboardingWelcomeTitle =>
      'Tracking your cycle, made easier every day';

  @override
  String get onboardingWelcomeSubtitle =>
      'Log your periods and symptoms and get reminders for what matters, without the clutter.';

  @override
  String get onboardingWelcomePrivacyTitle => 'Private by default';

  @override
  String get onboardingWelcomePrivacyBody =>
      'Your health data is presented clearly, and no ads are shown during onboarding.';

  @override
  String get onboardingGoalTitle => 'What would you like to use the app for?';

  @override
  String get onboardingGoalSubtitle =>
      'Choose your main goal so the app can prioritize the right content and reminders.';

  @override
  String get onboardingGoalTrackCycle => 'Track my cycle';

  @override
  String get onboardingGoalFertileWindow => 'Track fertile days';

  @override
  String get onboardingGoalLogSymptoms => 'Log symptoms';

  @override
  String get onboardingGoalWaterReminder => 'Water reminders';

  @override
  String get onboardingLastPeriodTitle => 'When did your last period start?';

  @override
  String get onboardingLastPeriodSubtitle =>
      'This helps predict your next period and the phases of your cycle.';

  @override
  String onboardingDateTileTitle(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String get onboardingDateTileSubtitle => 'Period start date';

  @override
  String get onboardingCycleTitle => 'Set your cycle length';

  @override
  String get onboardingCycleSubtitle =>
      'If you\'re not sure, keep the defaults and adjust them later in Settings.';

  @override
  String get onboardingPeriodLengthLabel => 'Period length';

  @override
  String get onboardingCycleLengthLabel => 'Cycle length';

  @override
  String get onboardingSymptomsTitle => 'What do you usually want to log?';

  @override
  String get onboardingSymptomsSubtitle =>
      'Quickly pick the symptoms you often have. You can add or remove them later.';

  @override
  String get onboardingSymptomCramps => 'Cramps';

  @override
  String get onboardingSymptomBackPain => 'Back pain';

  @override
  String get onboardingSymptomFatigue => 'Fatigue';

  @override
  String get onboardingSymptomHeadache => 'Headache';

  @override
  String get onboardingSymptomMoodSwings => 'Mood swings';

  @override
  String get onboardingSymptomAcne => 'Acne';

  @override
  String get onboardingReminderTitle => 'Turn on gentle reminders';

  @override
  String get onboardingReminderSubtitle =>
      'The app can remind you to log daily, about your expected period, and to drink water, based on your settings.';

  @override
  String get onboardingDailyReminderTitle => 'Daily logging reminder';

  @override
  String get onboardingDailyReminderSubtitle =>
      'How are you feeling today? Logging takes just 10 seconds';

  @override
  String get onboardingReminderInfoTitle => 'Change it anytime';

  @override
  String get onboardingReminderInfoBody =>
      'You control all notifications in Notification settings.';

  @override
  String get splashTagline => 'Gentle, private cycle tracking';

  @override
  String get languageTitle => 'Choose language';

  @override
  String get languageSubtitle => 'You can change this later in Settings.';

  @override
  String get dailyLogFlowSpotting => 'Spotting';

  @override
  String get dailyLogFlowLight => 'Light';

  @override
  String get dailyLogFlowMedium => 'Medium';

  @override
  String get dailyLogFlowHeavy => 'Heavy';

  @override
  String get dailyLogFlowProlonged => 'Prolonged';

  @override
  String get dailyLogMoodHappy => 'Happy';

  @override
  String get dailyLogMoodNormal => 'Okay';

  @override
  String get dailyLogMoodSad => 'Sad';

  @override
  String get dailyLogMoodIrritable => 'Irritable';

  @override
  String get dailyLogMoodAnxious => 'Anxious';

  @override
  String get dailyLogMoodTired => 'Tired';

  @override
  String get dailyLogSymptomCramps => 'Cramps';

  @override
  String get dailyLogSymptomBackPain => 'Back pain';

  @override
  String get dailyLogSymptomHeadache => 'Headache';

  @override
  String get dailyLogSymptomBloating => 'Bloating';

  @override
  String get dailyLogSymptomBreastTenderness => 'Tender breasts';

  @override
  String get dailyLogSymptomAcne => 'Acne';

  @override
  String get dailyLogSymptomNausea => 'Nausea';

  @override
  String get dailyLogSymptomCravings => 'Cravings';

  @override
  String get dailyLogSymptomInsomnia => 'Insomnia';

  @override
  String get dailyLogSymptomDiarrhea => 'Diarrhea';

  @override
  String dailyLogMaxMoods(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moods',
      one: '1 mood',
    );
    return 'Choose up to $_temp0.';
  }

  @override
  String get dailyLogAddSymptom => 'Add symptom';

  @override
  String get dailyLogSymptomNameHint => 'Symptom name';

  @override
  String get dailyLogAdd => 'Add';

  @override
  String get dailyLogSavedTitle => 'Saved';

  @override
  String dailyLogSavedMessage(String date) {
    return 'Saved your log for $date';
  }

  @override
  String get dailyLogFlow => 'Bleeding';

  @override
  String get dailyLogSpottingNotPeriod =>
      '\"Spotting\" doesn\'t count as a period.';

  @override
  String get dailyLogMood => 'Mood';

  @override
  String get dailyLogSymptoms => 'Symptoms';

  @override
  String get dailyLogNote => 'Notes';

  @override
  String get dailyLogNoteHint => 'Write a few lines about today…';

  @override
  String get dailyLogClearDay => 'Clear this day';

  @override
  String get dailyLogPreviousDay => 'Previous day';

  @override
  String get dailyLogNextDay => 'Next day';

  @override
  String dailyLogTodayDate(String date) {
    return 'Today, $date';
  }

  @override
  String logPeriodHintAutoFilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Auto-filled $_temp0 based on your average period length. Deselect them if your period ended earlier.';
  }

  @override
  String get logPeriodHintUntilToday =>
      'Marked up to today. The following days are predicted.';

  @override
  String get logPeriodHintMerged => 'Joined into one period.';

  @override
  String logPeriodHintGapFilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skipped days',
      one: '1 skipped day',
    );
    return 'Filled in $_temp0 in between.';
  }

  @override
  String logPeriodHintRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Removed $_temp0, including auto-filled ones.';
  }

  @override
  String get logPeriodSavedTitle => 'Saved';

  @override
  String get logPeriodSavedMessage =>
      'Your period calendar and predictions have been updated.';

  @override
  String get logPeriodDiscardTitle => 'Discard changes?';

  @override
  String get logPeriodDiscardMessage =>
      'The days you just selected won\'t be saved.';

  @override
  String get logPeriodKeepEditing => 'Keep editing';

  @override
  String get logPeriodDiscard => 'Discard';

  @override
  String get logPeriodTitle => 'Log period';

  @override
  String get logPeriodSubtitle => 'Tap the days you had your period';

  @override
  String get logPeriodLegendLogged => 'Logged';

  @override
  String get logPeriodLegendAutoFilled => 'Auto-filled';

  @override
  String get logPeriodLegendPredicted => 'Predicted';

  @override
  String logPeriodDaySemantics(int day, int month, String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'logged': ', period',
      'midCycle': ', mid-cycle bleeding',
      'predicted': ', predicted',
      'other': '',
    });
    return 'Day $day, month $month$_temp0';
  }

  @override
  String get phaseMenstrualName => 'Menstrual period';

  @override
  String get phaseMenstrualShortName => 'Period';

  @override
  String get phaseMenstrualDescription =>
      'A new cycle begins on the first day of bleeding. As hormone levels drop, the uterine lining that thickened during the previous cycle sheds and leaves the body through the vagina. A period usually lasts 2–7 days, and a total blood loss of about 30–80 ml is within the normal range.';

  @override
  String get phaseMenstrualSymptomNote =>
      'The uterus contracts to push the lining out, so abdominal and back pain are common, especially in the first 1–2 days. Symptoms gradually ease as the period ends.';

  @override
  String get phaseMenstrualTip1Title => 'Apply warmth to your belly';

  @override
  String get phaseMenstrualTip1Subtitle =>
      'Helps the uterine muscles relax and eases cramping.';

  @override
  String get phaseMenstrualTip2Title => 'Get more iron';

  @override
  String get phaseMenstrualTip2Subtitle =>
      'Red meat, dark leafy greens and beans help replace lost iron.';

  @override
  String get phaseMenstrualTip3Title => 'Rest more';

  @override
  String get phaseMenstrualTip3Subtitle =>
      'Favor gentle activity like walking and stretching.';

  @override
  String get phaseFollicularName => 'Follicular phase';

  @override
  String get phaseFollicularShortName => 'Follicular';

  @override
  String get phaseFollicularDescription =>
      'The hormone FSH stimulates follicles in the ovaries to develop, and one dominant follicle continues to mature. Rising estrogen helps the uterine lining thicken again. The chance of conception is still low now but increases as the fertile window approaches.';

  @override
  String get phaseFollicularSymptomNote =>
      'Rising estrogen often makes you feel more alert, cheerful and energetic. It\'s a good time for high-intensity workouts or starting something new.';

  @override
  String get phaseFollicularTip1Title => 'Train hard';

  @override
  String get phaseFollicularTip1Subtitle =>
      'Your body recovers well — great for cardio and weight training.';

  @override
  String get phaseFollicularTip2Title => 'Eat plenty of greens';

  @override
  String get phaseFollicularTip2Subtitle =>
      'Fiber helps your body metabolize estrogen.';

  @override
  String get phaseFertileName => 'Fertile window';

  @override
  String get phaseFertileShortName => 'Fertile';

  @override
  String get phaseFertileDescription =>
      'Estrogen is high, and cervical mucus becomes clear and stretchy, helping sperm move more easily. Sperm can survive up to 5 days in the body, so unprotected sex on these days can lead to pregnancy.';

  @override
  String get phaseFertileSymptomNote =>
      'Egg-white-like mucus is a natural sign that your body is about to ovulate. Tracking it helps pinpoint your fertile window more accurately.';

  @override
  String get phaseFertileTip1Title => 'Use protection';

  @override
  String get phaseFertileTip1Subtitle =>
      'Use contraception if you aren\'t planning a pregnancy.';

  @override
  String get phaseFertileTip2Title => 'Take your morning temperature';

  @override
  String get phaseFertileTip2Subtitle =>
      'Helps confirm ovulation after it has happened.';

  @override
  String get phaseOvulationName => 'Ovulation day';

  @override
  String get phaseOvulationShortName => 'Ovulation';

  @override
  String get phaseOvulationDescription =>
      'The LH surge causes the dominant follicle to rupture and release an egg into the fallopian tube. The egg survives only about 12–24 hours, so this is the most fertile time of the cycle. The ovulation day is an estimate and may be off by a few days.';

  @override
  String get phaseOvulationSymptomNote =>
      'Some people feel a mild, sharp pain on one side of the lower abdomen during ovulation. It usually lasts from a few minutes to a few hours and is normal.';

  @override
  String get phaseOvulationTip1Title => 'Your most fertile time';

  @override
  String get phaseOvulationTip1Subtitle =>
      'Useful if you\'re planning a pregnancy.';

  @override
  String get phaseOvulationTip2Title => 'Stay hydrated';

  @override
  String get phaseOvulationTip2Subtitle =>
      'Helps reduce bloating and discomfort around ovulation.';

  @override
  String get phaseLutealName => 'Luteal phase';

  @override
  String get phaseLutealShortName => 'Luteal';

  @override
  String get phaseLutealDescription =>
      'After ovulation, the follicle turns into the corpus luteum and releases progesterone to prepare the uterine lining for implantation. Body temperature rises slightly, by about 0.3–0.5°C. The chance of conception drops quickly after ovulation.';

  @override
  String get phaseLutealSymptomNote =>
      'Rising progesterone can make you hungrier and sleepier. Eating smaller, more frequent meals and getting enough sleep will help you feel better.';

  @override
  String get phaseLutealTip1Title => 'Exercise gently';

  @override
  String get phaseLutealTip1Subtitle =>
      'Yoga, walking and swimming suit your gradually lower energy.';

  @override
  String get phaseLutealTip2Title => 'Eat small, frequent meals';

  @override
  String get phaseLutealTip2Subtitle =>
      'Keeps blood sugar steady and curbs sugar cravings.';

  @override
  String get phasePmsShortName => 'Premenstrual';

  @override
  String get phasePmsDescription =>
      'If the egg isn\'t fertilized, the corpus luteum breaks down and estrogen and progesterone levels fall. This drop can cause premenstrual syndrome (PMS). Your next period begins when the uterine lining sheds.';

  @override
  String get phasePmsSymptomNote =>
      'PMS usually appears in the 5 days or so before your period and goes away once it starts. If symptoms significantly affect your daily life, talk to a doctor.';

  @override
  String get phasePmsTip1Title => 'Cut back on salt and caffeine';

  @override
  String get phasePmsTip1Subtitle =>
      'Helps reduce bloating, breast tenderness and irritability.';

  @override
  String get phasePmsTip2Title => 'Be prepared';

  @override
  String get phasePmsTip2Subtitle =>
      'Carry pads in case your period comes early.';

  @override
  String get phaseLateName => 'Late period';

  @override
  String get phaseLateShortName => 'Late';

  @override
  String get phaseLateDescription =>
      'Your period is later than expected. Being a few days late is quite common and can be caused by stress or changes in sleep, weight or routine. If you\'ve had unprotected sex, you can take a pregnancy test for peace of mind.';

  @override
  String get phaseLateSymptomNote =>
      'These symptoms may be prolonged PMS or early signs of pregnancy. If your period is more than 1 week late, or this happens several months in a row, see a doctor.';

  @override
  String get phaseLateTip1Title => 'Double-check your calendar';

  @override
  String get phaseLateTip1Subtitle =>
      'You may have forgotten to log the start of your period.';

  @override
  String get phaseLateTip2Title => 'Consider a pregnancy test';

  @override
  String get phaseLateTip2Subtitle =>
      'If you\'ve had unprotected sex this cycle.';

  @override
  String get phaseSymptomCramps => 'Lower abdominal cramps';

  @override
  String get phaseSymptomBackPain => 'Back pain';

  @override
  String get phaseSymptomFatigue => 'Fatigue';

  @override
  String get phaseSymptomHeadache => 'Headache';

  @override
  String get phaseSymptomBloating => 'Bloating';

  @override
  String get phaseSymptomMoodSwings => 'Mood swings';

  @override
  String get phaseSymptomEnergetic => 'Energetic';

  @override
  String get phaseSymptomGoodMood => 'Good mood';

  @override
  String get phaseSymptomClearSkin => 'Clearer skin';

  @override
  String get phaseSymptomFocus => 'Better focus';

  @override
  String get phaseSymptomEggWhiteMucus => 'Clear, stretchy mucus';

  @override
  String get phaseSymptomHighLibido => 'Higher libido';

  @override
  String get phaseSymptomBreastTendernessMild => 'Mild breast tenderness';

  @override
  String get phaseSymptomBreastTenderness => 'Breast tenderness';

  @override
  String get phaseSymptomOvulationPain => 'Mild one-sided abdominal pain';

  @override
  String get phaseSymptomCravings => 'Food cravings';

  @override
  String get phaseSymptomSleepy => 'Sleepiness';

  @override
  String get phaseSymptomAcne => 'Acne';

  @override
  String get phaseSymptomIrritable => 'Irritability';

  @override
  String get phaseSymptomNausea => 'Nausea';

  @override
  String get phaseConceptionLowLabel => 'Low';

  @override
  String get phaseConceptionLowMessage =>
      'Outside the fertile window, the chance of pregnancy is low but not zero, because ovulation timing can vary.';

  @override
  String get phaseConceptionMediumLabel => 'Medium';

  @override
  String get phaseConceptionMediumMessage =>
      'This day is at the edge of the fertile window, so pregnancy is still possible, though less likely than on the days closest to ovulation.';

  @override
  String get phaseConceptionHighLabel => 'High';

  @override
  String get phaseConceptionHighMessage =>
      'Only 1–2 days until your expected ovulation — the chance of conception is high.';

  @override
  String get phaseConceptionPeakLabel => 'Very high';

  @override
  String get phaseConceptionPeakMessage =>
      'This is your expected ovulation day, the most fertile time of your cycle.';

  @override
  String get phaseConceptionTitle => 'Chance of conception';

  @override
  String get phaseConceptionChartWindow => 'Fertile window';

  @override
  String phaseFooterDisclaimer(int cycleLength) {
    return 'Predictions are based on an average cycle length of $cycleLength days and are for reference only. They do not replace a doctor\'s diagnosis.';
  }

  @override
  String phaseTopBarDate(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String get phaseTopBarPreview => 'Preview';

  @override
  String get phaseBackToToday => 'Back to today';

  @override
  String phaseHeroStatusMenstrual(int day, int periodLength) {
    return 'Day $day of $periodLength of your period';
  }

  @override
  String phaseHeroStatusFollicular(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days until ovulation',
      one: '1 day until ovulation',
    );
    return '$_temp0';
  }

  @override
  String phaseHeroStatusFertile(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days until expected ovulation',
      one: '1 day until expected ovulation',
    );
    return '$_temp0';
  }

  @override
  String get phaseHeroStatusOvulation => 'Expected ovulation day';

  @override
  String phaseHeroStatusLuteal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days until your next period',
      one: '1 day until your next period',
    );
    return '$_temp0';
  }

  @override
  String phaseHeroStatusLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Period is $count days late',
      one: 'Period is 1 day late',
    );
    return '$_temp0';
  }

  @override
  String phaseHeroCycleLength(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '/ $count days',
      one: '/ 1 day',
    );
    return '$_temp0';
  }

  @override
  String phaseDayLabel(int day) {
    return 'Day $day';
  }

  @override
  String get phaseTimelineTitle => 'Cycle journey';

  @override
  String get phaseTimelineHint => 'Tap to view another day';

  @override
  String get phaseTimelineTodayMark => 'Today';

  @override
  String get phaseDescriptionTitle => 'What\'s happening?';

  @override
  String get phaseHormonesTitle => 'Hormones';

  @override
  String get phaseHormoneLow => 'Low';

  @override
  String get phaseHormoneRising => 'Rising';

  @override
  String get phaseHormoneHigh => 'High';

  @override
  String get phaseHormonePeak => 'Peaking';

  @override
  String get phaseHormoneFalling => 'Falling';

  @override
  String get phaseSymptomsTitle => 'You may experience';

  @override
  String get phaseSymptomsHintToday =>
      'Tap the symptoms you have to save them for today.';

  @override
  String get phaseSymptomsHintPreview =>
      'Symptoms can only be logged for today.';

  @override
  String phaseSymptomsLoggedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved $count symptoms for today',
      one: 'Saved 1 symptom for today',
    );
    return '$_temp0';
  }

  @override
  String get phaseTipsTitle => 'Self-care';

  @override
  String get emptyCycleTitle => 'No cycle data yet';

  @override
  String get emptyCycleMessage =>
      'Log your most recent period to see your own predictions, cycle phases and insights.';

  @override
  String get emptyCycleAction => 'Log period';

  @override
  String get homeLogFirstPeriod => 'Log your first period';

  @override
  String get homeRingEmptyTitle => 'No data yet';

  @override
  String get homeRingEmptySubtitle => 'Log a period to start predictions';

  @override
  String get homeRingLatePrefix => 'Period late by';

  @override
  String get homeRingLateHint => 'Log it if your period has started';

  @override
  String get homeRingPeriodPrefix => 'Period';

  @override
  String homeRingDay(int day) {
    return 'Day $day';
  }

  @override
  String homeRingPeriodOf(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usually lasts $count days',
      one: 'Usually lasts 1 day',
    );
    return '$_temp0';
  }

  @override
  String get homeGreetingAfternoon => 'Good afternoon 🌷';

  @override
  String get homeGreetingEvening => 'Good evening 🌙';

  @override
  String get onboardingPickDate => 'Pick a date';

  @override
  String get onboardingDontRemember => 'I don\'t remember';

  @override
  String get onboardingDontRememberHint => 'You can log your period later';

  @override
  String get dailyLogSymptomOther => 'Other symptom';

  @override
  String dailyLogDayDate(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String insightSummaryC1P1(int n, int avgPeriod, int avgCycle) {
    return 'Over your last $n cycles, things look consistent — periods last about $avgPeriod days and cycles run about $avgCycle days.';
  }

  @override
  String insightSummaryC1P2(int avgCycle, int periodMin, int periodMax) {
    return 'Your cycle length is holding steady at about $avgCycle days, though your period length has varied a little ($periodMin–$periodMax days).';
  }

  @override
  String insightSummaryC1P3(int periodValue, int avgCycle) {
    return 'One of your recent periods lasted $periodValue days, which is outside the typical range, while your cycle stayed consistent at about $avgCycle days. If you notice this again over the next few cycles, bring it up at your next appointment.';
  }

  @override
  String insightSummaryC1P4(String periodDetail, int avgCycle) {
    return 'A recent period ($periodDetail) fell well outside the typical range, even though your cycle length stayed consistent at about $avgCycle days. Consider checking in with a doctor about this.';
  }

  @override
  String insightSummaryC2P1(int avgPeriod, int cycleMin, int cycleMax) {
    return 'Your periods are consistent at about $avgPeriod days, while your cycle length has varied a little ($cycleMin–$cycleMax days).';
  }

  @override
  String get insightSummaryC2P2 =>
      'Both your cycle length and period length have varied slightly lately. Small changes like this are very common.';

  @override
  String insightSummaryC2P3(int periodValue, int cycleMin, int cycleMax) {
    return 'A recent period lasted $periodValue days, outside the typical range, and your cycle length has varied a little ($cycleMin–$cycleMax days). If this continues over the next few cycles, bring it up at your next appointment.';
  }

  @override
  String insightSummaryC2P4(String periodDetail, int cycleMin, int cycleMax) {
    return 'A recent period ($periodDetail) fell well outside the typical range, and your cycle length has varied a little ($cycleMin–$cycleMax days). Consider checking in with a doctor about this.';
  }

  @override
  String insightSummaryC3P1(int cycleValue, int avgPeriod) {
    return 'One recent cycle lasted $cycleValue days, outside the typical range, while your periods stayed consistent at about $avgPeriod days. If this continues over the next few cycles, bring it up at your next appointment.';
  }

  @override
  String insightSummaryC3P2(int cycleValue, int periodMin, int periodMax) {
    return 'One recent cycle lasted $cycleValue days, outside the typical range, and your period length has also varied a little ($periodMin–$periodMax days). If this continues over the next few cycles, bring it up at your next appointment.';
  }

  @override
  String get insightSummaryC3P3 =>
      'Both your cycle length and period length have recently moved outside their typical ranges. Keep logging and see how the next couple of cycles go.';

  @override
  String insightSummaryC3P4(String periodDetail, int cycleValue) {
    return 'A recent period ($periodDetail) fell well outside the typical range, and one cycle also ran outside its usual range ($cycleValue days). Consider checking in with a doctor about this.';
  }

  @override
  String insightSummaryC4P1(String cycleDetail, int avgPeriod) {
    return 'A recent cycle ($cycleDetail) fell well outside the typical range, while your periods stayed consistent at about $avgPeriod days. Consider checking in with a doctor about this.';
  }

  @override
  String insightSummaryC4P2(String cycleDetail, int periodMin, int periodMax) {
    return 'A recent cycle ($cycleDetail) fell well outside the typical range, and your period length has varied a little ($periodMin–$periodMax days). Consider checking in with a doctor about this.';
  }

  @override
  String insightSummaryC4P3(String cycleDetail, int periodValue) {
    return 'A recent cycle ($cycleDetail) fell well outside the typical range, and one period also lasted outside its usual range ($periodValue days). Consider checking in with a doctor about this.';
  }

  @override
  String get insightSummaryC4P4 =>
      'Both your cycle length and period length have recently reached values well outside their typical ranges. We recommend talking to a doctor about this.';

  @override
  String get insightSummaryNotEnough =>
      'Log at least 2 cycles and we\'ll start showing how your cycle and period length change over time.';

  @override
  String get insightBadgeAttention => 'Needs attention';

  @override
  String get insightTrendEmpty =>
      'The chart appears once you have at least one complete cycle (two consecutive periods logged).';

  @override
  String get insightPatternsEmpty =>
      'Log symptoms over at least 2 cycles to spot recurring patterns.';

  @override
  String insightPatternDuringDay(int day) {
    return 'Day $day of your period';
  }

  @override
  String insightPatternCycleDay(int day) {
    return 'Around cycle day $day';
  }

  @override
  String logPeriodHintMidCycle(int cycleDay, int nextDay, int cycleLength) {
    return 'This is day $cycleDay of your cycle; a new cycle only starts on day $nextDay ($cycleLength days in), so it\'s logged as mid-cycle bleeding.';
  }

  @override
  String logPeriodHintAbsorbed(String date) {
    return 'Note: the period on $date no longer opens its own cycle — it now counts as mid-cycle bleeding.';
  }

  @override
  String get logPeriodLegendMidCycle => 'Mid-cycle bleeding';

  @override
  String get homeRingMidCyclePrefix => 'Mid-cycle bleeding';

  @override
  String homeRingNextPeriodOn(String date) {
    return 'Next period due $date';
  }

  @override
  String get homeLogPeriodUpdateToday => 'Update period log';

  @override
  String get homeLegendMidCycle => 'Mid-cycle bleeding';

  @override
  String logPeriodCycleLengthChip(int count) {
    return '$count-day cycle';
  }

  @override
  String get logPeriodCycleLengthTitle => 'Cycle length';

  @override
  String get logPeriodCycleLengthHelp =>
      'A bleeding day only counts as day 1 of a new cycle once this many days have passed since the previous cycle began. Before that, it extends the period or counts as mid-cycle bleeding.';

  @override
  String get cycleHistoryTitle => 'Cycle history';

  @override
  String get cycleHistoryLegendTooltip => 'How to read the bars';

  @override
  String cycleHistorySummary(int count, String range, int typical) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cycles',
      one: 'cycle',
    );
    return 'Last $_temp0 · $range · typically $typical days';
  }

  @override
  String cycleHistorySummaryPeriod(String range) {
    return 'Periods $range';
  }

  @override
  String cycleHistoryDayRange(int min, int max) {
    return '$min–$max days';
  }

  @override
  String get cycleHistoryNeedMore =>
      'As you log more periods, you\'ll see how your cycles compare with each other.';

  @override
  String get cycleHistoryUpcoming => 'Upcoming (estimated)';

  @override
  String cycleHistoryRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String cycleHistoryRangeNow(String start) {
    return '$start – now';
  }

  @override
  String cycleHistoryAround(String date) {
    return 'Around $date';
  }

  @override
  String cycleHistoryCurrentDay(int day) {
    return 'Day $day';
  }

  @override
  String cycleHistoryLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days late',
      one: '1 day late',
    );
    return '$_temp0';
  }

  @override
  String get cycleHistoryPredicted => 'Expected';

  @override
  String cycleHistoryPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Period $count days',
      one: 'Period 1 day',
    );
    return '$_temp0';
  }

  @override
  String cycleHistoryPredictedPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Period about $count days',
      one: 'Period about 1 day',
    );
    return '$_temp0';
  }

  @override
  String cycleHistoryMidCycleDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days of bleeding between periods',
      one: '1 day of bleeding between periods',
    );
    return '$_temp0';
  }

  @override
  String get cycleHistoryMissing => 'A period may not have been logged';

  @override
  String cycleHistoryMissingDetail(int count) {
    return 'A $count-day gap is too long to be one cycle, so it isn\'t counted in your stats. If you had a period in between, log it.';
  }

  @override
  String get cycleHistoryAddPeriod => 'Add a period';

  @override
  String cycleHistoryShowAll(int count) {
    return 'Show all ($count)';
  }

  @override
  String get cycleHistoryShowLess => 'Show less';

  @override
  String cycleHistoryDiffLonger(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days longer than usual',
      one: '1 day longer than usual',
    );
    return '$_temp0';
  }

  @override
  String cycleHistoryDiffShorter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days shorter than usual',
      one: '1 day shorter than usual',
    );
    return '$_temp0';
  }

  @override
  String get cycleHistoryDiffSame => 'Same as usual';

  @override
  String get cycleHistoryOutsideRange =>
      'Outside the common range (21–38 days). An occasional unusual cycle is normal; if it keeps happening, consider checking with a doctor.';

  @override
  String get cycleHistoryDetailPeriod => 'Period';

  @override
  String get cycleHistoryDetailExpectedPeriod => 'Expected period';

  @override
  String get cycleHistoryDetailOvulation => 'Estimated ovulation';

  @override
  String cycleHistoryNotConfirmed(String date) {
    return '$date (not confirmed)';
  }

  @override
  String get cycleHistoryDetailFertile => 'Possible fertile days';

  @override
  String get cycleHistoryCannotEstimate => 'Can\'t be estimated for this cycle';

  @override
  String get cycleHistoryDetailSymptoms => 'Logged symptoms';

  @override
  String get cycleHistoryNoSymptoms => 'No symptoms logged';

  @override
  String cycleHistoryLateDetail(int count) {
    return 'No new period yet after your $count-day cycle length. If it has started, log it.';
  }

  @override
  String cycleHistoryForecastNote(int count) {
    return 'Based on the $count-day cycle length you set; it can be off by a few days.';
  }

  @override
  String get cycleHistoryLegendPeriod => 'Logged period';

  @override
  String get cycleHistoryLegendPredicted => 'Predicted period';

  @override
  String get cycleHistoryLegendMidCycle => 'Bleeding between periods';

  @override
  String get cycleHistoryLegendFertile => 'Possible fertile days (estimated)';

  @override
  String get cycleHistoryLegendOvulation => 'Estimated ovulation';

  @override
  String get cycleHistoryLegendLate => 'Days late';

  @override
  String get cycleHistoryLegendTypical => 'Your typical length';

  @override
  String get cycleHistoryDisclaimer =>
      'Ovulation and possible fertile days are calendar estimates. They can be off by several days and are not a method of contraception.';

  @override
  String cycleHistoryRowSemantics(String range, String length, String details) {
    return 'Cycle $range. $length. $details';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Adjust how the app predicts your cycle.';

  @override
  String get settingsCycleSectionTitle => 'CYCLE & PERIOD';

  @override
  String get settingsCycleLengthTitle => 'Cycle length';

  @override
  String get settingsCycleLengthSubtitle => 'Decides when a new cycle begins';

  @override
  String get settingsPeriodLengthTitle => 'Period length';

  @override
  String get settingsPeriodLengthSubtitle =>
      'Used for auto-fill and predictions; updates as you log more periods';

  @override
  String get settingsPeriodLengthHelp =>
      'Used to auto-fill a new period and to predict upcoming ones. It updates automatically each time you finish logging a period.';

  @override
  String logPeriodHintAutoFilledUntilToday(int count) {
    return 'Auto-filled $count days, marked up to today. The days after that are predicted.';
  }

  @override
  String logPeriodHintMergedWithFill(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Filled in $count days to join this into one period.',
      one: 'Filled in 1 day to join this into one period.',
    );
    return '$_temp0';
  }

  @override
  String logPeriodHintNewCycleAt(String date, int cycleLength) {
    return '$date is day 1 of a new cycle — $cycleLength days have passed since the previous one started.';
  }

  @override
  String logPeriodHintAbsorbedMultiple(int count) {
    return 'Note: $count earlier periods no longer open their own cycle — they now count as mid-cycle bleeding.';
  }

  @override
  String get calendarSubtitle => 'Tap a day to see details';

  @override
  String get calendarLegendTooltip => 'Legend';

  @override
  String get calendarJumpToToday => 'Jump to today';

  @override
  String get calendarLegendLogged => 'Something logged';

  @override
  String get calendarDetailNoLog => 'Nothing logged for this day yet.';

  @override
  String get calendarLogButton => 'Log';

  @override
  String settingsCycleSectionPreview(int cycleLength, int periodLength) {
    return '$cycleLength-day cycle · $periodLength-day period';
  }

  @override
  String get settingsThemeSectionTitle => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguageSectionTitle => 'Language';

  @override
  String get settingsReminderSectionTitle => 'Reminders';

  @override
  String settingsReminderSectionPreviewOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders on',
      one: '1 reminder on',
    );
    return '$_temp0';
  }

  @override
  String get settingsReminderSectionPreviewOff => 'No reminders on';

  @override
  String get settingsReminderNote =>
      'Notifications will be available in a future update. You can set your preference now.';

  @override
  String get settingsReminderDailyLogTitle => 'Daily log reminder';

  @override
  String get settingsReminderDailyLogSubtitle =>
      'Reminds you to log symptoms and mood each day';

  @override
  String get settingsReminderPeriodTitle => 'Period reminder';

  @override
  String settingsReminderPeriodSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Reminds you $days days before',
      one: 'Reminds you 1 day before',
    );
    return '$_temp0';
  }

  @override
  String get settingsReminderOvulationTitle => 'Ovulation reminder';

  @override
  String get settingsReminderOvulationSubtitle =>
      'Reminds you on the estimated ovulation day';

  @override
  String get settingsReminderDaysBeforeSheetTitle => 'How many days before?';

  @override
  String get settingsPrivacySectionTitle => 'Privacy & Data';

  @override
  String settingsPrivacySectionPreview(int periods, int days) {
    return '$periods periods logged · $days days of logs';
  }

  @override
  String get settingsDataLocalNote =>
      'All your data stays on this device only — nothing is sent to a server.';

  @override
  String get settingsClearDataTitle => 'Delete all cycle data';

  @override
  String get settingsClearDataSubtitle =>
      'Permanently deletes logged periods and daily logs';

  @override
  String get settingsClearDataConfirmTitle => 'Delete all data?';

  @override
  String get settingsClearDataConfirmMessage =>
      'All logged periods and daily logs will be permanently deleted. This cannot be undone.';

  @override
  String get settingsClearDataConfirmAction => 'Delete';

  @override
  String get settingsClearDataDone => 'All data deleted';

  @override
  String get settingsPremiumSectionTitle => 'Premium';

  @override
  String get settingsPremiumSectionPreview => 'Coming soon';

  @override
  String get settingsPremiumBody =>
      'Premium features (advanced predictions, no ads, cloud backup…) are coming soon.';

  @override
  String get settingsHelpSectionTitle => 'Help & About';

  @override
  String get settingsHelpSectionPreview => 'FAQ, app version';

  @override
  String get settingsFaqTitle => 'FAQ';

  @override
  String get settingsFaqQ1 => 'How does the app estimate ovulation?';

  @override
  String get settingsFaqA1 =>
      'Ovulation is a calendar estimate (about 14 days before the next period), not a real measurement, so it can be off by a few days.';

  @override
  String get settingsFaqQ2 =>
      'Why doesn\'t logging more bleeding change my current cycle?';

  @override
  String get settingsFaqA2 =>
      'A new cycle only starts once your set cycle length has passed. Bleeding before that is counted as mid-cycle bleeding.';

  @override
  String get settingsFaqQ3 => 'Where is my data stored?';

  @override
  String get settingsFaqA3 =>
      'Only on this device. The app never sends your data to any server.';

  @override
  String get settingsFaqQ4 => 'How do I change the default cycle length?';

  @override
  String get settingsFaqA4 =>
      'Open Cycle & period at the top of Settings and choose Cycle length.';

  @override
  String get settingsMedicalDisclaimerTitle => 'Medical disclaimer';

  @override
  String get settingsAppVersionTitle => 'App version';
}
