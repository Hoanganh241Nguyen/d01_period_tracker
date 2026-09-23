import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/local_storage_provider.dart';
import '../../../services/cycle_service.dart';
import '../../../utils/l10n.dart';
import '../../language/controllers/language_controller.dart'
    show LanguageOption;

/// Reminder day-before choices offered for the period reminder.
const reminderDaysBeforeOptions = [1, 2, 3, 5];

class SettingsController extends GetxController {
  final _storage = LocalStorageProvider.to;

  late final themeMode = parseThemeMode(_storage.themeMode).obs;
  late final languageCode = AppLocales.resolve(
    _storage.languageCode,
  ).languageCode.obs;

  late final reminderDailyLog = _storage.reminderDailyLogEnabled.obs;
  late final reminderPeriod = _storage.reminderPeriodEnabled.obs;
  late final reminderPeriodDaysBefore = _storage.reminderPeriodDaysBefore.obs;
  late final reminderOvulation = _storage.reminderOvulationEnabled.obs;

  final languages = const [
    LanguageOption(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt'),
    LanguageOption(code: 'en', name: 'English', nativeName: 'English'),
  ];

  /// Also used by main.dart to set the app's initial theme mode before this
  /// controller exists (it is only bound once Home is reached).
  static ThemeMode parseThemeMode(String value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  static String _themeModeValue(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _storage.setThemeMode(_themeModeValue(mode));
    Get.changeThemeMode(mode);
  }

  Future<void> setLanguage(String code) async {
    languageCode.value = code;
    await _storage.setLanguageCode(code);
    await Get.updateLocale(AppLocales.resolve(code));
  }

  Future<void> setReminderDailyLog(bool value) async {
    reminderDailyLog.value = value;
    await _storage.setReminderDailyLogEnabled(value);
  }

  Future<void> setReminderPeriod(bool value) async {
    reminderPeriod.value = value;
    await _storage.setReminderPeriodEnabled(value);
  }

  Future<void> setReminderPeriodDaysBefore(int value) async {
    reminderPeriodDaysBefore.value = value;
    await _storage.setReminderPeriodDaysBefore(value);
  }

  Future<void> setReminderOvulation(bool value) async {
    reminderOvulation.value = value;
    await _storage.setReminderOvulationEnabled(value);
  }

  /// Summary of how much has been logged, for the privacy & data section.
  (int periods, int loggedDays) get dataSummary {
    final cycle = CycleService.to;
    return (cycle.periods.length, cycle.dailyLogs.length);
  }

  Future<void> clearAllData() => CycleService.to.clearAllData();
}
