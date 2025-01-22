import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddSleepingWidget extends StatefulWidget {
  const AddSleepingWidget({super.key});

  @override
  State<AddSleepingWidget> createState() => _AddSleepingWidgetState();
}

class _AddSleepingWidgetState extends State<AddSleepingWidget> {
  late FormGroup formGroupAddSleep;

  @override
  void initState() {
    formGroupAddSleep = FormGroup({
      'sleepStart': FormControl(),
      'sleepEnd': FormControl(),
    });
    super.initState();
  }

  @override
  void dispose() {
    formGroupAddSleep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: formGroupAddSleep,
      child: Provider<AddSleeping>(
        create: (context) => AddSleeping(),
        builder: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Observer(builder: (context) {
            final AddSleeping addSleeping = Provider.of<AddSleeping>(context);
            formGroupAddSleep.control('sleepStart').value =
                DateFormat('HH:mm').format(addSleeping.timerStartTime);
            addSleeping.timerEndTime != null
                ? formGroupAddSleep.control('sleepEnd').value =
                    DateFormat('HH:mm').format(addSleeping.timerEndTime!)
                : null;
            final confirmButtonPressed = addSleeping.confirmSleepTimer;
            final isFeedingCanceled = addSleeping.isSleepCanceled;
            return Column(
              children: [
                30.h,
                Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: PlayerButton(
                        side: t.trackers.titlePlayButtonSleep,
                        onTap: () {
                          addSleeping.changeStatusTimer();
                        },
                        isStart: addSleeping.timerSleepStart,
                      )),
                    ],
                  ),
                ),
                30.h,
                addSleeping.showEditMenu
                    ? CurrentEditingTrackWidget(
                        title: t.trackers.currentEditTrackSleepingTitle,
                        noteTitle:
                            t.trackers.currentEditTrackCountTextTitleFeed,
                        noteText: t.trackers.currentEditTrackCountTextSleep,
                        onPressNote: () {},
                        onPressSubmit: () {
                          addSleeping.confirmButtonPressed();
                        },
                        onPressCancel: () {
                          addSleeping.cancelSleeping();
                        },
                        onPressManually: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return Provider<AddSleeping>.value(
                                  value: addSleeping,
                                  child: AddSleepingScreenManually());
                            }),
                          );
                        },
                        timerStart: addSleeping.timerStartTime,
                        timerEnd: addSleeping.timerEndTime,
                        isTimerStarted: addSleeping.timerSleepStart,
                      )
                    : Column(
                        children: [
                          HelperPlayButtonWidget(
                            title: t.trackers.helperPlayButtonSleep,
                          ),
                          30.h,
                          EditingButtons(
                              iconAsset: Assets.icons.icCalendar,
                              addBtnText: t.feeding.addManually,
                              learnMoreTap: () {},
                              addButtonTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return Provider<AddSleeping>.value(
                                        value: addSleeping,
                                        child: AddSleepingScreenManually());
                                  }),
                                );
                              }),
                        ],
                      ),
                confirmButtonPressed
                    ? TrackerStateContainer(
                        type: ContainerType.sleepingSaved,
                        onTapClose: () {},
                        onTapGoBack: () {},
                        onTapNote: () {},
                      )
                    : const SizedBox(),
                isFeedingCanceled
                    ? TrackerStateContainer(
                        type: ContainerType.sleepingCanceled,
                        onTapClose: () {},
                        onTapGoBack: () {},
                      )
                    : const SizedBox(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
