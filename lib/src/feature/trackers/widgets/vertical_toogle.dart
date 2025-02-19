import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

enum UnitMeasures {
  weight,
  height,
}

class VericalToogleCustom extends StatelessWidget {
  final UnitMeasures measure;
  final Function(int index) onChange;
  final List<bool> isSelected;
  const VericalToogleCustom(
      {super.key,
      required this.measure,
      required this.onChange,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.purpleLighterBackgroundColor,
      ),
      child: ToggleButtons(
        constraints: const BoxConstraints(
          minHeight: 30, // минимальная высота
          minWidth: 60, // минимальная ширина
        ),
        direction: Axis.vertical,
        isSelected: isSelected,
        borderRadius: BorderRadius.circular(8),
        fillColor: AppColors.purpleLighterBackgroundColor,
        selectedColor: Colors.transparent,
        borderColor: AppColors.purpleLighterBackgroundColor,
        selectedBorderColor: AppColors.purpleLighterBackgroundColor,
        color: AppColors.purpleLighterBackgroundColor,
        splashColor: Colors.transparent,
        children: [
          Container(
            height: 30,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected[0] ? AppColors.whiteColor : Colors.transparent,
            ),
            child: Center(
              child: Text(
                measure == UnitMeasures.weight
                    ? t.trackers.g.title
                    : t.trackers.cm.title,
                style: TextStyle(
                  color: isSelected[0]
                      ? AppColors.primaryColor
                      : AppColors.greyBrighterColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            height: 30,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected[1] ? AppColors.whiteColor : Colors.transparent,
            ),
            child: Center(
              child: Text(
                measure == UnitMeasures.weight
                    ? t.trackers.kg.title
                    : t.trackers.m.title,
                style: TextStyle(
                  color: isSelected[1]
                      ? AppColors.primaryColor
                      : AppColors.greyBrighterColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
        onPressed: (int index) {
          onChange(index);
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
        },
      ),
    );
  }
}
