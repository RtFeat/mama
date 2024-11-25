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
        height: 120,
        title: t.trackers.evolution,
        tabController: _tabController,
        action: const ProfileWidget(),
        tabs: EvolutionCategory.values.map((e) => e.title).toList(),
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
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// To Know More Contaner
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ToKnowMoreContainer(
                title1: trackerType.knowMoreTitle,
                title2: trackerType.knowMoreTitle,
              ),
            ),

            /// Current and Dynamic Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CurrentAndDymanicContainer(
                trackerType: trackerType,
              ),
            ),

            /// KG Or gramm Container
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 5,
                top: 16,
              ),
              child: Row(
                children: [
                  SwitchContainer(
                    title1: t.trackers.kg.title,
                    title2: t.trackers.g.title,
                  ),
                ],
              ),
            ),

            /// Grafic
            const Padding(
              padding: EdgeInsets.only(bottom: 16, top: 0),
              child: SizedBox(
                height: 278,
                child: FlProgressChart(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  KnowMoreButton(
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  AddButton(
                    title: trackerType.addButtonTitle,
                    onTap: () {
                      context.pushNamed(trackerType.route);
                    },
                  ),
                ],
              ),
            ),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
                          title1: t.trackers.kg.title,
                          title2: t.trackers.g.title,
                        ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RowStroriesData(
                data: t.trackers.date.title,
                week: t.trackers.weeks.title,
                growth: trackerType.storiesValueTitle,
                style: AppTextStyles.f10w700.copyWith(
                  color: AppColors.greyBrighterColor,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Column(
              children: List.generate(
                5,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RowStroriesData(
                      data: '01 сентября',
                      week: '17',
                      weight: trackerType.storiesValue,
                      style: AppTextStyles.f17w400,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
