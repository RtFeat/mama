import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// #name
                    Text(
                      model.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000),
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                    2.h,

                    /// #author
                    if (model.author != null)
                      Text(
                        model.author!.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666E80),
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// #time range
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            model.duration.toMinutes,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF000000),
              fontFamily: 'SF Pro Text',
            ),
          ),
        ),
      ],
    );
  }
}
