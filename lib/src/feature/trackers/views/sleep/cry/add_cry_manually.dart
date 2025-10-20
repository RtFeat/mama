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
  const AddCryManuallyView({super.key, this.existingRecord});
  
  final EntityCry? existingRecord;

  @override
  State<AddCryManuallyView> createState() => _AddCryManuallyViewState();
}

class _AddCryManuallyViewState extends State<AddCryManuallyView> {
  @override
  void initState() {
    super.initState();
    final cryStore = context.read<CryStore>();
    
    // Если редактируем существующую запись, инициализируем поля
    if (widget.existingRecord != null) {
      final record = widget.existingRecord!;
      
      // Сбрасываем состояние store перед редактированием (как в Sleep)
      cryStore.resetWithoutSaving();

      // Парсим время начала и окончания
      final startTime = _parseDateTime(record.timeToStart);
      final endTime = _parseDateTime(record.timeEnd);
      
      // Устанавливаем времена в store
      cryStore.updateStartTime(startTime);
      cryStore.updateEndTime(endTime);
      
      // Устанавливаем значения в форму
      cryStore.formGroup.control('cryStart').value = DateFormat('HH:mm').format(startTime);
      cryStore.formGroup.control('cryEnd').value = DateFormat('HH:mm').format(endTime);
    } else {
      // Инициализируем timerEndTime для ручного режима
      if (cryStore.timerEndTime == null) {
        // Устанавливаем timerEndTime равным timerStartTime, чтобы total был 0
        final now = DateTime.now();
        cryStore.timerEndTime = now;
        cryStore.timerStartTime = now;
      }
    }
  }

  DateTime _parseDateTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return DateTime.now();
    final String s = timeString.trim();

    // HH:mm
    final parts = s.split(':');
    if (parts.length == 2 && int.tryParse(parts[0]) != null && int.tryParse(parts[1]) != null) {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    }

    // ISO 8601
    try {
      return DateTime.parse(s);
    } catch (_) {}

    return DateTime.now();
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
          isCryMode: true,
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
            
            final childId = userStore.selectedChild!.id!;
            
            try {
              if (widget.existingRecord != null) {
                // Редактируем существующую запись
                final recordId = widget.existingRecord!.id;
                if (recordId != null) {
                  await cryStore.update(recordId, childId, noteStore.content);
                } else {
                  throw Exception('ID записи не найден');
                }
              } else {
                // Создаем новую запись
                await cryStore.add(childId, noteStore.content);
              }
            
              // Обновляем Stories для плача
              if (context.mounted) {
                final cryTableStore = context.read<CryTableStore>();
                cryTableStore.resetPagination();
                cryTableStore.loadPage(newFilters: [
                  SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                ]);
                
                // Сбросить таймерные значения (Start/End/Total) после подтверждения
                cryStore.resetWithoutSaving();
                
                // Также сбрасываем состояние SleepStore, чтобы избежать конфликта с таймером Sleep
                try {
                  final sleepStore = context.read<SleepStore>();
                  sleepStore.resetWithoutSaving();
                } catch (_) {
                  // SleepStore может быть недоступен на этом роуте
                }
                
                context.pop(true);
              }
            } catch (e) {
              // Показываем ошибку пользователю
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка при сохранении: ${e.toString()}')),
                );
              }
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


