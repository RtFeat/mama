import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class MicButton extends StatelessWidget {
  final Animation<double> animation;

  const MicButton({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final ChatBottomBarStore store = context.watch();

    return Observer(builder: (context) {
      if (store.isRecording) {
        return ScaleTransition(
            scale: animation,
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                AppIcons.micFill,
                color: AppColors.whiteColor,
              ),
            ));
      }
      return const Icon(
        AppIcons.mic,
        color: AppColors.greyLighterColor,
      );
    });
  }
}
