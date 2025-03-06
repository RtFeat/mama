import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class MicButton extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onStartRecording;
  final ValueChanged<DragUpdateDetails> onDragUpdate;
  final VoidCallback onStopRecording;

  const MicButton({
    super.key,
    required this.animation,
    required this.onStartRecording,
    required this.onDragUpdate,
    required this.onStopRecording,
  });

  @override
  Widget build(BuildContext context) {
    final ChatBottomBarStore store = context.watch();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (_) {
        onStartRecording();
      },
      onPanUpdate: onDragUpdate,
      onPanEnd: (_) {
        onStopRecording();
      },
      child: Observer(builder: (context) {
        if (!store.isRecording) {
          return Icon(
            store.isRecording ? AppIcons.micFill : AppIcons.mic,
            color: store.isRecording
                ? AppColors.whiteColor
                : AppColors.greyLighterColor,
          );
        }
        return ScaleTransition(
          scale: animation,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryColor,
            child: Icon(
              store.isRecording ? AppIcons.micFill : AppIcons.mic,
              color: store.isRecording
                  ? AppColors.whiteColor
                  : AppColors.greyLighterColor,
            ),
          ),
        );
      }),
    );
  }
}
