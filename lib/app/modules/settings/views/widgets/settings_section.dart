import 'package:flutter/material.dart';

const settingsInk = Color(0xFF2D2032);
const settingsMuted = Color(0xFF7A6877);

/// A top-level settings category: collapsed by default, expands in place to
/// reveal its own rows/controls when tapped.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
    this.initiallyExpanded = false,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          shape: const RoundedRectangleBorder(),
          collapsedShape: const RoundedRectangleBorder(),
          tilePadding: const EdgeInsets.fromLTRB(14, 6, 18, 6),
          childrenPadding: EdgeInsets.zero,
          iconColor: colorScheme.primary,
          collapsedIconColor: colorScheme.outline,
          leading: SizedBox(width: 36, height: 36, child: Center(child: icon)),
          title: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: settingsMuted),
          ),
          children: children,
        ),
      ),
    );
  }
}

/// One row inside an expanded [SettingsSection] that opens something on tap
/// (a sheet, a dialog, another screen) and shows the current value.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.destructive = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final bool destructive;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = destructive ? colorScheme.error : settingsInk;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.fromLTRB(18, 2, 14, 2),
      minVerticalPadding: 12,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: settingsMuted),
            ),
      trailing:
          trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null) ...[
                Text(
                  value!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              if (onTap != null)
                Icon(Icons.chevron_right_rounded, color: colorScheme.outline),
            ],
          ),
    );
  }
}

/// A row with a trailing on/off switch.
class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      title: title,
      subtitle: subtitle,
      onTap: () => onChanged(!value),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

/// A row of small pill choices (e.g. theme mode, language) with one selected.
class SettingsChoiceRow extends StatelessWidget {
  const SettingsChoiceRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
      child: Wrap(spacing: 8, runSpacing: 8, children: children),
    );
  }
}

class SettingsChoiceChip extends StatelessWidget {
  const SettingsChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? colorScheme.primary
          : colorScheme.primaryContainer.withValues(alpha: 0.4),
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? colorScheme.onPrimary : colorScheme.primary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? colorScheme.onPrimary : settingsInk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 18,
      endIndent: 18,
      color: settingsInk.withValues(alpha: 0.08),
    );
  }
}
