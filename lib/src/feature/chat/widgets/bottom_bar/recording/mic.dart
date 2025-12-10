import 'dart:async';

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
    Timer? holdTimer;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          holdTimer = Timer(const Duration(milliseconds: 100), () {
            onStartRecording();
          });
        },
        onTapUp: (details) {
          holdTimer?.cancel();
          store.stopRecording(isCanSend: true);
          store.setIsRecording(false);
        },
        onPanUpdate: (d) {
          onDragUpdate(d);
        },
        onPanEnd: (_) {
          onStopRecording();
        },
        child: _Body(micAnimation: animation));
  }
}

class _Body extends StatefulWidget {
  final Animation<double> micAnimation;
  const _Body({
    required this.micAnimation,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final ChatBottomBarStore store = context.watch();

    return Observer(builder: (context) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Анимация масштаба для плавного перехода
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: store.isRecording
            ? _RecordingBody(micAnimation: widget.micAnimation)
            : const _Icon(),
      );
    });
  }
}

class _RecordingBody extends StatelessWidget {
  final Animation<double> micAnimation;

  const _RecordingBody({required this.micAnimation});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: micAnimation,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.primaryColor,
        child: const _Icon(),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    final ChatBottomBarStore store = context.watch();

    return Observer(builder: (_) {
      return SizedBox(
        height: 100,
        width: 50,
        // radius: 50,
        // backgroundColor: Colors.transparent,
        child: Icon(
          store.isRecording ? AppIcons.micFill : AppIcons.mic,
          size: 32,
          color: store.isRecording
              ? AppColors.whiteColor
              : AppColors.greyLighterColor,
        ),
      );
    });
  }
}
