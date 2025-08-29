import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/evolution_category.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

export 'add_weight.dart';

class WeightView extends StatelessWidget {
  const WeightView({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = context.read<UserStore>();
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => WeightDataSourceLocal(
            sharedPreferences: context.read<Dependencies>().sharedPreferences,
          ),
        ),
        Provider(create: (context) {
          return WeightTableStore(
            apiClient: context.read<Dependencies>().apiClient,
            faker: context.read<Dependencies>().faker,
          );
        }),
        Provider(
          create: (context) => WeightStore(
            apiClient: context.read<Dependencies>().apiClient,
            restClient: context.read<Dependencies>().restClient,
            faker: context.read<Dependencies>().faker,
            childId: userStore.selectedChild?.id ?? '',
            onLoad: () => context.read<WeightDataSourceLocal>().getIsShow(),
            onSet: (value) =>
                context.read<WeightDataSourceLocal>().setShow(value),
          ),
        ),
      ],
      child: const _Body(),
    );
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
      final store = context.read<WeightStore>();
      final tableStore = context.read<WeightTableStore>();

      store.fetchWeightDetails();
      store.getIsShowInfo().then((v) {
        setState(() {});
      });
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
    final trackerType = EvolutionCategory.weight;
    final store = context.watch<WeightStore>();
    final tableStore = context.watch<WeightTableStore>();

    return Observer(builder: (context) {
      return TrackerBody(
        isShowInfo: store.isShowInfo,
        setIsShowInfo: (v) {
          store.setIsShowInfo(v).then((v) {
            setState(() {});
          });
        },
        learnMoreWidgetText: t.trackers.findOutMoreTextWeight,
        onPressLearnMore: () {},
        children: [
          SliverToBoxAdapter(child: 10.h),

          /// Current and Dynamic Container
          SliverToBoxAdapter(
            child: CurrentAndDymanicContainer(
              trackerType: EvolutionCategory.weight,
              current: store.current,
              dynamic: store.dynamicValue,
            ),
          ),

          /// KG Or gramm Container
          SliverToBoxAdapter(
            child: trackerType == EvolutionCategory.weight ||
                    trackerType == EvolutionCategory.growth
                ? Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      top: 16,
                    ),
                    child: Row(
                      children: [
                        SwitchContainer(
                          title1: trackerType.switchContainerTitle1,
                          title2: trackerType.switchContainerTitle2,
                          onSelected: (index) {
                            store.switchWeightUnit(
                                index == 0 ? WeightUnit.kg : WeightUnit.g);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
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
                  context.pushNamed(AppViews.addWeightView, extra: {
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
                  onSelected: (index) {},
                  // isTrue: false,
                ),
                trackerType.title == EvolutionCategory.head.title
                    ? const SizedBox()
                    : SwitchContainer(
                        title1: trackerType.switchContainerTitle1,
                        title2: trackerType.switchContainerTitle2,
                        onSelected: (index) {},
                      ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

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
