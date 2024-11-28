import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/feeding/state/add_feeding.dart';
import 'package:mama/src/feature/feeding/widgets/editing_buttons.dart';
import 'package:mama/src/feature/feeding/widgets/tracker_state_container.dart';
import 'package:mama/src/feature/feeding/widgets/current_editing_track_widget.dart';
import 'package:mama/src/feature/feeding/widgets/play_button.dart';
import 'package:provider/provider.dart';

class AddFeedingWidget extends StatelessWidget {
  const AddFeedingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
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
                      ),
                    ),
                  ],
                ),
              ),
              30.h,
              isStart
                  ? CurrentEditingTrackWidget(
                      title: t.trackers.currentEditTrackFeedingTitle,
                      noteTitle: t.trackers.currentEditTrackCountTextTitleFeed,
                      noteText: t.trackers.currentEditTrackCountTextFeed,
                      onPressNote: () {},
                      onPressSubmit: () {
                        // addFeeding.confirmButtonPressed();
                      },
                      onPressCancel: () {
                        // addFeeding.cancelFeeding();
                      },
                      onPressManually: () {},
                      timerStart: addFeeding.timerStartTime,
                      timerEnd: addFeeding.timerEndTime,
                    )
                  : Column(
                      children: [
                        HelperPlayButtonWidget(
                          title: t.trackers.helperPlayButtonFeed,
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
    );
  }
}
