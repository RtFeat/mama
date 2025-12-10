import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

class ItemsNeedToFill extends StatelessWidget {
  final FormGroup formGroup;
  const ItemsNeedToFill({
    super.key,
    required this.formGroup,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle titlesStyle =
        textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400);

    return ReactiveFormConsumer(
      builder: (context, formGroup, child) {
// Отображаемые названия полей
        final Map<String, String> data = {
          'name': t.profile.name,
          'dateBirth': t.profile.dateBirth,
          'weight': t.profile.weight,
          'height': t.profile.height,
          'headCircumference': t.profile.headCirc,
          // 'about': t.profile.aboutMe,
        };

        // Получаем список незаполненных полей по ключам
        final List<String> missingFields = data.entries
            .where((entry) {
              final control = formGroup.control(entry.key);
              final value = control.value;

              if (value == null || (value is String && value.isEmpty)) {
                return true;
              }

              logger.info(value);
              if (['weight', 'height', 'headCircumference']
                      .contains(entry.key) &&
                  (value as String).contains('0.0')) {
                return true;
              }
              return false;
            })
            .map((entry) => entry.value)
            .toList();

        // Создаем TextSpan для незаполненных полей
        List<TextSpan> missingFieldsTextSpans = [];
        for (int i = 0; i < missingFields.length; i++) {
          final String fieldName = missingFields[i];
          final bool isLast = i == missingFields.length - 1;
          final bool isPenultimate = i == missingFields.length - 2;

          missingFieldsTextSpans.add(TextSpan(
            text: fieldName,
            style: titlesStyle.copyWith(
              color: AppColors.primaryColor,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryColor,
            ),
          ));

          if (isPenultimate) {
            missingFieldsTextSpans.add(TextSpan(
              text: ' ${t.profile.and} ',
              style: titlesStyle.copyWith(
                color: AppColors.greyBrighterColor,
              ),
            ));
          } else if (!isLast) {
            missingFieldsTextSpans.add(TextSpan(
              text: ', ',
              style: titlesStyle.copyWith(
                color: AppColors.greyBrighterColor,
              ),
            ));
          }
        }

        return missingFieldsTextSpans.isNotEmpty
            ? Text.rich(
                TextSpan(
                  text: '${t.profile.needToFill} ',
                  style: titlesStyle.copyWith(
                    color: AppColors.greyBrighterColor,
                  ),
                  children: missingFieldsTextSpans,
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
