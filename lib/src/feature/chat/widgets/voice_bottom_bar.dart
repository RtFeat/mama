// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class RecordingMicWidget extends StatefulWidget {
  const RecordingMicWidget({
    super.key,
    required this.onHorizontalScrollComplete,
    required this.onLongPress,
    required this.onLongPressCancel,
    required this.onSend,
    required this.onTapCancel,
  });

  final VoidCallback onHorizontalScrollComplete;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressCancel;
  final VoidCallback onSend;
  final VoidCallback onTapCancel;

  @override
  State<RecordingMicWidget> createState() => _RecordingMicWidgetState();
}

class _RecordingMicWidgetState extends State<RecordingMicWidget>
    with TickerProviderStateMixin {
  double micDx = 4;
  double micDy = 38;

  double micWidth = 50;
  double micHeight = 50;

  bool isHorizontalActionComplete = false;
  bool isShowTime = false;
  bool showSwipeOptions = false;
  late AnimationController _animationController;
  late Animation<Color?> animationColor;
  late AnimationController controllerColor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    controllerColor = AnimationController(
        duration: const Duration(milliseconds: 90), vsync: this);
    AnimationController(
        duration: const Duration(milliseconds: 90), vsync: this);
    animationColor =
        ColorTween(begin: AppColors.primaryColor, end: AppColors.redColor)
            .animate(controllerColor)
          ..addListener(() {
            setState(() {});
          });
  }

  void animateColor() {
    controllerColor.forward();
  }

  void animateColorBack() {
    controllerColor.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: micDy,
          right: micDx,
          child: GestureDetector(
            onTap: () {
              widget.onLongPress();
              isHorizontalActionComplete = false;

              setState(() {
                micWidth = 100;
                micHeight = 100;
                micDy = -0;
                micDx = -25;
                showSwipeOptions = true;
                isShowTime = true;
              });
            },
            onLongPress: () {
              // widget.onLongPress();
              isHorizontalActionComplete = false;

              setState(() {
                micWidth = 100;
                micHeight = 100;
                micDy = -0;
                micDx = -25;
                showSwipeOptions = true;
                isShowTime = true;
              });
            },
            onLongPressEnd: (LongPressEndDetails lg) {
              animateColorBack();
              setState(() {
                micWidth = 50;
                micHeight = 50;
                micDy = 38;
                micDx = 4;
                showSwipeOptions = false;
              });
              if (!isHorizontalActionComplete) {
                widget.onLongPressCancel();
                setState(() {
                  isShowTime = false;
                });
              }
            },
            onLongPressMoveUpdate: (LongPressMoveUpdateDetails longPressData) {
              longPressUpdate(longPressData);
            },
            child: Row(
              children: [
                Visibility(
                  visible: showSwipeOptions,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new,
                      ),
                      Text(
                        'Влево – отмена',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(showSwipeOptions ? 30 : 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.00),
                    color: showSwipeOptions
                        ? animationColor.value
                        : AppColors.lightPirple,
                  ),
                  width: micWidth,
                  height: micHeight,
                  // child: Image.asset(
                  //   showSwipeOptions
                  //       ? Assets.icons.audioFilled.path
                  //       : Assets.icons.sound.path,
                  // ),

                  child: showSwipeOptions
                      ? const Icon(
                          AppIcons.mic,
                        )
                      : const Icon(
                          AppIcons.mic,
                          color: AppColors.greyLighterColor,
                        ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 35,
          left: 25,
          child: Visibility(
            visible: isShowTime,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 5,
                  backgroundColor: AppColors.redBright,
                ),
                5.w,
                const Text('Идет запись'),
                5.w,
                const TimerWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void longPressUpdate(LongPressMoveUpdateDetails longPressData) {
    if (longPressData.localPosition.dx < 0) {
      if (longPressData.localPosition.dx > -60) {
        setState(() {
          animateColor();
        });
      }
      if (longPressData.localPosition.dx > -150) {
        setState(() {
          micDx = -longPressData.localPosition.dx;
          animateColor();
        });
        if (longPressData.localPosition.dx > -60) {
          setState(() {
            animateColorBack();
          });
        }
      } else {
        if (showSwipeOptions) {
          isHorizontalActionComplete = true;
          isShowTime = false;
          _animationController.forward().then((_) {
            _animationController.reset();
          });
          widget.onHorizontalScrollComplete();
          showSwipeOptions = false;
          resetMicPosition();
        }
      }
    } else {
      resetMicPosition();
    }

    if (longPressData.localPosition.dy < -150 && micWidth != 50) {
      setState(() {
        micWidth = 50;
        micHeight = 50;
      });
    }
  }

  void resetMicPosition() {
    setState(() {
      micDx = 4;
      micDy = 0;
    });
    animateColorBack();
  }

  @override
  void dispose() {
    _animationController.dispose();
    controllerColor.dispose();
    super.dispose();
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTimer());
  }

  void addTimer() {
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: TextStyle(
        fontSize: 20,
        color: Colors.teal.shade700,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
