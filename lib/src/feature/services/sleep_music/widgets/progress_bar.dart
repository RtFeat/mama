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
  bool _isDragging = false;

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

        final double currentSeconds = (_isDragging
                ? _dragValue
                : audioPlayerStore.position?.inSeconds.toDouble()) ??
            0;
        final double clampedValue = currentSeconds.clamp(0, sliderMax);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// #start
            Text(
              clampedValue.toInt().toMinutes,
              style: textTheme.labelSmall,
            ),

            /// #slider
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8,
                ),
                child: Slider(
                  value: clampedValue,
                  max: sliderMax,
                  onChangeStart: (value) {
                    setState(() {
                      _isDragging = true;
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
                    // Задержка перед сбросом, чтобы плеер успел обновить позицию
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted) {
                        setState(() {
                          _isDragging = false;
                          _dragValue = null;
                        });
                      }
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
