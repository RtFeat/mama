import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:mama/src/feature/trackers/widgets/timer_interface.dart';
import 'package:mama/src/core/api/models/sleepcry_response_insert_dto.dart';

part 'cry.g.dart';

class CryStore = _CryStore with _$CryStore;

abstract class _CryStore with Store implements TimerInterface {
  _CryStore({
    required this.apiClient,
    required this.restClient,
    required this.faker,
    required this.childId,
    required this.onLoad,
    required this.onSet,
  }) {
    // Инициализируем formGroup
    formGroup = FormGroup({
      'cryStart': FormControl(),
      'cryEnd': FormControl(),
    });
    init();
  }

  final ApiClient apiClient;
  final RestClient restClient;
  final Faker faker;
  final String childId;
  final Future<bool> Function() onLoad;
  final Future<void> Function(bool value) onSet;

  final _dateTimeFormat = DateFormat('HH:mm');

  late final FormGroup formGroup;

  @observable
  bool timerSleepStart = false;

  @observable
  bool showEditMenu = false;

  @observable
  bool confirmSleepTimer = false;

  @observable
  bool isSleepCanceled = false;

  @observable
  DateTime timerStartTime = DateTime.now();

  @observable
  DateTime? timerEndTime;

  @observable
  DateTime? pauseTime;

  @observable
  String currentTimerText = '00:00';

  @observable
  DateTime? originalStartTime;

  @observable
  DateTime? lastUpdateTime;

  @observable
  bool _isUpdating = false;

  @observable
  DateTime? _systemTimeChangeDetected;

  @observable
  String? _savedRecordId;

  @observable
  bool _isManuallySaved = false;

  @observable
  DateTime? _timerStartTime;
  
  // Real moment when user pressed pause. Used to compute paused duration on resume.
  @observable
  DateTime? _pauseMoment;
  
  @observable
  bool _endManuallySet = false;

  @action
  confirmButtonManuallyPressed() {}

  @action
  changeStatusTimer() {
    confirmSleepTimer = false;
    showEditMenu = true;

    if (!timerSleepStart) {
      // Start timer
      timerSleepStart = true;
      // If End was manually set while paused/editing, treat this as a fresh start
      if (_endManuallySet) {
        _endManuallySet = false;
        timerEndTime = null;
        pauseTime = null;
        // Start from the visible edited start time
        _timerStartTime = timerStartTime;
        originalStartTime ??= timerStartTime;
      } else if (pauseTime != null) {
        // Resuming from pause - adjust start time to account for paused duration
        final DateTime basis = _pauseMoment ?? pauseTime!;
        final pausedDuration = DateTime.now().difference(basis);
        // Do not modify visible editable start time; only shift the baseline
        if (_timerStartTime != null) {
          _timerStartTime = _timerStartTime!.add(pausedDuration);
        } else {
          // Initialize baseline to current visible start on first resume so total doesn't reset
          _timerStartTime = timerStartTime.add(pausedDuration);
        }
        _pauseMoment = null; // clear after resume
      } else {
        // Fresh start - save original start time only if not set
        if (originalStartTime == null) {
          timerStartTime = DateTime.now();
          originalStartTime = timerStartTime;
        } else {
          // If originalStartTime is already set, use it as timerStartTime
          timerStartTime = originalStartTime!;
        }
        // Save the actual start time for total calculation
        _timerStartTime = timerStartTime;
      }
      // On resume, always clear pause state; show infinity while running
      pauseTime = null;
      timerEndTime = null;
    } else {
      // Pause timer
      timerSleepStart = false;
      // Always capture the real pause moment for correct resume math
      _pauseMoment = DateTime.now();
      // Visual pause equals the real pause moment
      pauseTime = _pauseMoment;
      // Set end time to pause moment so UI shows concrete time instead of infinity
      timerEndTime = pauseTime;
    }
    updateTimerDisplay();
  }

  @action
  confirmButtonPressed() async {
    // Stop timer into paused state and capture the moment
    timerSleepStart = false;
    if (pauseTime == null) {
      pauseTime = DateTime.now();
    }
    showEditMenu = false;
    confirmSleepTimer = true;
    // Set end time when confirming - используем время паузы
    timerEndTime = pauseTime;
    
    // НЕ сохраняем запись здесь - только обновляем UI
    // Сохранение произойдет только при крестике или выходе из секции
    
    // Reset original start time when confirming
    originalStartTime = null;
  }

  @action
  goBackAndContinue() async {
    confirmSleepTimer = false;
    isSleepCanceled = false;
    
    // Восстанавливаем состояние таймера
    showEditMenu = true;
    // Восстанавливаем состояние паузы - таймер должен быть на паузе
    timerSleepStart = false;
    // Устанавливаем end в момент паузы, чтобы редактор и Total не росли
    if (pauseTime != null) {
      timerEndTime = pauseTime;
    }
    
    // НЕ сбрасываем _savedRecordId - запись еще не была сохранена
    
    // Не сбрасываем originalStartTime и timerStartTime - они должны остаться
    // pauseTime остается как есть - это время когда была пауза
  }

  @action
  cancelSleeping() {
    timerSleepStart = false;
    showEditMenu = false;
    isSleepCanceled = true;
    // Reset original start time when canceling
    originalStartTime = null;
  }

  @action
  cancelSleepingClose() async {
    // Сохраняем запись перед сбросом
    await finalSave();
    
    isSleepCanceled = false;
    // Полный сброс таймера
    timerSleepStart = false;
    showEditMenu = false;
    confirmSleepTimer = false;
    pauseTime = null;
    timerEndTime = null;
    originalStartTime = null;
    currentTimerText = '00:00';
    _savedRecordId = null; // Сбрасываем ID сохраненной записи
    _isManuallySaved = false; // Сбрасываем флаг ручного сохранения
    _timerStartTime = null; // Сбрасываем время запуска таймера
    // Сбрасываем время на текущее
    timerStartTime = DateTime.now();
  }

  /// Полный сброс состояния без сохранения записи
  @action
  void resetWithoutSaving() {
    isSleepCanceled = false;
    timerSleepStart = false;
    showEditMenu = false;
    confirmSleepTimer = false;
    pauseTime = null;
    timerEndTime = null;
    originalStartTime = null;
    currentTimerText = '00:00';
    _savedRecordId = null;
    _isManuallySaved = false;
    _timerStartTime = null;
    timerStartTime = DateTime.now();
  }

  @action
  Future<void> finalSave() async {
    // Сохраняем запись только если таймер был запущен и есть время окончания
    // И запись не была уже сохранена вручную
    if (timerEndTime != null && _savedRecordId == null && !_isManuallySaved) {
      try {
        await add(childId, null);
      } catch (e) {
        // Игнорируем ошибки
      }
    }
  }

  @action
  updateStartTime(DateTime? value) {
    // Normalize to today's date to avoid epoch dates from pure time pickers
    final DateTime base = DateTime.now();
    final DateTime raw = value ?? base;
    final DateTime newStart = DateTime(
      base.year,
      base.month,
      base.day,
      raw.hour,
      raw.minute,
      raw.second,
      raw.millisecond,
      raw.microsecond,
    );
    // Update visible and original start
    timerStartTime = newStart;
    originalStartTime = newStart;
    // Also update effective baseline so Total recalculates immediately
    _timerStartTime = newStart;
    updateTimerDisplay();
  }

  @action
  updateEndTime(DateTime? value) {
    if (value == null) {
      timerEndTime = null;
    } else {
      // Normalize to today's date to avoid epoch dates from pure time pickers
      final DateTime base = DateTime.now();
      final DateTime raw = value;
      timerEndTime = DateTime(
        base.year,
        base.month,
        base.day,
        raw.hour,
        raw.minute,
        raw.second,
        raw.millisecond,
        raw.microsecond,
      );
    }
    // If timer is not running, treat manually selected end as a paused moment
    if (!timerSleepStart) {
      pauseTime = timerEndTime;
    }
    _endManuallySet = value != null;
  }

  @action
  void setPausedEndToNow() {
    // When timer is paused and end is not set, reflect current device time
    // but only if edit menu is hidden (not in editing UI) and End wasn't set manually
    if (!timerSleepStart && timerEndTime == null && !_endManuallySet && !showEditMenu && !confirmSleepTimer) {
      timerEndTime = DateTime.now();
    }
  }

  @action
  void setManuallySaved(bool value) {
    _isManuallySaved = value;
  }

  void init() {
    formGroup.control('cryStart').value =
        _dateTimeFormat.format(DateTime.now());
    formGroup.control('cryEnd').value =
        _dateTimeFormat.format(DateTime.now());
  }

  void dispose() {
    formGroup.dispose();
  }

  @computed
  bool get isFormValid => timerEndTime?.isAfter(timerStartTime) ?? false;

  @action
  void updateTimerDisplay() {
    // Предотвращаем одновременные обновления
    if (_isUpdating) return;
    
    try {
      _isUpdating = true;
      
      final now = DateTime.now();
      
      // Проверяем на резкое изменение системного времени
      if (lastUpdateTime != null) {
        final timeDiff = now.difference(lastUpdateTime!).inSeconds.abs();
        if (timeDiff > 5) { // Если разница больше 5 секунд - возможно изменили время
          _systemTimeChangeDetected = now;
          // Не обновляем время при изменении системного времени
          lastUpdateTime = now; // Обновляем lastUpdateTime чтобы избежать повторных срабатываний
          return;
        }
      }
      
      // Дополнительная проверка - обновляем только если таймер действительно запущен
      if (!timerSleepStart && pauseTime == null) {
        currentTimerText = '00:00';
        return;
      }

      if (!timerSleepStart) {
        if (pauseTime != null) {
          // Show paused time - время с момента старта до паузы
          final duration = pauseTime!.difference(timerStartTime);
          final minutes = duration.inMinutes;
          final seconds = duration.inSeconds % 60;
          currentTimerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          // НЕ обновляем end time при паузе, чтобы избежать проблем с изменением времени
        } else {
          currentTimerText = '00:00';
        }
      } else {
        // Timer is running - show current elapsed time
        final duration = now.difference(timerStartTime);
        final minutes = duration.inMinutes;
        final seconds = duration.inSeconds % 60;
        currentTimerText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        
        // Don't set end time when running - show infinity
        timerEndTime = null;
      }
      
      lastUpdateTime = now;
    } catch (e) {
      // Если произошла ошибка, просто не обновляем время
    } finally {
      _isUpdating = false;
    }
  }

  @computed
  String get currentTimerDisplay => currentTimerText;

  @computed
  String get totalDuration {
    // Ensure recomputation when things change
    if (timerSleepStart || pauseTime != null) {
      // ignore: unused_local_variable
      final _tick = currentTimerText;
    }
    final _s = timerStartTime;
    final _e = timerEndTime;

    DateTime normalizeToToday(DateTime dt) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, dt.hour, dt.minute, dt.second);
    }

    // Use a single consistent baseline to prevent jumps between running and paused
    final DateTime baseStart = _timerStartTime ?? timerStartTime;
    DateTime effectiveStart = normalizeToToday(baseStart);

    if (timerEndTime != null) {
      DateTime effectiveEnd = normalizeToToday(timerEndTime!);
      if (effectiveEnd.isBefore(effectiveStart)) {
        effectiveEnd = effectiveEnd.add(const Duration(days: 1));
      }
      final duration = effectiveEnd.difference(effectiveStart);
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
    } else if (timerSleepStart) {
      // Timer is running - show current elapsed time
      final now = DateTime.now();
      DateTime effectiveNow = normalizeToToday(now);
      if (effectiveNow.isBefore(effectiveStart)) {
        effectiveNow = effectiveNow.add(const Duration(days: 1));
      }
      final duration = effectiveNow.difference(effectiveStart);
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
    } else if (pauseTime != null) {
      // Timer is paused - show time from start to pause
      DateTime effectiveEnd = normalizeToToday(pauseTime!);
      if (effectiveEnd.isBefore(effectiveStart)) {
        effectiveEnd = effectiveEnd.add(const Duration(days: 1));
      }
      final duration = effectiveEnd.difference(effectiveStart);
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
      return '0м 0с';
    }
  }

  Future<SleepcryResponseInsertDto?> add(String childId, String? notes) async {
    final duration = (timerEndTime ?? DateTime.now()).difference(timerStartTime);
    final minutes = duration.inMinutes.abs();

    final dto = SleepcryInsertCryDto(
      childId: childId,
      // Server expects RFC3339 with timezone (Z) for time_end
      timeEnd: timerEndTime?.toUtc().toIso8601String(),
      // Keep local HH:mm for grouping/formatting fields
      timeToEnd: timerEndTime?.formattedTime,
      timeToStart: timerStartTime.formattedTime,
      allCry: '$minutes м',
      notes: notes,
    );

    final response = await restClient.sleepCry.postSleepCryCry(dto: dto);
    // Сохраняем ID записи для возможной перезаписи
    _savedRecordId = response?.id;
    return response;
  }

}
