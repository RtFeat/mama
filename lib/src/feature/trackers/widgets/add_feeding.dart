import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/widgets/feeding_editing_track_widget.dart';
import 'package:mama/src/feature/trackers/state/feeding/breast_feeding_table_store.dart';

class AddFeedingWidget extends StatefulWidget {
  final VoidCallback? onHistoryRefresh;

  const AddFeedingWidget({
    super.key,
    this.onHistoryRefresh,
  });

  @override
  State<AddFeedingWidget> createState() => _AddFeedingWidgetState();
}

class _AddFeedingWidgetState extends State<AddFeedingWidget> {
  late FormGroup formGroupAddBreastFeeding;
  Timer? _timer;
  AddFeeding? _addFeeding;

  @override
  void initState() {
    formGroupAddBreastFeeding = FormGroup({
      'feedingBreastStart': FormControl(),
      'feedingBreastEnd': FormControl(),
    });
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    formGroupAddBreastFeeding.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Проверяем, что виджет все еще смонтирован
      if (!mounted) {
        timer.cancel();
        return;
      }

      // Проверяем, что AddFeeding доступен
      if (_addFeeding == null) {
        return;
      }

      // Во время экрана Confirm ничего не обновляем и не триггерим setState,
      // чтобы бейджи под кнопками не «тикали» визуально
      if (_addFeeding!.confirmFeedingTimer) {
        return;
      }

      // Обновляем левый таймер если он запущен или на паузе (но не после Confirm)
      if ((_addFeeding!.isLeftSideStart || _addFeeding!.leftPauseTime != null) && !_addFeeding!.confirmFeedingTimer) {
        _addFeeding!.updateLeftTimerDisplay();
      }

      // Обновляем правый таймер если он запущен или на паузе (но не после Confirm)
      if ((_addFeeding!.isRightSideStart || _addFeeding!.rightPauseTime != null) && !_addFeeding!.confirmFeedingTimer) {
        _addFeeding!.updateRightTimerDisplay();
      }

      // Если оба таймера на паузе, обновляем время окончания под текущее время телефона
      if (!_addFeeding!.isLeftSideStart && !_addFeeding!.isRightSideStart) {
        _addFeeding!.setPausedEndToNow();
      }

      // Обновляем UI для обновления времени в реальном времени
      setState(() {});
    });
  }

  void _refreshBreastFeedingHistory() {
    try {
      // Find the BreastFeedingTableStore in the widget tree and refresh it
      final store = context.read<BreastFeedingTableStore>();
      final childId = context.read<UserStore>().selectedChild?.id;
      if (childId != null) {
        store.resetPagination();
        store.loadPage(newFilters: [
          SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
        ]);
      }
    } catch (e) {
      // Store might not be available in this context, ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: formGroupAddBreastFeeding,
      child: Provider(
        create: (context) => AddFeeding(
          childId: context.read<UserStore>().selectedChild!.id!,
          restClient: context.read<Dependencies>().restClient,
          noteStore: context.read<AddNoteStore>(),
          onHistoryRefresh: widget.onHistoryRefresh ?? () => _refreshBreastFeedingHistory(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Observer(builder: (context) {
            final AddFeeding addFeeding = context.watch();
            _addFeeding = addFeeding; // Сохраняем ссылку для Timer
            // var isStart = addFeeding.isRightSideStart || addFeeding.isLeftSideStart; // unused
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
                        child: Observer(
                          builder: (context) => PlayerButton(
                            side: t.feeding.left,
                            onTap: () {
                              addFeeding.changeStatusOfLeftSide();
                            },
                            isStart: addFeeding.isLeftSideStart,
                            needTimer: true,
                            timer: addFeeding.leftCurrentTimerDisplay,
                            showTimerBadge: true,
                            onTimeChange: (TimeOfDay time) {
                              // Устанавливаем время для левой стороны
                              final now = DateTime.now();
                              final newTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                              addFeeding.setLeftTimerManually(newTime);
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: -50,
                        child: Observer(
                          builder: (context) => PlayerButton(
                            side: t.feeding.right,
                            onTap: () {
                              addFeeding.changeStatusOfRightSide();
                            },
                            isStart: addFeeding.isRightSideStart,
                            needTimer: true,
                            timer: addFeeding.rightCurrentTimerDisplay,
                            showTimerBadge: true,
                            onTimeChange: (TimeOfDay time) {
                              // Устанавливаем время для правой стороны
                              final now = DateTime.now();
                              final newTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                              addFeeding.setRightTimerManually(newTime);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                0.h,
                addFeeding.showEditMenu
                    ? FeedingEditingTrackWidget(
                        title: t.trackers.currentEditTrackFeedingTitle,
                        noteTitle:
                            t.trackers.currentEditTrackCountTextTitleFeed,
                        noteText: t.trackers.currentEditTrackCountTextFeed,
                        onPressNote: () {
                          context.pushNamed(AppViews.addNote, extra: {
                            'initialValue': addFeeding.noteStore.content ?? '',
                            'onSaved': (String value) {
                              // Сохраняем заметку в store
                              addFeeding.noteStore.setContent(value);
                              // Очищаем store после сохранения, чтобы заметка не переносилась в другие модули
                              Future.microtask(() => addFeeding.noteStore.setContent(null));
                            },
                          });
                        },
                        onPressSubmit: () {
                          addFeeding.confirmButtonPressed();
                        },
                        onPressCancel: () {
                          addFeeding.cancelFeeding();
                        },
                        onPressManually: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return Provider<AddFeeding>.value(
                                value: addFeeding,
                                child: const AddFeedingBreastManually(),
                              );
                            }),
                          );
                        },
                        timerStart: addFeeding.timerStartTime,
                        timerEnd: addFeeding.timerEndTime,
                        formControlNameEnd: 'feedingBreastEnd',
                        formControlNameStart: 'feedingBreastStart',
                        isTimerStarted: addFeeding.isRightSideStart == true
                            ? true
                            : addFeeding.isLeftSideStart == true
                                ? true
                                : false,
                        addFeeding: addFeeding,
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
                              learnMoreTap: () {
                                context.pushNamed(AppViews.serviceKnowlegde);
                              },
                              addButtonTap: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return Provider<AddFeeding>.value(
                                        value: addFeeding,
                                        child:
                                            const AddFeedingBreastManually());
                                  }),
                                );

                                // If a record was successfully added, refresh the history
                                if (result == true && mounted) {
                                  widget.onHistoryRefresh?.call();
                                }
                              }),
                        ],
                      ),
                confirmButtonPressed
                    ? TrackerStateContainer(
                        type: ContainerType.feedingSaved,
                        onTapClose: () async {
                          // Крестик - сбросить все без сохранения
                          await addFeeding.cancelFeedingClose();
                        },
                        onTapGoBack: () async {
                          // Go back and continue - удалить запись и восстановить состояние паузы
                          await addFeeding.goBackAndContinue();
                        },
                        onTapNote: () {
                          context.pushNamed(AppViews.addNote, extra: {
                            'initialValue': addFeeding.noteStore.content ?? '',
                            'onSaved': (String value) async {
                              // Сохраняем заметки в локальный store
                              addFeeding.noteStore.setContent(value);
                              // Обновляем заметки на сервере для уже сохраненной записи
                              if (addFeeding.savedRecordId != null) {
                                await addFeeding.updateFeedingNotes(addFeeding.savedRecordId!, value);
                              }
                              // Очищаем store после сохранения
                              Future.microtask(() => addFeeding.noteStore.setContent(null));
                            },
                          });
                        },
                      )
                    : const SizedBox(),
                isFeedingCanceled
                    ? TrackerStateContainer(
                        type: ContainerType.feedingCanceled,
                        onTapClose: () async {
                          // Крестик при отмене — сброс без сохранения (как в Sleep)
                          addFeeding.resetWithoutSaving();
                        },
                        onTapGoBack: () {
                          // Go back and continue - восстановить состояние паузы
                          addFeeding.goBackAndContinue();
                        },
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