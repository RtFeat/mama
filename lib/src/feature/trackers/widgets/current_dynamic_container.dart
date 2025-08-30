import 'package:flutter/material.dart';
import 'package:mama/src/core/constant/constant.dart';
import 'package:mama/src/feature/trackers/widgets/evolution_category.dart';
import 'package:skit/skit.dart';

class Current {
  final double value;
  final String label;
  final String isNormal;
  final String days;

  Current({
    required this.value,
    required this.label,
    required this.isNormal,
    required this.days,
  });
}

class Dynamic {
  final double value;
  final String label;
  final String days;
  final String duration;

  Dynamic({
    required this.value,
    required this.label,
    required this.days,
    required this.duration,
  });
}

class CurrentAndDymanicContainer extends StatelessWidget {
  const CurrentAndDymanicContainer({
    super.key,
    required this.trackerType,
    required this.current,
    required this.dynamic,
  });
  final Current current;
  final Dynamic dynamic;
  final EvolutionCategory trackerType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Current Container
        Expanded(
          child: Container(
            height: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: AppColors.purpleLighterBackgroundColor,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.trackers.current.title,
                  style: AppTextStyles.f14w700.copyWith(
                    color: AppColors.greyBrighterColor,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      switch (trackerType) {
                        EvolutionCategory.weight =>
                          '${current.value ~/ 1} ${t.trackers.kg.title.toLowerCase()} ${current.value % 1 != 0 ? '${((current.value % 1) * 1000).toInt()} ${t.trackers.g.title.toLowerCase()}' : ''}',
                        EvolutionCategory.growth =>
                          '${current.value ~/ 1} ${t.trackers.cm.title.toLowerCase()} ${current.value % 1 != 0 ? '${((current.value % 1) * 1000).toInt()} ${t.trackers.g.title.toLowerCase()}' : ''}',
                        _ => ''
                      },
                      // trackerType.currentLabel,
                      style: AppTextStyles.f17w400.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    5.w,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        current.isNormal,
                        style: AppTextStyles.f10w700.copyWith(
                          color: AppColors.greenTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      current.label,
                      style: AppTextStyles.f10w700.copyWith(
                        color: AppColors.greyBrighterColor,
                      ),
                    ),
                    5.w,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        t.trackers.daysAgo(n: int.tryParse(current.days) ?? 0),
                        style: AppTextStyles.f10w700.copyWith(
                          color: AppColors.orangeTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        5.w,

        /// Dynamic Container
        Expanded(
          child: Container(
            height: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: AppColors.purpleLighterBackgroundColor,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.trackers.dynamics.title,
                  style: AppTextStyles.f14w700.copyWith(
                    color: AppColors.greyBrighterColor,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      switch (trackerType) {
                        EvolutionCategory.weight => '${dynamic.label} г',
                        EvolutionCategory.growth => '${dynamic.label} см',
                        _ => ''
                      },
                      // trackerType.dynamicLabel,
                      style: AppTextStyles.f17w400.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    5.w,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Text(
                        dynamic.days,
                        style: AppTextStyles.f14w400.copyWith(
                          color: AppColors.greyBrighterColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      switch (trackerType) {
                        EvolutionCategory.weight =>
                          '${(dynamic.value * 100).toInt()} г в сутки',
                        EvolutionCategory.growth =>
                          '${(dynamic.value).toInt()} см в сутки',
                        _ => ''
                      },
                      style: AppTextStyles.f10w700.copyWith(
                        color: AppColors.greenTextColor,
                      ),
                    ),
                    Text(
                      dynamic.duration,
                      // '23 августа-31 августа',
                      style: AppTextStyles.f10w700.copyWith(
                        color: AppColors.greyBrighterColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
