import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/app_assets.dart';
import '../../controllers/home_controller.dart';
import 'cycle_hero.dart';
import 'home_action_buttons.dart';
import 'home_app_bar.dart';
import 'status_cards.dart';
import 'tip_card.dart';

class HomeTab extends GetView<HomeController> {
  const HomeTab({super.key, required this.todayLabel});

  final String todayLabel;

  @override
  Widget build(BuildContext context) {
    const homeBackground = Color(0xFFFFEEF4);

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: homeBackground),
        SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        AppAssets.bgHome,
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
                              homeBackground.withValues(alpha: 0.06),
                              homeBackground.withValues(alpha: 0.28),
                              homeBackground,
                            ],
                            stops: const [0.0, 0.64, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                      child: Column(
                        children: [
                          HomeAppBar(
                            todayLabel: todayLabel,
                            onCalendarPressed: () => controller.selectTab(1),
                          ),
                          const SizedBox(height: 6),
                          const CycleHero(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverList.list(
                  children: const [
                    StatusCards(),
                    SizedBox(height: 12),
                    HomeActionButtons(),
                    SizedBox(height: 12),
                    TipCard(),
                    SizedBox(height: 96),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
