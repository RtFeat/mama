import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

import 'recording/recording.dart';
import 'text_field.dart';

class ChatBottomBarBody extends StatefulWidget {
  final ChatBottomBarStore barStore;
  final MessagesStore? store;
  const ChatBottomBarBody(
      {super.key, required this.barStore, required this.store});

  @override
  State<ChatBottomBarBody> createState() => _ChatBottomBarBodyState();
}

class _ChatBottomBarBodyState extends State<ChatBottomBarBody>
    with TickerProviderStateMixin {
  late AnimationController _micController;
  late Animation<double> _micScaleAnimation;

  late AnimationController _textController;
  late Animation<double> _textOffsetAnimation;

  @override
  void initState() {
    super.initState();

    // Анимация микрофона
    _micController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _micScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _micController,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация текста
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textOffsetAnimation = Tween<double>(begin: -20.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeInOut,
      ),
    );

    // Запускаем анимацию текста
    _textController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _micController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    widget.barStore.setIsRecording(true);
    widget.barStore.resetDragOffset();
    widget.barStore.startRecording();
    _micController.repeat(reverse: true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    widget.barStore.setDragOffset(details);
  }

  void _onDragEnd(DragEndDetails details) {
    widget.barStore.onDragEnd(details);
  }

  @override
  Widget build(BuildContext context) {
    final MessagesStore? store = widget.store;
    final ChatBottomBarStore barStore = context.watch();

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Observer(builder: (_) {
            return widget.barStore.isRecording
                ? RecordingIndicator(
                    animation: _micScaleAnimation,
                  )
                : BottomBarTextField(
                    store: widget.store,
                  );
          }),
          Observer(builder: (_) {
            return Positioned(
              right: widget.barStore.isRecording
                  ? -20 + widget.barStore.dragOffset
                  : 10,
              // top: widget.barStore.isRecording ? -30 : 12,
              top: widget.barStore.isRecording
                  ? -30
                  : widget.barStore.isShowEmojiPanel &&
                              store?.mentionedMessage != null ||
                          barStore.files.isNotEmpty
                      ? 60 +
                          (barStore.files.isNotEmpty
                              ? widget.barStore.isShowEmojiPanel &&
                                      store?.mentionedMessage != null
                                  ? 100
                                  : 50
                              : 0)
                      : 12,
              bottom: store?.mentionedMessage != null &&
                      !widget.barStore.isShowEmojiPanel &&
                      barStore.files.isEmpty
                  ? 0
                  : barStore.files.isNotEmpty &&
                          !widget.barStore.isShowEmojiPanel &&
                          store?.mentionedMessage != null
                      ? 0
                      : null,
              child: ReactiveFormConsumer(builder: (context, form, child) {
                final String? value = form.control('message').value;
                final bool isNotEmpty = value != null && value != '';

                if (isNotEmpty) {
                  return const SizedBox.shrink();
                }

                return GestureDetector(
                  onHorizontalDragStart: _onDragStart,
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: Row(
                    children: [
                      if (widget.barStore.isRecording)
                        Opacity(
                          opacity: widget.barStore.fadeOpacity,
                          child: RecordingText(animation: _textOffsetAnimation),
                        ),
                      10.w,
                      if (!widget.barStore.isRecording) ...[
                        widget.barStore.files.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  // TODO: send message

                                  widget.barStore.sendMessage();
                                },
                                child: const Icon(
                                  AppIcons.send,
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  widget.barStore.getAttach();
                                },
                                child: const Icon(
                                  AppIcons.paperclip,
                                  color: AppColors.greyLighterColor,
                                )),
                        20.w,
                      ],
                      MicButton(animation: _micScaleAnimation),
                    ],
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
