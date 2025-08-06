import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart' hide LocaleSettings;

part 'add_vaccine_store.g.dart';

class AddVaccineViewStore extends _AddVaccineViewStore
    with _$AddVaccineViewStore {
  AddVaccineViewStore({
    required super.picker,
    required super.restClient,
  });
}

abstract class _AddVaccineViewStore with Store {
  final RestClient restClient;
  final ImagePicker picker;

  FormGroup? formGroup;

  _AddVaccineViewStore({
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
        'd MMMM',
        LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
      ).format(selectedDate);
    }
  }

  @observable
  XFile? image;

  @action
  Future<void> pickImage() async {
    final pickedFile = await picker.pickMedia();

    if (pickedFile != null) {
      image = pickedFile;
      // images.addAll(pickedFile);
    }
  }

  @observable
  EntityVaccinationMain? model;

  @computed
  bool get isAdd => model == null;

  @action
  void init(EntityVaccinationMain? model) {
    this.model = model;

    // if (model != null && model.photos != null && model.photos!.isNotEmpty) {
    //   imagesUrls = ObservableList.of(model.photos!.map((e) => e));
    // }

    formGroup = FormGroup({
      'vaccine': FormControl<String>(
        // value: model == null ? '' : '${model.doctor}',
        validators: [Validators.required],
      ),
      'dataStart': FormControl<String>(
        // value: model == null || model. == null
        //     ? ''
        //     : DateFormat(
        //         'd MMMM y',
        //         LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
        //       ).format(model.date!),
        validators: [Validators.required],
      ),
      'clinic': FormControl<String>(
        // value: model == null ? '' : model.clinic,
        validators: [Validators.required],
      ),
      'comment': FormControl<String>(
        // value: model == null ? '' : '${model.notes}',
        validators: [Validators.required],
      ),
    });
  }

  AbstractControl? get vaccine => formGroup?.control('vaccine');

  bool get isVaccineValid => vaccine?.valid ?? false;

  AbstractControl? get dataStart => formGroup?.control('dataStart');

  bool get isDataStartValid => dataStart?.valid ?? false;

  AbstractControl? get clinic => formGroup?.control('clinic');

  bool get isClinicValid => clinic?.valid ?? false;

  AbstractControl? get comment => formGroup?.control('comment');

  bool get isCommentValid => comment?.valid ?? false;

  void dispose() => formGroup?.dispose();

  Future add(String childId) async {
    logger.info('Сохраняем данные для childId: $childId',
        runtimeType: runtimeType);

    return await restClient.health.postHealthVaccination(
      childId: childId,
      photo: image != null ? File(image!.path) : null,
      dataStart: selectedDate.toString(),
      vaccinationName: vaccine?.value,
      clinic: clinic?.value,
      notes: comment?.value,
    );
  }

  Future update() async {
    if (model != null) {
      return await restClient.health.patchHealthVaccination(
        id: model?.id ?? '',
        photo: image != null ? File(image!.path) : null,
        dataStart: selectedDate.toString(),
        clinic: clinic?.value,
        notes: comment?.value,
      );
    }
  }

  Future delete() async {
    if (model != null) {
      return await restClient.health.deleteHealthVaccination(
          dto: HealthDeleteVaccination(id: model?.id ?? ''));
    }
  }
}
