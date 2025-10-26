import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:mama/src/data.dart';
import 'package:dio/dio.dart';
import 'package:mama/src/feature/notes/state/add_note.dart';
import 'package:uuid/uuid.dart';
import 'package:mama/src/feature/trackers/state/feeding/breast_feeding_table_store.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/core/api/models/feed_chest_notes_dto.dart';
import 'package:mama/src/core/api/models/feed_delete_chest_notes_dto.dart';
import 'package:mama/src/core/api/models/feed_chest_stats_dto.dart';

part 'add_feeding.g.dart';

class AddFeeding extends _AddFeeding with _$AddFeeding {
  AddFeeding({
    required this.childId,
    required this.restClient,
    required this.noteStore,
    VoidCallback? onHistoryRefresh,
  }) : super(onHistoryRefresh: onHistoryRefresh);

  final String childId;
  final RestClient restClient;
  final AddNoteStore noteStore;

  /// Обновить заметки для записи кормления грудью
  @action
  Future<void> updateFeedingNotes(String recordId, String notes) async {
    try {
      await restClient.feed.patchFeedChestNotes(
        dto: FeedChestNotesDto(id: recordId, notes: notes),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Удалить заметки для записи кормления грудью
  @action
  Future<void> deleteFeedingNotes(String recordId) async {
    try {
      await restClient.feed.deleteFeedChestDeleteNotes(
        dto: FeedDeleteChestNotesDto(id: recordId),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Обновить статистику кормления грудью
  @action
  Future<void> updateFeedingStats(String recordId, int leftMinutes, int rightMinutes, DateTime timeToEnd) async {
    try {
      final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(timeToEnd);
      await restClient.feed.patchFeedChestStats(
        dto: FeedChestStatsDto(
          id: recordId,
          left: leftMinutes,
          right: rightMinutes,
          timeToEnd: formattedTime,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}

abstract class _AddFeeding with Store {
  final VoidCallback? onHistoryRefresh;

  _AddFeeding({this.onHistoryRefresh});

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
        rightPauseTime = null; // Clear pause time when resuming
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
      // Only reset timerEndTime if it wasn't manually set
      if (!endTimeManuallySet) {
        timerEndTime = null; // Show infinity when running
      }
      // Don't reset manual flags when starting timer
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
      DateTime endTime = parsed.copyWith(year: now.year, month: now.month, day: now.day);
      
      // If end time is before start time, assume it's the next day
      if (endTime.isBefore(timerStartTime)) {
        endTime = endTime.add(const Duration(days: 1));
      }
      
      timerEndTime = endTime;
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
        leftPauseTime = null; // Clear pause time when resuming
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
      // Only reset timerEndTime if it wasn't manually set
      if (!endTimeManuallySet) {
        timerEndTime = null; // Show infinity when running
      }
      // Don't reset manual flags when starting timer
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
    // Фиксируем момент окончания только если время не было установлено вручную
    final DateTime endMoment = DateTime.now();
    if (!endTimeManuallySet) {
      timerEndTime = endMoment;
    }
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
    
    // Сохраняем запись при подтверждении
    try {
      await addFeeding();
      // Обновляем историю после успешного сохранения
      onHistoryRefresh?.call();
    } catch (e) {
      // Не пробрасываем ошибку, чтобы не блокировать UI
    }
  }

  @action
  goBackAndContinue() async {
    // Удаляем запись при возврате и продолжении (как в Sleep)
    if (savedRecordId != null) {
      try {
        await deleteFeeding();
      } catch (e) {
        // Не пробрасываем ошибку, чтобы не блокировать UI
      }
    }
    
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
    // Крестик - просто сбрасываем все без сохранения
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
    
    // Очищаем заметку при сбросе
    (this as AddFeeding).noteStore.setContent(null);
  }

  @action
  Future<void> finalSave() async {
    // Сохраняем запись только если есть время окончания и не была сохранена вручную
    if (timerEndTime != null && savedRecordId == null && !leftIsManuallySaved && !rightIsManuallySaved) {
      try {
        await addFeeding();
        // Устанавливаем флаги после успешного сохранения
        leftIsManuallySaved = true;
        rightIsManuallySaved = true;
      } catch (e) {
        // Error saving feeding record
      }
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
        
        // Don't set end time when running - show infinity (only if not manually set)
        if (!endTimeManuallySet) {
          timerEndTime = null;
        }
      }
      
      leftLastUpdateTime = now;
    } catch (e) {
      // Если произошла ошибка, просто не обновляем время
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
        
        // Don't set end time when running - show infinity (only if not manually set)
        if (!endTimeManuallySet) {
          timerEndTime = null;
        }
      }
      
      rightLastUpdateTime = now;
    } catch (e) {
      // Если произошла ошибка, просто не обновляем время
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

  Future<void> addFeeding({int? manualLeftMinutes, int? manualRightMinutes}) async {
    if (timerEndTime == null) return;

    // Calculate durations for left and right sides
    var leftMinutes = 0;
    var rightMinutes = 0;
    
    // Only calculate durations if timers were actually used (not manual mode)
    if (!startTimeManuallySet && !endTimeManuallySet) {
      final leftDuration = leftPauseTime != null 
          ? leftPauseTime!.difference(leftTimerStartTime ?? timerStartTime)
          : timerEndTime!.difference(leftTimerStartTime ?? timerStartTime);
      
      final rightDuration = rightPauseTime != null 
          ? rightPauseTime!.difference(rightTimerStartTime ?? timerStartTime)
          : timerEndTime!.difference(rightTimerStartTime ?? timerStartTime);

      leftMinutes = leftDuration.inMinutes.abs();
      rightMinutes = rightDuration.inMinutes.abs();
    }
    
    // If manual values are provided (from manual input screen), use them instead
    if (manualLeftMinutes != null && manualRightMinutes != null) {
      leftMinutes = manualLeftMinutes;
      rightMinutes = manualRightMinutes;
    } else {
      // Manual mode: if user set time manually and both sides are 0,
      // distribute the total time equally between left and right sides
      int totalMinutes;
      if (timerEndTime != null) {
        Duration duration = timerEndTime!.difference(timerStartTime);
        // If end time is before start time, it means it's the next day
        if (duration.isNegative) {
          // Add 24 hours to get the correct duration
          duration = duration + const Duration(days: 1);
        }
        totalMinutes = duration.inMinutes;
      } else {
        totalMinutes = leftMinutes + rightMinutes;
      }
      
      // If manual time was set OR if we're in manual mode (no timers used), distribute time equally
      if ((startTimeManuallySet || endTimeManuallySet) && (leftMinutes == 0 && rightMinutes == 0)) {
        // Distribute total time equally between left and right sides
        final halfTime = totalMinutes ~/ 2;
        leftMinutes = halfTime;
        rightMinutes = totalMinutes - halfTime; // Ensure we don't lose any time due to rounding
        
      } else if (startTimeManuallySet || endTimeManuallySet) {
        // If manual time was set but we have some timer values, still distribute equally
        final halfTime = totalMinutes ~/ 2;
        leftMinutes = halfTime;
        rightMinutes = totalMinutes - halfTime;
        
      }
    }

    // Backend expects local time with milliseconds: yyyy-MM-dd HH:mm:ss.SSS
    final formattedEnd = timerEndTime != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(timerEndTime!)
        : null;

    final String notesValue = (this as AddFeeding).noteStore.content?.trim() ?? '';

    final dto = FeedInsertChestDto(
      childId: (this as AddFeeding).childId,
      timeToEnd: formattedEnd,
      left: leftMinutes,
      right: rightMinutes,
      notes: notesValue,
    );
    
    // Создаем JSON вручную, чтобы избежать "null" строк
    final jsonData = <String, dynamic>{
      'child_id': (this as AddFeeding).childId,
      'time_to_end': formattedEnd,
      'left': leftMinutes,
      'right': rightMinutes,
      if (notesValue.isNotEmpty) 'notes': notesValue,
    };

    try {
      // Используем notes из noteStore
      final response = await (this as AddFeeding).restClient.feed.postFeedChest(dto: dto);
      
      // Используем реальный ID с сервера для удаления
      savedRecordId = response.id;
      
      // Очищаем заметку после успешного сохранения
      (this as AddFeeding).noteStore.setContent(null);
    } catch (e) {
      if (e is DioException) {
        // Некоторые окружения возвращают пустой ответ (нет JSON), что вызывает ошибку парсинга у retrofit.
        // Больше не маскируем такую ситуацию как успех — сигнализируем об ошибке выше.
        final isEmptyOrInvalidJson = e.error is FormatException || e.response == null || e.response?.data == null;
        if (isEmptyOrInvalidJson) {
          rethrow;
        }

        // Подробный лог только для реальных сетевых/серверных ошибок
      }
      // Для прочих ошибок пробрасываем дальше
      rethrow;
    }
  }

  @action
  Future<void> deleteFeeding() async {
    if (savedRecordId == null) {
      return;
    }

    try {
      await (this as AddFeeding).restClient.feed.deleteFeedChestDeleteStats(
        dto: FeedDeleteChestDto(id: savedRecordId!),
      );
      savedRecordId = null; // Сбрасываем ID после удаления
    } catch (e) {
      rethrow;
    }
  }

  @action
  void setTimerEndTime(DateTime value) {
    timerEndTime = value;
    endTimeManuallySet = true;
  }

}
