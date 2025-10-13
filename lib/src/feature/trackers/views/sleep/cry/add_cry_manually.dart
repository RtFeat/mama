import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry.dart';
import 'package:mama/src/feature/trackers/state/sleep/sleep.dart';
import 'package:mama/src/core/api/models/entity_cry.dart';

class AddCryManuallyView extends StatefulWidget {
  const AddCryManuallyView({super.key});

  @override
  State<AddCryManuallyView> createState() => _AddCryManuallyViewState();
}

class _AddCryManuallyViewState extends State<AddCryManuallyView> {
  @override
  void initState() {
    super.initState();
    // Инициализируем timerEndTime для ручного режима
    final cryStore = context.read<CryStore>();
    if (cryStore.timerEndTime == null) {
      // Устанавливаем timerEndTime равным timerStartTime, чтобы total был 0
      final now = DateTime.now();
      cryStore.timerEndTime = now;
      cryStore.timerStartTime = now;
    }
  }

  @override
  void dispose() {
    // Сбрасываем состояние SleepStore при выходе без сохранения
    try {
      final sleepStore = context.read<SleepStore>();
      sleepStore.resetWithoutSaving();
    } catch (_) {
      // SleepStore может быть недоступен на этом роуте
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CryStore cryStore = context.watch<CryStore>();
    final UserStore userStore = context.watch<UserStore>();
    final AddNoteStore noteStore = context.watch<AddNoteStore>();
    final RestClient restClient = context.watch<Dependencies>().restClient;

    return ReactiveForm(
        formGroup: cryStore.formGroup,
        child: BodyAddManuallySleepCryFeeding(
          stopIfStarted: () {
            cryStore.cancelSleeping();
          },
          needIfEditNotCompleteMessage: true,
          timerManualStart: cryStore.timerStartTime,
          timerManualEnd: cryStore.timerEndTime,
          formControlNameEnd: 'cryEnd',
          formControlNameStart: 'cryStart',
          onStartTimeChanged: (v) {
            if (v != null && v.timeToDateTime != null) {
              final now = DateTime.now();
              final newStartTime = v.timeToDateTime!.copyWith(year: now.year, month: now.month, day: now.day);
              cryStore.updateStartTime(newStartTime);
              // Update form control value to reflect the change
              cryStore.formGroup.control('cryStart').value = 
                  DateFormat('HH:mm').format(newStartTime);
            } else if (v == null || v.timeToDateTime == null) {
              // Handle case when user clears the field - don't update the store
              // This prevents setting null values that cause issues
              return;
            }
          },
          onEndTimeChanged: (v) {
            if (v != null && v.timeToDateTime != null) {
              final now = DateTime.now();
              final newEndTime = v.timeToDateTime!.copyWith(year: now.year, month: now.month, day: now.day);
              cryStore.updateEndTime(newEndTime);
              // Update form control value to reflect the change
              cryStore.formGroup.control('cryEnd').value = 
                  DateFormat('HH:mm').format(newEndTime);
            } else if (v == null || v.timeToDateTime == null) {
              // Handle case when user clears the field - don't update the store
              // This prevents setting null values that cause issues
              return;
            }
          },
          isTimerStart: cryStore.timerSleepStart,
          onTapNotes: () {
            context.pushNamed(AppViews.addNote);
          },
          onTapConfirm: () async {
            if (cryStore.timerEndTime == null) {
              // Show error or return early
              return;
            }
            
            // Use the store's computed duration for consistency
            final duration = cryStore.timerEndTime!.difference(cryStore.timerStartTime);
            final minutes = duration.inMinutes.abs();
            final seconds = duration.inSeconds % 60;
            
            // Format duration string to match the UI display
            String durationString;
            if (minutes > 0) {
              durationString = '$minutes м';
              if (seconds > 0) {
                durationString += ' ${seconds}с';
              }
            } else {
              durationString = '${seconds}с';
            }

            final dto = SleepcryInsertCryDto(
              childId: userStore.selectedChild!.id,
              // API expects time_end in UTC with Z
              timeEnd: cryStore.timerEndTime?.toUtc().toIso8601String(),
              // Keep local HH:mm values for grouping on server
              timeToEnd: cryStore.timerEndTime?.formattedTime,
              timeToStart: cryStore.timerStartTime.formattedTime,
              allCry: durationString,
              notes: noteStore.content,
            );

            await restClient.sleepCry.postSleepCryCry(dto: dto);
            // Устанавливаем флаг, что запись была сохранена вручную
            cryStore.setManuallySaved(true);
            
            // Обновляем Stories сразу (если провайдер доступен на текущем роуте)
            CryTableStore? cryTableStore;
            
            // Попробуем найти CryTableStore через разные способы
            try {
              cryTableStore = context.read<CryTableStore>();
            } catch (e) {
              // Попробуем через Provider.of
              try {
                cryTableStore = Provider.of<CryTableStore>(context, listen: false);
              } catch (e2) {
                // Попробуем найти через родительский контекст
                try {
                  final parentContext = context.findAncestorStateOfType<State>();
                  if (parentContext != null) {
                    cryTableStore = Provider.of<CryTableStore>(parentContext.context, listen: false);
                  }
                } catch (e3) {
                  cryTableStore = null;
                }
              }
            }
            
            if (cryTableStore != null) {
              // Оптимистично добавляем запись сразу в список для мгновенного отображения
              final optimisticRecord = EntityCry(
                id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
                childId: userStore.selectedChild!.id,
                timeToStart: cryStore.timerStartTime.formattedTime,
                timeToEnd: cryStore.timerEndTime?.formattedTime,
                timeEnd: cryStore.timerEndTime?.toUtc().toIso8601String(),
                allCry: durationString,
                notes: noteStore.content,
              );
              cryTableStore.listData.insert(0, optimisticRecord);
              
              // For cry history API we must pass from_time/to_time range
              final now = DateTime.now();
              final startOfMonth = DateTime(now.year, now.month, 1);
              final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

              // Фоново обновляем данные с сервера (Cry API не поддерживает from_time/to_time)
              Future.delayed(const Duration(milliseconds: 500), () {
                cryTableStore?.resetPagination();
                cryTableStore?.loadPage(newFilters: [
                  SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: userStore.selectedChild!.id),
                ]);
              });
            } else {
              // Если CryTableStore недоступен, попробуем найти его через другие способы
              
              // Попробуем найти CryTableStore через Provider.of с listen: false
              try {
                final alternativeStore = Provider.of<CryTableStore>(context, listen: false);
                
                // Добавляем оптимистичную запись
                final optimisticRecord = EntityCry(
                  id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
                  childId: userStore.selectedChild!.id,
                  timeToStart: cryStore.timerStartTime.formattedTime,
                  timeToEnd: cryStore.timerEndTime?.formattedTime,
                  timeEnd: cryStore.timerEndTime?.toUtc().toIso8601String(),
                  allCry: durationString,
                  notes: noteStore.content,
                );
                alternativeStore.listData.insert(0, optimisticRecord);
                
              } catch (e) {
                // Последняя попытка - создать новый экземпляр
                try {
                  final deps = context.read<Dependencies>();
                  final newCryTableStore = CryTableStore(
                    apiClient: deps.apiClient,
                    restClient: deps.restClient,
                    faker: deps.faker,
                    userStore: context.read<UserStore>(),
                  );
                  
                  // Загружаем данные с сервера (Cry API не поддерживает from_time/to_time)
                  newCryTableStore.loadPage(newFilters: [
                    SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: userStore.selectedChild!.id),
                  ]);
                } catch (e2) {
                  // Игнорируем ошибки
                }
              }
            }
            // Сбросить таймерные значения (Start/End/Total) после подтверждения
            cryStore.resetWithoutSaving();
            
            // Также сбрасываем состояние SleepStore, чтобы избежать конфликта с таймером Sleep
            try {
              final sleepStore = context.read<SleepStore>();
              sleepStore.resetWithoutSaving();
            } catch (_) {
              // SleepStore может быть недоступен на этом роуте
            }
            
            // Передаем результат обратно, чтобы родительский экран мог обновить данные
            if (context.mounted) {
              context.pop(true); // true означает, что запись была добавлена
            }
          },
          titleIfEditNotComplete: t.trackers.ifEditNotCompleteCry.title,
          textIfEditNotComplete: t.trackers.ifEditNotCompleteCry.text,
          bodyWidget: BodyCommentCry(
            titleAddNewManual: t.trackers.addNewManualCry.title,
            textAddNewManual: t.trackers.addNewManualCry.text,
          ),
        ),
      );
  }
}

class BodyCommentCry extends StatelessWidget {
  final String titleAddNewManual;
  final String textAddNewManual;
  const BodyCommentCry({super.key, required this.titleAddNewManual, required this.textAddNewManual});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              titleAddNewManual,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 20, color: AppColors.greyBrighterColor),
            ),
            16.h,
            Row(
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.center,
                    textAddNewManual,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 14, color: AppColors.greyBrighterColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


