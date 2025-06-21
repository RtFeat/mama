import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class KnowledgeFilterWidget extends StatelessWidget {
  final KnowledgeFilter filter;
  const KnowledgeFilterWidget({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: RawChip(
        // defaultProperties: ChipThemeData(selectedColor: AppColors.primaryColor),
        onPressed: () {
          filter.onTap();
        },
        showCheckmark: false,
        // color: const WidgetStatePropertyAll(AppColors.lightBlue),
        selected: filter.isSelected,
        selectedColor: AppColors.primaryColor,
        labelStyle: textTheme.titleSmall?.copyWith(
          color: filter.isSelected ? AppColors.whiteColor : null,
        ),
        label: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          child: Text(
            filter.title,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}
