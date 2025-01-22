import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

part 'add_sleeping.g.dart';

class AddSleeping extends _AddSleeping with _$AddSleeping {
  AddSleeping();
}

abstract class _AddSleeping with Store {
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
    DateFormat format = DateFormat('HH:mm');
    if (value.length == 5) {
      manualStartTime = format.parse(value);
    }
  }

  @action
  setTimeEndManually(String value) {
    DateFormat format = DateFormat('HH:mm');
    if (value.length == 5) {
      manualStartTime = format.parse(value);
    }
  }

  @action
  confirmButtonManuallyPressed() {}

  @action
  changeStatusTimer() {
    confirmSleepTimer = false;
    showEditMenu = true;
    timerSleepStart = !timerSleepStart;
    timerSleepStart ? timerEndTime = null : timerEndTime = DateTime.now();
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
}
