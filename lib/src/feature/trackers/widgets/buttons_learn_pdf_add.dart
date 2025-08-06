import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ButtonsLearnPdfAdd extends StatelessWidget {
  final VoidCallback onTapLearnMore;
  final EdgeInsetsGeometry? padding;
  final VoidCallback onTapPDF;
  final VoidCallback onTapAdd;
  final String? titileAdd;
  final int? maxLinesAddButton;
  final IconData iconAddButton;
  final CustomButtonType? typeAddButton;

  final TextStyle? knowMoreTextStyle;
  final TextStyle? pdfTextStyle;
  final TextStyle? addButtonTextStyle;

  const ButtonsLearnPdfAdd({
    super.key,
    required this.onTapLearnMore,
    required this.onTapPDF,
    required this.onTapAdd,
    required this.iconAddButton,
    this.titileAdd,
    this.maxLinesAddButton,
    this.typeAddButton,
    this.padding,
    this.knowMoreTextStyle,
    this.pdfTextStyle,
    this.addButtonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;
    double buttonsHeight = 55;
    return ColoredBox(
      color: AppColors.whiteColor,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 16).copyWith(
              top: 8,
              bottom: phonePadding.bottom + 16,
            ),
        child: Row(
          children: [
            /// #find out more button
            Expanded(
              flex: 3,
              child: CustomButton(
                height: buttonsHeight,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                title: t.trackers.knowMoreText.title,
                onTap: () => onTapLearnMore(),
                icon: AppIcons.graduationcapFill,
                type: CustomButtonType.outline,
                iconSize: 28,
                textStyle: knowMoreTextStyle ??
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 10,
                        ),
              ),
            ),
            8.w,

            /// #pdf button
            Expanded(
              flex: 2,
              child: CustomButton(
                height: buttonsHeight,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                iconPadding: 0,
                title: t.trackers.pdf.title,
                maxLines: 1,
                onTap: () => onTapPDF(),
                icon: AppIcons.arrowDownToLineCompact,
                type: CustomButtonType.outline,
                iconSize: 28,
                textStyle: pdfTextStyle ??
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          letterSpacing: -.1,
                        ),
              ),
            ),
            8.w,

            /// #add new tracker button
            Expanded(
              flex: 5,
              child: CustomButton(
                height: buttonsHeight,
                type: typeAddButton ?? CustomButtonType.filled,
                maxLines: maxLinesAddButton ?? 1,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 24,
                ),
                title: titileAdd ?? t.trackers.add.title,
                onTap: () => onTapAdd(),
                icon: iconAddButton,
                iconSize: 28,
                textStyle: addButtonTextStyle ??
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 10,
                          letterSpacing: -.1,
                        ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
