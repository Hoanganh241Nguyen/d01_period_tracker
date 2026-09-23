import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/l10n.dart';
import '../../../widgets/app_background.dart';
import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AppBackground(
        assetPath: AppAssets.bgSplashOnboarding,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.language,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.languageTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.languageSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: Obx(() {
                    final selectedCode = controller.selectedCode.value;

                    return ListView.separated(
                      itemCount: controller.languages.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final language = controller.languages[index];
                        final selected = selectedCode == language.code;

                        return Card(
                          color: selected
                              ? colorScheme.primary.withValues(alpha: 0.16)
                              : colorScheme.surface.withValues(alpha: 0.84),
                          child: ListTile(
                            minVerticalPadding: 14,
                            leading: CircleAvatar(
                              backgroundColor: selected
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainerHighest,
                              foregroundColor: selected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                              child: Text(language.code.toUpperCase()),
                            ),
                            title: Text(language.nativeName),
                            subtitle: Text(language.name),
                            trailing: Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: selected ? colorScheme.primary : null,
                            ),
                            onTap: () =>
                                controller.selectLanguage(language.code),
                          ),
                        );
                      },
                    );
                  }),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: controller.continueToOnboarding,
                    child: Text(context.l10n.commonContinue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
