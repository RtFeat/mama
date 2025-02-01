import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final AudioPlayerStore audioPlayerStore = context.watch();

    return Observer(
      builder: (context) {
        if (audioPlayerStore.isPlaying) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// #start
              Text(
                  audioPlayerStore.position?.inSeconds.toMinutes ?? 0.toMinutes,
                  style: textTheme.labelSmall),

              /// #slider
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8,
                  ),
                  child: Slider(
                    value: audioPlayerStore.position?.inSeconds.toDouble() ?? 0,
                    max: audioPlayerStore.duration?.inSeconds.toDouble() ?? 1,
                    onChanged: (value) {
                      audioPlayerStore.seek(Duration(seconds: value.toInt()));
                    },
                    secondaryActiveColor: Colors.red,
                    thumbColor: AppColors.blueLighter,
                    activeColor: AppColors.purpleBrighterBackgroundColor,
                    inactiveColor: AppColors.purpleLighterBackgroundColor,
                  ),
                ),
              ),

              /// #end
              Text(
                  audioPlayerStore.duration?.inSeconds.toMinutes ?? 0.toMinutes,
                  style: textTheme.labelSmall),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
