import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/cycle_service.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/l10n.dart';
import '../../../widgets/app_svg_icon.dart';
import '../../settings/views/settings_tab.dart';
import '../controllers/home_controller.dart';
import 'widgets/calendar_tab.dart';
import 'widgets/home_sheets.dart';
import 'widgets/home_tab.dart';
import 'widgets/insight_tab.dart';
import 'widgets/nav_icon.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Obx(() {
      final today = CycleService.to.today.value;
      final todayLabel = l10n.homeTodayWithWeekdayDate(
        l10n.weekdayLong(today.weekday),
        l10n.dayMonth(today),
      );
      return Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: controller.selectedTab.value,
          children: [
            HomeTab(todayLabel: todayLabel),
            const CalendarTab(),
            const InsightTab(),
            const SettingsTab(),
          ],
        ),
        floatingActionButton: controller.selectedTab.value == 0
            ? FloatingActionButton(
                tooltip: l10n.homeLogTodayTooltip,
                onPressed: () => showDailyLogSheet(context),
                child: const AppSvgIcon(AppAssets.homeAdd),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedTab.value,
          onDestinationSelected: controller.selectTab,
          destinations: [
            NavigationDestination(
              icon: const NavIcon(assetPath: AppAssets.navHome),
              selectedIcon: const NavIcon(
                assetPath: AppAssets.navHome,
                selected: true,
              ),
              label: l10n.homeTabHome,
            ),
            NavigationDestination(
              icon: const NavIcon(assetPath: AppAssets.navCalendar),
              selectedIcon: const NavIcon(
                assetPath: AppAssets.navCalendar,
                selected: true,
              ),
              label: l10n.homeTabCalendar,
            ),
            NavigationDestination(
              icon: const NavIcon(assetPath: AppAssets.navStats),
              selectedIcon: const NavIcon(
                assetPath: AppAssets.navStats,
                selected: true,
              ),
              label: l10n.homeTabInsights,
            ),
            NavigationDestination(
              icon: const NavIcon(assetPath: AppAssets.navSettings),
              selectedIcon: const NavIcon(
                assetPath: AppAssets.navSettings,
                selected: true,
              ),
              label: l10n.homeTabSettings,
            ),
          ],
        ),
      );
    });
  }
}
