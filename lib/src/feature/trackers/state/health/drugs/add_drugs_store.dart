import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart' hide LocaleSettings;

part 'add_drugs_store.g.dart';

class AddDrugsViewStore extends _AddDrugsViewStore with _$AddDrugsViewStore {
  AddDrugsViewStore({
    required super.picker,
    required super.restClient,
  });
}

abstract class _AddDrugsViewStore with Store {
  final RestClient restClient;
  final ImagePicker picker;

  FormGroup? formGroup;

  _AddDrugsViewStore({
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
        'd MMMM hh:mm',
        LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
      ).format(selectedDate);
    }
  }

  @action
  Future selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      if (model != null) {
        if (context.mounted) model!.reminder.add(picked.format(context));
      } else {
        if (context.mounted) {
          model = EntityMainDrug(
              reminder: ObservableList.of([picked.format(context)]),
              reminderAfter: ObservableList());
        }
      }
    }
  }

  @observable
  int numberOfSpoons = 1;

  @action
  void incrementSpoons(BuildContext context) {
    Picker(
      selecteds: [numberOfSpoons],
      adapter: NumberPickerAdapter(data: [
        const NumberPickerColumn(begin: 1, end: 25, jump: 1),
      ]),
      hideHeader: true,
      onSelect: (Picker picker, i, List<int> value) {
        numberOfSpoons = value[i];
        dose?.value = t.trackers.pillDescription.averageCount(n: value[i]);
      },
    ).showModal(context);
  }

  @observable
  XFile? image;

  @observable
  String? imageUrl;

  @action
  Future<void> pickImage() async {
    final pickedFile = await picker.pickMedia();

    if (pickedFile != null) {
      image = pickedFile;
    }
  }

  @observable
  EntityMainDrug? model;

  @action
  void init(EntityMainDrug? model) {
    this.model = model;

    // if (model != null && model.photos != null && model.photos!.isNotEmpty) {
    //   imagesUrls = ObservableList.of(model.photos!.map((e) => e));
    // }

    formGroup = FormGroup({
      'name': FormControl<String>(
        value: model == null ? '' : '${model.name}',
        validators: [Validators.required],
      ),
      'dataStart': FormControl<String>(
        // value: model.date,
        // value: model == null || model.date == null
        //     ? ''
        //     : DateFormat(
        //         'd MMMM y',
        //         LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
        //       ).format(model.date!),
        validators: [Validators.required],
      ),
      'dose': FormControl<String>(
        value: model == null ? '' : '${model.dose}',
      ),
      'comment': FormControl<String>(
        value: model == null ? '' : '${model.notes}',
      ),
    });
  }

  @observable
  TimeOfDay? notificationTime;

  AbstractControl? get name => formGroup?.control('name');

  bool get isNameValid => name?.valid ?? false;

  AbstractControl? get dataStart => formGroup?.control('dataStart');

  bool get isDataStartValid => dataStart?.valid ?? false;

  AbstractControl? get dose => formGroup?.control('dose');

  bool get isDoseValid => dose?.valid ?? false;

  AbstractControl? get comment => formGroup?.control('comment');

  bool get isCommentValid => comment?.valid ?? false;

  void dispose() => formGroup?.dispose();

  Future _add(String childId) async {
    return await restClient.health.postHealthDrug(
      childId: childId,
      photo: image != null ? File(image!.path) : null,
      dataStart: selectedDate.toString(),
      dose: '$numberOfSpoons',
      nameDrug: name?.value,
      reminder: notificationTime != null
          ? '${notificationTime?.hour}:${notificationTime?.minute}:00'
          : null,
      isEnd: false,
      notes: comment?.value,
    );
  }

  Future add(String childId, DrugsStore? store) async {
    logger.info('Сохраняем данные для childId: $childId',
        runtimeType: runtimeType);

    _add(childId).then((v) {
      store?.listData.add(EntityMainDrug(
        id: v,
        name: name?.value,
        // dataStart: selectedDate.toString(),
        dose: '$numberOfSpoons',
        notes: comment?.value,
        // isEnd: false,
        // dataEnd: null,
        // reminder: notificationTime != null
        //     ? '${notificationTime?.hour}:${notificationTime?.minute}:00'
        //     : null,

        // child_id: addDrugsViewStore.model?.child_id ?? '',
        // data_start: addDrugsViewStore.model?.data_start ?? '',
        // name_drug: addDrugsViewStore.model?.name_drug ?? '',
        // dose: addDrugsViewStore.model?.dose ?? '',
        // notes: addDrugsViewStore.model?.notes ?? '',
        // reminder: addDrugsViewStore.model?.reminder ?? '',
        // is_end: addDrugsViewStore.model?.is_end ?? false,
        reminder: ObservableList(),
        reminderAfter: ObservableList(),
      ));
    });
  }

  Future update({DateTime? dataEnd}) async {
    if (model != null) {
      model?.reminder.removeWhere((e) => e.isEmpty);

      return await restClient.health.patchHealthDrug(
        id: model!.id!,
        photo: image != null ? File(image!.path) : null,
        dataStart: selectedDate.toString(),
        dose: dose?.value,
        nameDrug: name?.value,
        isEnd: dataEnd != null,
        dataEnd: dataEnd?.toUtc().toIso8601String(),
        notes: comment?.value,
        reminder:
            model?.reminder.map((e) => e is String ? '$e:00' : '').toList(),
      );
    }
  }

  Future delete() async {
    if (model != null) {
      return await restClient.health
          .deleteHealthDrug(dto: HealthDeleteDrug(id: model!.id ?? ''));
    }
  }
}
