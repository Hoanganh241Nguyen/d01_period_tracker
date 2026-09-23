part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const language = _Paths.language;
  static const onboarding = _Paths.onboarding;
  static const home = _Paths.home;
  static const addSymptom = _Paths.addSymptom;
  static const logPeriod = _Paths.logPeriod;
  static const cyclePhase = _Paths.cyclePhase;
}

abstract class _Paths {
  _Paths._();

  static const splash = '/splash';
  static const language = '/language';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const addSymptom = '/add-symptom';
  static const logPeriod = '/log-period';
  static const cyclePhase = '/cycle-phase';
}
