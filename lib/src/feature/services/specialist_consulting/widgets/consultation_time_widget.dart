import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ConsultationTimeWidget extends StatelessWidget {
  const ConsultationTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleViewStore store = context.watch();

    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Observer(builder: (context) {
      final Color iconColor =
          store.workTime < 45 ? AppColors.primaryColor : Colors.white;

      final Color textColor = store.workTime < 60 ? Colors.black : Colors.white;

      return RoundedSlider(
          min: 5,
          max: 120,
          height: 64,
          backgroundColor: AppColors.lightBlueBackgroundStatus,
          foregroundColor: AppColors.primaryColor,
          initialValue: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconWidget(
                  model: IconModel(
                iconPath: Assets.icons.icDoubleArrow,
                color: iconColor,
              )),
              Text(
                getTime(store.workTime),
                style: textTheme.titleSmall?.copyWith(color: textColor),
              ),
            ],
          ),
          onChanged: (value) => store.setWorkTime(value.toInt()));
    });
  }

  String getTime(int time) {
    if (time <= 60) {
      return '$time минут';
    } else {
      int hours = time ~/ 60;
      int minutes = time % 60;
      return '$hours час $minutes минут';
    }
  }
}

class RoundedSlider extends StatefulWidget {
  final double min;
  final double max;
  final double initialValue;
  final ValueChanged<double> onChanged;
  final double height;
  final double radius;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? child;

  const RoundedSlider({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.onChanged,
    required this.foregroundColor,
    this.child,
    this.radius = 32,
    required this.backgroundColor,
    this.height = 6.0, // Высота слайдера по умолчанию
  });

  @override
  State<RoundedSlider> createState() => _RoundedSliderState();
}

class _RoundedSliderState extends State<RoundedSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    // Общая ширина виджета
    final double sliderWidth = MediaQuery.of(context).size.width;
    // Вычисляем ширину активной части
    final double activeWidth = (_currentValue - widget.min) /
        (widget.max - widget.min) *
        (sliderWidth - widget.radius); // Учитываем радиус

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          double newValue = (_currentValue +
                  details.primaryDelta! /
                      (sliderWidth - widget.radius * 2) *
                      (widget.max - widget.min))
              .clamp(widget.min, widget.max);
          _currentValue = newValue;
        });
        widget.onChanged(_currentValue); // Передаем новое значение
      },
      child: SizedBox(
        height: widget.height + widget.radius, // Увеличиваем высоту под child
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Фон
            SizedBox(
                height: widget.height,
                width: sliderWidth,
                child: ClipRRect(
                  borderRadius: widget.radius.r,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                            height: widget.height,
                            width: activeWidth,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: widget.foregroundColor,
                              ),
                            )),
                      ],
                    ),
                  ),
                )),
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }
}
