import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class TrackersHealthView extends StatefulWidget {
  const TrackersHealthView({super.key});

  @override
  State<TrackersHealthView> createState() => _TrackersHealthViewState();
}

class _TrackersHealthViewState extends State<TrackersHealthView>
    with SingleTickerProviderStateMixin {
  // controllers
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initAllController();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeAllController();
  }

  // funtions
  void _initAllController() {
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,
    );
  }

  void _disposeAllController() {
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // tabs
    final tabs = [
      t.trackers.temperature.title,
      t.trackers.medicines.title,
      t.trackers.doctorsAppointment.title,
      t.trackers.vaccinations.title,
    ];

    return Scaffold(
      backgroundColor: AppColors.e8ddf9,
      appBar: CustomAppBar(
        height: 114,
        title: t.trackers.health.title,
        tabs: tabs,
        action: const ProfileWidget(),
        padding: const EdgeInsets.only(right: 8),
        tabController: _tabController,
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: AppColors.trackerColor, fontSize: 20),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: TemperatureView()),
          Center(child: DrugsView()),
          Center(child: DoctorVisitScreen()),
          Center(child: VaccinesScreen()),
        ],
      ),
    );
  }
}
