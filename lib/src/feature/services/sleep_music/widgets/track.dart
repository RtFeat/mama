import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'play_btn.dart';

class TrackWidget extends StatelessWidget {
  final TrackModel model;

  const TrackWidget({
    super.key,
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final MusicStore store = context.watch<MusicStore>();

    return Row(
      children: [
        /// #play button, name, author, time range
        Expanded(
          child: Row(
            children: [
              /// #play button
              AudioPlayerWidget(
                onPause: () {},
                onPlay: () {
                  store.setSelectedMusic(model);
                },
                source: model.source,
                player: context.watch(),
                builder: (isPlaying) => PlayButton(isPlaying: isPlaying),
              ),
              8.w,

              /// #name, author
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// #name
                    AutoSizeText(
                      model.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),

                    /// #author
                    AutoSizeText(model.author ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// #time range
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AutoSizeText(
            model.duration.toMinutes,
            style: textTheme.titleSmall?.copyWith(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
