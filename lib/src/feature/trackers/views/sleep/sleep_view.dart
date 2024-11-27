import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/feeding/data/repository/history_repository.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfData = historyOfPumping;
    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextSleep,
      children: [
        const AddSleepingWidget(),
        TableHistory(
          listOfData: listOfData,
          firstColumnName: t.feeding.feedingEndTime,
          secondColumnName: t.feeding.breastMl,
          thirdColumnName: t.feeding.bottleMl,
          fourthColumnName: t.feeding.totalMl,
          showTitle: true,
        ),
      ],
    );
  }
}
