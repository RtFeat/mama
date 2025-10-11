import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/widgets/timer_interface.dart';
import 'package:mama/src/feature/notes/state/add_note.dart';
import 'package:mama/src/core/api/models/sleepcry_delete_sleep_dto.dart';

class SleepWidget extends StatelessWidget {
  const SleepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: _Body(store: context.watch<SleepStore>()),
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

class __BodyState extends State<_Body> with TickerProviderStateMixin {
  Timer? _timer;
  String? _lastSavedSleepId;

  @override
  void initState() {
    widget.store.init();
    super.initState();
    _startTimer();
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
      // Обновляем отображение каждую секунду, чтобы Total и пауза были консистентны
      widget.store.updateTimerDisplay();
      // Если таймер на паузе и не в режиме редактирования, подстраиваем End под текущее время
      // но не трогаем, если End был установлен вручную
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
                    needTimer: true,
                    timer: widget.store.currentTimerDisplay,
                    showTimerBadge: false,
                  )),
                ],
              ),
              // 30.h,
              widget.store.showEditMenu
                  ? Builder(
                      builder: (context) {
                        try {
                          return Provider<TimerInterface>.value(
                            value: widget.store,
                            child: CurrentEditingTrackWidget(
                              title: t.trackers.currentEditTrackSleepingTitle,
                              formControlNameEnd: 'sleepEnd',
                              formControlNameStart: 'sleepStart',
                              noteTitle: t.trackers.currentEditTrackCountTextTitleFeed,
                              noteText: t.trackers.currentEditTrackCountTextSleep,
                              onPressNote: () {
                                context.pushNamed(AppViews.addNote);
                              },
                              onPressSubmit: () {
                                // Подтверждаем и сохраняем запись здесь (а не на крестике)
                                // 1) Синхронно захватываем все зависимости до асинхронного кода
                                final addNoteStore = context.read<AddNoteStore>();
                                final userStore = context.read<UserStore>();
                                final sleepTableStore = context.read<SleepTableStore>();
                                final childId = userStore.selectedChild?.id ?? '';
                                final notes = addNoteStore.content;
                                final DateTime optimisticStart = widget.store.timerStartTime;
                                final DateTime optimisticEnd = (widget.store.timerEndTime ?? DateTime.now());
                                // 2) Переводим стор в режим подтверждения (меняет UI)
                                widget.store.confirmButtonPressed();
                                // 3) Асинхронно выполняем сохранение, используя уже захваченные ссылки
                                Future.microtask(() async {
                                  final response = await widget.store.add(childId, notes);
                                  _lastSavedSleepId = response?.id;
                                  // Оптимистично добавляем запись в локальный список
                                  if (response?.id != null) {
                                    final exists = sleepTableStore.listData.any((e) => e.id == response!.id);
                                    if (!exists) {
                                      sleepTableStore.listData.add(EntitySleep(
                                        id: response!.id,
                                        childId: childId,
                                        timeToStart: optimisticStart.toIso8601String(),
                                        timeEnd: optimisticEnd.toIso8601String(),
                                        timeToEnd: '${optimisticEnd.difference(optimisticStart).inMinutes} м',
                                        allSleep: '${optimisticEnd.difference(optimisticStart).inMinutes} м',
                                        notes: notes,
                                      ));
                                    }
                                  }
                                  // Тригерим фоновой рефреш
                                  sleepTableStore.loadPage(newFilters: [
                                    SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                                  ]);
                                });
                              },
                              onPressCancel: () {
                                widget.store.cancelSleeping();
                              },
                              onPressManually: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return Provider<SleepStore>.value(
                                        value: widget.store,
                                        child: const AddSleepingView());
                                  }),
                                );
                              },
                              timerStart: widget.store.originalStartTime ?? widget.store.timerStartTime,
                              timerEnd: widget.store.timerEndTime,
                              isTimerStarted: widget.store.timerSleepStart,
                            ),
                          );
                        } catch (e) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Timer widget not available',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            ),
                          );
                        }
                      },
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
                            learnMoreTap: () {
                              context.pushNamed(AppViews.serviceKnowlegde);
                            },
                            addButtonTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return Provider<SleepStore>.value(
                                      value: widget.store,
                                      child: const AddSleepingView());
                                }),
                              );
                            }),
                      ],
                    ),
              confirmButtonPressed
                  ? TrackerStateContainer(
                      type: ContainerType.sleepingSaved,
                      onTapClose: () async {
                        // Крестик теперь просто закрывает и сбрасывает состояние без дополнительного сохранения
                        _lastSavedSleepId = null;
                        widget.store.resetWithoutSaving();
                      },
                      onTapGoBack: () {
                        // Возврат к редактированию: удаляем только что сохраненную запись и продолжаем
                        final deps = context.read<Dependencies>();
                        final sleepTableStore = context.read<SleepTableStore>();
                        final id = _lastSavedSleepId;
                        if (id != null) {
                          () async {
                            try {
                              await deps.restClient.sleepCry
                                  .deleteSleepCrySleepDeleteStats(dto: SleepcryDeleteSleepDto(id: id));
                            } catch (_) {}
                            // Удаляем из локального списка
                            sleepTableStore.listData.removeWhere((e) => e.id == id);
                            setState(() {});
                          }();
                        }
                        _lastSavedSleepId = null;
                        widget.store.goBackAndContinue();
                      },
                      onTapNote: () {
                        context.pushNamed(AppViews.addNote);
                      },
                    )
                  : const SizedBox(),
              isSleepingCanceled
                  ? TrackerStateContainer(
                      type: ContainerType.sleepingCanceled,
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
