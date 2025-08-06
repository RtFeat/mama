import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart' hide LocaleSettings;

part 'add_doctor_visit_store.g.dart';

class AddDoctorVisitViewStore extends _AddDoctorVisitViewStore
    with _$AddDoctorVisitViewStore {
  AddDoctorVisitViewStore({
    required super.picker,
    required super.restClient,
  });
}

abstract class _AddDoctorVisitViewStore with Store {
  final RestClient restClient;
  final ImagePicker picker;

  FormGroup? formGroup;

  _AddDoctorVisitViewStore({
    required this.restClient,
    required this.picker,
  });

  @observable
  DateTime selectedDate = DateTime.now();

  @action
  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dataStart?.value = DateFormat(
        'd MMMM y',
        LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
      ).format(selectedDate);
    }
  }

  @observable
  ObservableList<XFile> images = ObservableList.of([]);

  @observable
  ObservableList<String>? imagesUrls;

  @action
  Future<void> pickImage() async {
    final pickedFile = await picker.pickMultiImage();

    if (pickedFile.isNotEmpty) {
      images.addAll(pickedFile);
    }
  }

  @observable
  EntityMainDoctor? model;

  @action
  void init(EntityMainDoctor? model) {
    this.model = model;

    if (model != null && model.photos != null && model.photos!.isNotEmpty) {
      imagesUrls = ObservableList.of(model.photos!.map((e) => e));
    }

    formGroup = FormGroup({
      'doctor': FormControl<String>(
        value: model == null ? '' : '${model.doctor}',
        validators: [Validators.required],
      ),
      'dataStart': FormControl<String>(
        // value: model.date,
        value: model == null || model.date == null
            ? ''
            : DateFormat(
                'd MMMM y',
                LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
              ).format(model.date!),
        validators: [Validators.required],
      ),
      'clinic': FormControl<String>(
        value: model == null ? '' : model.clinic,
        validators: [Validators.required],
      ),
      'comment': FormControl<String>(
        value: model == null ? '' : '${model.notes}',
        validators: [Validators.required],
      ),
    });
  }

  AbstractControl? get doctor => formGroup?.control('doctor');

  bool get isDoctorValid => doctor?.valid ?? false;

  AbstractControl? get dataStart => formGroup?.control('dataStart');

  bool get isDataStartValid => dataStart?.valid ?? false;

  AbstractControl? get clinic => formGroup?.control('clinic');

  bool get isClinicValid => clinic?.valid ?? false;

  AbstractControl? get comment => formGroup?.control('comment');

  bool get isCommentValid => comment?.valid ?? false;

  // void updateData() {
  // if (isDoctorValid && doctor?.value != model.doctor) {
  //   model.setDoctor(doctor?.value!);
  // }

  // if (isDataStartValid && dataStart?.value != model.data_start) {
  //   model.setDataStart(dataStart?.value!);
  // }

  // if (isClinicValid && clinic?.value != model.clinic) {
  //   model.setClinic(clinic?.value!);
  // }

  // if (isCommentValid && comment?.value != model.notes) {
  //   model.setComment(comment?.value!);
  // }

  // model?.doctor = doctor?.value!;
  // model.data_start = dataStart?.value!;
  // model.clinic = clinic?.value!;
  //   model?.notes = comment?.value!;
  // }

  void dispose() => formGroup?.dispose();

  Future save(String childId) async {
    logger.info('Сохраняем данные для childId: $childId',
        runtimeType: runtimeType);

    model = EntityMainDoctor(
      doctor: doctor?.value,
      date: selectedDate,
      clinic: clinic?.value,
      notes: comment?.value,
      photos: images.map((e) => e.path).toList(),
      isLocal: true,
    );

    return await restClient.health.postHealthConsDoctor(
      childId: childId,
      photos: images.map((e) => File(e.path)).toList(),
      dataStart: selectedDate.toString(),
      doctor: doctor?.value,
      clinic: clinic?.value,
      notes: comment?.value,
    );
  }

  Future delete() async {
    if (model != null) {
      return await restClient.health.deleteHealthConsDoctor(
          dto: HealthDeleteConsDoctor(id: model?.id ?? ''));
    }
  }
}
