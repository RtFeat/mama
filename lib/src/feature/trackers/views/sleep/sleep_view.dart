import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/feeding/data/repository/history_repository.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    // DateTime input = inputFormat.parse(listDates[index]);
    // String tracker = DateFormat('dd MMMM').format(input);

    return TrackerBody(
        learnMoreWidgetText: t.trackers.findOutMoreTextSleep,
        children: [
          const AddSleepingWidget(),
          CalendarSleeping(),
          TableWidgetSleepCry(),
          // TableHistory(
          //   listOfData: listOfData,
          //   firstColumnName: t.feeding.feedingEndTime,
          //   secondColumnName: t.feeding.breastMl,
          //   thirdColumnName: t.feeding.bottleMl,
          //   fourthColumnName: t.feeding.totalMl,
          //   showTitle: true,
          // ),
        ]);
  }
}

class TableWidgetSleepCry extends StatelessWidget {
  const TableWidgetSleepCry({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, int> countDateDupes(List<String> list) {
      Map<String, int> returnMap = {};
      for (var i = 0; i < list.length; i++) {
        DateTime parsedDate = DateTime.parse(list[i]);
        String date =
            '${parsedDate.year}-${parsedDate.month}-${parsedDate.day}';
        if (returnMap.containsKey(date)) {
          returnMap[date] = returnMap[date]! + 1;
        } else {
          returnMap[date] = 1;
        }
      }
      return returnMap;
    }

    final mapDates = countDateDupes(
            historyOfSleepCry.map((e) => e.begin.toString()).toList())
        .keys
        .toList();
    // final listDates = mapDates.keys.toList();

    List<DetailTimeSleepCry> newList = [];
    for (var i = 0; i < historyOfSleepCry.length; i++) {
      Duration difference =
          historyOfSleepCry[i].end.difference(historyOfSleepCry[i].begin);
      int hours = difference.inHours % 60;
      int minutes = difference.inMinutes % 60;
      String timeTotal = hours == 0
          ? '$minutes${t.trackers.min}'
          : '$hoursч $minutes${t.trackers.min}';
      newList.add(DetailTimeSleepCry(
        begin: DateFormat('HH:mm').format(historyOfSleepCry[i].begin),
        end: DateFormat('HH:mm').format(historyOfSleepCry[i].end),
        time: timeTotal,
      ));
    }
    return SizedBox(
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
            itemCount: mapDates.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              DateFormat inputFormat = DateFormat('yyyy-MM-dd');
              DateTime input = inputFormat.parse(mapDates[index]);
              String tracker = DateFormat('dd MMMM').format(input);
              final list = historyOfSleepCry.where((element) =>
                  inputFormat.parse(element.begin.toString()) == input);
              // for (var i = 0; i < mapDates.length; i++) {}
              return Table(
                defaultColumnWidth:
                    FixedColumnWidth(MediaQuery.of(context).size.width / 3),
                children: [
                  TableRow(
                    children: [
                      Text(maxLines: 1, tracker),
                      Text(
                        'всего',
                      ),
                      Text(
                        'всего',
                      ),
                      for (var item in historyOfSleepCry.where((element) =>
                          inputFormat.parse(element.begin.toString()) == input))
                        Table(
                          defaultColumnWidth: FixedColumnWidth(
                              MediaQuery.of(context).size.width / 3),
                          children: [
                            TableRow(children: [
                              Text(maxLines: 1, tracker),
                              Text(
                                'всего',
                              ),
                              Text(
                                'всего',
                              ),
                            ]),
                          ],
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
    );
  }
}

class CalendarSleeping extends StatelessWidget {
  const CalendarSleeping({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return CalendarControllerProvider(
        controller: EventController()..addAll(_events),
        child: SizedBox(
          height: 600,
          child: WeekView(
            controller: EventController(),
            weekDayBuilder: (day) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${t.trackers.list_of_weeks[day.weekday - 1]} ${day.day}',
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall
                      ?.copyWith(fontWeight: FontWeight.w400),
                  maxLines: 1,
                ),
              );
            },
            eventTileBuilder: (date, events, boundry, start, end) {
              // Return your widget to display as event tile.
              return Container();
            },
            fullDayEventBuilder: (events, date) {
              // Return your widget to display full day event view.
              return Container(
                color: Colors.red,
              );
            },
            showLiveTimeLineInAllDays:
                true, // To display live time line in all pages in week view.
            // width: 400, // width of week view.
            minDay: DateTime(1990),
            maxDay: DateTime(2050),
            initialDay: DateTime(2021),
            heightPerMinute: 1, // height occupied by 1 minute time span.
            eventArranger:
                SideEventArranger(), // To define how simultaneous events will be arranged.
            onEventTap: (events, date) => print(events),
            onEventDoubleTap: (events, date) => print(events),
            onDateLongPress: (date) => print(date),
            startDay: WeekDays.monday, // To change the first day of the week.
            startHour: 0, // To set the first hour displayed (ex: 05:00)
            endHour: 23, // To set the end hour displayed
            showVerticalLines: true, // Show the vertical line between days.
            // hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
            //     return //Your custom painter.
            // },
            weekPageHeaderBuilder: (context, date) {
              return Container();
            },

            keepScrollOffset: true,
          ),
        ));
  }
}

DateTime get _now => DateTime.now();
List<CalendarEventData> _events = [
  CalendarEventData(
    date: _now,
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
  ),
  // CalendarEventData(
  //   date: _now.subtract(Duration(days: 3)),
  //   recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
  //     startDate: _now.subtract(Duration(days: 3)),
  //   ),
  //   title: 'Leetcode Contest',
  //   description: 'Give leetcode contest',
  // ),
  // CalendarEventData(
  //   date: _now.subtract(Duration(days: 3)),
  //   recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
  //     startDate: _now.subtract(Duration(days: 3)),
  //     frequency: RepeatFrequency.daily,
  //     recurrenceEndOn: RecurrenceEnd.after,
  //     occurrences: 5,
  //   ),
  //   title: 'Physics test prep',
  //   description: 'Prepare for physics test',
  // ),
  // CalendarEventData(
  //   date: _now.add(Duration(days: 1)),
  //   startTime: DateTime(_now.year, _now.month, _now.day, 18),
  //   endTime: DateTime(_now.year, _now.month, _now.day, 19),
  //   recurrenceSettings: RecurrenceSettings(
  //     startDate: _now,
  //     endDate: _now.add(Duration(days: 5)),
  //     frequency: RepeatFrequency.daily,
  //     recurrenceEndOn: RecurrenceEnd.after,
  //     occurrences: 5,
  //   ),
  //   title: "Wedding anniversary",
  //   description: "Attend uncle's wedding anniversary.",
  // ),
  // CalendarEventData(
  //   date: _now,
  //   startTime: DateTime(_now.year, _now.month, _now.day, 14),
  //   endTime: DateTime(_now.year, _now.month, _now.day, 17),
  //   title: "Football Tournament",
  //   description: "Go to football tournament.",
  // ),
  // CalendarEventData(
  //   date: _now.add(Duration(days: 3)),
  //   startTime: DateTime(_now.add(Duration(days: 3)).year,
  //       _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10),
  //   endTime: DateTime(_now.add(Duration(days: 3)).year,
  //       _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14),
  //   title: "Sprint Meeting.",
  //   description: "Last day of project submission for last year.",
  // ),
  // CalendarEventData(
  //   date: _now.subtract(Duration(days: 2)),
  //   startTime: DateTime(
  //       _now.subtract(Duration(days: 2)).year,
  //       _now.subtract(Duration(days: 2)).month,
  //       _now.subtract(Duration(days: 2)).day,
  //       14),
  //   endTime: DateTime(
  //       _now.subtract(Duration(days: 2)).year,
  //       _now.subtract(Duration(days: 2)).month,
  //       _now.subtract(Duration(days: 2)).day,
  //       16),
  //   title: "Team Meeting",
  //   description: "Team Meeting",
  // ),
  // CalendarEventData(
  //   date: _now.subtract(Duration(days: 2)),
  //   startTime: DateTime(
  //       _now.subtract(Duration(days: 2)).year,
  //       _now.subtract(Duration(days: 2)).month,
  //       _now.subtract(Duration(days: 2)).day,
  //       10),
  //   endTime: DateTime(
  //       _now.subtract(Duration(days: 2)).year,
  //       _now.subtract(Duration(days: 2)).month,
  //       _now.subtract(Duration(days: 2)).day,
  //       12),
  //   title: "Chemistry Viva",
  //   description: "Today is Joe's birthday.",
  // ),
];
