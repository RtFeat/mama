import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final String formControllName;
  final VoidCallback onTapSmile;
  final VoidCallback onTapAttach;
  final VoidCallback onTapRecord;
  const MessageInput({
    super.key,
    required this.formControllName,
    required this.onTapSmile,
    required this.controller,
    required this.onTapAttach,
    required this.onTapRecord,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return ReactiveValueListenableBuilder(
        formControlName: widget.formControllName,
        builder: (context, control, child) {
          return Container(
            height: (control.value != null && control.value != '') ? null : 88,
            // decoration: const BoxDecoration(color: AppColors.lightPirple),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(color: AppColors.lightPirple),
                  child: ReactiveTextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: widget.controller,
                    formControlName: widget.formControllName,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: null,
                    style: textTheme.titleSmall,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: t.chat.messageHint,
                      hintStyle: textTheme.titleSmall!
                          .copyWith(color: AppColors.greyBrighterColor),

                      //TODO! сделать кнопки внизу
                      prefixIcon: IconButton(
                        onPressed: () => widget.onTapSmile(),
                        // icon: Image.asset(
                        //   Assets.icons.smile.path,
                        //   height: 28,
                        // ),
                        icon: const Icon(
                          AppIcons.faceSmiling,
                          color: AppColors.greyLighterColor,
                          size: 28,
                        ),
                      ),
                      suffixIcon: (control.value != null && control.value != '')
                          ? IconButton(
                              onPressed: () {},
                              // icon: Image.asset(
                              //   Assets.icons.send.path,
                              //   height: 28,
                              // ),
                              icon: const Icon(
                                AppIcons.send,
                                size: 28,
                                color: AppColors.primaryColor,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => widget.onTapAttach(),
                                  // icon: Image.asset(
                                  //   Assets.icons.attach.path,
                                  //   height: 24,
                                  // ),
                                  icon: const Icon(
                                    AppIcons.paperclip,
                                    size: 24,
                                    color: AppColors.greyLighterColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                (control.value != null && control.value != '')
                    ? const SizedBox.shrink()
                    : RecordingMicWidget(
                        onHorizontalScrollComplete: () {
                          // cancelRecord();
                        },
                        onLongPress: () {
                          // startRecording();
                        },
                        onLongPressCancel: () {
                          // stopRecording();
                        },
                        onSend: () {
                          // stopRecording();
                        },
                        onTapCancel: () {
                          // cancelRecord();
                        },
                      ),
              ],
            ),
          );
        });
  }
}
