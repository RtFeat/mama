import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../data.dart';

class DetailContainer extends StatelessWidget {
  final String title;
  final String? formControlName;
  final String text;
  final String detail;
  final bool filled;
  final bool isEdited;
  final VoidCallback? onChanged;

  const DetailContainer(
      {super.key,
      required this.title,
      required this.text,
      required this.detail,
      required this.filled,
      required this.isEdited,
      this.formControlName,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(
              color: filled
                  ? Colors.transparent
                  : AppColors.purpleLighterBackgroundColor),
          color: filled ? AppColors.purpleLighterBackgroundColor : null,
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.labelLarge
                  ?.copyWith(color: AppColors.greyBrighterColor),
            ),
            isEdited
                ? ReactiveTextField(
                    scrollPadding: EdgeInsets.zero,
                    formControlName: formControlName,
                    inputFormatters: <TextInputFormatter>[
                      HourMinsFormatter(),
                      LengthLimitingTextInputFormatter(5),
                    ],
                    showErrors: (control) => false,
                    keyboardType: TextInputType.text,
                    style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.black),
                    onTapOutside: (event) {},
                    onChanged: (value) {
                      onChanged!();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      hintStyle: textTheme.headlineSmall
                          ?.copyWith(color: AppColors.greyBrighterColor),
                    ),
                  )
                : Text(
                    text,
                    style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
            Text(
              detail,
              style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyBrighterColor),
            ),
          ],
        ),
      ),
    );
  }
}

class HourMinsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text.contains(':') &&
        !newValue.text.contains(':') &&
        newValue.text.length == 2) {
      return newValue;
    }
    String value = newValue.text;
    if (newValue.text.length == 1) {
      value = int.parse(newValue.text).clamp(0, 2).toString();
    } else if (newValue.text.length == 2) {
      value =
          '${int.parse(newValue.text).clamp(0, 23).toString().padLeft(2, '0')}:';
    } else if (newValue.text.length == 4) {
      value =
          '${int.parse(newValue.text.substring(0, 2)).clamp(0, 23).toString().padLeft(2, '0')}:${int.parse(newValue.text.substring(3)).clamp(0, 5).toString()}';
    } else if (newValue.text.length == 5) {
      value =
          '${newValue.text.substring(0, 2).toString().padLeft(2, '0')}:${int.parse(newValue.text.substring(3)).clamp(0, 59).toString().padLeft(2, '0')}';
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}
