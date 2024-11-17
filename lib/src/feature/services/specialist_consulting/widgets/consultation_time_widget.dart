import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:mama/src/core/constant/constant.dart';

class ConsultationTimeWidget extends StatefulWidget {
  const ConsultationTimeWidget({super.key});

  @override
  State<ConsultationTimeWidget> createState() => _ConsultationTimeWidgetState();
}

class _ConsultationTimeWidgetState extends State<ConsultationTimeWidget> {
  int time = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      child: InteractiveSlider(
        unfocusedHeight: 64,
        focusedHeight: 64,
        backgroundColor: AppColors.lightBlueBackgroundStatus,
        foregroundColor: AppColors.primaryColor,
        centerIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.icDoubleArrow,
              colorFilter:
                  ColorFilter.mode(getArrowIconColor(time), BlendMode.srcIn),
            ),
            Text(
              getTime(time),
              style: textTheme.titleSmall?.copyWith(color: getTextColor(time)),
            ),
          ],
        ),
        min: 0,
        max: 120,
        onChanged: (value) {
          setState(() {
            time = value.toInt();
          });
        },
      ),
    );
  }

  Color getArrowIconColor(int time) {
    if (time < 45) {
      return AppColors.primaryColor;
    } else {
      return Colors.white;
    }
  }

  Color getTextColor(int time ){
    if(time < 60){
      return Colors.black;
    }else {
      return Colors.white;
    }
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
