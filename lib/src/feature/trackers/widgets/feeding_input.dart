import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:skit/skit.dart';

class InputContainer extends StatelessWidget {
  final String controlName;
  final String title;
  final MaskTextInputFormatter? formatter;
  final String inputHint;
  final bool? readOnly;
  final Function(String? value)? onTap;
  final String? subtitle;

  const InputContainer(
      {super.key,
      required this.controlName,
      required this.title,
      this.formatter,
      required this.inputHint,
      this.readOnly,
      this.onTap,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final InputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(6),
    );
    const EdgeInsets inputPadding = EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 0);

    final MaskTextInputFormatter mlFormatter = MaskTextInputFormatter(
        mask: '##м ##с',
        filter: {'#': RegExp('[0-9]')},
        type: MaskAutoCompletionType.eager);

    const TextAlign inputTextAlign = TextAlign.center;

    final inputHintStyle = textTheme.labelLarge
        ?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
              color: AppColors.greyBrighterColor,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        10.h,
        Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (onTap != null) onTap!(null);
              },
              child: SizedBox(
                width: 100,
                child: IgnorePointer(
                  ignoring: readOnly ?? false,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xD9F8FAFF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InputItemWidget(
                          item: InputItem(
                            inputHint: inputHint,
                            keyboardType: TextInputType.number,
                            inputHintStyle: inputHintStyle,
                            controlName: controlName,
                            isCollapsed: true,
                            needBackgroundOnFocus: false,
                            textAlign: inputTextAlign,
                            textInputAction: TextInputAction.next,
                            maskFormatter: formatter ?? mlFormatter,
                            border: inputBorder,
                            contentPadding: inputPadding,
                            backgroundColor: Colors.transparent,
                            readOnly: readOnly,
                            onTap: onTap,
                          ),
                        ),
                        if (subtitle != null) ...[
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.greyBrighterColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 10.w,
            // IconButton(
            //     onPressed: (){},
            //     icon: Icon(Icons.close))
          ],
        )
        
      ],
    );
  }
}
