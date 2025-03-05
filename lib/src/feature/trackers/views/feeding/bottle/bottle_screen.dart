import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skit/skit.dart';

import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/repository/feeding_repository.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';

class BottleScreen extends StatelessWidget {
  const BottleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfData = historyOfPumping;
    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextBottle,
      onPressClose: () {},
      onPressLearnMore: () {},
      children: [
        SliverToBoxAdapter(
          child: GraphicWidget(
              listOfData: getBottleData(),
              topColumnText: t.feeding.breast,
              bottomColumnText: t.feeding.mixture,
              minimum: 0,
              maximum: 500,
              interval: 100),
        ),
        SliverToBoxAdapter(child: 10.h),
        SliverToBoxAdapter(
          child: EditingButtons(
              addBtnText: t.feeding.addFeeding,
              learnMoreTap: () {},
              addButtonTap: () {
                context.pushNamed(AppViews.addBottle);
              }),
        ),
        // SliverToBoxAdapter(
        //   child: TableHistory(
        //     listOfData: listOfData,
        //     firstColumnName: t.feeding.feedingEndTime,
        //     secondColumnName: t.feeding.breastMl,
        //     thirdColumnName: t.feeding.bottleMl,
        //     fourthColumnName: t.feeding.totalMl,
        //     showTitle: true,
        //   ),
        // ),
      ],
    );
  }
}
