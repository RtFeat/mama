import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'doctor_visit_view.g.dart';

class DoctorVisitViewStore extends _DoctorVisitViewStore
    with _$DoctorVisitViewStore {
  DoctorVisitViewStore({
    required super.model,
    required super.restClient,
  });
}

abstract class _DoctorVisitViewStore with Store {
  final DoctorVisitModel model;
  final RestClient restClient;

  late final FormGroup formGroup;

  _DoctorVisitViewStore({
    required this.model,
    required this.restClient,
  });

  // @observable
  // DateTime? selectedDate;

  @observable
  DateTime selectedDate = DateTime.now();

  // @observable
  // TimeOfDay? selectedTime;

  @observable
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  @computed
  DateTime get selectedDateTime => DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

  // @observable
  // String formattedDateTime = '';

  @observable
  XFile? image;

  // @action
  // Future<void> selectDateTime(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (pickedDate != null) {
  //     final TimeOfDay? pickedTime = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //     );

  //     if (pickedTime != null) {
  //       selectedDate = pickedDate;
  //       selectedTime = pickedTime;
  //       formattedDateTime = formatDateTime(selectedDate!, selectedTime!);
  //     }
  //   }
  // }

  // String formatDateTime(DateTime date, TimeOfDay time) {
  //   final DateTime dateTime = DateTime(
  //     date.year,
  //     date.month,
  //     date.day,
  //     time.hour,
  //     time.minute,
  //   );

  //   final String formattedDate =
  //       DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(dateTime);
  //   // final String formattedTime = DateFormat('HH:mm').format(dateTime);
  //   return '$formattedDate';
  // }

  @computed
  String get formattedDateTime {
    // final String formattedDate =
    //     DateFormat('d MMMM', 'ru').format(selectedDateTime);
    final String formattedDate =
        DateFormat('dd MMMM yyyy').format(selectedDateTime);
    // final String formattedTime = DateFormat('HH:mm').format(selectedDateTime);
    return '$formattedDate';
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
    // if (selectedTime == null) return '';
    // final hour = selectedTime.hour.toString().padLeft(2, '0');
    // final minute = selectedTime.minute.toString().padLeft(2, '0');
    final String formattedTime = DateFormat('HH:mm').format(selectedDateTime);
    return formattedTime;
  }

  void init() {
    formGroup = FormGroup({
      'doctor': FormControl<String>(
        value: '${model.doctor}',
        validators: [Validators.required],
      ),
      'dataStart': FormControl<String>(
        value: model.data_start,
        validators: [Validators.required],
      ),
      'clinic': FormControl<String>(
        value: '${model.clinic}',
        validators: [Validators.required],
      ),
      'comment': FormControl<String>(
        value: '${model.notes}',
        validators: [Validators.required],
      ),
    });
  }

  AbstractControl get doctor => formGroup.control('doctor');

  bool get isDoctorValid => doctor.valid;

  AbstractControl get dataStart => formGroup.control('dataStart');

  bool get isDataStartValid => dataStart.valid;

  AbstractControl get clinic => formGroup.control('clinic');

  bool get isClinicValid => clinic.valid;

  AbstractControl get comment => formGroup.control('comment');

  bool get isCommentValid => comment.valid;

  void updateData() {
    if (isDoctorValid && doctor.value != model.doctor) {
      model.setDoctor(doctor.value!);
    }

    if (isDataStartValid && dataStart.value != model.data_start) {
      model.setDataStart(dataStart.value!);
    }

    if (isClinicValid && clinic.value != model.clinic) {
      model.setClinic(clinic.value!);
    }

    if (isCommentValid && comment.value != model.notes) {
      model.setComment(comment.value!);
    }
  }

  void dispose() => formGroup.dispose();
}
