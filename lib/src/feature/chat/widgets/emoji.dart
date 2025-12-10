import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:mama/src/data.dart';

class EmojiWidget extends StatelessWidget {
  final MessagesStore store;
  const EmojiWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return emoji.EmojiPicker(
      // textEditingController: controller,
      onEmojiSelected: (category, emoji) {
        final control = store.formGroup.control('message');
        final String? value = control.value;

        if (value == null) {
          control.value = emoji.emoji;
        } else {
          control.value += emoji.emoji;
        }
      },
      config: emoji.Config(
        height: 200,
        checkPlatformCompatibility: true,
        viewOrderConfig: const emoji.ViewOrderConfig(
          top: emoji.EmojiPickerItem.categoryBar,
          middle: emoji.EmojiPickerItem.emojiView,
          bottom: emoji.EmojiPickerItem.searchBar,
        ),
        emojiViewConfig: emoji.EmojiViewConfig(
          backgroundColor: AppColors.lightPirple,
          emojiSizeMax: 28 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.2
                  : 1.0),
        ),
        skinToneConfig: const emoji.SkinToneConfig(),
        categoryViewConfig: const emoji.CategoryViewConfig(
          backgroundColor: AppColors.lightPirple,
        ),
        bottomActionBarConfig:
            const emoji.BottomActionBarConfig(enabled: false),
        searchViewConfig: const emoji.SearchViewConfig(),
      ),
    );
  }
}
