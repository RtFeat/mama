import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skit/skit.dart';

import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';
import 'package:mama/src/feature/trackers/widgets/pumping_graphic_widget.dart';

class PumpingScreen extends StatelessWidget {
  const PumpingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfData = historyOfPumping;

    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextPumping,
      onPressClose: () {},
      onPressLearnMore: () {},
      children: [
        SliverToBoxAdapter(child: const PumpingGraphicWidget()),
        SliverToBoxAdapter(child: 30.h),
        SliverToBoxAdapter(
          child: EditingButtons(
              addBtnText: t.feeding.addPumping,
              learnMoreTap: () {},
              addButtonTap: () {
                context.pushNamed(AppViews.addPumping);
              }),
        ),
        // SliverToBoxAdapter(
        //   child: TableHistory(
        //     listOfData: listOfData,
        //     firstColumnName: t.feeding.endTimeOfPumping,
        //     secondColumnName: t.feeding.pumpingLeftSide,
        //     thirdColumnName: t.feeding.pumpingRightSide,
        //     fourthColumnName: t.feeding.totalMl,
        //     showTitle: true,
        //   ),
        // ),
      ],
    );
  }
}
