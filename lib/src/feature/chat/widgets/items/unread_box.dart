import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class UnreadBox extends StatelessWidget {
  final int? unread;
  const UnreadBox({super.key, required this.unread});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final bool isSmall = (unread ?? 0) < 10;

    return Row(
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: isSmall ? 24 : 29, // минимальная ширина
            minHeight: 24, // фиксированная высота
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(12), // одинаковые скругления для всех
            color: AppColors.primaryColor,
          ),
          alignment: Alignment.center, // выравнивание текста по центру
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 4), // горизонтальные отступы
            child: Text(
              '$unread',
              style:
                  textTheme.labelMedium!.copyWith(color: AppColors.whiteColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
