import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class AddGrowth extends StatelessWidget {
  const AddGrowth({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        title: t.trackers.growth.add,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: AppColors.trackerColor, fontSize: 17),
      ),
      body: ListView(
        children: [
          FixedCenterIndicator(
            kgOrG: t.trackers.cm.title,
            painter: CustomPointCm(),
            size: const Size(200 * 10, 200),
            top: 170,
          ),
          8.h,
          CustomBlog(
            measure: UnitMeasures.height,
            onPressedElevated: () {},
            onPressedOutlined: () {},
          ),
          8.h,
        ],
      ),
    );
  }
}
