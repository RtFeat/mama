import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final String? title;
  final DateTime startDate;
  final DateTime? endDate;
  final String? subtitle;

  final Function()? onLeftTap;
  final Function()? onRightTap;

  const DateRangeSelectorWidget(
      {super.key,
      this.title,
      required this.startDate,
      this.endDate,
      this.subtitle,
      this.onLeftTap,
      this.onRightTap});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat(
        'dd MMMM', LocaleSettings.currentLocale.flutterLocale.toLanguageTag());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onLeftTap,
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryColor,
          ),
        ),
        Column(
          children: [
            Text(
              '${format.format(startDate)} - ${format.format(
                endDate ??
                    startDate.add(
                      const Duration(days: 6),
                    ),
              )}',
              style: AppTextStyles.f14w400,
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppTextStyles.f10w400,
              ),
          ],
        ),
        GestureDetector(
          onTap: onRightTap,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
