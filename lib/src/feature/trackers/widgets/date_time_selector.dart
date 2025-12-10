// ignore_for_file: use_build_context_synchronously, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
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
    this.onChanged,
  });

  final String title1;
  final String title2;
  final String title3;
  final ValueChanged<DateTime?>? onChanged;

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
        final dt = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        widget.onChanged?.call(dt);
        // SnackBar аркылуу тандалган күн жана убакытты көрсөтүү
        if (!mounted) return;
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger?.showSnackBar(SnackBar(
          content: Text(
            "Выбранное время: ${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year} ${selectedTime!.format(context)}",
          ),
          duration: const Duration(seconds: 3),
        ));
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
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedTime = picked;
                        });
                        if (selectedDate != null) {
                          final dt = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, picked.hour, picked.minute);
                          widget.onChanged?.call(dt);
                        }
                      }
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
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : widget.title2,
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
                          selectedDate != null
                              ? DateFormat('d MMMM').format(selectedDate!)
                              : widget.title3,
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
          if (index == 0) {
            widget.onChanged?.call(DateTime.now());
          } else {
            if (selectedDate != null && selectedTime != null) {
              final dt = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute);
              widget.onChanged?.call(dt);
            }
          }
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
                        // Сначала показываем выбор даты
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: store.dateTime ?? DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );

                        if (pickedDate != null) {
                          // Затем показываем выбор времени
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: store.dateTime != null 
                                ? TimeOfDay.fromDateTime(store.dateTime!)
                                : TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            // Объединяем выбранную дату и время
                            final DateTime dateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute);
                            store.setDateTime(dateTime);
                            onChanged?.call(dateTime);
                          } else {
                            // Если время не выбрано, используем только дату с текущим временем
                            final DateTime dateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                DateTime.now().hour,
                                DateTime.now().minute);
                            store.setDateTime(dateTime);
                            onChanged?.call(dateTime);
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // Позволяем выбрать только время
                              final TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: store.dateTime != null 
                                    ? TimeOfDay.fromDateTime(store.dateTime!)
                                    : TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                // Используем текущую дату или уже выбранную дату
                                final currentDate = store.dateTime ?? DateTime.now();
                                final DateTime dateTime = DateTime(
                                    currentDate.year,
                                    currentDate.month,
                                    currentDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute);
                                store.setDateTime(dateTime);
                                onChanged?.call(dateTime);
                              }
                            },
                            child: _SelectorItemWidget(
                                title: store.time,
                                icon: AppIcons.clock,
                                isSelected: store.isSelectedOtherDateTime),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Позволяем выбрать только дату
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: store.dateTime ?? DateTime.now(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );

                              if (pickedDate != null) {
                                // Используем текущее время или уже выбранное время
                                final currentTime = store.dateTime ?? DateTime.now();
                                final DateTime dateTime = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    currentTime.hour,
                                    currentTime.minute);
                                store.setDateTime(dateTime);
                                onChanged?.call(dateTime);
                              }
                            },
                            child: _SelectorItemWidget(
                                title: store.date,
                                icon: AppIcons.calendar,
                                isSelected: store.isSelectedOtherDateTime),
                          ),
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
