import 'package:get/get.dart';

import '../controllers/log_period_controller.dart';

class LogPeriodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogPeriodController>(() => LogPeriodController());
  }
}
