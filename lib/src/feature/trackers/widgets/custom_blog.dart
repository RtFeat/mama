// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class CustomBlog extends StatefulWidget {
  const CustomBlog({
    super.key,
    this.onPressedElevated,
    this.onPressedOutlined,
    this.controller,
    this.verticalSwitch,
    this.measure,
  });

  final UnitMeasures? measure;
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
              color: Colors.grey.withValues(alpha: 0.2),
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
                  widget.measure == null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '°С',
                            style: AppTextStyles.f14w700.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                      : VericalToogleCustom(
                          measure: widget.measure!,
                          onChange: (int index) {
                            setState(() {
                              for (int i = 0; i < isSelected.length; i++) {
                                isSelected[i] = i == index;
                              }
                            });
                          },
                          isSelected: isSelected,
                        ),
                  8.w,
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
                  16.w,
                ],
              ),

              10.h,

              DateSwitchContainer(
                title1: t.trackers.now.title,
                title2: t.trackers.sixTeenThirtyTwo.title,
                title3: t.trackers.fourteensOfSeptember.title,
              ),
              10.h,

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
