import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../utils/l10n.dart';

/// Shown wherever cycle data is needed but no period has been logged yet.
class NoCycleDataCard extends StatelessWidget {
  const NoCycleDataCard({super.key, this.message});

  /// Overrides the default explanation.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.primary,
              child: const Icon(Icons.water_drop_outlined, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.emptyCycleTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              message ?? l10n.emptyCycleMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Get.toNamed<void>(Routes.logPeriod),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.emptyCycleAction),
            ),
          ],
        ),
      ),
    );
  }
}
