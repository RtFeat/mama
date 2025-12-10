import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:mama/src/feature/trackers/widgets/timer_interface.dart';
import 'package:mama/src/core/api/models/sleepcry_response_insert_dto.dart';
import 'package:mama/src/core/api/models/sleepcry_update_sleep_dto.dart';
import 'package:mama/src/core/api/models/sleepcry_insert_sleep_dto.dart';
import 'package:mama/src/core/api/models/sleepcry_delete_sleep_dto.dart';

part 'sleep.g.dart';

class SleepStore extends _SleepStore with _$SleepStore {
  SleepStore({
    required super.apiClient,
    required super.restClient,
    required super.faker,
    required super.userStore,
    required super.onLoad,
    required super.onSet,
  });
}

abstract class _SleepStore extends LearnMoreStore<EntitySleepHistoryTotal>
    with Store implements TimerInterface {
  _SleepStore({
    required super.apiClient,
    required this.restClient,
    required super.faker,
    required this.userStore,
    required super.onLoad,
    required super.onSet,
  }) : super(
          testDataGenerator: () {
            return EntitySleepHistoryTotal();
          },
          basePath: '/sleep_cry/sleep/history',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 15,
          transformer: (raw) {
            final data = SleepcryResponseHistorySleep.fromJson(raw);
            return {
              'main': data.list ?? <EntitySleepHistoryTotal>[],
            };
          },
        ) {
    // Инициализируем formGroup после создания store
    formGroup = FormGroup({
      'sleepStart': FormControl(),
      'sleepEnd': FormControl(),
    });
    init();
  }

  final UserStore userStore;
  final RestClient restClient;

  @computed
  String get childId => userStore.selectedChild?.id ?? '';

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
  
  @observable
  bool _isManualEditMode = false;
  
  // Real moment when user pressed pause. Used to compute paused duration on resume.
  @observable
  DateTime? _pauseMoment;
  
  @observable
  bool _endManuallySet = false;

  @action
  confirmButtonManuallyPressed() {}

  void init() {
    formGroup.control('sleepStart').value =
        _dateTimeFormat.format(DateTime.now());
    formGroup.control('sleepEnd').value =
        _dateTimeFormat.format(DateTime.now());
  }

  void dispose() {
    formGroup.dispose();
  }

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
      // On resume, always clear pause state and any manual End so total cannot shrink
      pauseTime = null;
      timerEndTime = null; // Show infinity when running
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
    // Устанавливаем pauseTime если его еще нет (когда confirm нажимается без предварительной паузы)
    // Используем текущее время для корректного расчета total
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
    // и корректно отображали конечное время интервала
    if (pauseTime != null) {
      timerEndTime = pauseTime;
    }
    
    // НЕ сбрасываем _savedRecordId - запись еще не была сохранена
    
    // Не сбрасываем originalStartTime и timerStartTime - они должны остаться
    // pauseTime остается как есть - это время когда была пауза или confirm
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
  cancelSleepingClose([String? notes]) async {
    // Сохраняем запись перед сбросом
    await finalSave(notes);
    
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
    _isManualEditMode = false; // Сбрасываем флаг ручного редактирования
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
    _isManualEditMode = false;
    timerStartTime = DateTime.now();
  }

  @action
  Future<void> finalSave([String? notes]) async {
    // Сохраняем запись только если таймер был запущен и есть время окончания
    // И запись не была уже сохранена вручную
    if (timerEndTime != null && _savedRecordId == null && !_isManuallySaved) {
      try {
        await add(childId, notes);
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
    // Mark as manual edit mode when user manually changes start time
    _isManualEditMode = true;
    
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
    // so that when user presses Start, we resume from that chosen end
    if (!timerSleepStart) {
      pauseTime = timerEndTime;
    }
    _endManuallySet = value != null;
  }

  @action
  void setManuallySaved(bool value) {
    _isManuallySaved = value;
  }

  @action
  void setPausedEndToNow() {
    // Update end time to current device time when timer is paused
    // but only if end wasn't set and we are NOT in edit mode
    if (!timerSleepStart && timerEndTime == null && !_endManuallySet && !showEditMenu && !confirmSleepTimer) {
      timerEndTime = DateTime.now();
    }
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

      // Во время экрана подтверждения фиксируем показ и не пересчитываем счетчик
      if (confirmSleepTimer && !timerSleepStart) {
        lastUpdateTime = now;
        return;
      }
      
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
        if (!_endManuallySet) {
          timerEndTime = null;
        }
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
    // Only observe ticking text when timer is running or paused
    if (timerSleepStart || pauseTime != null) {
      // ignore: unused_local_variable
      final _tick = currentTimerText;
    }
    // Track manual changes
    final _s = timerStartTime;
    final _e = timerEndTime;

    // Use a single consistent baseline to prevent jumps between running and paused
    // When manually editing, always use timerStartTime directly
    final DateTime effectiveStart = _isManualEditMode 
        ? timerStartTime 
        : (_timerStartTime ?? timerStartTime);

    // When running, always show growing elapsed time regardless of explicit end
    if (timerSleepStart) {
      final now = DateTime.now();
      DateTime effectiveNow = now;
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
    }

    // If explicit end is set, prefer it when NOT running
    if (timerEndTime != null) {
      DateTime effectiveEnd = timerEndTime!;
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
    } else if (pauseTime != null) {
      // Timer is paused - show time from start to pause
      DateTime effectiveEnd = pauseTime!;
      if (effectiveEnd.isBefore(effectiveStart)) {
        // crossed midnight
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
      // No end time yet and timer not running
      return '0м 0с';
    }
  }

  Future<SleepcryResponseInsertDto?> add(String childId, String? notes) async {
    final duration = (timerEndTime ?? DateTime.now()).difference(timerStartTime);
    final minutes = duration.inMinutes.abs();

    final dto = SleepcryInsertSleepDto(
      childId: childId,
      // Server expects RFC3339 with timezone (Z) for time_end
      timeEnd: timerEndTime?.toUtc().toIso8601String(),
      // UI grouping relies on local clock: keep HH:mm local for these
      timeToEnd: timerEndTime?.formattedTime,
      timeToStart: timerStartTime.formattedTime,
      allSleep: '$minutes м',
      notes: notes,
    );

    final response = await restClient.sleepCry.postSleepCrySleep(dto: dto);
    // Сохраняем ID записи для возможной перезаписи
    _savedRecordId = response?.id;
    // Устанавливаем флаг ручного сохранения
    _isManuallySaved = true;
    return response;
  }

  Future<void> update(String recordId, String childId, String? notes) async {
    try {
      // Рассчитываем длительность в минутах между timerStartTime и timerEndTime (или сейчас)
      final Duration duration = (timerEndTime ?? DateTime.now()).difference(timerStartTime);
      final int minutes = duration.inMinutes.abs();

      // Формируем DTO для PATCH /sleep_cry/sleep/stats с полным набором полей
      final SleepcryUpdateSleepDto dto = SleepcryUpdateSleepDto(
        id: recordId,
        allSleep: '$minutes м',
        timeEnd: timerEndTime,
        timeToEnd: timerEndTime?.formattedTime,
        timeToStart: timerStartTime.formattedTime,
        notes: notes,
      );

      await restClient.sleepCry.patchSleepCrySleepStats(dto: dto);
      // Если пришли заметки, а у записи их не было, обновим заметки отдельным PATCH
      if (notes != null && notes.trim().isNotEmpty) {
        try {
          await apiClient.patch('sleep_cry/sleep/notes', body: {
            'id': recordId,
            'notes': notes,
          });
        } catch (_) {
          // Игнорируем ошибки обновления заметок, чтобы не ломать общий сценарий
        }
      }
    } catch (e) {
      rethrow;
    }
  }

}