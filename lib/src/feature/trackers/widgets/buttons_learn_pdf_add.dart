import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class ButtonsLearnPdfAdd extends StatelessWidget {
  final VoidCallback onTapLearnMore;
  final VoidCallback onTapPDF;
  final VoidCallback onTapAdd;
  final IconData iconAddButton;
  const ButtonsLearnPdfAdd(
      {super.key,
      required this.onTapLearnMore,
      required this.onTapPDF,
      required this.onTapAdd,
      required this.iconAddButton});

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;
    double buttonsHeight = 55;
    return ColoredBox(
      color: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
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
                  horizontal: 8,
                ),
                title: t.trackers.knowMoreText.title,
                onTap: () => onTapLearnMore(),
                icon: AppIcons.graduationcapFill,
                type: CustomButtonType.outline,
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 12,
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
                title: t.trackers.pdf.title,
                maxLines: 1,
                onTap: () => onTapPDF(),
                icon: AppIcons.arrowDownToLineCompact,
                type: CustomButtonType.outline,
              ),
            ),
            8.w,

            /// #add new tracker button
            Expanded(
              flex: 3,
              child: CustomButton(
                height: buttonsHeight,
                maxLines: 1,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                title: t.trackers.add.title,
                onTap: () => onTapAdd(),
                icon: iconAddButton,
                iconSize: 28,
              ),
            )
          ],
        ),
      ),
    );
  }
}
