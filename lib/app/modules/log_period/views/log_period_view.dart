import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/cycle_service.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/l10n.dart';
import '../../../widgets/length_setting_sheet.dart';
import '../controllers/log_period_controller.dart';
import '../period_log_editor.dart';
import 'widgets/period_month.dart';

class LogPeriodView extends GetView<LogPeriodController> {
  const LogPeriodView({super.key});

  static const _bg = Color(0xFFFFF4F7);

  Future<void> _confirmDiscard(BuildContext context) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.logPeriodDiscardTitle),
        content: Text(context.l10n.logPeriodDiscardMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.logPeriodKeepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.logPeriodDiscard),
          ),
        ],
      ),
    );
    if (discard ?? false) Get.back<void>();
  }

  /// Explains the last tap, or null when there is nothing worth saying.
  static String? _hintFor(AppLocalizations l10n, PeriodTapResult? result) {
    if (result == null) return null;
    final filled = result.autoFilledCount;
    final main = switch (result.outcome) {
      PeriodTapOutcome.startedWithFill when filled > 0 =>
        l10n.logPeriodHintAutoFilled(filled),
      PeriodTapOutcome.startedUntilToday when filled > 0 =>
        l10n.logPeriodHintAutoFilledUntilToday(filled),
      PeriodTapOutcome.startedUntilToday => l10n.logPeriodHintUntilToday,
      PeriodTapOutcome.midCycle when result.cycleDay > 0 =>
        l10n.logPeriodHintMidCycle(
          result.cycleDay,
          result.cycleLength + 1,
          result.cycleLength,
        ),
      PeriodTapOutcome.newCycleByLength => l10n.logPeriodHintNewCycleAt(
        l10n.dayMonth(result.newCycleStart!),
        result.cycleLength,
      ),
      PeriodTapOutcome.merged when filled > 0 =>
        l10n.logPeriodHintMergedWithFill(filled),
      PeriodTapOutcome.merged => l10n.logPeriodHintMerged,
      PeriodTapOutcome.extended when filled > 0 => l10n.logPeriodHintGapFilled(
        filled,
      ),
      PeriodTapOutcome.removedWithFill => l10n.logPeriodHintRemoved(
        result.count,
      ),
      _ => null,
    };
    final absorbed = result.absorbedStarts;
    final note = absorbed.isEmpty
        ? null
        : absorbed.length == 1
        ? l10n.logPeriodHintAbsorbed(l10n.dayMonth(absorbed.single))
        : l10n.logPeriodHintAbsorbedMultiple(absorbed.length);
    return [?main, ?note].join(' ').ifEmptyNull;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: !controller.isDirty,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _confirmDiscard(context);
        },
        child: Scaffold(
          backgroundColor: _bg,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 220,
                child: Image.asset(
                  AppAssets.bgPeriodLogEdit,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _bg.withValues(alpha: 0.3),
                        _bg.withValues(alpha: 0.94),
                        _bg,
                      ],
                      stops: const [0, 0.22, 0.4],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _Header(onBack: () => Navigator.of(context).maybePop()),
                    const _WeekdayRow(),
                    const Expanded(child: _MonthList()),
                    _BottomBar(
                      enabled: controller.isDirty && !controller.isSaving.value,
                      hint: _hintFor(context.l10n, controller.hint.value),
                      onSave: controller.save,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            tooltip: context.l10n.commonBack,
            onPressed: onBack,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
            ),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.logPeriodTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2D2032),
                  ),
                ),
                Text(
                  context.l10n.logPeriodSubtitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF7A6877),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => ActionChip(
              avatar: const Icon(Icons.tune_rounded, size: 16),
              label: Text(
                context.l10n.logPeriodCycleLengthChip(
                  CycleService.to.cycleLength.value,
                ),
              ),
              onPressed: () => showCycleLengthSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    final labels = context.l10n.weekdaysShort;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF2D2032).withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  // Sunday is the last column (Monday-first).
                  color: i == DateTime.sunday - 1
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFF7A6877),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MonthList extends StatefulWidget {
  const _MonthList();

  @override
  State<_MonthList> createState() => _MonthListState();
}

class _MonthListState extends State<_MonthList> {
  final controller = Get.find<LogPeriodController>();
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    // Month heights are fixed, so the offset of the current month can be
    // computed up front. Leave two rows of the previous month visible as a
    // hint that history is above.
    final today = controller.today;
    var offset = 0.0;
    for (final month in controller.months) {
      if (month.year == today.year && month.month == today.month) break;
      offset += PeriodMonthSliver.heightOf(month);
    }
    _scroll = ScrollController(
      initialScrollOffset: (offset - PeriodMonthSliver.rowHeight * 2).clamp(
        0.0,
        double.infinity,
      ),
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final today = controller.today;
      final marks = controller.marks;

      return CustomScrollView(
        controller: _scroll,
        slivers: [
          for (final month in controller.months)
            PeriodMonthSliver(
              month: month,
              today: today,
              marks: marks,
              onTap: controller.toggle,
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      );
    });
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.enabled,
    required this.hint,
    required this.onSave,
  });

  final bool enabled;
  final String? hint;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: hint == null
                ? const SizedBox(width: double.infinity)
                : Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hint!,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: const Color(0xFF2D2032),
                                  height: 1.3,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 6,
            children: [
              PeriodLegend(
                type: PeriodLegendType.logged,
                label: context.l10n.logPeriodLegendLogged,
              ),
              PeriodLegend(
                type: PeriodLegendType.autoFilled,
                label: context.l10n.logPeriodLegendAutoFilled,
              ),
              PeriodLegend(
                type: PeriodLegendType.midCycle,
                label: context.l10n.logPeriodLegendMidCycle,
              ),
              PeriodLegend(
                type: PeriodLegendType.predicted,
                label: context.l10n.logPeriodLegendPredicted,
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: enabled ? onSave : null,
              style: FilledButton.styleFrom(shape: const StadiumBorder()),
              child: Text(
                context.l10n.commonSave,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on String {
  String? get ifEmptyNull => isEmpty ? null : this;
}
