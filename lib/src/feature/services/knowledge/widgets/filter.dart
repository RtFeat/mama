import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
      child: Observer(builder: (_) {
        return RawChip(
          onPressed: () {
            filter.setSelected(!filter.isSelected);
            filter.onTap();
          },
          showCheckmark: false,
          selected: filter.isSelected,
          selectedColor: AppColors.primaryColor,
          labelStyle: textTheme.titleSmall?.copyWith(
            color: filter.isSelected ? AppColors.whiteColor : null,
          ),
          label: Text(
            filter.title,
            // style: textTheme.titleSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        );
      }),
    );
  }
}
