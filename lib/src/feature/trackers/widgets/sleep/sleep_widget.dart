import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

class SleepWidget extends StatelessWidget {
  const SleepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<SleepStore>(
      create: (context) => SleepStore(),
      builder: (context, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: _Body(store: context.watch()),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final SleepStore store;
  const _Body({
    required this.store,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.init();
    super.initState();
  }

  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: widget.store.formGroup,
        child: Observer(builder: (context) {
          final confirmButtonPressed = widget.store.confirmSleepTimer;
          final isSleepingCanceled = widget.store.isSleepCanceled;

          return Column(
            children: [
              // 30.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: PlayerButton(
                    side: t.trackers.titlePlayButtonSleep,
                    onTap: () {
                      widget.store.changeStatusTimer();
                    },
                    isStart: widget.store.timerSleepStart,
                  )),
                ],
              ),
              // 30.h,
              widget.store.showEditMenu
                  ? CurrentEditingTrackWidget(
                      title: t.trackers.currentEditTrackSleepingTitle,
                      formControlNameEnd: 'sleepEnd',
                      formControlNameStart: 'sleepStart',
                      noteTitle: t.trackers.currentEditTrackCountTextTitleFeed,
                      noteText: t.trackers.currentEditTrackCountTextSleep,
                      onPressNote: () {},
                      onPressSubmit: () {
                        widget.store.confirmButtonPressed();
                      },
                      onPressCancel: () {
                        widget.store.cancelSleeping();
                      },
                      onPressManually: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return Provider<SleepStore>.value(
                                value: widget.store,
                                child: const AddSleepingScreenManually());
                          }),
                        );
                      },
                      timerStart: widget.store.timerStartTime,
                      timerEnd: widget.store.timerEndTime,
                      isTimerStarted: widget.store.timerSleepStart,
                    )
                  : Column(
                      children: [
                        HelperPlayButtonWidget(
                          title: t.trackers.helperPlayButtonSleep,
                        ),
                        30.h,
                        EditingButtons(
                            iconAsset: AppIcons.calendar,
                            addBtnText: t.feeding.addManually,
                            learnMoreTap: () {},
                            addButtonTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return Provider<SleepStore>.value(
                                      value: widget.store,
                                      child: const AddSleepingScreenManually());
                                }),
                              );
                            }),
                      ],
                    ),
              confirmButtonPressed
                  ? TrackerStateContainer(
                      type: ContainerType.sleepingSaved,
                      onTapClose: () {
                        widget.store.confirmSleepTimer = false;
                      },
                      onTapGoBack: () {},
                      onTapNote: () {},
                    )
                  : const SizedBox(),
              isSleepingCanceled
                  ? TrackerStateContainer(
                      type: ContainerType.sleepingCanceled,
                      onTapClose: () {},
                      onTapGoBack: () {},
                    )
                  : const SizedBox(),
            ],
          );
        }));
  }
}
