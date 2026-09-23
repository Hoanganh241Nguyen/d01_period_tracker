import 'package:get/get.dart';

import '../../../data/models/cycle_day_info.dart';
import '../../../services/cycle_service.dart';

class CyclePhaseController extends GetxController {
  final _cycle = CycleService.to;

  /// Cycle day being previewed on the timeline; null means today.
  final previewDay = RxnInt();

  /// Null until a period has been logged.
  CycleDayInfo? get todayInfo => _cycle.todayInfo.value;

  CycleDayInfo? get info {
    final today = todayInfo;
    final day = previewDay.value;
    return day == null || today == null ? today : today.copyWith(cycleDay: day);
  }

  bool get isToday => previewDay.value == null;

  DateTime get today => _cycle.today.value;

  DateTime get selectedDate {
    final offset = (info?.cycleDay ?? 0) - (todayInfo?.cycleDay ?? 0);
    return DateTime(today.year, today.month, today.day + offset);
  }

  Set<String> get todaySymptoms => _cycle.todaySymptoms;

  /// Number of days shown on the timeline (includes late days, if any).
  int get timelineLength {
    final today = todayInfo!;
    return today.cycleDay > today.cycleLength
        ? today.cycleDay
        : today.cycleLength;
  }

  @override
  void onInit() {
    super.onInit();
    _cycle.refreshToday();
  }

  void selectDay(int day) {
    previewDay.value = day == todayInfo?.cycleDay ? null : day;
  }

  void backToToday() => previewDay.value = null;

  void toggleSymptom(String id) {
    if (!isToday) return;
    _cycle.toggleTodaySymptom(id);
  }
}
