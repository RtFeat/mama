// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mama/src/core/constant/constant.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/widgets.dart';

class CustomBlog extends StatefulWidget {
  const CustomBlog({
    super.key,
    this.kgOrCm,
    this.gOrM,
    this.onPressedElevated,
    this.onPressedOutlined,
    this.controller,
    this.verticalSwitch,
  });

  final String? kgOrCm;
  final String? gOrM;
  final void Function()? onPressedElevated;
  final void Function()? onPressedOutlined;
  final TextEditingController? controller;
  final Widget? verticalSwitch;

  @override
  _CustomBlogState createState() => _CustomBlogState();
}

class _CustomBlogState extends State<CustomBlog> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // КГ / Г кнопки (вертикально)
              Row(
                children: [
                  widget.kgOrCm == null && widget.gOrM == null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '°С',
                            style: AppTextStyles.f14w700.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                      : Container(
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
                            selectedBorderColor:
                                AppColors.purpleLighterBackgroundColor,
                            color: AppColors.purpleLighterBackgroundColor,
                            splashColor: Colors.transparent,
                            children: [
                              Container(
                                height: 30,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: isSelected[0]
                                      ? AppColors.whiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.kgOrCm ?? '',
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
                                  color: isSelected[1]
                                      ? AppColors.whiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.gOrM ?? '',
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
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                              });
                            },
                          ),
                        ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(),
                      style: AppTextStyles.f44w400.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              const SizedBox(height: 10),

              DateSwitchContainer(
                title1: t.trackers.now.title,
                title2: t.trackers.sixTeenThirtyTwo.title,
                title3: t.trackers.fourteensOfSeptember.title,
              ),
              const SizedBox(height: 10),

              // кнопки "Заметка" и "Добавить"
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      type: CustomButtonType.outline,
                      onTap: widget.onPressedOutlined,
                      maxLines: 1,
                      title: t.trackers.note.title,
                      icon: AppIcons.pencil,
                      iconColor: AppColors.primaryColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 12),
                      textStyle: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  10.w,
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      backgroundColor: AppColors.purpleLighterBackgroundColor,
                      onTap: widget.onPressedElevated,
                      title: t.trackers.add.title,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 12),
                      textStyle: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
