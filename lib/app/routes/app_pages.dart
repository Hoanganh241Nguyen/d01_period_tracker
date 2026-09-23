import 'package:get/get.dart';

import '../modules/cycle_phase/bindings/cycle_phase_binding.dart';
import '../modules/cycle_phase/views/cycle_phase_view.dart';
import '../modules/daily_log/views/add_symptom_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/log_period/bindings/log_period_binding.dart';
import '../modules/log_period/views/log_period_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

abstract class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  // A getter (not a static final) so hot reload picks up newly added pages.
  static List<GetPage> get routes => [
    GetPage(name: _Paths.splash, page: () => const SplashView()),
    GetPage(
      name: _Paths.language,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(name: _Paths.addSymptom, page: () => const AddSymptomView()),
    GetPage(
      name: _Paths.logPeriod,
      page: () => const LogPeriodView(),
      binding: LogPeriodBinding(),
    ),
    GetPage(
      name: _Paths.cyclePhase,
      page: () => const CyclePhaseView(),
      binding: CyclePhaseBinding(),
    ),
  ];
}
