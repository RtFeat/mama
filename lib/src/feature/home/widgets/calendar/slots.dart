import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SlotsWidget extends StatelessWidget {
  const SlotsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DoctorStore doctorStore = context.watch();
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final CalendarStore store = context.watch();

    return Observer(builder: (context) {
      final bool isEmpty = doctorStore.dividedSlots[0].isEmpty &&
          doctorStore.dividedSlots[1].isEmpty;

      final DateTime startedAt = doctorStore.weekStart
          .add(Duration(days: store.selectedDate.weekday - 1));

      return Column(
        children: [
          if (isEmpty)
            SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      border: Border.all(
                        color: AppColors.purpleLighterBackgroundColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(t.home.no_work,
                            style: textTheme.titleSmall
                                ?.copyWith(color: AppColors.greyBrighterColor)),
                      ),
                    ))),
          if (!isEmpty) ...[
            if (doctorStore.dividedSlots[0].isNotEmpty)
              MeetingsSection(
                whichSection: 1,
                meetingsList: doctorStore.dividedSlots[0]
                    .map((e) => MeetingBox(
                        consultationId: e.id ?? '',
                        scheduledTime: e.consultationTime ?? '',
                        meetingType: switch (e.type) {
                          ConsultationType.chat => t.home.chat.title,
                          ConsultationType.video => t.home.video.title,
                          ConsultationType.express => t.home.express.title,
                        },

                        //  e.type.name,
                        isCancelled: false,
                        tutorFullName: e.fullName ?? '',
                        startedAt: e.slotTime(startedAt, true),
                        whichSection: 1))
                    .toList(),
              ),
            if (doctorStore.dividedSlots[1].isNotEmpty) ...[
              8.h,
              MeetingsSection(
                whichSection: 2,
                meetingsList: doctorStore.dividedSlots[1]
                    .map((e) => MeetingBox(
                        consultationId: e.id ?? '',
                        scheduledTime: e.consultationTime ?? '',
                        meetingType: switch (e.type) {
                          ConsultationType.chat => t.home.chat.title,
                          ConsultationType.video => t.home.video.title,
                          ConsultationType.express => t.home.express.title,
                        },
                        isCancelled: false,
                        tutorFullName: e.fullName ?? '',
                        startedAt: e.slotTime(startedAt, true),
                        whichSection: 2))
                    .toList(),
              )
            ]
          ]

          /// #meetings section one

          /// #meetings section two
          // MeetingsSection(
          //   whichSection: 2,
          //   meetingsList: meetingsListTwo,
          // ),
        ],
      );
    });
  }
}
