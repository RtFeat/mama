import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:record/record.dart';
import 'package:skit/skit.dart';
import 'package:path/path.dart' as p;

part 'bottom_bar.g.dart';

class ChatBottomBarStore extends _ChatBottomBarStore with _$ChatBottomBarStore {
  ChatBottomBarStore({
    required super.store,
    required super.apiClient,
    required super.socket,
  });
}

abstract class _ChatBottomBarStore with Store {
  final MessagesStore store;
  final ChatSocket socket;
  final ApiClient apiClient;

  final record = AudioRecorder();

  _ChatBottomBarStore(
      {required this.store, required this.apiClient, required this.socket});

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
  double maxDragDistance = 120;

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
  void resetDragOffset() {
    dragOffset = 0;
  }

  @computed
  AbstractControl get messageController => store.formGroup.control('message');

  @computed
  String get _messageText => messageController.value ?? '';

  Future sendMessage({String? filePath}) async {
    logger.info('Сообщение отправлено', runtimeType: runtimeType);

    List<MessageFile> uploadedFiles = [];

    // Если есть файл для загрузки
    if (filePath != null) {
      uploadedFiles = await _uploadFiles(
        files: [filePath],
        apiClient: apiClient,
      );
    }
    // Если есть список файлов для загрузки
    else if (files.isNotEmpty) {
      final List<String> filePaths = files.map((file) => file.path!).toList();
      uploadedFiles = await _uploadFiles(
        files: filePaths,
        apiClient: apiClient,
      );
    }

    socket
        .sendMessage(
      files: uploadedFiles,
      messageText: _messageText,
      chatId: store.chatId!,
      replyMessageId: store.mentionedMessage?.id ?? '',
    )
        .then((v) {
      messageController.value = '';
      store.setMentionedMessage(null);
      files.clear();
    });
  }

  Future<List<MessageFile>> _uploadFiles({
    required List<String> files,
    required ApiClient apiClient,
  }) async {
    final List<MultipartFile> multipartFiles = await Future.wait(
      files.map((filePath) async {
        String fileName = p.basename(filePath); // Extract file name

        return await MultipartFile.fromFile(
          filePath,
          filename: fileName, // Explicitly set the file name
        );
      }),
    );

    print(multipartFiles.first); // Debugging

    FormData formData = FormData.fromMap({
      'file': multipartFiles,
    });

    final response =
        await apiClient.post(Endpoint().uploadFile, body: formData);

    if (response != null) {
      final List data = response['messages'] as List? ?? [];
      return data.map((e) => MessageFile.fromJson(e)).toList();
    }

    return [];
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
    try {
      isRecording = false;
      if (isRecording) {
        logger.warning('Запись уже идёт');
        return;
      }

      final filePath = await _generateFilePath();

      final hasPermission = await record.hasPermission();
      if (!hasPermission) {
        logger.warning('Нет разрешения на запись');
        return;
      }

      final isRecordingNow = await record.isRecording();
      if (isRecordingNow) {
        logger.warning(
            'Попытка начать запись, но уже идёт другая запись. Сбрасываем.');
        await stopRecording();
      }

      logger.info('Запускаем запись, файл: $filePath');
      await record.start(
        const RecordConfig(),
        path: filePath,
      );

      setIsRecording(true);
      _startTimer();
    } catch (e, stackTrace) {
      logger.error('Ошибка при старте записи: $e',
          error: e, stackTrace: stackTrace);
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
      sendMessage(filePath: filePath);
    }

    setIsRecording(false);
    seconds = 0;
  }

  @action
  void onDragEnd() {
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
    if (_timer != null) return;
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
