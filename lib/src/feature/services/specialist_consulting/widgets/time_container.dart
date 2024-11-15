import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/core.dart';

class TimeContainer extends StatelessWidget {
  final String time;

  const TimeContainer({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.lightBlueBackgroundStatus,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 5,
              child: InkWell(
                onTap: (){
                  log("tap");
                },
                child: SvgPicture.asset(Assets.icons.icClose),
              ),
            ),
            Center(
              child: Text(
                time,
                style: textTheme.titleSmall?.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
