import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/views/sleep/cry/add_cry_manually.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry.dart';
import 'package:mama/src/feature/trackers/widgets/timer_interface.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/notes/state/add_note.dart';
import 'package:mama/src/core/api/models/sleepcry_delete_sleep_dto.dart';

class CryWidget extends StatelessWidget {
  const CryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: _Body(store: context.watch<CryStore>()),
    );
  }
}

class _Body extends StatefulWidget {
  final CryStore store;
  const _Body({
    required this.store,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  Timer? _timer;
  String? _lastSavedCryId;

  @override
  void initState() {
    widget.store.init();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      // Обновляем каждую секунду вне зависимости от состояния, чтобы Total и пауза были корректны
      widget.store.updateTimerDisplay();
      if (!widget.store.timerSleepStart && !widget.store.showEditMenu) {
        widget.store.setPausedEndToNow();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
        formGroup: widget.store.formGroup,
        child: Observer(builder: (context) {
          final confirmButtonPressed = widget.store.confirmSleepTimer;
          final isCanceled = widget.store.isSleepCanceled;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: PlayerButton(
                    side: t.trackers.crying,
                    onTap: () {
                      widget.store.changeStatusTimer();
                    },
                    isStart: widget.store.timerSleepStart,
                    needTimer: true,
                    timer: widget.store.currentTimerDisplay,
                    showTimerBadge: false,
                  )),
                ],
              ),
              widget.store.showEditMenu
                  ? Provider<TimerInterface>.value(
                      value: widget.store,
                      child: CurrentEditingTrackWidget(
                        title: t.trackers.currentEditTrackCryingTitle,
                        formControlNameEnd: 'cryEnd',
                        formControlNameStart: 'cryStart',
                        noteTitle: t.trackers.currentEditTrackCountTextTitleCry,
                        noteText: t.trackers.currentEditTrackCountTextCry,
                        onPressNote: () {
                          context.pushNamed(AppViews.addNote);
                        },
                        onPressSubmit: () {
                          // Сохранение на Confirm: сначала захватываем зависимости синхронно
                          final addNoteStore = context.read<AddNoteStore>();
                          final userStore = context.read<UserStore>();
                          final cryTableStore = context.read<CryTableStore>();
                          final childId = userStore.selectedChild?.id ?? '';
                          final notes = addNoteStore.content;
                          final DateTime optimisticStart = widget.store.timerStartTime;
                          final DateTime optimisticEnd = (widget.store.timerEndTime ?? DateTime.now());
                          // Переключаем UI в режим подтверждения
                          widget.store.confirmButtonPressed();
                          // Выполняем сохранение асинхронно, используя захваченные ссылки
                          Future.microtask(() async {
                            final response = await widget.store.add(childId, notes);
                            _lastSavedCryId = response?.id;
                            if (response?.id != null) {
                              final exists = cryTableStore.listData.any((e) => e.id == response!.id);
                              if (!exists) {
                                cryTableStore.listData.add(EntityCry(
                                  id: response!.id,
                                  childId: childId,
                                  timeToStart: optimisticStart.toIso8601String(),
                                  timeEnd: optimisticEnd.toIso8601String(),
                                  timeToEnd: '${optimisticEnd.difference(optimisticStart).inMinutes} м',
                                  notes: notes,
                                ));
                              }
                            }
                            // Фоновый рефреш для синхронизации
                            cryTableStore.loadPage(newFilters: [
                              SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                            ]);
                          });
                        },
                        onPressCancel: () {
                          widget.store.cancelSleeping();
                        },
                        onPressManually: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return Provider<CryStore>.value(
                                  value: widget.store,
                                  child: const AddCryManuallyView());
                            }),
                          );
                          
                          // Если запись была добавлена (result == true), обновляем истории
                          if (result == true) {
                            try {
                              final cryTableStore = context.read<CryTableStore>();
                              final userStore = context.read<UserStore>();
                              final childId = userStore.selectedChild?.id ?? '';
                              
                              // Сначала сбрасываем пагинацию
                              cryTableStore.resetPagination();
                              
                              // Затем загружаем данные (Cry API не поддерживает from_time/to_time)
                              cryTableStore.loadPage(newFilters: [
                                SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                              ]);
                            } catch (e) {
                              // Игнорируем ошибки
                            }
                          }
                        },
                        timerStart: widget.store.originalStartTime ?? widget.store.timerStartTime,
                        timerEnd: widget.store.timerEndTime,
                        isTimerStarted: widget.store.timerSleepStart,
                      ),
                    )
                  : Column(
                      children: [
                        HelperPlayButtonWidget(
                          title: t.trackers.helperPlayButtonCry,
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
                                  return Provider<CryStore>.value(
                                      value: widget.store,
                                      child: const AddCryManuallyView());
                                }),
                              );
                              
                              // Если запись была добавлена (result == true), обновляем истории
                              if (result == true) {
                                try {
                                  final cryTableStore = context.read<CryTableStore>();
                                  final userStore = context.read<UserStore>();
                                  final childId = userStore.selectedChild?.id ?? '';
                                  
                                  // Сначала сбрасываем пагинацию
                                  cryTableStore.resetPagination();
                                  
                                  // Затем загружаем данные (Cry API не поддерживает from_time/to_time)
                                  cryTableStore.loadPage(newFilters: [
                                    SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                                  ]);
                                } catch (e) {
                                  // Игнорируем ошибки
                                }
                              }
                            }),
                      ],
                    ),
              confirmButtonPressed
                  ? TrackerStateContainer(
                      type: ContainerType.cryingSaved,
                      onTapClose: () async {
                        // Крестик теперь просто сбрасывает состояние без дополнительного сохранения
                        _lastSavedCryId = null;
                        widget.store.resetWithoutSaving();
                      },
                      onTapGoBack: () {
                        // Удаляем только что созданную запись и возвращаемся к редактированию
                        final deps = context.read<Dependencies>();
                        final cryTableStore = context.read<CryTableStore>();
                        final id = _lastSavedCryId;
                        if (id != null) {
                          Future.microtask(() async {
                            try {
                              await deps.restClient.sleepCry
                                  .deleteSleepCryCryDeleteStats(dto: SleepcryDeleteSleepDto(id: id));
                            } catch (_) {}
                            cryTableStore.listData.removeWhere((e) => e.id == id);
                            setState(() {});
                          });
                        }
                        _lastSavedCryId = null;
                        widget.store.goBackAndContinue();
                      },
                      onTapNote: () {
                        context.pushNamed(AppViews.addNote);
                      },
                    )
                  : const SizedBox(),
              isCanceled
                  ? TrackerStateContainer(
                      type: ContainerType.cryingCanceled,
                      onTapClose: () async {
                        // Крестик при отмене — сброс без сохранения
                        widget.store.resetWithoutSaving();
                      },
                      onTapGoBack: () {
                        // Go back and continue - восстановить состояние паузы
                        widget.store.goBackAndContinue();
                      },
                    )
                  : const SizedBox(),
            ],
          );
        }));
  }
}


