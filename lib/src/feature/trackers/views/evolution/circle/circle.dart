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
      if (!mounted) return;
      final store = context.read<CircleStore>();
      final tableStore = context.read<CircleTableStore>();
      store.getIsShowInfo().then((v) {
        if (mounted) {
          setState(() {});
        }
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
      if (!mounted) return const SizedBox.shrink();
      return TrackerBody(
        isShowInfo: store.isShowInfo,
        setIsShowInfo: (v) {
          store.setIsShowInfo(v).then((v) {
            if (mounted) {
              setState(() {});
            }
          });
        },
        learnMoreWidgetText: t.trackers.findOutMoreTextHead,
        onPressLearnMore: () {
          context.pushNamed(AppViews.serviceKnowlegde);
        },
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
                  if (!mounted) return const SizedBox.shrink();
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
                learnMoreTap: () {
                  context.pushNamed(AppViews.serviceKnowlegde);
                },
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
                    if (mounted) {
                      setState(() {});
                    }
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
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          if (tableStore.listData.isNotEmpty)
            SliverToBoxAdapter(
              child: _CircleTableWithShowAll(store: tableStore),
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

class _CircleTableWithShowAll extends StatelessWidget {
  final CircleTableStore store;
  
  const _CircleTableWithShowAll({required this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Observer(builder: (context) {
          return SkitTableWidget(store: store);
        }),
        Observer(builder: (context) {
          if (store.canShowAll || store.canCollapse) {
            return Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      store.toggleShowAll();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Column(
                        children: [
                          Text(
                            store.showAll ? 'Свернуть историю' : 'Вся история',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(
                            store.showAll ? Icons.expand_less : Icons.expand_more, 
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
