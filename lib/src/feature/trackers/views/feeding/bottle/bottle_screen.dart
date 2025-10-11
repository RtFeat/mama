import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/feature/trackers/widgets/dialog_overlay.dart';
import 'package:skit/skit.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/api/models/feed_response_history_food.dart';
import 'package:mama/src/core/api/models/entity_food_history.dart';

import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/feeding/bottle_graphic_widget.dart';
import 'package:mama/src/feature/trackers/state/health/temperature/info_store.dart';
import 'package:mama/src/feature/trackers/widgets/inline_banner.dart';
import 'package:mama/src/feature/trackers/widgets/feeding/bottle_history_table.dart';
import 'package:mama/src/feature/trackers/state/feeding/bottle_table_store.dart';

class BottleScreen extends StatefulWidget {
  const BottleScreen({super.key});

  @override
  State<BottleScreen> createState() => _BottleScreenState();
}

class _BottleScreenState extends State<BottleScreen> {
  late final TemperatureInfoStore _infoStore;
  bool _showSavedBanner = false;
  int _reloadTick = 0;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<Dependencies>().sharedPreferences;
    _infoStore = TemperatureInfoStore(
      onLoad: () async => prefs.getBool('feed_bottle_info') ?? true,
      onSet: (v) async => prefs.setBool('feed_bottle_info', v),
    );
    _infoStore.getIsShowInfo().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return TrackerBody(
      isShowInfo: _infoStore.isShowInfo,
      setIsShowInfo: (v) {
        _infoStore.setIsShowInfo(v).then((_) => setState(() {}));
      },
      learnMoreWidgetText: t.trackers.findOutMoreTextBottle,
      onPressLearnMore: () {
        context.pushNamed(AppViews.serviceKnowlegde);
      },
      children: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              AutoHideInlineBanner(
                visible: _showSavedBanner,
                text: 'Кормление сохранено',
                type: InlineBannerType.success,
                onClosed: () => setState(() => _showSavedBanner = false),
              ),
              // Rebuild chart after returning from Add Bottle using _reloadTick key
              BottleGraphicWidget(key: ValueKey(_reloadTick)),
            ],
          ),
        ),
        SliverToBoxAdapter(child: 10.h),
        SliverToBoxAdapter(
          child: EditingButtons(
              addBtnText: t.feeding.addFeeding,
              learnMoreTap: () {
                context.pushNamed(AppViews.serviceKnowlegde);
              },
              addButtonTap: () async {
                final res = await context.pushNamed(AppViews.addBottle);
                if (res == true && mounted) {
                  setState(() {
                    _showSavedBanner = true;
                    _reloadTick++;
                  });
                }
              }),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Center(
            child: Text(
              t.trackers.stories.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: Builder(builder: (context) {
            final deps = context.read<Dependencies>();
            final childId = context.read<UserStore>().selectedChild?.id;
            return Provider(
              key: ValueKey(_reloadTick),
              create: (context) => BottleTableStore(
                apiClient: deps.apiClient,
                restClient: deps.restClient,
                faker: deps.faker,
              )..loadPage(newFilters: [
                  SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                ]),
              child: BottleHistoryTableWidgetWrapper(
                showSavedBanner: (show) {
                  if (show) {
                    setState(() {
                      _showSavedBanner = true;
                    });
                  }
                },
              ),
            );
          }),
        ),
        // SliverToBoxAdapter(
        //   child: TableHistory(
        //     listOfData: listOfData,
        //     firstColumnName: t.feeding.feedingEndTime,
        //     secondColumnName: t.feeding.breastMl,
        //     thirdColumnName: t.feeding.bottleMl,
        //     fourthColumnName: t.feeding.totalMl,
        //     showTitle: true,
        //   ),
        // ),
      ],
    );
  }
}

