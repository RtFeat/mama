import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'add_pumping.g.dart';

class AddPumping extends _AddPumping with _$AddPumping {
  AddPumping();
}

abstract class _AddPumping with Store {
  final FormBuilder formBuilder = FormBuilder();

  late final FormGroup formGroup = formBuilder.group({
    'left': FormControl<int>(value: 0),
    'right': FormControl<int>(value: 0),
  });

  AbstractControl get left => formGroup.control('left');

  AbstractControl get right => formGroup.control('right');

  @observable
  DateTime? selectedDateTime;

  @action
  void setSelectedDateTime(DateTime? value) {
    selectedDateTime = value;
  }

  void dispose() {
    formGroup.dispose();
  }
}
