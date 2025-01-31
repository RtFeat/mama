import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/views/evolution/table_view.dart';
import 'package:mama/src/feature/trackers/widgets/evolution_category.dart';

class EvolutionView extends StatefulWidget {
  const EvolutionView({super.key});

  @override
  State<EvolutionView> createState() => _EvolutionViewState();
}

class _EvolutionViewState extends State<EvolutionView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EvolutionCategory evolutionCategory = EvolutionCategory.weight;

  @override
  void initState() {
    _tabController = TabController(
      length: EvolutionCategory.values.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        height: 110,
        isScrollable: false,
        title: t.trackers.evolution,
        tabController: _tabController,
        action: const ProfileWidget(),
        padding: const EdgeInsets.only(right: 8),
        tabs: EvolutionCategory.values.map((e) => e.title).toList(),
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: AppColors.trackerColor, fontSize: 20),
      ),
      body: TabBarView(
        controller: _tabController,
        children: EvolutionCategory.values.map((trackerType) {
          if (trackerType == EvolutionCategory.table) {
            return TablePage(trackerType: trackerType);
          }
          return WeightT(trackerType: trackerType);
        }).toList(),
      ),
    );
  }
}

class WeightT extends StatelessWidget {
  const WeightT({super.key, required this.trackerType});
  final EvolutionCategory trackerType;

  @override
  Widget build(BuildContext context) {
    return TrackerBody(
      learnMoreWidgetText: trackerType.knowMoreTitle,
      children: [
        10.h,

        /// Current and Dynamic Container
        CurrentAndDymanicContainer(
          trackerType: trackerType,
        ),

        /// KG Or gramm Container
        trackerType == EvolutionCategory.weight ||
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
                    ),
                  ],
                ),
              )
            : const SizedBox(),

        /// Grafic
        const Padding(
          padding: EdgeInsets.only(bottom: 16, top: 0),
          child: SizedBox(
            height: 278,
            child: FlProgressChart(),
          ),
        ),

        EditingButtons(
            addBtnText: trackerType.addButtonTitle,
            learnMoreTap: () {},
            addButtonTap: () {
              context.pushNamed(trackerType.route);
            }),
        const SizedBox(height: 16),

        /// Stories
        Center(
          child: Text(
            t.trackers.stories.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SwitchContainer(
              title1: t.trackers.news.title,
              title2: t.trackers.old.title,
              // isTrue: false,
            ),
            trackerType.title == EvolutionCategory.head.title
                ? const SizedBox()
                : SwitchContainer(
                    title1: trackerType.switchContainerTitle1,
                    title2: trackerType.switchContainerTitle2,
                  ),
          ],
        ),
        const SizedBox(height: 16),
        RowStroriesData(
          data: t.trackers.date.title,
          week: t.trackers.weeks.title,
          growth: trackerType.storiesValueTitle,
          style: AppTextStyles.f10w700.copyWith(
            color: AppColors.greyBrighterColor,
          ),
        ),
        const SizedBox(height: 8),

        Column(
          children: List.generate(
            5,
            (index) {
              return RowStroriesData(
                data: '01 сентября',
                week: '17',
                weight: trackerType.storiesValue,
                style: AppTextStyles.f17w400,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
