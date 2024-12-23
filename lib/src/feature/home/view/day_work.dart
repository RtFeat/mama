import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

    final CalendarStore store = context.watch();
    // Add 6 hours to the event date
    // to format to utc correctly
    final DateTime date = event.first.date.add(Duration(hours: 6));

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  '${date.day} ${t.home.monthsData.withNumbers[date.month - 1]}',
                  style: textTheme.titleLarge,
                ),
                if (date.day == now.day) ...[
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
                  title: t.consultation.setDayAsHoliday,
                  onTap: () {
                    store.controller.removeAll(event);
                    doctorStore.setDayHoliday(day: date);
                  },
                ),
              ],
            ),
            10.h,
            Row(
              children: [
                CustomButton(
                  title: t.consultation.cancelConsultations,
                  backgroundColor: AppColors.redLighterBackgroundColor,
                  onTap: () {
                    store.controller.removeAll(event);
                    doctorStore.cancelConsultations(day: date);
                  },
                  icon: IconModel(icon: Icons.close, color: AppColors.redColor),
                ),
              ],
            ),
            20.h,
            // ...doctorStore.slots.map((e) {
            //   return SpecialistDaySlot(slot: e, event: event);
            // })

            Observer(builder: (context) {
              logger.info(doctorStore.weekSlots[date.weekday - 1].toList(),
                  runtimeType: runtimeType);
              return _Slots(
                  slots: doctorStore.weekSlots[date.weekday - 1].toList(),
                  event: event);
            })
          ],
        ),
      ),
    );
  }
}

class _Slots extends StatelessWidget {
  final List<WorkSlot> slots;
  final List<CalendarEventData<Object?>> event;
  const _Slots({
    required this.slots,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: slots
            .map((e) => SpecialistDaySlot(slot: e, event: event))
            .toList());
  }
}
