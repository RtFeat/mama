import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/core.dart';
import 'package:skit/skit.dart';

class PlayerButton extends StatefulWidget {
  final Function() onTap;
  final String side;
  final bool isStart;
  final String? timer;
  final bool needTimer;
  final bool showTimerBadge;

  const PlayerButton({
    super.key,
    required this.side,
    required this.onTap,
    required this.isStart,
    this.needTimer = false,
    this.timer,
    this.showTimerBadge = true,
  });

  @override
  State<PlayerButton> createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton>
    with TickerProviderStateMixin {
  late AnimationController _controllerColor; // color/inner circle
  late AnimationController _controllerPulse; // pulsation 240<->256
  late AnimationController _controllerAppear; // 0 -> 1 blending
  late Animation<double> _animation; // color curve
  late Animation<double> _appear; // 0..1
  late TweenSequence<Size> tweenSequence;
  late Animation<Size> animation; // pulse size

  @override
  void initState() {
    super.initState();
    _controllerColor = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controllerPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controllerAppear = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _controllerColor,
      curve: Curves.easeInOut,
    );
    _appear = CurvedAnimation(parent: _controllerAppear, curve: Curves.easeOutCubic);

    tweenSequence = TweenSequence<Size>([
      TweenSequenceItem(
        tween: Tween(
          begin: const Size(240, 240),
          end: const Size(256, 256),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Size(256, 256),
          end: const Size(240, 240),
        ),
        weight: 1,
      ),
    ]);
    animation = _controllerPulse.drive(tweenSequence);
  }

  @override
  void dispose() {
    _controllerColor.dispose();
    _controllerPulse.dispose();
    _controllerAppear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
              animation: Listenable.merge([_animation, _appear, animation]),
              builder: (context, child) {
                if (widget.isStart) {
                  _controllerColor.forward();
                  if (!_controllerPulse.isAnimating) {
                    _controllerPulse.repeat(reverse: true);
                  }
                  _controllerAppear.forward();
                } else {
                  _controllerColor.reverse();
                  _controllerPulse.stop();
                  _controllerPulse.reset();
                  _controllerAppear.reverse();
                }
                 return Stack(
                   alignment: Alignment.center,
                   clipBehavior: Clip.none, // Позволяет элементам выходить за границы Stack
                   children: [
                    const SizedBox(
                      height: 256,
                      width: 256,
                    ),
                    Container(
                      height: Size.lerp(const Size(0, 0), animation.value, _appear.value)!.height,
                      width: Size.lerp(const Size(0, 0), animation.value, _appear.value)!.width,
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(radius: 0.5, colors: [
                          AppColors.whiteColor,
                          AppColors.blueGradient
                        ]),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(''),
                    ),
                    Positioned(
                      top: 80,
                      child: Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          color: ColorTween(
                            begin: AppColors.purpleLighterBackgroundColor,
                            end: Colors.white,
                          ).animate(_animation).value,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            widget.isStart
                                ? AppIcons.pauseFill
                                : AppIcons.playFill,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      child: Text(
                        widget.side,
                        style: textTheme.headlineSmall?.copyWith(
                            fontSize: 20,
                            color: widget.isStart
                                ? AppColors.whiteColor
                                : AppColors.blackColor),
                      ),
                    ),
                    if (widget.showTimerBadge)
                      Positioned(
                        bottom: widget.isStart ? -28 : 4, // При запуске еще ниже (-28), при остановке чуть выше (4)
                        child: IgnorePointer(
                          ignoring: false,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xD9F8FAFF), // #F8FAFF с 85% opacity
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.timer ?? '00:00',
                                      style: textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Change time',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox()
                  ],
                );
              }),
        ),
        20.h,
      ],
    );
  }
}
