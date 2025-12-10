import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class RecordingIndicator extends StatelessWidget {
  final Animation<double> animation;

  const RecordingIndicator({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final ChatBottomBarStore store = context.watch();
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            10.w,
            ScaleTransition(
                scale: animation,
                child: const SizedBox(
                  height: 10,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.redBright,
                      shape: BoxShape.circle,
                    ),
                  ),
                )),
            10.w,
            Observer(
              builder: (_) {
                return Text.rich(
                  t.chat.recording(
                    duration: (p0) => TextSpan(
                      text: store.formattedDuration,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  style: textTheme.titleSmall,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
