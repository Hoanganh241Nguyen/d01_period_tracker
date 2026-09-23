import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_log.dart';

class LocalStorageProvider {
  LocalStorageProvider(this._prefs);

  static Future<LocalStorageProvider> create() async =>
      LocalStorageProvider(await SharedPreferences.getInstance());

  static LocalStorageProvider get to => Get.find();

  final SharedPreferences _prefs;

  static const _cycleLengthKey = 'cycle_length';
  static const _periodLengthKey = 'period_length';
  static const _periodDaysKey = 'period_days';
  static const _dailyLogPrefix = 'daily_log_';
  static const _languageCodeKey = 'language_code';
  static const _onboardingDoneKey = 'onboarding_done';
  static const _themeModeKey = 'theme_mode';
  static const _reminderDailyLogKey = 'reminder_daily_log';
  static const _reminderPeriodKey = 'reminder_period';
  static const _reminderPeriodDaysBeforeKey = 'reminder_period_days_before';
  static const _reminderOvulationKey = 'reminder_ovulation';

  /// Keys written by earlier versions that are no longer read.
  static const _legacyKeys = ['last_period_start'];
  static const _legacySymptomsPrefix = 'daily_symptoms_';

  /// Whether data from an earlier version is present. Those versions
  /// overwrote the user's cycle length with a learned average.
  bool get hasLegacyData => _prefs.getKeys().any(
    (k) => _legacyKeys.contains(k) || k.startsWith(_legacySymptomsPrefix),
  );

  Future<void> removeLegacyData() async {
    for (final key in _prefs.getKeys().toList()) {
      if (_legacyKeys.contains(key) || key.startsWith(_legacySymptomsPrefix)) {
        await _prefs.remove(key);
      }
    }
  }

  String? get languageCode => _prefs.getString(_languageCodeKey);
  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_languageCodeKey, code);

  bool get onboardingDone => _prefs.getBool(_onboardingDoneKey) ?? false;
  Future<void> setOnboardingDone() => _prefs.setBool(_onboardingDoneKey, true);

  /// Average cycle length; set in onboarding, then learned from logged data.
  int? get cycleLength => _prefs.getInt(_cycleLengthKey);
  Future<void> setCycleLength(int value) =>
      _prefs.setInt(_cycleLengthKey, value);

  /// Average period length; set in onboarding, then learned from logged data.
  int? get periodLength => _prefs.getInt(_periodLengthKey);
  Future<void> setPeriodLength(int value) =>
      _prefs.setInt(_periodLengthKey, value);

  /// Every logged bleeding day, stored as `yyyy-MM-dd`.
  Set<DateTime> get periodDays =>
      (_prefs.getStringList(_periodDaysKey) ?? const [])
          .map(DateTime.tryParse)
          .whereType<DateTime>()
          .toSet();

  Future<void> setPeriodDays(Iterable<DateTime> days) => _prefs.setStringList(
    _periodDaysKey,
    [for (final day in days.toList()..sort()) dateKey(day)],
  );

  /// All non-empty daily logs, keyed by date.
  Map<DateTime, DailyLog> get dailyLogs => {
    for (final key in _prefs.getKeys())
      if (key.startsWith(_dailyLogPrefix))
        ?DateTime.tryParse(key.substring(_dailyLogPrefix.length)): ?_readLog(
          key,
        ),
  };

  DailyLog? _readLog(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return DailyLog.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    }
  }

  DailyLog dailyLogOn(DateTime date) =>
      _readLog('$_dailyLogPrefix${dateKey(date)}') ?? const DailyLog();

  Future<void> setDailyLog(DateTime date, DailyLog log) {
    final key = '$_dailyLogPrefix${dateKey(date)}';
    return log.isEmpty
        ? _prefs.remove(key)
        : _prefs.setString(key, jsonEncode(log.toJson()));
  }

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// 'system' | 'light' | 'dark'.
  String get themeMode => _prefs.getString(_themeModeKey) ?? 'system';
  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);

  /// These only persist a preference; no notification is actually
  /// scheduled or delivered yet (no local-notifications engine is wired up).
  bool get reminderDailyLogEnabled =>
      _prefs.getBool(_reminderDailyLogKey) ?? false;
  Future<void> setReminderDailyLogEnabled(bool value) =>
      _prefs.setBool(_reminderDailyLogKey, value);

  bool get reminderPeriodEnabled => _prefs.getBool(_reminderPeriodKey) ?? true;
  Future<void> setReminderPeriodEnabled(bool value) =>
      _prefs.setBool(_reminderPeriodKey, value);

  int get reminderPeriodDaysBefore =>
      _prefs.getInt(_reminderPeriodDaysBeforeKey) ?? 2;
  Future<void> setReminderPeriodDaysBefore(int value) =>
      _prefs.setInt(_reminderPeriodDaysBeforeKey, value);

  bool get reminderOvulationEnabled =>
      _prefs.getBool(_reminderOvulationKey) ?? false;
  Future<void> setReminderOvulationEnabled(bool value) =>
      _prefs.setBool(_reminderOvulationKey, value);

  /// Erases every logged period day and daily log, and resets the cycle and
  /// period length settings. Keeps app-level preferences (language, theme,
  /// onboarding, reminders).
  Future<void> clearCycleData() async {
    for (final key in _prefs.getKeys().toList()) {
      if (key == _periodDaysKey ||
          key == _cycleLengthKey ||
          key == _periodLengthKey ||
          key.startsWith(_dailyLogPrefix)) {
        await _prefs.remove(key);
      }
    }
  }
}
