import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/state/add_manually.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

class ManuallyInputContainer extends StatelessWidget {
  const ManuallyInputContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AddManually(),
      dispose: (context, value) => value.dispose(),
      builder: (context, child) {
        final model = context.watch<AddManually>();
        return DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.greyColor, width: 1)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ReactiveForm(
                  formGroup: model.formGroup,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InputContainer(
                        title: t.feeding.left,
                        controlName: 'left',
                        inputHint: '0м 0с',
                      ),
                      InputContainer(
                        title: t.feeding.right,
                        controlName: 'right',
                        inputHint: '0м 0с',
                      )
                    ],
                  ),
                ),
                15.h,
                _TextWidget(text: t.feeding.manualyInputComment.title),
                8.h,
                _TextWidget(text: t.feeding.manualyInputComment.subtitle)
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TextWidget extends StatelessWidget {
  final String text;

  const _TextWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Text(
      textAlign: TextAlign.center,
      text,
      style: textTheme.labelMedium
          ?.copyWith(fontSize: 14, color: AppColors.greyBrighterColor),
    );
  }
}
