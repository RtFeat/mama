import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class RemindItem extends StatelessWidget {
  final String time;
  final VoidCallback onRemove;
  const RemindItem({super.key, required this.time, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return
        // TODO добавить напоминание по времени
        Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primaryColorBrighter,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Icon(
            AppIcons.alarmFill,
            color: AppColors.primaryColor,
            size: 28,
          ),
          5.w,
          Text(
            time,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: AppColors.blackColor),
          ),
          5.w,
          InkWell(
            onTap: () {
              onRemove();
            },
            child: const Icon(
              Icons.close,
              size: 28,
              color: AppColors.redColor,
            ),
          ),
        ],
      ),
    );
  }
}
