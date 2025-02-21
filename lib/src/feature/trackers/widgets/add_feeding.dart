import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddFeedingWidget extends StatefulWidget {
  const AddFeedingWidget({super.key});

  @override
  State<AddFeedingWidget> createState() => _AddFeedingWidgetState();
}

class _AddFeedingWidgetState extends State<AddFeedingWidget> {
  late FormGroup formGroupAddBreastFeeding;

  @override
  void initState() {
    formGroupAddBreastFeeding = FormGroup({
      'feedingBreastStart': FormControl(),
      'feedingBreastEnd': FormControl(),
    });
    super.initState();
  }

  @override
  void dispose() {
    formGroupAddBreastFeeding.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: formGroupAddBreastFeeding,
      child: Provider(
        create: (context) => AddFeeding(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Observer(builder: (context) {
            final AddFeeding addFeeding = context.watch();
            var isStart =
                addFeeding.isRightSideStart || addFeeding.isLeftSideStart;
            final confirmButtonPressed = addFeeding.confirmFeedingTimer;
            final isFeedingCanceled = addFeeding.isFeedingCanceled;
            return Column(
              children: [
                30.h,
                SizedBox(
                  height: 300,
                  child: Stack(
                    // fit: StackFit.passthrough,
                    clipBehavior: Clip.none,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Positioned(
                        left: -50,
                        child: PlayerButton(
                          side: t.feeding.left,
                          onTap: () {
                            addFeeding.changeStatusOfLeftSide();
                          },
                          isStart: addFeeding.isLeftSideStart,
                          needTimer: true,
                          timer: '', //TODO время таймера
                        ),
                      ),
                      Positioned(
                        right: -50,
                        child: PlayerButton(
                          side: t.feeding.right,
                          onTap: () {
                            addFeeding.changeStatusOfRightSide();
                          },
                          isStart: addFeeding.isRightSideStart,
                          needTimer: true,
                          timer: '', //TODO время таймера
                        ),
                      ),
                    ],
                  ),
                ),
                30.h,
                isStart
                    ? CurrentEditingTrackWidget(
                        title: t.trackers.currentEditTrackFeedingTitle,
                        noteTitle:
                            t.trackers.currentEditTrackCountTextTitleFeed,
                        noteText: t.trackers.currentEditTrackCountTextFeed,
                        onPressNote: () {},
                        onPressSubmit: () {
                          addFeeding.confirmButtonPressed();
                        },
                        onPressCancel: () {
                          addFeeding.cancelFeeding();
                        },
                        onPressManually: () {},
                        timerStart: addFeeding.timerStartTime,
                        timerEnd: addFeeding.timerEndTime,
                        formControlNameEnd: 'feedingBreastEnd',
                        formControlNameStart: 'feedingBreastStart',
                        isTimerStarted: addFeeding.isRightSideStart == true
                            ? true
                            : addFeeding.isLeftSideStart == true
                                ? true
                                : false,
                      )
                    : Column(
                        children: [
                          HelperPlayButtonWidget(
                            title: t.trackers.helperPlayButtonFeed,
                          ),
                          30.h,
                          EditingButtons(
                              iconAsset: AppIcons.calendar,
                              addBtnText: t.feeding.addManually,
                              learnMoreTap: () {},
                              addButtonTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return Provider<AddFeeding>.value(
                                        value: addFeeding,
                                        child:
                                            const AddFeedingBreastManually());
                                  }),
                                );
                              }),
                        ],
                      ),
                confirmButtonPressed
                    ? TrackerStateContainer(
                        onTapClose: () {
                          addFeeding.goBackAndContinue();
                        },
                        onTapGoBack: () {
                          addFeeding.goBackAndContinue();
                        },
                        onTapNote: () {}, //Todo Заметки
                        type: ContainerType.feedingSaved,
                      )
                    : const SizedBox(),
                isFeedingCanceled
                    ? TrackerStateContainer(
                        onTapClose: () {
                          addFeeding.goBackAndContinue();
                        },
                        onTapGoBack: () {
                          addFeeding.goBackAndContinue();
                        },
                        type: ContainerType.feedingCanceled,
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
