import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Finder extends StatelessWidget {
  final String? value;
  final String formControlName;
  final Function(String v)? onTap;
  final Function(String v) onChanged;
  final VoidCallback onPressedClear;
  final String hintText;
  final InputBorder? inputBorder;
  final Function()? onSearchIconPressed;
  final Widget Function()? suffixIcon;
  const Finder({
    super.key,
    this.onTap,
    this.value,
    this.inputBorder,
    this.onSearchIconPressed,
    required this.onChanged,
    required this.onPressedClear,
    required this.formControlName,
    required this.hintText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final InputBorder inputBorder = this.inputBorder ??
        const UnderlineInputBorder(
            borderSide: BorderSide(
          color: AppColors.greyBrighterColor,
        ));

    return ReactiveTextField(
      formControlName: formControlName,
      // onTapOutside: (event) {
      //   onSearchIconPressed?.call();
      // },
      decoration: InputDecoration(
          border: inputBorder,
          focusedBorder: inputBorder,
          disabledBorder: inputBorder,
          enabledBorder: inputBorder,
          prefixIcon: GestureDetector(
            onTap: onSearchIconPressed,
            child: const Icon(
              Icons.search,
              size: 24,
              color: AppColors.primaryColor,
            ),
          ),
          suffixIcon: suffixIcon?.call() ??
              ValueListenableBuilder(
                  valueListenable: ValueNotifier(value),
                  builder: (_, v, __) {
                    if (v == null || v.isEmpty) return const SizedBox.shrink();
                    return GestureDetector(
                      onTap: onPressedClear,
                      child: const Icon(
                        Icons.clear,
                        size: 24,
                        color: AppColors.greyBrighterColor,
                      ),
                    );
                  }),
          hintText: hintText,
          hintStyle: textTheme.titleSmall!.copyWith(
            color: AppColors.greyBrighterColor,
          )),
      onTap: (v) {
        if (onTap != null) onTap!(v.value as String? ?? '');
      },
      onChanged: (v) {
        onChanged(v.value as String? ?? '');
      },
    );
  }
}
