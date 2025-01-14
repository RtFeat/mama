import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class EmojiWidget extends StatelessWidget {
  const EmojiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MessagesStore store = context.watch();
    return emoji.EmojiPicker(
      // textEditingController: controller,
      onEmojiSelected: (category, emoji) {
        store.formGroup.control('message').value += emoji.emoji;
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
