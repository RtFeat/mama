// ignore_for_file: use_build_context_synchronously, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:mama/src/core/constant/constant.dart';
import 'package:mama/src/feature/trackers/trackers.dart';

class DateSwitchContainer extends StatefulWidget {
  const DateSwitchContainer({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
  });

  final String title1;
  final String title2;
  final String title3;

  @override
  State<DateSwitchContainer> createState() => _DateSwitchContainerState();
}

class _DateSwitchContainerState extends State<DateSwitchContainer> {
  List<bool> isSelected = [true, false];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Күн жана убакытты тандаган функция
  Future<void> selectDateTime(BuildContext context) async {
    // Алгач күндү тандайбыз
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Андан соң убакытты тандайбыз
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
        });
        // SnackBar аркылуу тандалган күн жана убакытты көрсөтүү
        final snackBar = SnackBar(
          content: Text(
            "Выбранное время: ${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year} ${selectedTime!.format(context)}",
          ),
          duration: const Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      height: 35,
      decoration: BoxDecoration(
        color: AppColors.purpleLighterBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ToggleButtons(
        fillColor: AppColors.purpleLighterBackgroundColor,
        selectedColor: Colors.transparent,
        borderColor: AppColors.purpleLighterBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        isSelected: isSelected,
        renderBorder: false,
        splashColor: Colors.transparent,
        children: [
          Container(
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected[0] ? AppColors.whiteColor : Colors.transparent,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.title1,
                  style: AppTextStyles.f14w700.copyWith(
                    color: isSelected[0]
                        ? AppColors.primaryColor
                        : AppColors.greyBrighterColor,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 35,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.66,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected[1] ? AppColors.whiteColor : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await DateTimeService.selectedTime(context, (value) {
                        // dateTime.text = DateFormat("d MMM, y").format(value);
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          AppIcons.clock,
                          size: 28,
                          color: isSelected[1]
                              ? AppColors.blueLighter
                              : AppColors.greyBrighterColor,
                        ),
                        Text(
                          widget.title2,
                          style: AppTextStyles.f14w700.copyWith(
                            color: isSelected[1]
                                ? AppColors.blueLighter
                                : AppColors.greyBrighterColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // await DateTimeService.selectedTime(context, (value) {
                      //   // dateTime.text = DateFormat("d MMM, y").format(value);
                      // });

                      return selectDateTime(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          AppIcons.calendar,
                          size: 28,
                          color: isSelected[1]
                              ? AppColors.blueLighter
                              : AppColors.greyBrighterColor,
                        ),
                        Text(
                          widget.title3,
                          style: AppTextStyles.f14w700.copyWith(
                            color: isSelected[1]
                                ? AppColors.blueLighter
                                : AppColors.greyBrighterColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index; // Тандалган элементти өзгөртүү
            }
          });
        },
      ),
    );
  }
}
