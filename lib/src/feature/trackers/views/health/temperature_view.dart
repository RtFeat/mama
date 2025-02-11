import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class TemperatureView extends StatelessWidget {
  const TemperatureView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<List> tableData = [
      ['06 сентября', '09:30', '36,9'],
      ['', '09:30', '36,9'],
      ['', '09:30', '36,9'],
      ['', '09:30', '36,9'],
      ['05 сентября', '09:30', '36,9'],
      ['', '09:30', '36,9'],
      ['', '09:30', '36,9'],
      ['', '09:30', '36,9'],
    ];
    final phonePadding = MediaQuery.of(context).padding;
    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextTemp,
      onPressClose: () {},
      onPressLearnMore: () {},
      stackWidget:

          /// #bottom buttons
          Align(
        alignment: Alignment.bottomCenter,
        child: ButtonsLearnPdfAdd(
          onTapLearnMore: () {},
          onTapPDF: () {},
          onTapAdd: () {
            context.pushNamed(AppViews.trackersHealthAddMedicineView);
          },
          iconAddButton: AppIcons.thermometer,
        ),
      ),
      children: [
        14.h,

        /// #tabel header
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                t.trackers.date.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greyBrighterColor,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                t.trackers.time.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greyBrighterColor,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                t.trackers.temperature.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greyBrighterColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),

        /// #actual table
        Table(
          children: tableData
              .map(
                (row) => TableRow(
                  children: row
                      .map(
                        (cell) => Text(cell),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),

        SizedBox(height: phonePadding.bottom + 16),
      ],
    );
  }
}
