import 'package:get/get.dart';

import '../controllers/cycle_phase_controller.dart';

class CyclePhaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CyclePhaseController>(() => CyclePhaseController());
  }
}
