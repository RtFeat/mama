import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:mama/src/data.dart';
import 'package:dio/dio.dart';
import 'package:mama/src/feature/notes/state/add_note.dart';

part 'add_feeding.g.dart';

class AddFeeding extends _AddFeeding with _$AddFeeding {
  AddFeeding({
    required this.childId,
    required this.restClient,
    required this.noteStore,
  });

  final String childId;
  final RestClient restClient;
  final AddNoteStore noteStore;
}

abstract class _AddFeeding with Store {
  @observable
  bool isRightSideStart = false;

  @observable
  bool isLeftSideStart = false;

  @observable
  bool confirmFeedingTimer = false;

  @observable
  bool isFeedingCanceled = false;

  @observable
  bool showEditMenu = false;

  @observable
  DateTime timerStartTime = DateTime.now();

  @observable
  DateTime? timerEndTime = DateTime.now();
  
  @observable
  bool endTimeManuallySet = false;

  @observable
  bool startTimeManuallySet = false;

  // Timer fields for left side
  @observable
  DateTime? leftPauseTime;

  @observable
  DateTime? leftTimerStartTime;

  @observable
  DateTime? leftOriginalStartTime;

  @observable
  String leftCurrentTimerText = '00:00';

  @observable
  DateTime? leftLastUpdateTime;

  @observable
  bool leftIsUpdating = false;

  @observable
  DateTime? leftSystemTimeChangeDetected;

  @observable
  bool leftIsManuallySaved = false;

  // Timer fields for right side
  @observable
  DateTime? rightPauseTime;

  @observable
  DateTime? rightTimerStartTime;

  @observable
  DateTime? rightOriginalStartTime;

  @observable
  String rightCurrentTimerText = '00:00';

  @observable
  DateTime? rightLastUpdateTime;

  @observable
  bool rightIsUpdating = false;

  @observable
  DateTime? rightSystemTimeChangeDetected;

  @observable
  bool rightIsManuallySaved = false;

  @observable
  String? savedRecordId;

  @action
  changeStatusOfRightSide() {
    confirmFeedingTimer = false;
    showEditMenu = true;
    
    if (!isRightSideStart) {
      // Start right side timer
      isRightSideStart = true;
      // Stop left side if running and set pause timestamp to freeze its value
      if (isLeftSideStart) {
        isLeftSideStart = false;
        leftPauseTime = DateTime.now();
      }
      
      if (rightPauseTime != null) {
        // Resuming from pause - adjust start time to account for paused duration
        final pausedDuration = DateTime.now().difference(rightPauseTime!);
        rightTimerStartTime = rightTimerStartTime!.add(pausedDuration);
        // Don't change rightTimerStartTime when resuming - keep original start time
      } else {
        // Fresh start - save original start time only if not set
        if (rightOriginalStartTime == null) {
          rightTimerStartTime = DateTime.now();
          rightOriginalStartTime = rightTimerStartTime;
        } else {
          // If rightOriginalStartTime is already set, use it as rightTimerStartTime
          rightTimerStartTime = rightOriginalStartTime!;
        }
        // Save the actual start time for total calculation
        rightTimerStartTime = rightTimerStartTime;
      }
      rightPauseTime = null;
      timerEndTime = null; // Show infinity when running
      endTimeManuallySet = false;
      startTimeManuallySet = false;
    } else {
      // Pause right side timer
      isRightSideStart = false;
      rightPauseTime = DateTime.now();
    }
    // Refresh both displays to immediately reflect the switch
    updateRightTimerDisplay();
    updateLeftTimerDisplay();
  }

  @action
  setTimeStartManually(String value) {
    DateFormat format = DateFormat('HH:mm');
    if (value.length == 5) {
      final DateTime parsed = format.parse(value);
      final now = DateTime.now();
      timerStartTime = parsed.copyWith(year: now.year, month: now.month, day: now.day);
      startTimeManuallySet = true;
    }
  }

  @action
  setTimeEndManually(String value) {
    DateFormat format = DateFormat('HH:mm');
    if (value.length == 5) {
      final DateTime parsed = format.parse(value);
      final now = DateTime.now();
      timerEndTime = parsed.copyWith(year: now.year, month: now.month, day: now.day);
      endTimeManuallySet = true;
    }
  }

  @action
  changeStatusOfLeftSide() {
    confirmFeedingTimer = false;
    showEditMenu = true;
    
    if (!isLeftSideStart) {
      // Start left side timer
      isLeftSideStart = true;
      // Stop right side if running and set pause timestamp to freeze its value
      if (isRightSideStart) {
        isRightSideStart = false;
        rightPauseTime = DateTime.now();
      }
      
      if (leftPauseTime != null) {
        // Resuming from pause - adjust start time to account for paused duration
        final pausedDuration = DateTime.now().difference(leftPauseTime!);
        leftTimerStartTime = leftTimerStartTime!.add(pausedDuration);
        // Don't change leftTimerStartTime when resuming - keep original start time
      } else {
        // Fresh start - save original start time only if not set
        if (leftOriginalStartTime == null) {
          leftTimerStartTime = DateTime.now();
          leftOriginalStartTime = leftTimerStartTime;
        } else {
          // If leftOriginalStartTime is already set, use it as leftTimerStartTime
          leftTimerStartTime = leftOriginalStartTime!;
        }
        // Save the actual start time for total calculation
        leftTimerStartTime = leftTimerStartTime;
      }
      leftPauseTime = null;
      timerEndTime = null; // Show infinity when running
      endTimeManuallySet = false;
      startTimeManuallySet = false;
    } else {
      // Pause left side timer
      isLeftSideStart = false;
      leftPauseTime = DateTime.now();
    }
    // Refresh both displays to immediately reflect the switch
    updateLeftTimerDisplay();
    updateRightTimerDisplay();
  }

  @action
  confirmButtonPressed() async {
    // Останавливаем обе стороны
    isRightSideStart = false;
    isLeftSideStart = false;
    // Скрываем редактор как в Sleep и показываем контейнер состояния
    showEditMenu = false;
    confirmFeedingTimer = true;
    // Фиксируем момент окончания
    final DateTime endMoment = DateTime.now();
    timerEndTime = endMoment;
    // Если какая-то сторона была без паузы, фиксируем ей pause к моменту Confirm
    leftPauseTime ??= endMoment;
    rightPauseTime ??= endMoment;
    // Зафиксируем отображаемый текущий таймер на обеих сторонах
    if (leftTimerStartTime != null) {
      // Если сторона была на паузе, используем момент паузы, а не Confirm
      final DateTime leftEffectiveEnd = leftPauseTime ?? endMoment;
      final duration = leftEffectiveEnd.difference(leftTimerStartTime!);
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      leftCurrentTimerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    if (rightTimerStartTime != null) {
      // Если сторона была на паузе, используем момент паузы, а не Confirm
      final DateTime rightEffectiveEnd = rightPauseTime ?? endMoment;
      final duration = rightEffectiveEnd.difference(rightTimerStartTime!);
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      rightCurrentTimerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @action
  goBackAndContinue() {
    confirmFeedingTimer = false;
    isFeedingCanceled = false;
    // Восстанавливаем состояние таймера
    showEditMenu = true;
    // Восстанавливаем состояние паузы - таймеры должны быть на паузе
    isLeftSideStart = false;
    isRightSideStart = false;
  }

  @action
  cancelFeeding() {
    isRightSideStart = false;
    isLeftSideStart = false;
    showEditMenu = false;
    isFeedingCanceled = true;
  }

  @action
  void setPausedEndToNow() {
    // Do not move end time after confirmation (total must be frozen)
    if (confirmFeedingTimer) return;
    // Do not override manually set End
    if (endTimeManuallySet) return;
    // Update end time to current device time when timers are paused
    if (!isLeftSideStart && !isRightSideStart) {
      timerEndTime = DateTime.now();
    }
  }

  @action
  cancelFeedingClose() async {
    // Сохраняем запись перед сбросом (если есть что сохранять)
    if (timerEndTime != null && savedRecordId == null && !leftIsManuallySaved && !rightIsManuallySaved) {
      try {
        await addFeeding();
        print('Feeding record saved on cancel close');
      } catch (e) {
        print('Error saving feeding record on cancel close: $e');
      }
    }
    
    isFeedingCanceled = false;
    showEditMenu = false;
    confirmFeedingTimer = false;
    
    // Reset all timer fields
    leftPauseTime = null;
    leftTimerStartTime = null;
    leftOriginalStartTime = null;
    leftCurrentTimerText = '00:00';
    leftLastUpdateTime = null;
    leftIsUpdating = false;
    leftSystemTimeChangeDetected = null;
    leftIsManuallySaved = false;
    
    rightPauseTime = null;
    rightTimerStartTime = null;
    rightOriginalStartTime = null;
    rightCurrentTimerText = '00:00';
    rightLastUpdateTime = null;
    rightIsUpdating = false;
    rightSystemTimeChangeDetected = null;
    rightIsManuallySaved = false;
    
    // Reset main timer
    timerStartTime = DateTime.now();
    timerEndTime = DateTime.now();
    endTimeManuallySet = false;
    startTimeManuallySet = false;
    savedRecordId = null; // Сбрасываем ID сохраненной записи
  }

  /// Полный сброс состояния без сохранения записи (поведение как в Sleep -> Cancel -> крестик)
  @action
  void resetWithoutSaving() {
    isFeedingCanceled = false;
    isRightSideStart = false;
    isLeftSideStart = false;
    showEditMenu = false;
    confirmFeedingTimer = false;

    leftPauseTime = null;
    leftTimerStartTime = null;
    leftOriginalStartTime = null;
    leftCurrentTimerText = '00:00';
    leftLastUpdateTime = null;
    leftIsUpdating = false;
    leftSystemTimeChangeDetected = null;
    leftIsManuallySaved = false;

    rightPauseTime = null;
    rightTimerStartTime = null;
    rightOriginalStartTime = null;
    rightCurrentTimerText = '00:00';
    rightLastUpdateTime = null;
    rightIsUpdating = false;
    rightSystemTimeChangeDetected = null;
    rightIsManuallySaved = false;

    timerStartTime = DateTime.now();
    timerEndTime = null;
    endTimeManuallySet = false;
    startTimeManuallySet = false;
    savedRecordId = null;
  }

  @action
  Future<void> finalSave() async {
    // Сохраняем запись только если есть время окончания и не была сохранена вручную
    if (timerEndTime != null && savedRecordId == null && !leftIsManuallySaved && !rightIsManuallySaved) {
      try {
        await addFeeding();
        print('Feeding record saved on final save');
        // Устанавливаем флаги после успешного сохранения
        leftIsManuallySaved = true;
        rightIsManuallySaved = true;
      } catch (e) {
        print('Error saving feeding record on final save: $e');
      }
    } else {
      print('Final save skipped - timerEndTime: $timerEndTime, savedRecordId: $savedRecordId, leftIsManuallySaved: $leftIsManuallySaved, rightIsManuallySaved: $rightIsManuallySaved');
    }
  }

  @action
  void updateLeftTimerDisplay() {
    // Stop updating after confirmation; total and per-side timers are frozen
    if (confirmFeedingTimer) {
      return;
    }
    // Предотвращаем одновременные обновления
    if (leftIsUpdating) return;
    
    try {
      leftIsUpdating = true;
      
      final now = DateTime.now();
      
      // Проверяем на резкое изменение системного времени
      if (leftLastUpdateTime != null) {
        final timeDiff = now.difference(leftLastUpdateTime!).inSeconds.abs();
        if (timeDiff > 5) { // Если разница больше 5 секунд - возможно изменили время
          leftSystemTimeChangeDetected = now;
          print('System time change detected in Left timer: $timeDiff seconds');
          // Не обновляем время при изменении системного времени
          leftLastUpdateTime = now; // Обновляем lastUpdateTime чтобы избежать повторных срабатываний
          return;
        }
      }
      
      // Дополнительная проверка - обновляем только если таймер действительно запущен
      if (!isLeftSideStart && leftPauseTime == null) {
        leftCurrentTimerText = '00:00';
        return;
      }

      if (!isLeftSideStart) {
        if (leftPauseTime != null && leftTimerStartTime != null) {
          // Show paused time - время с момента старта до паузы
          final duration = leftPauseTime!.difference(leftTimerStartTime!);
          final minutes = duration.inMinutes;
          final seconds = duration.inSeconds % 60;
          leftCurrentTimerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        } else {
          leftCurrentTimerText = '00:00';
        }
      } else {
        // Timer is running - show current elapsed time
        if (leftTimerStartTime != null) {
          final duration = now.difference(leftTimerStartTime!);
          final minutes = duration.inMinutes;
          final seconds = duration.inSeconds % 60;
          leftCurrentTimerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        } else {
          leftCurrentTimerText = '00:00';
        }
        
        // Don't set end time when running - show infinity
        timerEndTime = null;
      }
      
      leftLastUpdateTime = now;
    } catch (e) {
      // Если произошла ошибка, просто не обновляем время
      print('Error updating Left timer display: $e');
    } finally {
      leftIsUpdating = false;
    }
  }

  @action
  void updateRightTimerDisplay() {
    // Stop updating after confirmation; total and per-side timers are frozen
    if (confirmFeedingTimer) {
      return;
    }
    // Предотвращаем одновременные обновления
    if (rightIsUpdating) return;
    
    try {
      rightIsUpdating = true;
      
      final now = DateTime.now();
      
      // Проверяем на резкое изменение системного времени
      if (rightLastUpdateTime != null) {
        final timeDiff = now.difference(rightLastUpdateTime!).inSeconds.abs();
        if (timeDiff > 5) { // Если разница больше 5 секунд - возможно изменили время
          rightSystemTimeChangeDetected = now;
          print('System time change detected in Right timer: $timeDiff seconds');
          // Не обновляем время при изменении системного времени
          rightLastUpdateTime = now; // Обновляем lastUpdateTime чтобы избежать повторных срабатываний
          return;
        }
      }
      
      // Дополнительная проверка - обновляем только если таймер действительно запущен
      if (!isRightSideStart && rightPauseTime == null) {
        rightCurrentTimerText = '00:00';
        return;
      }

      if (!isRightSideStart) {
        if (rightPauseTime != null && rightTimerStartTime != null) {
          // Show paused time - время с момента старта до паузы
          final duration = rightPauseTime!.difference(rightTimerStartTime!);
          final minutes = duration.inMinutes;
          final seconds = duration.inSeconds % 60;
          rightCurrentTimerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        } else {
          rightCurrentTimerText = '00:00';
        }
      } else {
        // Timer is running - show current elapsed time
        if (rightTimerStartTime != null) {
          final duration = now.difference(rightTimerStartTime!);
          final minutes = duration.inMinutes;
          final seconds = duration.inSeconds % 60;
          rightCurrentTimerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        } else {
          rightCurrentTimerText = '00:00';
        }
        
        // Don't set end time when running - show infinity
        timerEndTime = null;
      }
      
      rightLastUpdateTime = now;
    } catch (e) {
      // Если произошла ошибка, просто не обновляем время
      print('Error updating Right timer display: $e');
    } finally {
      rightIsUpdating = false;
    }
  }

  @computed
  String get leftCurrentTimerDisplay => leftCurrentTimerText;

  @computed
  String get rightCurrentTimerDisplay => rightCurrentTimerText;

  @computed
  String get leftTotalDuration {
    if (leftTimerStartTime == null) {
      // Timer not started - show 0
      return '0м 0с';
    }
    
    if (isLeftSideStart) {
      // Timer is running - show current elapsed time
      final now = DateTime.now();
      final duration = now.difference(leftTimerStartTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      
      if (hours > 0) {
        return '${hours}ч ${minutes}м ${seconds}с';
      } else if (minutes > 0) {
        return '${minutes}м ${seconds}с';
      } else {
        return '${seconds}с';
      }
    } else if (leftPauseTime != null) {
      // Timer is paused - show time from start to pause
      final duration = leftPauseTime!.difference(leftTimerStartTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      
      if (hours > 0) {
        return '${hours}ч ${minutes}м ${seconds}с';
      } else if (minutes > 0) {
        return '${minutes}м ${seconds}с';
      } else if (seconds > 0) {
        return '${seconds}с';
      } else {
        return '0м 0с';
      }
    } else if (timerEndTime != null) {
      // Timer is stopped or in manual mode - show time from start to end
      final duration = timerEndTime!.difference(leftTimerStartTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      
      if (hours > 0) {
        return '${hours}ч ${minutes}м ${seconds}с';
      } else if (minutes > 0) {
        return '${minutes}м ${seconds}с';
      } else if (seconds > 0) {
        return '${seconds}с';
      } else {
        return '0м 0с';
      }
    } else {
      // No end time yet and timer not started - show 0
      return '0м 0с';
    }
  }

  @computed
  String get combinedTotalDuration {
    // Manual mode (no side timers): compute from Start/End fields
    final bool noSideTimers =
        leftTimerStartTime == null &&
        rightTimerStartTime == null &&
        leftPauseTime == null &&
        rightPauseTime == null &&
        !isLeftSideStart &&
        !isRightSideStart;
    if (noSideTimers || ((startTimeManuallySet || endTimeManuallySet) && !isLeftSideStart && !isRightSideStart)) {
      final DateTime start = timerStartTime;
      final DateTime? end = timerEndTime;
      if (end == null) {
        return '0м 0с';
      }
      final DateTime adjustedEnd = end.isBefore(start) ? end.add(const Duration(days: 1)) : end;
      final duration = adjustedEnd.difference(start).abs();
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      if (hours > 0) {
        return '${hours}ч ${minutes}м ${seconds}с';
      } else if (minutes > 0) {
        return '${minutes}м ${seconds}с';
      } else if (seconds > 0) {
        return '${seconds}с';
      } else {
        return '0м 0с';
      }
    }

    // Calculate combined total duration from both sides
    Duration leftDuration = Duration.zero;
    Duration rightDuration = Duration.zero;
    
    // Left side duration
    if (leftTimerStartTime != null) {
      if (isLeftSideStart) {
        // Left timer is running - show current elapsed time
        final now = DateTime.now();
        leftDuration = now.difference(leftTimerStartTime!);
      } else if (leftPauseTime != null) {
        // Left timer is paused - show time from start to pause
        leftDuration = leftPauseTime!.difference(leftTimerStartTime!);
      } else if (timerEndTime != null) {
        // Left timer is stopped - show time from start to end
        leftDuration = timerEndTime!.difference(leftTimerStartTime!);
      }
    }
    
    // Right side duration
    if (rightTimerStartTime != null) {
      if (isRightSideStart) {
        // Right timer is running - show current elapsed time
        final now = DateTime.now();
        rightDuration = now.difference(rightTimerStartTime!);
      } else if (rightPauseTime != null) {
        // Right timer is paused - show time from start to pause
        rightDuration = rightPauseTime!.difference(rightTimerStartTime!);
      } else if (timerEndTime != null) {
        // Right timer is stopped - show time from start to end
        rightDuration = timerEndTime!.difference(rightTimerStartTime!);
      }
    }
    
    // Combine both durations
    final totalDuration = leftDuration + rightDuration;
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes % 60;
    final seconds = totalDuration.inSeconds % 60;
    
    
    if (hours > 0) {
      return '${hours}ч ${minutes}м ${seconds}с';
    } else if (minutes > 0) {
      return '${minutes}м ${seconds}с';
    } else if (seconds > 0) {
      return '${seconds}с';
    } else {
      return '0м 0с';
    }
  }

  @computed
  String get rightTotalDuration {
    if (rightTimerStartTime == null) {
      // Timer not started - show 0
      return '0м 0с';
    }
    
    if (isRightSideStart) {
      // Timer is running - show current elapsed time
      final now = DateTime.now();
      final duration = now.difference(rightTimerStartTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      
      if (hours > 0) {
        return '${hours}ч ${minutes}м ${seconds}с';
      } else if (minutes > 0) {
        return '${minutes}м ${seconds}с';
      } else {
        return '${seconds}с';
      }
    } else if (rightPauseTime != null) {
      // Timer is paused - show time from start to pause
      final duration = rightPauseTime!.difference(rightTimerStartTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      
      if (hours > 0) {
        return '${hours}ч ${minutes}м ${seconds}с';
      } else if (minutes > 0) {
        return '${minutes}м ${seconds}с';
      } else if (seconds > 0) {
        return '${seconds}с';
      } else {
        return '0м 0с';
      }
    } else if (timerEndTime != null) {
      // Timer is stopped or in manual mode - show time from start to end
      final duration = timerEndTime!.difference(rightTimerStartTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      
      if (hours > 0) {
        return '${hours}ч ${minutes}м ${seconds}с';
      } else if (minutes > 0) {
        return '${minutes}м ${seconds}с';
      } else if (seconds > 0) {
        return '${seconds}с';
      } else {
        return '0м 0с';
      }
    } else {
      // No end time yet and timer not started - show 0
      return '0м 0с';
    }
  }

  @action
  Future<void> addFeeding() async {
    if (timerEndTime == null) return;

    // Calculate durations for left and right sides
    final leftDuration = leftPauseTime != null 
        ? leftPauseTime!.difference(leftTimerStartTime ?? timerStartTime)
        : timerEndTime!.difference(leftTimerStartTime ?? timerStartTime);
    
    final rightDuration = rightPauseTime != null 
        ? rightPauseTime!.difference(rightTimerStartTime ?? timerStartTime)
        : timerEndTime!.difference(rightTimerStartTime ?? timerStartTime);

    final leftMinutes = leftDuration.inMinutes.abs();
    final rightMinutes = rightDuration.inMinutes.abs();
    // final totalMinutes = leftMinutes + rightMinutes; // not used currently

    // Backend expects local time with milliseconds: yyyy-MM-dd HH:mm:ss.SSS
    final formattedEnd = timerEndTime != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(timerEndTime!)
        : null;

    final String notesValue = (this as AddFeeding).noteStore.content?.trim() ?? '';

    final dto = FeedInsertChestDto(
      childId: (this as AddFeeding).childId,
      timeToEnd: formattedEnd,
      left: leftMinutes > 0 ? leftMinutes : 1, // Отправляем минимум 1 минуту
      right: rightMinutes > 0 ? rightMinutes : 1, // Отправляем минимум 1 минуту
      notes: notesValue,
    );
    
    // Создаем JSON вручную, чтобы избежать "null" строк
    final jsonData = <String, dynamic>{
      'child_id': (this as AddFeeding).childId,
      'time_to_end': formattedEnd,
      'left': leftMinutes > 0 ? leftMinutes : 1, // Минимум 1 минута
      'right': rightMinutes > 0 ? rightMinutes : 1, // Минимум 1 минута
      if (notesValue.isNotEmpty) 'notes': notesValue,
    };

    try {
      print('Sending feeding data (DTO): ${dto.toJson()}');
      print('Sending feeding data (Manual JSON): $jsonData');
      print('Using restClient: ${(this as AddFeeding).restClient}');
      print('Calling postFeedChest...');
      
      // Используем notes из noteStore
      await (this as AddFeeding).restClient.feed.postFeedChest(dto: dto);
      print('API response: success (void)');
      // Бек может не возвращать id — помечаем как сохранённое
      savedRecordId ??= 'unknown';
      print('Feeding record saved successfully');
    } catch (e) {
      if (e is DioException) {
        // Некоторые окружения возвращают пустой ответ (нет JSON), что вызывает ошибку парсинга у retrofit.
        // Больше не маскируем такую ситуацию как успех — сигнализируем об ошибке выше.
        final isEmptyOrInvalidJson = e.error is FormatException || e.response == null || e.response?.data == null;
        if (isEmptyOrInvalidJson) {
          print('Empty/invalid JSON response from /feed/chest — will show error to user');
          rethrow;
        }

        // Подробный лог только для реальных сетевых/серверных ошибок
        print('Error saving feeding record: DioException');
        print('  Request path: ${e.requestOptions.path}');
        print('  Request baseUrl: ${e.requestOptions.baseUrl}');
        print('  Request full URL: ${e.requestOptions.uri}');
        print('  Response data: ${e.response?.data}');
        print('  Response status: ${e.response?.statusCode}');
        print('  Response headers: ${e.response?.headers}');
        print('  Response statusMessage: ${e.response?.statusMessage}');
        print('  Request data: ${e.requestOptions.data}');
        print('  Request headers: ${e.requestOptions.headers}');
      } else {
        print('Error saving feeding record: $e');
      }
      // Для прочих ошибок пробрасываем дальше
      rethrow;
    }
  }

  @action
  void setTimerEndTime(DateTime value) {
    timerEndTime = value;
    endTimeManuallySet = true;
  }
}
