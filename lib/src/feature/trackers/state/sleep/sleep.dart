import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'sleep.g.dart';

class SleepStore extends _SleepStore with _$SleepStore {
  SleepStore();
}

abstract class _SleepStore with Store {
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
  DateTime manualStartTime = DateTime.now();

  @observable
  DateTime manualEndTime = DateTime.now();

  @observable
  DateTime timerStartTime = DateTime.now();

  @observable
  DateTime? timerEndTime;

  @action
  setTimeStartManually(String value) {
    if (value.length == 5) {
      manualStartTime = _dateTimeFormat.parse(value);
    }
  }

  @action
  setTimeEndManually(String value) {
    if (value.length == 5) {
      manualStartTime = _dateTimeFormat.parse(value);
    }
  }

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
}
