import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final AudioPlayerStore audioPlayerStore = context.watch();

    return Observer(
      builder: (context) {
        final bool hasSource = audioPlayerStore.source != null;
        if (!hasSource) {
          return const SizedBox.shrink();
        }

        final double maxSeconds =
            audioPlayerStore.duration?.inSeconds.toDouble() ?? 0;
        final double sliderMax = maxSeconds > 0 ? maxSeconds : 1;

        final double currentSeconds = (_dragValue ??
                audioPlayerStore.position?.inSeconds.toDouble() ??
                0)
            .clamp(0, sliderMax);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// #start
            Text(
              currentSeconds.toInt().toMinutes,
              style: textTheme.labelSmall,
            ),

            /// #slider
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8,
                ),
                child: Slider(
                  value: currentSeconds,
                  max: sliderMax,
                  onChangeStart: (value) {
                    setState(() {
                      _dragValue = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _dragValue = value;
                    });
                  },
                  onChangeEnd: (value) {
                    audioPlayerStore.seek(
                      Duration(
                        seconds: value.round(),
                      ),
                    );
                    setState(() {
                      _dragValue = null;
                    });
                  },
                  thumbColor: AppColors.blueLighter,
                  activeColor: AppColors.purpleBrighterBackgroundColor,
                  inactiveColor: AppColors.purpleLighterBackgroundColor,
                ),
              ),
            ),

            /// #end
            Text(
              audioPlayerStore.duration?.inSeconds.toMinutes ?? 0.toMinutes,
              style: textTheme.labelSmall,
            ),
          ],
        );
      },
    );
  }
}
