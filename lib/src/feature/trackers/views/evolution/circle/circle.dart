import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/evolution_category.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

export 'add_circle.dart';

class CircleView extends StatelessWidget {
  const CircleView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<CircleStore>();
      final tableStore = context.read<CircleTableStore>();
      store.getIsShowInfo().then((v) {
        setState(() {});
      });
      store.fetchCircleDetails();

      tableStore.loadPage(newFilters: [
        SkitFilter(
            field: 'child_id',
            operator: FilterOperator.equals,
            value: store.childId),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final trackerType = EvolutionCategory.head;
    final store = context.watch<CircleStore>();
    final tableStore = context.watch<CircleTableStore>();

    return Observer(builder: (context) {
      return TrackerBody(
        isShowInfo: store.isShowInfo,
        setIsShowInfo: (v) {
          store.setIsShowInfo(v).then((v) {
            setState(() {});
          });
        },
        learnMoreWidgetText: t.trackers.findOutMoreTextHead,
        onPressLearnMore: () {},
        children: [
          SliverToBoxAdapter(child: 10.h),

          /// Current and Dynamic Container
          SliverToBoxAdapter(
            child: CurrentAndDymanicContainer(
              trackerType: EvolutionCategory.growth,
              current: store.current,
              dynamic: store.dynamicValue,
            ),
          ),

          /// Grafic
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16, top: 0),
              child: SizedBox(
                height: 278,
                child: Observer(builder: (context) {
                  return FlProgressChart(
                    min: store.minValue,
                    max: store.maxValue,
                    chartData: store.chartData,
                  );
                }),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: EditingButtons(
                addBtnText: trackerType.addButtonTitle,
                learnMoreTap: () {},
                addButtonTap: () {
                  context.pushNamed(AppViews.addHeadView, extra: {
                    'store': store,
                  });
                }),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          /// Stories
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SwitchContainer(
                  title1: t.trackers.news.title,
                  title2: t.trackers.old.title,
                  onSelected: (index) {
                    tableStore.setSortOrder(index);
                    setState(() {});
                  },
                  // isTrue: false,
                ),
                trackerType.title == EvolutionCategory.head.title
                    ? const SizedBox()
                    : SwitchContainer(
                        title1: trackerType.switchContainerTitle1,
                        title2: trackerType.switchContainerTitle2,
                        onSelected: (index) {
                          tableStore.setCircleUnit(
                              index == 0 ? CircleUnit.cm : CircleUnit.m);
                          setState(() {});
                        },
                      ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          if (tableStore.listData.isNotEmpty)
            SliverToBoxAdapter(
              child: SkitTableWidget(store: tableStore),
            ),

          // SliverToBoxAdapter(
          //   child: Column(
          //     children: List.generate(
          //       5,
          //       (index) {
          //         return RowStroriesData(
          //           data: '01 сентября',
          //           week: '17',
          //           weight: trackerType.storiesValue,
          //           style: AppTextStyles.f17w400,
          //         );
          //       },
          //     ),
          //   ),
          // ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
        ],
      );
    });
  }
}
