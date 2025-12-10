import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skit/skit.dart' hide LocaleSettings;

part 'add_drugs_store.g.dart';

class AddDrugsViewStore extends _AddDrugsViewStore with _$AddDrugsViewStore {
  AddDrugsViewStore({
    required super.picker,
    required super.restClient,
    required super.sharedPreferences,
  });
}

abstract class _AddDrugsViewStore with Store {
  final RestClient restClient;
  final ImagePicker picker;
  final SharedPreferences sharedPreferences;

  FormGroup? formGroup;

  _AddDrugsViewStore({
    required this.restClient,
    required this.picker,
    required this.sharedPreferences,
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
      // сохраняем выбранную дату, время остаётся прежним
      selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDate.hour,
        selectedDate.minute,
      );
      dataStart?.value = DateFormat(
        'd MMMM HH:mm',
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
      // Обновляем время начала приёма на выбранное время
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );
      dataStart?.value = DateFormat(
        'd MMMM HH:mm',
        LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
      ).format(selectedDate);
      // Форматируем время вручную в формате HH:mm
      final String formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      
      if (model != null) {
        if (context.mounted) {
          model!.reminder.add(formattedTime);
          logger.info('Добавлено напоминание: $formattedTime', runtimeType: runtimeType);
        }
      } else {
        if (context.mounted) {
          model = EntityMainDrug(
              reminder: ObservableList.of([formattedTime]),
              reminderAfter: ObservableList());
          logger.info('Создан новый model с напоминанием: $formattedTime', runtimeType: runtimeType);
        }
      }
    }
  }

  @observable
  int numberOfSpoons = 0;

  @action
  void incrementSpoons(BuildContext context) {
    Picker(
      selecteds: [numberOfSpoons],
      adapter: NumberPickerAdapter(data: [
        const NumberPickerColumn(begin: 0, end: 25, jump: 1),
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

  @observable
  bool isSaving = false;

  @action
  void init(EntityMainDrug? model) {
    this.model = model;
    
    logger.info('init: ВЫЗВАН init с model = ${model?.name}, id = ${model?.id}, dataStart = ${model?.dataStart}', runtimeType: runtimeType);

    // Инициализируем numberOfSpoons из dose модели, если она существует
    if (model != null && model.dose != null && model.dose!.isNotEmpty) {
      try {
        // Извлекаем первое число из строки дозы (например, из "1 ложка" -> 1)
        final match = RegExp(r'\d+').firstMatch(model.dose!);
        if (match != null) {
          numberOfSpoons = int.parse(match.group(0)!);
        } else {
          numberOfSpoons = 0;
        }
      } catch (e) {
        logger.error('Ошибка парсинга дозы: $e', runtimeType: runtimeType);
        numberOfSpoons = 0;
      }
    } else {
      numberOfSpoons = 0;
    }

    // if (model != null && model.photos != null && model.photos!.isNotEmpty) {
    //   imagesUrls = ObservableList.of(model.photos!.map((e) => e));
    // }

    // Если редактируем существующую запись, пытаемся получить дату из локального хранилища
    if (model?.id != null) {
      try {
        // Пытаемся получить сохраненную дату из SharedPreferences
        final savedDateString = sharedPreferences.getString('drug_${model!.id}_dataStart');
        if (savedDateString != null) {
          selectedDate = DateTime.parse(savedDateString);
          logger.info('init: установлена selectedDate из SharedPreferences: $selectedDate', runtimeType: runtimeType);
        } else {
          logger.info('init: нет сохраненной даты в SharedPreferences, используем текущую: $selectedDate', runtimeType: runtimeType);
        }
      } catch (e) {
        logger.error('init: ошибка загрузки даты из SharedPreferences: $e', runtimeType: runtimeType);
      }
    } else if (model?.dataStart != null) {
      // Если есть dataStart в модели, используем её
      try {
        selectedDate = DateTime.parse(model!.dataStart!);
        logger.info('init: установлена selectedDate из model.dataStart: $selectedDate', runtimeType: runtimeType);
      } catch (e) {
        logger.error('init: ошибка парсинга dataStart: $e', runtimeType: runtimeType);
      }
    } else {
      logger.info('init: model.dataStart == null, используем текущую дату: $selectedDate', runtimeType: runtimeType);
    }

    formGroup = FormGroup({
      'name': FormControl<String>(
        value: model == null ? '' : '${model.name}',
        validators: [Validators.required],
      ),
      'dataStart': FormControl<String>(
        value: model == null 
            ? DateFormat(
                'd MMMM HH:mm',
                LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
              ).format(selectedDate)
            : model!.dataStart != null 
                ? (() {
                    logger.info('Используем dataStart из модели: ${model!.dataStart}', runtimeType: runtimeType);
                    return DateFormat(
                      'd MMMM HH:mm',
                      LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
                    ).format(DateTime.parse(model!.dataStart!));
                  })()
                : (() {
                    logger.info('dataStart в модели null, используем selectedDate', runtimeType: runtimeType);
                    return DateFormat(
                      'd MMMM HH:mm',
                      LocaleSettings.currentLocale.flutterLocale.toLanguageTag(),
                    ).format(selectedDate);
                  })(),
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
    // Подготавливаем список напоминаний
    List<String>? reminders;
    if (model != null && model!.reminder.isNotEmpty) {
      reminders = model!.reminder
          .where((e) => e is String && e.isNotEmpty)
          .map((e) {
            if (e is String && e.isNotEmpty) {
              // Обрабатываем время для правильного формата
              String time = e;
              
              // Если время уже в формате HH:mm:ss, убираем секунды
              if (time.split(':').length == 3) {
                return time.substring(0, 5); // Убираем :00 в конце
              }
              
              // Если время в формате HH:mm, оставляем как есть
              if (time.split(':').length == 2) {
                return time;
              }
              
              // Если время содержит лишние :00:00, убираем их
              if (time.endsWith(':00:00')) {
                time = time.substring(0, time.length - 3);
                return time;
              }
              
              return time;
            }
            return '';
          })
          .toList();
      logger.info('Напоминания для отправки на сервер: $reminders', runtimeType: runtimeType);
    } else {
      logger.info('Напоминания отсутствуют или model == null', runtimeType: runtimeType);
    }
    
    logger.info('Отправляем данные на сервер: name=${name?.value}, dose=${dose?.value}, childId=$childId', runtimeType: runtimeType);
    
    // Отправляем дату в формате, ожидаемом API: 'yyyy-MM-dd HH:mm:00.000'
    final String apiDataStart = DateFormat('yyyy-MM-dd HH:mm:00.000')
        .format(selectedDate.toLocal());

    return await restClient.health.postHealthDrug(
      childId: childId,
      photo: image != null ? File(image!.path) : null,
      dataStart: apiDataStart,
      dose: dose?.value ?? '$numberOfSpoons',
      nameDrug: name?.value,
      reminder: reminders?.isNotEmpty == true ? reminders : null,
      isEnd: false,
      notes: comment?.value,
    );
  }

  @action
  Future add(String childId, DrugsStore? store) async {
    // Предотвращаем двойное нажатие
    if (isSaving) {
      logger.info('Попытка сохранить повторно, операция уже выполняется', runtimeType: runtimeType);
      return;
    }

    isSaving = true;
    logger.info('Сохраняем данные для childId: $childId, store: ${store != null ? "не null" : "null"}',
        runtimeType: runtimeType);

    try {
      final result = await _add(childId);
      logger.info('Результат добавления: $result', runtimeType: runtimeType);
      
      // Сохраняем напоминания из model, если они есть
      ObservableList<String> reminders = ObservableList();
      if (model != null && model!.reminder.isNotEmpty) {
        reminders = ObservableList.of(model!.reminder
            .where((e) => e is String && e.isNotEmpty)
            .cast<String>());
        logger.info('Напоминания для сохранения: ${reminders.toList()}', runtimeType: runtimeType);
      }
      
      // Добавляем логирование перед созданием newDrug
      logger.info('Значение name?.value перед созданием newDrug: ${name?.value}', runtimeType: runtimeType);
      logger.info('Значение dose?.value перед созданием newDrug: ${dose?.value}', runtimeType: runtimeType);
      logger.info('Значение numberOfSpoons перед созданием newDrug: $numberOfSpoons', runtimeType: runtimeType);
      
      // Вычисляем reminderAfter на клиенте
      ObservableList<String> reminderAfter = ObservableList();
      if (reminders.isNotEmpty) {
        final now = DateTime.now();
        final currentTime = TimeOfDay.fromDateTime(now);
        
        for (String reminder in reminders) {
          try {
            final parts = reminder.split(':');
            if (parts.length >= 2) {
              final hour = int.parse(parts[0]);
              final minute = int.parse(parts[1]);
              final reminderTime = TimeOfDay(hour: hour, minute: minute);
              
              // Вычисляем разность во времени
              final nowMinutes = currentTime.hour * 60 + currentTime.minute;
              final reminderMinutes = reminderTime.hour * 60 + reminderTime.minute;
              
              int diffMinutes = reminderMinutes - nowMinutes;
              if (diffMinutes < 0) {
                diffMinutes += 24 * 60; // Если время уже прошло сегодня, считаем до завтра
              }
              
              final hours = diffMinutes ~/ 60;
              final minutes = diffMinutes % 60;
              
              String timeText;
              if (hours > 0 && minutes > 0) {
                timeText = 'Через $hours ${hours == 1 ? 'час' : hours < 5 ? 'часа' : 'часов'} $minutes ${minutes == 1 ? 'минуту' : minutes < 5 ? 'минуты' : 'минут'}';
              } else if (hours > 0) {
                timeText = 'Через $hours ${hours == 1 ? 'час' : hours < 5 ? 'часа' : 'часов'}';
              } else {
                timeText = 'Через $minutes ${minutes == 1 ? 'минуту' : minutes < 5 ? 'минуты' : 'минут'}';
              }
              
              reminderAfter.add(timeText);
            }
          } catch (e) {
            logger.error('Ошибка при вычислении времени: $e', runtimeType: runtimeType);
          }
        }
      }
      
      final newDrug = EntityMainDrug(
        id: result,
        name: name?.value,
        dose: dose?.value ?? '$numberOfSpoons',
        notes: comment?.value,
        dataStart: selectedDate.toIso8601String(),
        reminder: reminders,
        reminderAfter: reminderAfter,
      );
      
      // Сохраняем дату начала в SharedPreferences для будущего редактирования
      try {
        await sharedPreferences.setString('drug_${result}_dataStart', selectedDate.toIso8601String());
        logger.info('init: сохранена дата в SharedPreferences: ${selectedDate.toIso8601String()}', runtimeType: runtimeType);
      } catch (e) {
        logger.error('init: ошибка сохранения даты в SharedPreferences: $e', runtimeType: runtimeType);
      }
      
      logger.info('Добавляем новую запись в store: ${newDrug.name}', runtimeType: runtimeType);
      
      if (store != null) {
        // Небольшая задержка, чтобы сервер успел обработать запрос
        await Future.delayed(Duration(milliseconds: 500));
        
        // Перезагружаем данные с сервера, чтобы получить полную информацию включая картинку
        try {
          await store.refreshForChild(childId);
          logger.info('Данные перезагружены с сервера', runtimeType: runtimeType);
        } catch (e) {
          logger.error('Ошибка при перезагрузке данных: $e', runtimeType: runtimeType);
        }
      } else {
        logger.error('Store равен null! Запись не может быть добавлена в локальный список', runtimeType: runtimeType);
      }
      
    } catch (e) {
      logger.error('Ошибка при добавлении записи: $e', runtimeType: runtimeType);
    } finally {
      isSaving = false;
    }
  }

  Future update({DateTime? dataEnd}) async {
    if (model != null && model!.id != null) {
      model?.reminder.removeWhere((e) => e.isEmpty);

      // Подготавливаем список напоминаний
      List<String>? reminders;
      if (model!.reminder.isNotEmpty) {
        reminders = model!.reminder
            .where((e) => e is String && e.isNotEmpty)
            .map((e) {
              if (e is String && e.isNotEmpty) {
                // Обрабатываем время для правильного формата
                String time = e;
                
                // Если время уже в формате HH:mm:ss, убираем секунды
                if (time.split(':').length == 3) {
                  return time.substring(0, 5); // Убираем :00 в конце
                }
                
                // Если время в формате HH:mm, оставляем как есть
                if (time.split(':').length == 2) {
                  return time;
                }
                
                // Если время содержит лишние :00:00, убираем их
                if (time.endsWith(':00:00')) {
                  time = time.substring(0, time.length - 3);
                  return time;
                }
                
                return time;
              }
              return '';
            })
            .toList();
      }

      // Отправляем дату в формате API
      final String apiDataStart = DateFormat('yyyy-MM-dd HH:mm:00.000')
          .format(selectedDate.toLocal());

      return await restClient.health.patchHealthDrug(
        id: model!.id!,
        photo: image != null ? File(image!.path) : null,
        dataStart: apiDataStart,
        dose: dose?.value,
        nameDrug: name?.value,
        isEnd: dataEnd != null,
        dataEnd: dataEnd?.toUtc().toIso8601String(),
        notes: comment?.value,
        reminder: reminders?.isNotEmpty == true ? reminders : null,
      );
    }
  }

  Future delete() async {
    if (model != null && model!.id != null) {
      return await restClient.health
          .deleteHealthDrug(dto: HealthDeleteDrug(id: model!.id!));
    }
  }
}
