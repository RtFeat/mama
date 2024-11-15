import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../data.dart';
import 'calendar_cell_widget.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    var weeks = [
      'П',
      'В',
      'С',
      'Ч',
      'П',
      'С',
      'В',
    ];

    var listOfData = listOfDayOfWeek;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SpecialistConsultingContainer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(Assets.icons.chevronLeft),
                      5.w,
                      Text(
                        "Сентябрь 2023",
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      5.w,
                      SvgPicture.asset(Assets.icons.chevronRight),
                    ],
                  ),
                  const Spacer(),
                  CustomButton(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    borderRadius: 16,
                    onTap: () {},
                    title: "Вернуться\nк сегодня",
                    textStyle: textTheme.labelSmall
                        ?.copyWith(color: AppColors.primaryColor),
                  )
                ],
              ),
            ),
            DataTable(
                dataRowMaxHeight: 90,
                showBottomBorder: true,
                columnSpacing: 15,
                border: TableBorder(
                  verticalInside: BorderSide(color: Colors.grey.shade300),
                  horizontalInside: BorderSide(color: Colors.grey.shade300),
                ),
                columns: weeks
                    .map((w) => DataColumn(
                            label: Text(
                          w,
                          style: textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        )))
                    .toList(),
                rows: listOfData
                    .map((l) => DataRow(
                        cells: l
                            .map((w) => DataCell(CalendarCell(data: w)))
                            .toList()))
                    .toList())
          ],
        ),
      ),
    );
  }
}
