import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class PlayButton extends StatelessWidget {
  final bool isPlaying;
  const PlayButton({super.key, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPlaying ? AppColors.blueLighter : AppColors.primaryColor,
      ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              key: ValueKey<bool>(isPlaying),
            ),
          ),
        ),
      ),
    );
  }
}
