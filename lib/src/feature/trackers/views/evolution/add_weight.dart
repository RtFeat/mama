import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class AddWeight extends StatelessWidget {
  const AddWeight({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        title: t.trackers.weight.add,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: AppColors.trackerColor, fontSize: 17),
      ),
      body: ListView(
        children: [
          FixedCenterIndicator(
              kgOrG: t.trackers.kg.title, painter: CustomPointKG()),
          8.h,
          FixedCenterIndicator(
              kgOrG: t.trackers.g.title, painter: CustomPointG()),
          8.h,
          CustomBlog(
            value: '',
            onChangedValue: (p0) {},
            measure: UnitMeasures.weight,
            onPressedElevated: () {},
          ),
          8.h,
        ],
      ),
    );
  }
}
