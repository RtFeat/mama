import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/feeding/data/repository/history_repository.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, int> countDateDupes(List<String> list) {
      Map<String, int> returnMap = {};
      for (var i = 0; i < list.length; i++) {
        DateTime parsedDate = DateTime.parse(list[i]);
        String date =
            "${parsedDate.year}-${parsedDate.month}-${parsedDate.day}";
        if (returnMap.containsKey(date)) {
          returnMap[date] = returnMap[date]! + 1;
        } else {
          returnMap[date] = 1;
        }
      }
      return returnMap;
    }

    final mapDates = countDateDupes(
        historyOfSleepCry.map((e) => e.begin.toString()).toList());
    final listDates = mapDates.keys.toList();
    return TrackerBody(
        learnMoreWidgetText: t.trackers.findOutMoreTextSleep,
        children: [
          const AddSleepingWidget(),
          // TableHistory(
          //   listOfData: listOfData,
          //   firstColumnName: t.feeding.feedingEndTime,
          //   secondColumnName: t.feeding.breastMl,
          //   thirdColumnName: t.feeding.bottleMl,
          //   fourthColumnName: t.feeding.totalMl,
          //   showTitle: true,
          // ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Начало',
                    ),
                    Text(
                      'Окончание',
                    ),
                    Text(
                      'Время',
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listDates.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
                    DateTime input = inputFormat.parse(listDates[index]);
                    String tracker = DateFormat('dd MMMM').format(input);

                    return Table(
                      defaultColumnWidth: FixedColumnWidth(
                          MediaQuery.of(context).size.width / 3),
                      children: [
                        TableRow(
                          children: [
                            Text(maxLines: 1, tracker),
                            Text(
                              'fgh',
                            ),
                            Text(
                              'всего',
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: historyOfSleepCry.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {},
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          )
        ]);
  }
}
