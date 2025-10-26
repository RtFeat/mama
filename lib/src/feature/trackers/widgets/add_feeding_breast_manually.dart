import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:mama/src/feature/trackers/state/add_manually.dart';
import 'package:mama/src/feature/trackers/state/feeding/breast_feeding_table_store.dart';
import 'package:mama/src/feature/notes/state/add_note.dart';
import 'package:skit/skit.dart';

class AddFeedingBreastManually extends StatefulWidget {
  const AddFeedingBreastManually({super.key});

  @override
  State<AddFeedingBreastManually> createState() =>
      _AddFeedingBreastManuallyState();
}

class _AddFeedingBreastManuallyState extends State<AddFeedingBreastManually> {
  late FormGroup formGroup;
  bool _isInitialized = false; // Флаг для однократной инициализации

  @override
  void initState() {
    formGroup = FormGroup({
      'feedingBreastStart': FormControl<String>(),
      'feedingBreastEnd': FormControl<String>(),
    });
    super.initState();
  }

  @override
  void dispose() {
    formGroup.dispose();
    super.dispose();
  }

  int _parseMinutesFromString(String timeString) {
    if (timeString.isEmpty) return 0;
    
    // Handle formats like "20м 0с", "20м", "0м 30с"
    final minutesMatch = RegExp(r'(\d+)м').firstMatch(timeString);
    final secondsMatch = RegExp(r'(\d+)с').firstMatch(timeString);
    
    final minutes = minutesMatch != null ? int.parse(minutesMatch.group(1)!) : 0;
    final seconds = secondsMatch != null ? int.parse(secondsMatch.group(1)!) : 0;
    
    // Convert seconds to minutes (round up if there are any seconds)
    return minutes + (seconds > 0 ? 1 : 0);
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
      print('Could not refresh breast feeding history: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Инициализируем форму только один раз
    if (!_isInitialized) {
      final AddFeeding addFeeding = context.read<AddFeeding>();
      formGroup.control('feedingBreastStart').value =
          DateFormat('HH:mm').format(addFeeding.timerStartTime);
      formGroup.control('feedingBreastEnd').value =
          DateFormat('HH:mm').format(addFeeding.timerEndTime ?? DateTime.now());
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AddFeeding addFeeding = context.watch<AddFeeding>();
  
  // Обновляем только если пользователь не вводил время вручную
  if (!addFeeding.startTimeManuallySet) {
    formGroup.control('feedingBreastStart').value =
        DateFormat('HH:mm').format(addFeeding.timerStartTime);
  }
  if (!addFeeding.endTimeManuallySet) {
    formGroup.control('feedingBreastEnd').value =
        DateFormat('HH:mm').format(addFeeding.timerEndTime ?? DateTime.now());
  }
    return Provider(
      create: (_) => AddManually(),
      dispose: (_, AddManually value) => value.dispose(),
      builder: (context, _) => ReactiveForm(
        formGroup: formGroup,
        child: BodyAddManuallySleepCryFeeding(
          stopIfStarted: () {},
          timerManualStart: addFeeding.timerStartTime,
          timerManualEnd: addFeeding.timerEndTime,
          formControlNameEnd: 'feedingBreastEnd',
          formControlNameStart: 'feedingBreastStart',
          isCryMode: false,
          onTapNotes: () {
            // Переходим к редактированию заметки
            final router = GoRouter.of(context);
            router.pushNamed(AppViews.addNote, extra: {
              'initialValue': '',
              'onSaved': (String value) {
                // Сохраняем заметку в AddNoteStore
                final noteStore = context.read<AddNoteStore>();
                noteStore.setContent(value);
              },
            });
          },
          onStartTimeChanged: (v) {
            final value = formGroup.control('feedingBreastStart').value;
            if (v != null && v is String) {
              print('Start time changed to: $v');
              addFeeding.setTimeStartManually(v);
            }
          },
          onEndTimeChanged: (v) {
            // ИСПОЛЬЗУЕМ ПАРАМЕТР v НАПРЯМУЮ, а не читаем из formGroup!
            if (v != null && v is String) {
              print('End time changed to: $v');
              addFeeding.setTimeEndManually(v);
            }
          },
          isTimerStart: addFeeding.isRightSideStart == true
              ? true
              : addFeeding.isLeftSideStart == true
                  ? true
                  : false,
          onTapConfirm: () async {
            // Если конец не выбран, зафиксируем текущий момент
            addFeeding.timerEndTime ??= DateTime.now();
            
            // Get manual input values from the form
            final AddManually manualInput = context.read<AddManually>();
            final leftValue = manualInput.left.value as String? ?? '';
            final rightValue = manualInput.right.value as String? ?? '';
            
            // Parse manual input values (format: "20м 0с" or "20м")
            int? manualLeftMinutes;
            int? manualRightMinutes;
            
            try {
              manualLeftMinutes = _parseMinutesFromString(leftValue);
              manualRightMinutes = _parseMinutesFromString(rightValue);
              
              // If both values are 0 or empty, distribute total time equally
              if (manualLeftMinutes == 0 && manualRightMinutes == 0) {
                // Calculate total time from start and end times
                final startTime = addFeeding.timerStartTime;
                final endTime = addFeeding.timerEndTime;
                
                if (endTime != null) {
                  Duration duration = endTime.difference(startTime);
                  // If end time is before start time, it means it's the next day
                  if (duration.isNegative) {
                    duration = duration + const Duration(days: 1);
                  }
                  
                  final totalMinutes = duration.inMinutes;
                  if (totalMinutes > 0) {
                    // Distribute equally between left and right sides
                    final halfTime = totalMinutes ~/ 2;
                    manualLeftMinutes = halfTime;
                    manualRightMinutes = totalMinutes - halfTime;
                    
                    print('Feeding: Manual form auto-distribution - Total: ${totalMinutes}min, Left: ${manualLeftMinutes}min, Right: ${manualRightMinutes}min');
                  }
                }
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Проверьте правильность ввода времени')),
                );
              }
              return;
            }
            
            try {
              // Проверяем, есть ли заметка в AddNoteStore
              final noteStore = context.read<AddNoteStore>();
              final noteContent = noteStore.content;
              print('Manual feeding: Note content from AddNoteStore: "$noteContent"');
              
              await addFeeding.addFeeding(
                manualLeftMinutes: manualLeftMinutes,
                manualRightMinutes: manualRightMinutes,
              );
              // После успешного сохранения полностью сбрасываем состояние и останавливаем таймеры
              addFeeding.resetWithoutSaving();
              if (context.mounted) {
                // Обновляем историю после успешного добавления
                _refreshBreastFeedingHistory();
                context.pop(true); // Возвращаем true для индикации успешного добавления
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Не удалось сохранить запись, попробуйте позже')),
                );
              }
            }
          },
          titleIfEditNotComplete: t.feeding.ifEditNotCompleteFeed.title,
          textIfEditNotComplete: t.feeding.ifEditNotCompleteFeed.text,
          bodyWidget: const ManuallyInputContainer(),
          needIfEditNotCompleteMessage: true,
        ),
      ),
    );
    // });
  }
}
