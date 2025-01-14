import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'asset_row.dart';
import 'mention.dart';

class BottomBarTextField extends StatelessWidget {
  const BottomBarTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final MessagesStore store = context.watch();
    final ChatBottomBarStore barStore = context.watch();

    return Observer(builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (store.mentionedMessage != null) const MentionWidget(),
          if (barStore.files.isNotEmpty) const AssetsInBottomWidget(),
          barStore.isShowEmojiPanel
              ? const _Field()
              : const SafeArea(child: _Field()),
          if (barStore.isShowEmojiPanel) const EmojiWidget()
        ],
      );
    });
  }
}

class _Field extends StatelessWidget {
  const _Field();

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
        ),
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
                // TODO: send message
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
