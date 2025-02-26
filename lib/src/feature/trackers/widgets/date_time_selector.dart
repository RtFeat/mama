// ignore_for_file: use_build_context_synchronously, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/core/constant/constant.dart';
import 'package:mama/src/feature/trackers/trackers.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

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
      width: MediaQuery.of(context).size.width,
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

class DateTimeSelectorWidget extends StatelessWidget {
  final Function(DateTime? value)? onChanged;
  const DateTimeSelectorWidget({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DateTimeSelectorStore(),
      builder: (context, child) {
        final DateTimeSelectorStore store = context.watch();

        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.purpleLighterBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Observer(builder: (context) {
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _SelectorWidget(
                        isSelected: !store.isSelectedOtherDateTime,
                        onTap: () {
                          store.setDateTime(null);
                          onChanged?.call(DateTime.now());
                        },
                        child: Center(
                            child: _SelectorItemWidget(
                                title: t.home.today,
                                isSelected: !store.isSelectedOtherDateTime))),
                  ),
                  Expanded(
                    flex: 3,
                    child: _SelectorWidget(
                      isSelected: store.isSelectedOtherDateTime,
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );

                        if (pickedDate != null) {
                          store.setDateTime(pickedDate);
                          onChanged?.call(pickedDate);

                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            final DateTime dateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute);
                            store.setDateTime(dateTime);
                            onChanged?.call(dateTime);
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _SelectorItemWidget(
                              title: store.time,
                              icon: AppIcons.clock,
                              isSelected: store.isSelectedOtherDateTime),
                          _SelectorItemWidget(
                              title: store.date,
                              icon: AppIcons.calendar,
                              isSelected: store.isSelectedOtherDateTime),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

class _SelectorWidget extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final bool isSelected;
  const _SelectorWidget({
    required this.child,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? AppColors.whiteColor : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SelectorItemWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final IconData? icon;
  const _SelectorItemWidget({
    this.icon,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyBrighterColor,
          ),
          4.w,
        ],
        Text(
          title,
          style: AppTextStyles.f14w700.copyWith(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyBrighterColor,
          ),
        ),
      ],
    );
  }
}
