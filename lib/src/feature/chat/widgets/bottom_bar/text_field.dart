import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BottomBarTextField extends StatelessWidget {
  final MessagesStore? store;
  const BottomBarTextField({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ChatBottomBarStore barStore = context.watch();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: GestureDetector(
            onTap: () {
              barStore.setIsShowEmojiPanel(!barStore.isShowEmojiPanel);
            },
            child: Observer(builder: (_) {
              return Icon(
                AppIcons.faceSmiling,
                color: barStore.isShowEmojiPanel
                    ? AppColors.primaryColor
                    : AppColors.greyLighterColor,
              );
            }),
          ),
        ),
        Expanded(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ReactiveTextField(
            formControlName: 'message',
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            style: textTheme.titleSmall,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: t.chat.messageHint,
              hintStyle: textTheme.titleSmall!
                  .copyWith(color: AppColors.greyBrighterColor),
            ),
          ),
        )),
        ReactiveFormConsumer(builder: (context, form, child) {
          final String? value = form.control('message').value;
          final bool isNotEmpty = value != null && value != '';

          if (!isNotEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: GestureDetector(
              onTap: () {
                barStore.sendMessage();
              },
              child: const Icon(
                AppIcons.send,
                color: AppColors.primaryColor,
              ),
            ),
          );
        }),
      ],
    );
  }
}
