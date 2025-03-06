import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';

class BreastScreen extends StatelessWidget {
  const BreastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfData = historyOfFeedings;

    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextBrist,
      onPressClose: () {},
      onPressLearnMore: () {},
      children: [
        SliverToBoxAdapter(child: const AddFeedingWidget()),
        // SliverToBoxAdapter(
        //   child: TableHistory(
        //     listOfData: listOfData,
        //     firstColumnName: t.feeding.feedingEndTime,
        //     secondColumnName: t.feeding.l,
        //     thirdColumnName: t.feeding.r,
        //     fourthColumnName: t.feeding.general,
        //     showTitle: true,
        //   ),
        // )
      ],
    );
  }
}
