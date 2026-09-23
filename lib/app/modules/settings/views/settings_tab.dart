import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/cycle_service.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/l10n.dart';
import '../../../widgets/app_background.dart';
import '../../../widgets/app_svg_icon.dart';
import '../../../widgets/length_setting_sheet.dart';
import '../controllers/settings_controller.dart';
import 'widgets/settings_section.dart';

/// Full settings screen: each top-level item expands in place to reveal its
/// own controls, all backed by real, persisted state (see
/// [SettingsController]) except reminders, which only save a preference —
/// no notification is actually scheduled yet.
class SettingsTab extends GetView<SettingsController> {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppBackground(
      assetPath: AppAssets.bgSettingsPrivacyNotifications,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 100),
          children: [
            Text(
              l10n.settingsTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: settingsInk,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.settingsSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: settingsMuted),
            ),
            const SizedBox(height: 18),
            _CycleSection(),
            _ThemeSection(),
            _LanguageSection(),
            _ReminderSection(),
            _PrivacySection(),
            _PremiumSection(),
            _HelpSection(),
          ],
        ),
      ),
    );
  }
}

class _CycleSection extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Obx(() {
      final cycle = CycleService.to;
      return SettingsSection(
        icon: const AppSvgIcon(AppAssets.settingsCycle),
        title: l10n.settingsCycleSectionTitle,
        subtitle: l10n.settingsCycleSectionPreview(
          cycle.cycleLength.value,
          cycle.periodLength.value,
        ),
        children: [
          SettingsRow(
            title: l10n.settingsCycleLengthTitle,
            subtitle: l10n.settingsCycleLengthSubtitle,
            value: l10n.commonDays(cycle.cycleLength.value),
            onTap: () => showCycleLengthSheet(context),
          ),
          const SettingsDivider(),
          SettingsRow(
            title: l10n.settingsPeriodLengthTitle,
            subtitle: l10n.settingsPeriodLengthSubtitle,
            value: l10n.commonDays(cycle.periodLength.value),
            onTap: () => showPeriodLengthSheet(context),
          ),
          const SizedBox(height: 4),
        ],
      );
    });
  }
}

class _ThemeSection extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String label(ThemeMode mode) => switch (mode) {
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.dark => l10n.settingsThemeDark,
      ThemeMode.system => l10n.settingsThemeSystem,
    };
    IconData icon(ThemeMode mode) => switch (mode) {
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
      ThemeMode.system => Icons.brightness_auto_rounded,
    };

    return Obx(
      () => SettingsSection(
        icon: const AppSvgIcon(AppAssets.settingsTheme),
        title: l10n.settingsThemeSectionTitle,
        subtitle: label(controller.themeMode.value),
        children: [
          SettingsChoiceRow(
            children: [
              for (final mode in ThemeMode.values)
                SettingsChoiceChip(
                  label: label(mode),
                  icon: icon(mode),
                  selected: controller.themeMode.value == mode,
                  onTap: () => controller.setThemeMode(mode),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageSection extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Obx(
      () => SettingsSection(
        icon: const Icon(Icons.language_rounded, color: settingsInk),
        title: l10n.settingsLanguageSectionTitle,
        subtitle: controller.languages
            .firstWhere((o) => o.code == controller.languageCode.value)
            .nativeName,
        children: [
          SettingsChoiceRow(
            children: [
              for (final option in controller.languages)
                SettingsChoiceChip(
                  label: option.nativeName,
                  selected: controller.languageCode.value == option.code,
                  onTap: () => controller.setLanguage(option.code),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReminderSection extends GetView<SettingsController> {
  Future<void> _pickDaysBefore(BuildContext context) async {
    final l10n = context.l10n;
    final chosen = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsReminderDaysBeforeSheetTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final days in reminderDaysBeforeOptions)
                    Obx(
                      () => SettingsChoiceChip(
                        label: l10n.commonDays(days),
                        selected:
                            controller.reminderPeriodDaysBefore.value == days,
                        onTap: () => Navigator.of(context).pop(days),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (chosen != null) await controller.setReminderPeriodDaysBefore(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Obx(() {
      final onCount = [
        controller.reminderDailyLog.value,
        controller.reminderPeriod.value,
        controller.reminderOvulation.value,
      ].where((v) => v).length;

      return SettingsSection(
        icon: const AppSvgIcon(AppAssets.settingsNotification),
        title: l10n.settingsReminderSectionTitle,
        subtitle: onCount == 0
            ? l10n.settingsReminderSectionPreviewOff
            : l10n.settingsReminderSectionPreviewOn(onCount),
        children: [
          SettingsSwitchRow(
            title: l10n.settingsReminderDailyLogTitle,
            subtitle: l10n.settingsReminderDailyLogSubtitle,
            value: controller.reminderDailyLog.value,
            onChanged: controller.setReminderDailyLog,
          ),
          const SettingsDivider(),
          SettingsSwitchRow(
            title: l10n.settingsReminderPeriodTitle,
            subtitle: l10n.settingsReminderPeriodSubtitle(
              controller.reminderPeriodDaysBefore.value,
            ),
            value: controller.reminderPeriod.value,
            onChanged: controller.setReminderPeriod,
          ),
          if (controller.reminderPeriod.value)
            SettingsRow(
              title: l10n.settingsReminderDaysBeforeSheetTitle,
              value: l10n.commonDays(controller.reminderPeriodDaysBefore.value),
              onTap: () => _pickDaysBefore(context),
            ),
          const SettingsDivider(),
          SettingsSwitchRow(
            title: l10n.settingsReminderOvulationTitle,
            subtitle: l10n.settingsReminderOvulationSubtitle,
            value: controller.reminderOvulation.value,
            onChanged: controller.setReminderOvulation,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 15,
                  color: settingsMuted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.settingsReminderNote,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: settingsMuted,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _PrivacySection extends GetView<SettingsController> {
  Future<void> _confirmClear(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsClearDataConfirmTitle),
        content: Text(l10n.settingsClearDataConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.settingsClearDataConfirmAction,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await controller.clearAllData();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.settingsClearDataDone)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Obx(() {
      // Re-evaluate whenever periodDays/dailyLogs change.
      CycleService.to.periodDays.length;
      CycleService.to.dailyLogs.length;
      final (periods, loggedDays) = controller.dataSummary;

      return SettingsSection(
        icon: const AppSvgIcon(AppAssets.settingsPrivacyData),
        title: l10n.settingsPrivacySectionTitle,
        subtitle: l10n.settingsPrivacySectionPreview(periods, loggedDays),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 10),
            child: Text(
              l10n.settingsDataLocalNote,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: settingsMuted,
                height: 1.4,
              ),
            ),
          ),
          SettingsRow(
            title: l10n.settingsClearDataTitle,
            subtitle: l10n.settingsClearDataSubtitle,
            destructive: true,
            onTap: () => _confirmClear(context),
          ),
          const SizedBox(height: 4),
        ],
      );
    });
  }
}

class _PremiumSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingsSection(
      icon: const AppSvgIcon(AppAssets.settingsPremium),
      title: l10n.settingsPremiumSectionTitle,
      subtitle: l10n.settingsPremiumSectionPreview,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
          child: Text(
            l10n.settingsPremiumBody,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: settingsMuted, height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _HelpSection extends StatelessWidget {
  void _showFaq(BuildContext context) {
    final l10n = context.l10n;
    final qa = [
      (l10n.settingsFaqQ1, l10n.settingsFaqA1),
      (l10n.settingsFaqQ2, l10n.settingsFaqA2),
      (l10n.settingsFaqQ3, l10n.settingsFaqA3),
      (l10n.settingsFaqQ4, l10n.settingsFaqA4),
    ];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Text(
              l10n.settingsFaqTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            for (final (q, a) in qa)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: settingsMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDisclaimer(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsMedicalDisclaimerTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.cycleHistoryDisclaimer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: settingsMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingsSection(
      icon: const AppSvgIcon(AppAssets.settingsHelp),
      title: l10n.settingsHelpSectionTitle,
      subtitle: l10n.settingsHelpSectionPreview,
      children: [
        SettingsRow(
          title: l10n.settingsFaqTitle,
          onTap: () => _showFaq(context),
        ),
        const SettingsDivider(),
        SettingsRow(
          title: l10n.settingsMedicalDisclaimerTitle,
          onTap: () => _showDisclaimer(context),
        ),
        const SettingsDivider(),
        SettingsRow(title: l10n.settingsAppVersionTitle, value: '1.0.0'),
        const SizedBox(height: 4),
      ],
    );
  }
}
