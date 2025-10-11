import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
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
    super.initState();
    _tabController = TabController(
      length: EvolutionCategory.values.length,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // УБИРАЕМ проблемную логику - TabController должен создаваться только один раз в initState
    // Эта проверка была источником проблемы
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        height: 114,
        isScrollable: false,
        title: t.trackers.trackersName.evolution,
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
        children: [
          const WeightView(),
          const GrowthView(),
          const CircleView(),
          const TablePage(),
        ],
      ),
    );
  }
}