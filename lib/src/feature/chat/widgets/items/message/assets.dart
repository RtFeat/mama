import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class MessageAssets extends StatelessWidget {
  final MessageItem item;
  const MessageAssets({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    if (item.files == null || item.files!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (item.hasVoice) {
      final MessageFile file =
          item.files!.firstWhere((e) => e.typeFile == 'm4a');
      return Stack(
        children: [
          Row(
            children: [
              AudioPlayerWidget(
                source: UrlSource(
                    '${const AppConfig().apiUrl}chat/message/file/${file.fileUrl}.${file.typeFile}'),
                player: context.watch(),
                builder: (isPlaying) {
                  return PlayButton(isPlaying: isPlaying);
                },
              ),
              10.w,
              Expanded(child: Text(t.chat.voice)),
            ],
          ),
          Positioned(
            right: 0,
            child: Text(
              item.createdAt?.formattedTime ?? '',
              maxLines: 1,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.greyColor,
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Observer(builder: (context) {
        return Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.files!.map((e) {
                  if (e.fileUrl != null && e.fileUrl!.isNotEmpty) {
                    return AssetItemWidget(
                        asset: e,
                        onTapDelete: () {
                          item.files?.remove(e);
                        });
                  }

                  return const SizedBox.shrink();
                }).toList(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
