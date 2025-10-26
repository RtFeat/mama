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
import 'package:mama/src/feature/trackers/widgets/edit_feeding_breast_body.dart';
import 'package:skit/skit.dart';

class EditFeedingBreastManually extends StatefulWidget {
  final EntityFeeding existingRecord;
  final BreastFeedingTableStore? store;
  
  const EditFeedingBreastManually({super.key, required this.existingRecord, this.store});

  @override
  State<EditFeedingBreastManually> createState() =>
      _EditFeedingBreastManuallyState();
}

class _EditFeedingBreastManuallyState extends State<EditFeedingBreastManually> {
  late FormGroup formGroup;
  bool _isInitialized = false;
  bool _timeChanged = false;
  
  // Хранение текущих значений времени
  DateTime? _currentStartTime;
  DateTime? _currentEndTime;
  
  // Экземпляр AddFeeding - создается один раз
  AddFeeding? _editAddFeeding;

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

  String _minutesToString(int minutes) {
    if (minutes == 0) return '';
    return '${minutes}м';
  }

  void _refreshBreastFeedingHistory() {
    try {
      // Use the passed store or try to find it in the widget tree
      final store = widget.store ?? context.read<BreastFeedingTableStore>();
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
    
    // Инициализируем форму только один раз с данными существующей записи
    if (!_isInitialized) {
      print('EditFeeding: Initializing with record data:');
      print('  - timeToEnd: ${widget.existingRecord.timeToEnd}');
      print('  - allFeeding: ${widget.existingRecord.allFeeding}');
      print('  - leftFeeding: ${widget.existingRecord.leftFeeding}');
      print('  - rightFeeding: ${widget.existingRecord.rightFeeding}');
      
      final endTime = DateTime.tryParse(widget.existingRecord.timeToEnd ?? '');
      if (endTime == null) {
        print('EditFeeding: Failed to parse timeToEnd, using current time');
        final now = DateTime.now();
        _currentStartTime = now;
        _currentEndTime = now;
        formGroup.control('feedingBreastStart').value = DateFormat('HH:mm').format(now);
        formGroup.control('feedingBreastEnd').value = DateFormat('HH:mm').format(now);
      } else {
        final startTime = endTime.subtract(Duration(minutes: widget.existingRecord.allFeeding ?? 0));
        _currentStartTime = startTime;
        _currentEndTime = endTime;
        
        print('EditFeeding: Calculated times - Start: ${DateFormat('HH:mm').format(startTime)}, End: ${DateFormat('HH:mm').format(endTime)}');
        
        formGroup.control('feedingBreastStart').value = DateFormat('HH:mm').format(startTime);
        formGroup.control('feedingBreastEnd').value = DateFormat('HH:mm').format(endTime);
      }
      
      // Создаем экземпляр AddFeeding один раз
      final userStore = context.read<UserStore>();
      final dependencies = context.read<Dependencies>();
      final noteStore = context.read<AddNoteStore>();
      
      _editAddFeeding = AddFeeding(
        childId: userStore.selectedChild!.id!,
        restClient: dependencies.restClient,
        noteStore: noteStore,
      );
      
      // Устанавливаем время
      _editAddFeeding!.timerStartTime = _currentStartTime!;
      _editAddFeeding!.timerEndTime = _currentEndTime!;
      _editAddFeeding!.startTimeManuallySet = true;
      _editAddFeeding!.endTimeManuallySet = true;
      
      print('EditFeeding: Initialized editAddFeeding - Start: ${DateFormat('HH:mm').format(_currentStartTime!)}, End: ${DateFormat('HH:mm').format(_currentEndTime!)}');
      
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Проверяем что инициализация завершена
    if (!_isInitialized || _editAddFeeding == null || _currentStartTime == null || _currentEndTime == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final noteStore = context.read<AddNoteStore>();

    return Provider(
      create: (_) => AddManually(),
      dispose: (_, AddManually value) => value.dispose(),
      builder: (context, _) {
        // Предзаполняем данные из существующей записи
        final manualInput = context.read<AddManually>();
        manualInput.left.value = _minutesToString(widget.existingRecord.leftFeeding ?? 0);
        manualInput.right.value = _minutesToString(widget.existingRecord.rightFeeding ?? 0);
        
        // Предзаполняем заметку
        if (widget.existingRecord.notes != null && widget.existingRecord.notes!.isNotEmpty) {
          noteStore.setContent(widget.existingRecord.notes!);
        }

        // Пробрасываем setState для обновления UI при изменении времени
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return ReactiveForm(
              formGroup: formGroup,
              child: BodyEditFeedingBreastManually(
              stopIfStarted: () {},
             timerManualStart: _currentStartTime!,
             timerManualEnd: _currentEndTime!,
            formControlNameEnd: 'feedingBreastEnd',
            formControlNameStart: 'feedingBreastStart',
            isTimerStart: false,
             onStartTimeChanged: (v) {
               if (v != null && v is String) {
                 print('Start time changed to: $v');
                 try {
                   final time = DateFormat('HH:mm').parse(v);
                   
                   // Используем текущую дату начала как базу, меняем только время
                   final newStartTime = DateTime(
                     _currentStartTime!.year,
                     _currentStartTime!.month,
                     _currentStartTime!.day,
                     time.hour,
                     time.minute,
                   );
                   
                   // Если новое время начала позже времени окончания, уменьшаем дату начала на 1 день
                   if (newStartTime.isAfter(_currentEndTime!)) {
                     _currentStartTime = newStartTime.subtract(const Duration(days: 1));
                   } else {
                     _currentStartTime = newStartTime;
                   }
                   
                    // Обновляем в editAddFeeding
                    _editAddFeeding!.timerStartTime = _currentStartTime!;
                    _editAddFeeding!.startTimeManuallySet = true;
                    _timeChanged = true;
                    setState(() {}); // Обновляем UI
                    
                    print('Updated start time to: ${DateFormat('HH:mm').format(_currentStartTime!)}');
                    print('Full start DateTime: $_currentStartTime');
                 } catch (e) {
                   print('Error parsing start time: $e');
                 }
               }
             },
             onEndTimeChanged: (v) {
               if (v != null && v is String) {
                 print('End time changed to: $v');
                 try {
                   final time = DateFormat('HH:mm').parse(v);
                   
                   // Используем текущую дату конца как базу, меняем только время
                   final newEndTime = DateTime(
                     _currentEndTime!.year,
                     _currentEndTime!.month,
                     _currentEndTime!.day,
                     time.hour,
                     time.minute,
                   );
                   
                   // Если новое время окончания раньше времени начала, увеличиваем дату конца на 1 день
                   if (newEndTime.isBefore(_currentStartTime!)) {
                     _currentEndTime = newEndTime.add(const Duration(days: 1));
                   } else {
                     _currentEndTime = newEndTime;
                   }
                   
                    // Обновляем в editAddFeeding
                    _editAddFeeding!.timerEndTime = _currentEndTime!;
                    _editAddFeeding!.endTimeManuallySet = true;
                    _timeChanged = true;
                    setState(() {}); // Обновляем UI
                    
                    print('Updated end time to: ${DateFormat('HH:mm').format(_currentEndTime!)}');
                    print('Full end DateTime: $_currentEndTime');
                 } catch (e) {
                   print('Error parsing end time: $e');
                 }
               }
             },
            onTapNotes: () {
              // Переходим к редактированию заметки
              final router = GoRouter.of(context);
              router.pushNamed(AppViews.addNote, extra: {
                'initialValue': widget.existingRecord.notes ?? '',
                'onSaved': (String value) {
                  // Сохраняем заметку в AddNoteStore
                  noteStore.setContent(value);
                },
              });
            },
            onTapConfirm: () async {
              // Используем текущие сохраненные значения времени
              _editAddFeeding!.timerEndTime ??= DateTime.now();
              
              // Get manual input values from the form
              final AddManually manualInput = context.read<AddManually>();
              final leftValue = manualInput.left.value as String? ?? '';
              final rightValue = manualInput.right.value as String? ?? '';
              
              // Parse manual input values (format: "20м 0с" or "20м")
              int? manualLeftMinutes;
              int? manualRightMinutes;
              
               try {
                 // First, try to parse manual input values
                 manualLeftMinutes = _parseMinutesFromString(leftValue);
                 manualRightMinutes = _parseMinutesFromString(rightValue);
                 
                 // If time was changed (start or end), always use total time distribution
                 if (_timeChanged) {
                   // Calculate total time from start and end times
                   final startTime = _currentStartTime!;
                   final endTime = _currentEndTime!;
                   
                   print('Feeding: Using times from editAddFeeding - Start: ${DateFormat('HH:mm').format(startTime)}, End: ${DateFormat('HH:mm').format(endTime)}');
                   print('Feeding: Full start time: $startTime');
                   print('Feeding: Full end time: $endTime');
                   
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
                     
                     print('Feeding: Edit form time changed - Total: ${totalMinutes}min, Left: ${manualLeftMinutes}min, Right: ${manualRightMinutes}min');
                   }
                 } else if (manualLeftMinutes == 0 && manualRightMinutes == 0) {
                   // If time wasn't changed and both values are 0, distribute total time equally
                   final startTime = _currentStartTime!;
                   final endTime = _currentEndTime!;
                   
                   Duration duration = endTime.difference(startTime);
                   if (duration.isNegative) {
                     duration = duration + const Duration(days: 1);
                   }
                   
                   final totalMinutes = duration.inMinutes;
                   if (totalMinutes > 0) {
                     final halfTime = totalMinutes ~/ 2;
                     manualLeftMinutes = halfTime;
                     manualRightMinutes = totalMinutes - halfTime;
                     
                     print('Feeding: Edit form auto-distribution - Total: ${totalMinutes}min, Left: ${manualLeftMinutes}min, Right: ${manualRightMinutes}min');
                   }
                 } else {
                   print('Feeding: Edit form using manual values - Left: ${manualLeftMinutes}min, Right: ${manualRightMinutes}min');
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
                // Обновляем существующую запись используя актуальное время
                await _editAddFeeding!.updateFeedingStats(
                  widget.existingRecord.id!,
                  manualLeftMinutes ?? 0,
                  manualRightMinutes ?? 0,
                  _currentEndTime!,
                );
                
                // Обновляем заметку если она изменилась
                final currentNote = noteStore.content?.trim() ?? '';
                final originalNote = widget.existingRecord.notes?.trim() ?? '';
                if (currentNote != originalNote) {
                  await _editAddFeeding!.updateFeedingNotes(widget.existingRecord.id!, currentNote);
                }
                
                if (context.mounted) {
                  // Обновляем историю после успешного обновления
                  _refreshBreastFeedingHistory();
                  context.pop(true); // Возвращаем true для индикации успешного обновления
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Не удалось обновить запись, попробуйте позже')),
                  );
                }
              }
            },
            titleIfEditNotComplete: t.feeding.ifEditNotCompleteFeed.title,
            textIfEditNotComplete: t.feeding.ifEditNotCompleteFeed.text,
            bodyWidget: const ManuallyInputContainer(),
            needIfEditNotCompleteMessage: true,
          ),
        );
          },
        );
      },
    );
  }
}