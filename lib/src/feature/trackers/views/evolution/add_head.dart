import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class AddHead extends StatelessWidget {
  const AddHead({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        title: t.trackers.head.title,
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
            verticalSwitch: Text(
              t.trackers.cm.title,
              style: AppTextStyles.f14w700.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          8.h,
        ],
      ),
    );
  }
}
