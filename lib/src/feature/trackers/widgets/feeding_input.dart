import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:skit/skit.dart';

class InputContainer extends StatefulWidget {
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
  State<InputContainer> createState() => _InputContainerState();
}

class _InputContainerState extends State<InputContainer> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    
    // Добавляем listener для форматирования
    _controller.addListener(() {
      final value = _controller.text;
      if (value.isNotEmpty) {
        final formatted = formatTimeInput(value);
        if (formatted != value) {
          _controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
  
  String formatTimeInput(String value) {
    // Убираем все нецифровые символы
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digits.isEmpty) return '';
    
    // Интерпретируем число
    if (digits.length == 1) {
      // Одна цифра: X → Xм
      return '${digits}м';
    } else if (digits.length == 2) {
      // Две цифры: XX → XXм
      return '${digits}м';
    } else if (digits.length == 3) {
      // Три цифры: XXX → XXм Xс
      final minutes = digits.substring(0, 2);
      final seconds = int.parse(digits.substring(2, 3));
      if (seconds > 9) {
        // Если последняя цифра > 9, берем её как 9
        return '${minutes}м 9с';
      }
      return '${minutes}м ${digits[2]}с';
    } else if (digits.length >= 4) {
      // Четыре и более цифр: XXXX → XXм XXс
      final minutes = digits.substring(0, 2);
      final seconds = int.parse(digits.substring(2, 4));
      final limitedSeconds = seconds > 59 ? 59 : seconds;
      return '${minutes}м ${limitedSeconds.toString().padLeft(2, '0')}с';
    }
    
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final InputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(6),
    );
    const EdgeInsets inputPadding = EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10);

    // Кастомный форматтер для интерпретации чисел
    final maskFormatter = MaskTextInputFormatter(
      mask: '##м ##с',
      filter: {'#': RegExp('[0-9]')},
      type: MaskAutoCompletionType.eager,
    );

    const TextAlign inputTextAlign = TextAlign.center;

    final inputHintStyle = textTheme.labelLarge
        ?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
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
                final isReadOnly = widget.readOnly ?? false;
                if (!isReadOnly) {
                  _focusNode.requestFocus();
                  // Открываем клавиатуру
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _focusNode.requestFocus();
                  });
                }
                if (widget.onTap != null) widget.onTap!(null);
              },
              child: FocusScope(
                child: Container(
                  width: 100,
                  constraints: const BoxConstraints(
                    minHeight: 42,
                    maxHeight: 60,
                  ),
                  decoration: BoxDecoration(
                    color: _isFocused ? const Color(0xFF4D4DE8) : const Color(0xD9F8FAFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Focus(
                          focusNode: _focusNode,
                          child: InputItemWidget(
                          item: InputItem(
                            inputHint: widget.inputHint,
                            keyboardType: TextInputType.number,
                            inputHintStyle: inputHintStyle?.copyWith(
                              color: _isFocused ? Colors.white : const Color(0xFF4D4DE8),
                              fontSize: 14,
                            ),
                            controlName: widget.controlName,
                            controller: _controller,
                            isCollapsed: true,
                            needBackgroundOnFocus: false, // Управляем фоном сами
                            textAlign: inputTextAlign,
                            textInputAction: TextInputAction.next,
                            maskFormatter: widget.formatter ?? maskFormatter,
                            border: inputBorder,
                            contentPadding: inputPadding,
                            backgroundColor: Colors.transparent,
                            readOnly: widget.readOnly,
                            onTap: widget.onTap,
                            titleStyle: _isFocused 
                                ? TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  )
                                : TextStyle(
                                    color: const Color(0xFF4D4DE8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    // Показываем subtitle только если нет фокуса
                    if (widget.subtitle != null && !_isFocused) ...[
                      Text(
                        widget.subtitle!,
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
