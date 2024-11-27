import 'package:mobx/mobx.dart';

part 'add_sleeping.g.dart';

class AddSleeping extends _AddSleeping with _$AddSleeping {
  AddSleeping();
}

abstract class _AddSleeping with Store {
  @observable
  bool timerSleepStart = false;

  @observable
  bool confirmSleepTimer = false;

  @observable
  bool isSleepCanceled = false;

  @observable
  DateTime timerStartTime = DateTime.now();

  @observable
  DateTime timerEndTime = DateTime.now();

  @action
  changeStatusTimer() {
    confirmSleepTimer = false;
    timerSleepStart = !timerSleepStart;
  }

  @action
  confirmButtonPressed() {
    timerSleepStart = false;
    confirmSleepTimer = true;
  }

  @action
  goBackAndContinue() {
    confirmSleepTimer = false;
    isSleepCanceled = false;
  }

  @action
  cancelFeeding() {
    timerSleepStart = false;
    isSleepCanceled = true;
  }

  @action
  cancelFeedingClose() {
    isSleepCanceled = false;
  }

  @action
  timerStart() {
    timerStartTime = DateTime.now();
    timerSleepStart = true;
    confirmSleepTimer = false;
  }

  @action
  timerCanceled() {
    timerSleepStart = false;
    timerEndTime = DateTime.now();
  }
}
