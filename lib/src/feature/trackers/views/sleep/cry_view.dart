import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/feeding/data/repository/history_repository.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';

class CryScreen extends StatelessWidget {
  const CryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfData = historyOfFeedings;

    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextCry,
      children: [
        const AddFeedingWidget(),
        TableHistory(
          listOfData: listOfData,
          firstColumnName: t.feeding.feedingEndTime,
          secondColumnName: t.feeding.l,
          thirdColumnName: t.feeding.r,
          fourthColumnName: t.feeding.general,
          showTitle: true,
        )
      ],
    );
  }
}
