import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';

class AudioPlayerWidget extends StatelessWidget {
  final Source? source;
  final AudioPlayerStore player;

  final Function()? onPause;
  final Function()? onPlay;

  final Function()? onTap;
  final Widget Function(bool isPlaying) builder;

  const AudioPlayerWidget({
    super.key,
    required this.source,
    required this.player,
    required this.builder,
    this.onTap,
    this.onPause,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      bool thisPlayer = source != null && player.source != null
          ? switch (source) {
              UrlSource _ => (source as UrlSource).url.split('/').last ==
                  (player.source as UrlSource).url.split('/').last,
              DeviceFileSource _ => (source as DeviceFileSource).path ==
                  (player.source as DeviceFileSource).path,
              AssetSource _ => (source as AssetSource).path ==
                  (player.source as AssetSource).path,
              BytesSource _ => (source as BytesSource).bytes ==
                  (player.source as BytesSource).bytes,
              _ => false
            }
          : false;
      final isPlaying = player.isPlaying && thisPlayer;

      return GestureDetector(
        onTap: () {
          if (isPlaying) {
            player.pause();
            onPause?.call();
          } else {
            if (source != null) player.play(source!);
            onPlay?.call();
          }
          onTap?.call();
        },
        child: builder(isPlaying),
      );
    });
  }
}
