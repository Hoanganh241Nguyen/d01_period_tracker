import 'package:get/get.dart';

import '../../../data/providers/local_storage_provider.dart';
import '../../../utils/l10n.dart';

import '../../../routes/app_pages.dart';

class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  final String code;
  final String name;
  final String nativeName;
}

class LanguageController extends GetxController {
  final _storage = LocalStorageProvider.to;
  late final selectedCode = AppLocales.resolve(
    _storage.languageCode,
  ).languageCode.obs;

  final languages = const [
    LanguageOption(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt'),
    LanguageOption(code: 'en', name: 'English', nativeName: 'English'),
  ];

  /// Applies the language immediately so the rest of the flow is shown in it.
  Future<void> selectLanguage(String code) async {
    selectedCode.value = code;
    await _storage.setLanguageCode(code);
    await Get.updateLocale(AppLocales.resolve(code));
  }

  void continueToOnboarding() => Get.offNamed(Routes.onboarding);
}
