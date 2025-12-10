import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry.dart';

class AddSleepingView extends StatefulWidget {
  const AddSleepingView({super.key, this.existingRecord});
  
  final EntitySleep? existingRecord;

  @override
  State<AddSleepingView> createState() => _AddSleepingViewState();
}

class _AddSleepingViewState extends State<AddSleepingView> {
  @override
  void initState() {
    final addSleeping = context.read<SleepStore>();
    
    // Если редактируем существующую запись, инициализируем поля
    if (widget.existingRecord != null) {
      final record = widget.existingRecord!;
      
      // Сбрасываем состояние store перед редактированием
      addSleeping.resetWithoutSaving();
      
      // Парсим время начала и окончания
      final startTime = _parseDateTime(record.timeToStart);
      final endTime = _parseDateTime(record.timeEnd);
      
      // Устанавливаем времена в store
      addSleeping.updateStartTime(startTime);
      addSleeping.updateEndTime(endTime);
      
      // Устанавливаем значения в форму
      addSleeping.formGroup.control('sleepStart').value = DateFormat('HH:mm').format(startTime);
      addSleeping.formGroup.control('sleepEnd').value = DateFormat('HH:mm').format(endTime);
    } else {
      // Инициализируем timerEndTime для ручного режима
      if (addSleeping.timerEndTime == null) {
        addSleeping.timerEndTime = DateTime.now();
      }
      
      // Устанавливаем текущее время в форму для новых записей
      final now = DateTime.now();
      addSleeping.updateStartTime(now);
      addSleeping.updateEndTime(now);
      addSleeping.formGroup.control('sleepStart').value = DateFormat('HH:mm').format(now);
      addSleeping.formGroup.control('sleepEnd').value = DateFormat('HH:mm').format(now);
    }
    
    super.initState();
  }

  @override
  void dispose() {
    // Сбрасываем состояние CryStore при выходе без сохранения
    try {
      final cryStore = context.read<CryStore>();
      cryStore.resetWithoutSaving();
    } catch (_) {
      // CryStore может быть недоступен на этом роуте
    }
    
    super.dispose();
  }

  DateTime _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null) return DateTime.now();
    try {
      if (dateTimeString.contains('T')) {
        return DateTime.parse(dateTimeString);
      } else if (dateTimeString.contains(' ')) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
      } else if (dateTimeString.contains(':')) {
        // Если это только время в формате HH:mm, создаем дату на сегодня
        final timeParts = dateTimeString.split(':');
        if (timeParts.length == 2) {
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final now = DateTime.now();
          return DateTime(now.year, now.month, now.day, hour, minute);
        }
      } else {
        return DateFormat('yyyy-MM-dd').parse(dateTimeString);
      }
    } catch (_) {
      return DateTime.now();
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final SleepStore addSleeping = context.watch<SleepStore>();
    final UserStore userStore = context.watch<UserStore>();
    final AddNoteStore noteStore = context.watch<AddNoteStore>();

    return ReactiveForm(
      formGroup: addSleeping.formGroup,
      child: BodyAddManuallySleepCryFeeding(
        stopIfStarted: () {
          addSleeping.cancelSleeping();
        },
        needIfEditNotCompleteMessage: true,
        timerManualStart: addSleeping.timerStartTime,
        timerManualEnd: addSleeping.timerEndTime,
        formControlNameEnd: 'sleepEnd',
        formControlNameStart: 'sleepStart',
        isCryMode: false,
        onStartTimeChanged: (v) {
          if (v != null && v.timeToDateTime != null) {
            final now = DateTime.now();
            addSleeping.updateStartTime(v.timeToDateTime!
                .copyWith(year: now.year, month: now.month, day: now.day));
          }
        },
        onEndTimeChanged: (v) {
          if (v != null && v.timeToDateTime != null) {
            final now = DateTime.now();
            addSleeping.updateEndTime(v.timeToDateTime!
                .copyWith(year: now.year, month: now.month, day: now.day));
          }
        },
        isTimerStart: addSleeping.timerSleepStart,
        onTapNotes: () {
          context.pushNamed(AppViews.addNote);
        },
        onTapConfirm: () async {
          final childId = userStore.selectedChild!.id!;
          
          try {
            if (widget.existingRecord != null) {
              // Редактируем существующую запись
              final recordId = widget.existingRecord!.id;
              if (recordId != null) {
                await addSleeping.update(recordId, childId, noteStore.content);
              } else {
                throw Exception('ID записи не найден');
              }
            } else {
              // Создаем новую запись
              await addSleeping.add(childId, noteStore.content);
            }
            
            // Обновляем Stories для сна
            if (context.mounted) {
              final sleepTableStore = context.read<SleepTableStore>();
              sleepTableStore.resetPagination();
              sleepTableStore.loadPage(newFilters: [
                SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
              ]);
              
              // Сбросить таймерные значения (Start/End/Total) после подтверждения
              addSleeping.resetWithoutSaving();
              
              // Также сбрасываем состояние CryStore, чтобы избежать конфликта с таймером Cry
              try {
                final cryStore = context.read<CryStore>();
                cryStore.resetWithoutSaving();
              } catch (_) {
                // CryStore может быть недоступен на этом роуте
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
        titleIfEditNotComplete: t.trackers.ifEditNotCompleteSleep.title,
        textIfEditNotComplete: t.trackers.ifEditNotCompleteSleep.text,
        bodyWidget: BodyCommentSleep(
          titleAddNewManual: t.trackers.addNewManualSleep.title,
          textAddNewManual: t.trackers.addNewManualSleep.text,
        ),
      ),
    );
  }
}

class BodyCommentSleep extends StatelessWidget {
  final String titleAddNewManual;
  final String textAddNewManual;
  const BodyCommentSleep(
      {super.key,
      required this.titleAddNewManual,
      required this.textAddNewManual});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.greyColor, width: 1)),
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
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 14, color: AppColors.greyBrighterColor),
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
