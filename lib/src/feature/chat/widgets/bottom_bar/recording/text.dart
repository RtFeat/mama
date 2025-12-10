import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class RecordingText extends StatelessWidget {
  final Animation<double> animation;

  const RecordingText({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animation.value, 0),
          child: Row(
            children: [
              const Icon(
                AppIcons.chevronCompactLeft,
                color: AppColors.greyBrighterColor,
              ),
              Text(
                t.chat.cancelRecording,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
