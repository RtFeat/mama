import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/data.dart';

class SleepingScreen extends StatefulWidget {
  const SleepingScreen({super.key});

  @override
  State<SleepingScreen> createState() => _SleepingScreenState();
}

class _SleepingScreenState extends State<SleepingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      backgroundColor: AppColors.pirpleSleeping,
      appBar: CustomAppBar(
        isScrollable: false,
        padding: const EdgeInsets.only(right: 8),
        height: 114,
        tabController: _tabController,
        title: t.sleep.title,
        titleTextStyle: textTheme.headlineSmall!
            .copyWith(fontSize: 20, color: AppColors.blueDark),
        tabs: [
          t.sleep.sleep,
          t.sleep.cry,
          t.sleep.table,
        ],
        action: const ProfileWidget(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SleepScreen(),
          CryScreen(),
          TableScreen(),
        ],
      ),
    );
  }
}
