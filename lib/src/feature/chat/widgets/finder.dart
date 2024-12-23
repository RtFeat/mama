import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Finder extends StatelessWidget {
  final String formControlName;
  final Function(String v) onChanged;
  final VoidCallback onPressedClear;
  final String hintText;
  const Finder({
    super.key,
    required this.onChanged,
    required this.onPressedClear,
    required this.formControlName,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    const InputBorder inputBorder = UnderlineInputBorder(
        borderSide: BorderSide(
      color: AppColors.greyBrighterColor,
    ));

    return ReactiveTextField(
      formControlName: formControlName,
      decoration: InputDecoration(
          border: inputBorder,
          focusedBorder: inputBorder,
          disabledBorder: inputBorder,
          enabledBorder: inputBorder,
          prefixIcon: const Icon(
            Icons.search,
            size: 24,
            color: AppColors.primaryColor,
          ),
          hintText: hintText,
          hintStyle: textTheme.titleSmall!.copyWith(
            color: AppColors.greyBrighterColor,
          )),
      onChanged: (v) {
        onChanged(v.value as String? ?? '');
      },
    );
  }
}
