import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';
import 'package:provider/provider.dart';

class AddSleepingWidget extends StatelessWidget {
  const AddSleepingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AddSleeping(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Observer(builder: (context) {
          final AddSleeping addSleeping = context.watch();
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
                      noteTitle: t.trackers.currentEditTrackCountTextTitleFeed,
                      noteText: t.trackers.currentEditTrackCountTextSleep,
                      onPressNote: () {},
                      onPressSubmit: () {
                        addSleeping.confirmButtonPressed();
                      },
                      onPressCancel: () {
                        addSleeping.cancelSleeping();
                      },
                      onPressManually: () {},
                      timerStart: addSleeping.timerStartTime,
                      timerEnd: addSleeping.timerEndTime,
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
                              context.pushNamed(AppViews.addManually);
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
    );
  }
}
