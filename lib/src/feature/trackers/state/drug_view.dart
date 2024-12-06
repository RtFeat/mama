import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'drug_view.g.dart';

class DrugViewStore extends _DrugViewStore with _$DrugViewStore {
  DrugViewStore({
    required super.model,
    required super.restClient,
  });
}

abstract class _DrugViewStore with Store {
  final DrugModel model;
  final RestClient restClient;

  late final FormGroup formGroup;

  _DrugViewStore({
    required this.model,
    required this.restClient,
  });

  @observable
  DateTime? selectedDate;

  @observable
  TimeOfDay? selectedTime;

  @observable
  String formattedDateTime = '';

  @observable
  XFile? image;

  @action
  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedDate = pickedDate;
        selectedTime = pickedTime;
        formattedDateTime = formatDateTime(selectedDate!, selectedTime!);
      }
    }
  }

  String formatDateTime(DateTime date, TimeOfDay time) {
    final DateTime dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final String formattedDate = DateFormat('d MMMM', 'ru').format(dateTime);
    final String formattedTime = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate $formattedTime';
  }

  @action
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = pickedFile;
    }
  }

  @action
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      selectedTime = pickedTime; // Обновляем выбранное время
    }
  }

  String get formattedTime {
    if (selectedTime == null) return '';
    final hour = selectedTime!.hour.toString().padLeft(2, '0');
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void init() {
    formGroup = FormGroup({
      'nameDrug': FormControl<String>(
        value: '${model.nameDrug}',
        validators: [Validators.required],
      ),
      'dataStart': FormControl<String>(
        value: model.dataStart,
        validators: [Validators.required],
      ),
      'dose': FormControl<String>(
        value: '${model.dose}',
        validators: [Validators.required],
      ),
      'comment': FormControl<String>(
        value: '${model.comment}',
        validators: [Validators.required],
      ),
    });
  }

  AbstractControl get nameDrug => formGroup.control('nameDrug');

  bool get isNameDrugValid => nameDrug.valid;

  AbstractControl get dataStart => formGroup.control('dataStart');

  bool get isDataStartValid => dataStart.valid;

  AbstractControl get dose => formGroup.control('dose');

  bool get isDoseValid => dose.valid;

  AbstractControl get comment => formGroup.control('comment');

  bool get isCommentValid => comment.valid;

  void updateData() {
    if (isNameDrugValid && nameDrug.value != model.nameDrug) {
      model.setNameDrug(nameDrug.value!);
    }

    if (isDataStartValid && dataStart.value != model.dataStart) {
      model.setDataStart(dataStart.value!);
    }

    if (isDoseValid && dose.value != model.dose) {
      model.setDose(dose.value!);
    }

    if (isCommentValid && comment.value != model.comment) {
      model.setComment(comment.value!);
    }
  }

  void dispose() => formGroup.dispose();
}
