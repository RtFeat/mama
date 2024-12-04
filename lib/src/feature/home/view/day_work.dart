import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SpecialistDayView extends StatelessWidget {
  final List<CalendarEventData<Object?>> event;
  const SpecialistDayView({
    super.key,
    required this.event,
  });

  String formatTimeRange(DateTime startTime, DateTime endTime) {
    // Форматируем время с ведущими нулями
    String formatTime(DateTime time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    // Возвращаем отформатированную строку
    return '${formatTime(startTime)} - ${formatTime(endTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final DoctorStore doctorStore = context.watch();

    logger.info(event);

    return Scaffold(
      appBar: CustomAppBar(),
      // title: '${event.first.date.day} ${t.home.monthsData[now.month - 1]}',
      // action: event.first.date.day == now.day
      //     ? DecoratedBox(
      //         decoration: BoxDecoration(
      //           color: AppColors.primaryColor,
      //           borderRadius: BorderRadius.circular(16),
      //         ),
      //         child: Padding(
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      //           child: Text(
      //             t.home.today,
      //             style: textTheme.titleLarge?.copyWith(
      //               color: AppColors.whiteColor,
      //               fontSize: 10,
      //             ),
      //           ),
      //         ),
      //       )
      //     : const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  '${event.first.date.day} ${t.home.monthsData[now.month - 1]}',
                  style: textTheme.titleLarge,
                ),
                if (event.first.date.day == now.day) ...[
                  10.w,
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Text(
                        t.home.today,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                ]
              ],
            ),
            10.h,
            Row(
              children: [
                CustomButton(
                  title: 'Сделать выходным',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('На бэкенде не реализовано'),
                      ),
                    );
                  },
                ),
              ],
            ),
            10.h,
            Row(
              children: [
                CustomButton(
                  title: 'Отменить все записи',
                  backgroundColor: AppColors.redLighterBackgroundColor,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('На бэкенде не реализовано'),
                      ),
                    );
                  },
                  icon: IconModel(icon: Icons.close, color: AppColors.redColor),
                ),
              ],
            ),
            20.h,
            ...doctorStore.slots.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.workSlot,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.greyBrighterColor,
                    ),
                  ),
                  MeetingsSection(
                      whichSection: 1,
                      showDecoration: false,
                      meetingsList: event
                          .where((i) =>
                              i.startTime?.hour ==
                              int.parse(e.workSlot.split(':')[0]))
                          .map((e) {
                        final bool isLater = e.startTime!.hour > now.hour;

                        return MeetingBox(
                            icon: IconModel(
                              iconPath: !isLater
                                  ? Assets.icons.icCheckmark
                                  : Assets.icons.icClock,
                              size: isLater
                                  ? const Size(18, 18)
                                  : const Size(12, 12),
                              color: !isLater
                                  ? AppColors.greenTextColor
                                  : AppColors.primaryColor,
                            ),
                            timeStyle: textTheme.labelLarge?.copyWith(
                              color: !isLater
                                  ? AppColors.greenTextColor
                                  : AppColors.primaryColor,
                            ),
                            tutorNameStyle: textTheme.titleSmall?.copyWith(
                                fontSize: 14,
                                color: !isLater
                                    ? AppColors.greenTextColor
                                    : AppColors.primaryColor),
                            backgroundColor: !isLater
                                ? AppColors.greenLighterBackgroundColor
                                : AppColors.purpleLighterBackgroundColor,
                            scheduledTime:
                                formatTimeRange(e.startTime!, e.endTime!),
                            meetingType: '',
                            isCancelled: false,
                            tutorFullName: '${e.event}',
                            whichSection: 1,
                            consultationId: '');
                      }).toList()),

                  // [
                  //   MeetingBox(
                  //       scheduledTime: 'sdfdsf',
                  //       meetingType: 'dsf',
                  //       isCancelled: false,
                  //       tutorFullName: 'sdfd dfsdf',
                  //       whichSection: 1,
                  //       consultationId: '')
                  // ])
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
