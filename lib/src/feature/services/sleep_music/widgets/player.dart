import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

import 'progress_bar.dart';

class TrackPlayer extends StatelessWidget {
  const TrackPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final MusicStore store = context.watch<MusicStore>();

    return Observer(builder: (context) {
      if (store.selectedMusic == null) {
        return const SizedBox.shrink();
      }

      return const ColoredBox(
        color: AppColors.whiteColor,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// #slider
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: ProgressBar(),
                ),

                /// #controls
                Row(
                  children: [
                    _PlayPauseButton(),
                    Expanded(child: _Header()),
                    _Trailing(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton();

  @override
  Widget build(BuildContext context) {
    final AudioPlayerStore audioPlayerStore = context.watch();

    return IconButton(
      onPressed: () {
        if (audioPlayerStore.isPlaying) {
          audioPlayerStore.pause();
        } else {
          audioPlayerStore.resume();
        }
      },
      icon: Observer(builder: (context) {
        if (audioPlayerStore.isPlaying) {
          return const Icon(
            AppIcons.pauseFill,
            color: AppColors.primaryColor,
          );
        }
        return const Icon(
          AppIcons.playFill,
          color: AppColors.primaryColor,
        );
      }),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final MusicStore store = context.watch<MusicStore>();

    return Observer(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// #name
          Text(
            store.selectedMusic?.title ?? '',
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall,
          ),

          /// #author
          Text(
            store.selectedMusic?.author ?? 'author',
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall,
          ),
        ],
      );
    });
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing();

  @override
  Widget build(BuildContext context) {
    final MusicStore store = context.watch<MusicStore>();
    final AudioPlayerStore audioPlayerStore = context.watch();

    return Row(
      children: [
        IconButton(
          onPressed: () {
            store.toggleIsLooping();
          },
          icon: Observer(builder: (context) {
            return store.isLooping
                ? const Icon(
                    AppIcons.infinityCircleFill,
                    color: AppColors.primaryColor,
                  )
                : const Icon(
                    AppIcons.infinityCircle,
                  );
          }),
        ),
        Observer(builder: (_) {
          final bool canSkip = store.isHasNextMusic;

          return IconButton(
            icon: Icon(
              canSkip ? AppIcons.forwardEndAltFill : AppIcons.xmark,
              color:
                  canSkip ? AppColors.primaryColor : AppColors.greyLighterColor,
            ),
            onPressed: () {
              if (canSkip) {
                store.nextMusic();
                final source = store.selectedMusic?.source;
                if (source != null) {
                  audioPlayerStore.play(source);
                }
              } else {
                store.setSelectedMusic(null);
              }
            },
          );
        }),
      ],
    );
  }
}
