import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';

class TimeChip extends StatelessWidget {
  final WorkSlot slot;
  final Function(bool v) onSelect;
  const TimeChip({
    super.key,
    required this.slot,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Observer(builder: (_) {
      return RawChip(
        onPressed: () {
          onSelect(!slot.isSelected);
        },
        side: const BorderSide(
          color: AppColors.primaryColor,
        ),
        color: slot.isSelected
            ? const WidgetStatePropertyAll(
                AppColors.primaryColor,
              )
            : null,
        label: Text(
          slot.workSlot,
          style: textTheme.titleMedium!.copyWith(
            color: slot.isSelected ? themeData.colorScheme.onPrimary : null,
          ),
        ),
      );
    });
  }
}
