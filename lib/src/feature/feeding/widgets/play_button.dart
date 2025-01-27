import 'package:flutter/material.dart';
import '../../../core/core.dart';

class PlayerButton extends StatefulWidget {
  final Function() onTap;
  final String side;
  final bool isStart;
  final bool needTimer;

  const PlayerButton({
    super.key,
    required this.side,
    required this.onTap,
    required this.isStart,
    this.needTimer = false,
  });

  @override
  State<PlayerButton> createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton>
    with TickerProviderStateMixin {
  late AnimationController _controllerColor;
  late AnimationController _controllerSize;
  late Animation<double> _animation;
  late Animation<double> _sizeAnim;
  late TweenSequence<Size> tweenSequence;
  late Animation<Size> animation;

  @override
  void initState() {
    super.initState();
    _controllerColor = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sizeAnim = Tween(begin: 0.0, end: 256.0).animate(_controllerColor);

    _controllerSize = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..reverse();

    _animation = CurvedAnimation(
      parent: _controllerColor,
      curve: Curves.easeInOut,
    );

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
    animation = _controllerSize.drive(tweenSequence);
  }

  @override
  void dispose() {
    _controllerColor.dispose();
    _controllerSize.dispose();
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
              animation: Listenable.merge([_animation, _sizeAnim, animation]),
              builder: (context, child) {
                widget.isStart
                    ? _controllerColor.forward()
                    : _controllerColor.reverse();
                widget.isStart
                    ? {_controllerSize.forward(), _controllerSize.repeat()}
                    : _controllerSize.reverse();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      height: 256,
                      width: 256,
                    ),
                    Container(
                      height: widget.isStart
                          ? animation.value.height
                          : _sizeAnim.value,
                      width: widget.isStart
                          ? animation.value.width
                          : _sizeAnim.value,
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
                    widget.isStart
                        ? const SizedBox()
                        : Positioned(
                            bottom: 40,
                            child: Text(
                              '00:00',
                              style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                    widget.isStart && widget.needTimer
                        ? Positioned(
                            bottom: 0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.purpleLighterBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '8м 46с',
                                      style: textTheme.labelLarge,
                                    ),
                                    10.h,
                                    Text('Изменить время',
                                        style: textTheme.labelSmall?.copyWith(
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                );
              }),
        ),
        20.h,
      ],
    );
  }
}
