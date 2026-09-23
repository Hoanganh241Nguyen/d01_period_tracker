import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app/data/providers/local_storage_provider.dart';
import 'app/modules/settings/controllers/settings_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/cycle_service.dart';
import 'app/utils/l10n.dart';
import 'app/utils/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(await LocalStorageProvider.create(), permanent: true);
  await Get.putAsync(() => CycleService().init(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX registers getPages only once, when GetMaterialApp first starts, so
    // pages added during a hot reload would be missing. Re-sync them in debug.
    assert(() {
      Get.clearRouteTree();
      Get.addPages(AppPages.routes);
      return true;
    }());

    return GetMaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      locale: AppLocales.resolve(LocalStorageProvider.to.languageCode),
      fallbackLocale: AppLocales.fallback,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: SettingsController.parseThemeMode(
        LocalStorageProvider.to.themeMode,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
