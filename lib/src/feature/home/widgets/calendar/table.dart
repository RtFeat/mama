import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/services/specialist_consulting/widgets/calendar_cell_widget.dart';

class CustomTableWidget extends StatelessWidget {
  const CustomTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return DataTable(
        dataRowMaxHeight: 90,
        showBottomBorder: true,
        columnSpacing: 15,
        border: TableBorder(
          verticalInside: BorderSide(color: Colors.grey.shade300),
          horizontalInside: BorderSide(color: Colors.grey.shade300),
        ),
        columns: t.home.list_of_weeks
            .map((w) => DataColumn(
                    label: Text(
                  w,
                  style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                )))
            .toList(),
        rows: CalendarUtils.generateCalendarData(DateTime.now())
            .map((l) => DataRow(
                cells: l.map((w) => DataCell(CalendarCell(data: w))).toList()))
            .toList());
  }
}
