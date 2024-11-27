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
          var isStart = addSleeping.timerSleepStart;
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
                        // addSleeping.();
                      },
                      isStart: addSleeping.timerSleepStart,
                    )),
                  ],
                ),
              ),
              30.h,
              isStart
                  ? CurrentEditingTrackWidget(
                      title: t.trackers.currentEditTrackSleepingTitle,
                      noteTitle: t.trackers.currentEditTrackCountTextTitleFeed,
                      noteText: t.trackers.currentEditTrackCountTextSleep,
                      onPressNote: () {},
                      onPressSubmit: () {
                        addSleeping.confirmButtonPressed();
                      },
                      onPressCancel: () {
                        addSleeping.cancelFeeding();
                      },
                      onPressManually: () {},
                      timerStart: addSleeping.timerStartTime,
                      timerEnd: addSleeping.timerEndTime,
                    )
                  : EditingButtons(
                      iconAsset: Assets.icons.icCalendar,
                      addBtnText: t.feeding.addManually,
                      learnMoreTap: () {},
                      addButtonTap: () {
                        context.pushNamed(AppViews.addManually);
                      }),
              // confirmButtonPressed
              //     ? FeedingStateContainer(
              //         addFeeding: addFeeding,
              //         type: ContainerType.feedingSaved,
              //       )
              //     : const SizedBox(),
              // isFeedingCanceled
              //     ? FeedingStateContainer(
              //         addFeeding: addFeeding,
              //         type: ContainerType.feedingCanceled,
              //       )
              //     : const SizedBox(),
            ],
          );
        }),
      ),
    );
  }
}
