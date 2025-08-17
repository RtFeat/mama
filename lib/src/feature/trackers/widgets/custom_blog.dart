// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class CustomBlog extends StatefulWidget {
  const CustomBlog({
    super.key,
    this.onPressedElevated,
    this.controller,
    this.verticalSwitch,
    this.measure,
    this.onChangedTime,
    required this.onChangedValue,
    required this.value,
  });

  final String value;
  final Function(String) onChangedValue;
  final Function(DateTime?)? onChangedTime;
  final UnitMeasures? measure;
  final void Function()? onPressedElevated;
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

    final isTemperature = widget.measure == null;

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
                  // NumberField(
                  //   value: widget.value,
                  //   onChanged: widget.onChangedValue,
                  //   decimals: 1,
                  //   unit: '°С',
                  // ),
                  isTemperature
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
                    child: NumberField(
                      value: widget.value,
                      onChanged: widget.onChangedValue,
                      decimals: 1,
                      inputFormatters: [
                        TemperatureInputFormatter(),
                      ],
                    ),
                    // isTemperature
                    //     ? TemperatureField(
                    //         value: widget.value,
                    //         onChanged: widget.onChangedValue,
                    //       )
                    //     : TextFormField(
                    //         controller: widget.controller,
                    //         keyboardType: TextInputType.number,
                    //         textAlign: TextAlign.center,
                    //         decoration: const InputDecoration(),
                    //         style: AppTextStyles.f44w400.copyWith(
                    //           color: AppColors.primaryColor,
                    //         ),
                    //         onChanged: widget.onChangedValue,
                    //       ),
                  ),
                  16.w,
                ],
              ),

              18.h,

              DateTimeSelectorWidget(onChanged: widget.onChangedTime),
              18.h,

              // кнопки "Заметка" и "Добавить"
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      type: CustomButtonType.outline,
                      onTap: () {
                        context.pushNamed(
                          AppViews.addNote,
                        );
                      },
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
