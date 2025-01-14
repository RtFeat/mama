import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

part 'bottom_bar.g.dart';

class ChatBottomBarStore extends _ChatBottomBarStore with _$ChatBottomBarStore {
  ChatBottomBarStore({
    required super.store,
  });
}

abstract class _ChatBottomBarStore with Store {
  final MessagesStore store;
  final record = AudioRecorder();

  _ChatBottomBarStore({required this.store});

  Timer? _timer;

  @observable
  bool isRecording = false;

  @action
  void setIsRecording(bool value) => isRecording = value;

  @observable
  bool isShowEmojiPanel = false;

  @action
  void setIsShowEmojiPanel(bool value) => isShowEmojiPanel = value;

  @observable
  int seconds = 0; // Время записи в секундах

  @computed
  String get formattedDuration {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @observable
  double dragOffset = 0;

  @observable
  double maxDragDistance = 200;

  @computed
  double get fadeOpacity =>
      1.0 - (dragOffset / maxDragDistance).clamp(0.0, 1.0);

  @action
  void setMaxDragDistance(double value) => maxDragDistance = value;

  @action
  void setDragOffset(DragUpdateDetails details) {
    dragOffset = (dragOffset - details.delta.dx).clamp(0.0, maxDragDistance);

    if (dragOffset >= maxDragDistance) {
      stopRecording(isCanSend: false); // Отмена записи
    }
  }

  @action
  void resetDragOffset() => dragOffset = 0;

  Future sendMessage(String? filePath) async {
    logger.info('Сообщение отправлено', runtimeType: runtimeType);
    // TODO send message
  }

  Future<String> _generateFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp =
        DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
    final recordingsDir = Directory('${dir.path}/recordings');

    // Создаем папку, если она не существует
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    return '${recordingsDir.path}/recording_$timestamp.m4a';
  }

  @action
  Future startRecording() async {
    final filePath = await _generateFilePath();

    if (await record.hasPermission()) {
      await record.start(
        const RecordConfig(),
        path: filePath,
      );

      setIsRecording(true);
      _startTimer(); // Запуск таймера
    } else {
      logger.warning('Нет разрешения на запись');
    }
  }

  @action
  Future stopRecording({bool isCanSend = false}) async {
    if (!isRecording) return;

    _stopTimer();

    final filePath = await record.stop();
    if (filePath != null) {
      final file = File(filePath);

      if (await file.exists()) {
        final fileSize = await file.length();

        // Если запись слишком короткая, удаляем файл
        if (seconds < 2 || fileSize == 0) {
          logger.info('Запись слишком короткая или файл пустой. Удаляем файл.',
              runtimeType: runtimeType);
          await file.delete();
          isCanSend = false;
        } else if (fileSize > 0) {
          logger.info('Файл успешно записан: $filePath, размер: $fileSize байт',
              runtimeType: runtimeType);
        }
      }
    }

    if (isCanSend) {
      sendMessage(filePath);
    }

    setIsRecording(false);
  }

  @action
  void onDragEnd(DragEndDetails details) {
    if (!isRecording) return;

    // Проверяем длительность записи перед отправкой
    if (seconds >= 2) {
      stopRecording(isCanSend: true);
    } else {
      logger.info('Запись слишком короткая, не отправляем сообщение.',
          runtimeType: runtimeType);
      stopRecording(isCanSend: false);
    }
  }

  @action
  void _startTimer() {
    seconds = 0; // Сбрасываем счетчик перед началом записи
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds++;
    });
  }

  @action
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @observable
  ObservableList<PlatformFile> files = ObservableList();

  @action
  Future getAttach() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    logger.info('Выбрано файлов: ${result?.files.length}',
        runtimeType: runtimeType);

    if (result != null) {
      files.addAll(result.files);
      // files = ObservableList.of(result.files);
    } else {
      // User canceled the picker
    }
  }
}
