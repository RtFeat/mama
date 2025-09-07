import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'sleep.g.dart';

class SleepStore extends _SleepStore with _$SleepStore {
  SleepStore({
    required super.restClient,
  });
}

abstract class _SleepStore with Store {
  _SleepStore({required this.restClient});

  final RestClient restClient;

  static final _dateTimeFormat = DateFormat('HH:mm');

  FormGroup formGroup = FormGroup({
    'sleepStart': FormControl(),
    'sleepEnd': FormControl(),
  });

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

  @action
  confirmButtonManuallyPressed() {}

  @action
  changeStatusTimer() {
    confirmSleepTimer = false;
    showEditMenu = true;
    timerSleepStart = !timerSleepStart;
    // timerSleepStart ? timerEndTime = null :
    timerEndTime = DateTime.now();
  }

  @action
  confirmButtonPressed() {
    timerSleepStart = false;
    showEditMenu = false;
    confirmSleepTimer = true;
  }

  @action
  goBackAndContinue() {
    confirmSleepTimer = false;
    isSleepCanceled = false;
  }

  @action
  cancelSleeping() {
    timerSleepStart = false;
    showEditMenu = false;
    isSleepCanceled = true;
  }

  @action
  cancelSleepingClose() {
    isSleepCanceled = false;
  }

  @action
  updateStartTime(DateTime? value) {
    timerStartTime = value ?? DateTime.now();
  }

  @action
  updateEndTime(DateTime? value) {
    timerEndTime = value;
  }

  void init() {
    formGroup.control('sleepStart').value =
        _dateTimeFormat.format(DateTime.now());
    formGroup.control('sleepEnd').value =
        _dateTimeFormat.format(DateTime.now());
  }

  void dispose() {
    formGroup.dispose();
  }

  @computed
  bool get isFormValid => timerEndTime?.isAfter(timerStartTime) ?? false;

  Future<void> add(String childId, String? notes) async {
    final duration = timerEndTime!.difference(timerStartTime);
    final minutes = duration.inMinutes.abs();

    final dto = SleepcryInsertSleepDto(
      childId: childId,
      timeEnd: timerEndTime?.toUtc().toIso8601String(),
      timeToEnd: timerEndTime?.toUtc().formattedTime,
      timeToStart: timerStartTime.toUtc().formattedTime,
      allSleep: '$minutes м',
      notes: notes,
    );

    await restClient.sleepCry.postSleepCrySleep(dto: dto);
  }
}
