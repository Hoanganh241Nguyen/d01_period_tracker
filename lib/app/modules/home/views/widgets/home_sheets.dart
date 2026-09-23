import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/l10n.dart';

void showPeriodLogSnack(BuildContext context) {
  Get.toNamed<void>(Routes.logPeriod);
}

void showDailyLogSheet(
  BuildContext context, {
  String? section,
  DateTime? date,
}) {
  Get.toNamed<void>(
    Routes.addSymptom,
    arguments: {
      'section': section ?? context.l10n.homeSectionDailyLog,
      'date': ?date,
    },
  );
}
