import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

class AppLocales {
  AppLocales._();

  static const fallback = Locale('vi');
  static const supported = AppLocalizations.supportedLocales;

  static Locale resolve(String? code) => supported.firstWhere(
    (l) => l.languageCode == code,
    orElse: () => fallback,
  );
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Strings for code without a [BuildContext] (controllers, services).
AppLocalizations get appL10n =>
    lookupAppLocalizations(Get.locale ?? AppLocales.fallback);

extension L10nDates on AppLocalizations {
  /// Short weekday label, Monday = 1 … Sunday = 7 (as [DateTime.weekday]).
  String weekdayShort(int weekday) => [
    weekdayShortMon,
    weekdayShortTue,
    weekdayShortWed,
    weekdayShortThu,
    weekdayShortFri,
    weekdayShortSat,
    weekdayShortSun,
  ][weekday - 1];

  String weekdayLong(int weekday) => [
    weekdayLongMon,
    weekdayLongTue,
    weekdayLongWed,
    weekdayLongThu,
    weekdayLongFri,
    weekdayLongSat,
    weekdayLongSun,
  ][weekday - 1];

  /// Short weekday labels in Monday-first order.
  List<String> get weekdaysShort => [
    for (var i = 1; i <= 7; i++) weekdayShort(i),
  ];

  String monthYear(DateTime date) =>
      commonMonthYear('${date.month}', '${date.year}');

  String dayMonth(DateTime date) => commonDayMonth(
    date.day.toString().padLeft(2, '0'),
    date.month.toString().padLeft(2, '0'),
  );
}
