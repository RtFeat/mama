import 'package:flutter/material.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';
import 'package:mama/src/feature/trackers/widgets/table_history.dart';

import '../../../../../core/core.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TableHistory(
          listOfData: listOfTableData,
          firstColumnName: t.feeding.date,
          secondColumnName: t.feeding.gwTime,
          thirdColumnName: t.feeding.totalLiquidsMl,
          fourthColumnName: t.feeding.totalComplementary,
          showTitle: false,
        ),
      ),
    );
  }
}
