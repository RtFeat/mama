import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skit/skit.dart';

import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';
import 'package:mama/src/feature/trackers/widgets/feeding/pumping_history_table.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/state/feeding/pumping_table_store.dart';
import 'package:mama/src/feature/trackers/widgets/pumping_graphic_widget.dart';
import 'package:mama/src/feature/trackers/widgets/inline_banner.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/state/health/temperature/info_store.dart';

class PumpingScreen extends StatefulWidget {
  const PumpingScreen({super.key});

  @override
  State<PumpingScreen> createState() => _PumpingScreenState();
}

class _PumpingScreenState extends State<PumpingScreen> {
  late final TemperatureInfoStore _infoStore;
  bool _showSavedBanner = false;
  int _reloadTick = 0;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<Dependencies>().sharedPreferences;
    _infoStore = TemperatureInfoStore(
      onLoad: () async => prefs.getBool('feed_pumping_info') ?? true,
      onSet: (v) async => prefs.setBool('feed_pumping_info', v),
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
      learnMoreWidgetText: t.trackers.findOutMoreTextPumping,
      onPressLearnMore: () {
        context.pushNamed(AppViews.serviceKnowlegde);
      },
      children: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              AutoHideInlineBanner(
                visible: _showSavedBanner,
                type: InlineBannerType.success,
                text: 'Кормление сохранено',
                onClosed: () => setState(() => _showSavedBanner = false),
              ),
              PumpingGraphicWidget(
                key: ValueKey(context.read<UserStore>().selectedChild?.id),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(child: 0.h),
        SliverToBoxAdapter(
          child: EditingButtons(
              addBtnText: t.feeding.addPumping,
              learnMoreTap: () {
                context.pushNamed(AppViews.serviceKnowlegde);
              },
              addButtonTap: () async {
                final res = await context.pushNamed(AppViews.addPumping);
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
            final childId = context.read<UserStore>().selectedChild!.id;
            return Provider(
              key: ValueKey(_reloadTick),
              create: (context) {
                final store = PumpingTableStore(
                  apiClient: deps.apiClient,
                  restClient: deps.restClient,
                  faker: deps.faker,
                  userStore: context.read<UserStore>(),
                );
                store.activate();
                return store;
              },
              child: const PumpingHistoryTableWidget(),
            );
          }),
        ),
        // Bottom spacing so the last story is not tight to the screen edge
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        // SliverToBoxAdapter(
        //   child: TableHistory(
        //     listOfData: listOfData,
        //     firstColumnName: t.feeding.endTimeOfPumping,
        //     secondColumnName: t.feeding.pumpingLeftSide,
        //     thirdColumnName: t.feeding.pumpingRightSide,
        //     fourthColumnName: t.feeding.totalMl,
        //     showTitle: true,
        //   ),
        // ),
      ],
    );
  }
}

class _PumpingHistory extends StatefulWidget {
  const _PumpingHistory();

  @override
  State<_PumpingHistory> createState() => _PumpingHistoryState();
}

class _PumpingHistoryState extends State<_PumpingHistory> {
  String sortOrder = 'new'; // 'new' or 'old'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 10,
      color: const Color(0xFF666E80),
    );
    final dateStyle = theme.textTheme.titleMedium?.copyWith(
      fontSize: 17,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    );
    // final smallHint = theme.textTheme.labelSmall?.copyWith(
    //   color: theme.colorScheme.onSurface.withOpacity(0.6),
    //   fontWeight: FontWeight.w400,
    // );
    final cellStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w400,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CustomToggleButton(
              alignment: Alignment.topLeft,
              items: [t.feeding.newS, t.feeding.old],
              onTap: (index) {
                setState(() {
                  sortOrder = index == 0 ? 'new' : 'old';
                });
              },
              btnWidth: 64,
              btnHeight: 26,
            ),
          ],
        ),
        8.h,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  t.feeding.endTimeOfPumping,
                  style: headerStyle,
                ),
              ),
              Expanded(child: Text('${t.feeding.l}, мл', style: headerStyle)),
              Expanded(child: Text('${t.feeding.r}, мл', style: headerStyle)),
              Expanded(child: Text('${t.feeding.totalMl}', style: headerStyle)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          itemCount: historyOfPumping.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final items = sortOrder == 'new'
                ? historyOfPumping
                : historyOfPumping.reversed.toList();
            final day = items[index];
            final dateLabel = day.firstColumnText;

            final rows = <Widget>[];
            for (var i = 0; i < day.detailColumnText.length; i++) {
              final d = day.detailColumnText[i];
              rows.add(Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                margin: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(d.detailFirstColumnText, style: cellStyle)),
                    Expanded(
                        child: Text(d.detailSecondColumnText, style: cellStyle)),
                    Expanded(
                        child: Text(d.detailThirdColumnText, style: cellStyle)),
                    Expanded(
                        child:
                            Text(d.detailFourthColumnText ?? '', style: cellStyle)),
                  ],
                ),
              ));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          dateLabel,
                          style: dateStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          day.secondColumnText,
                          textAlign: TextAlign.start,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          day.thirdColumnText,
                          textAlign: TextAlign.start,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          day.fourthColumnText ?? '',
                          textAlign: TextAlign.start,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...rows,
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                children: [
                  Text(
                    'Вся история',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(Icons.expand_more, color: theme.colorScheme.primary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
