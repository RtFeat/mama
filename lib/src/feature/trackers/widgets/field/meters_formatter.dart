import 'package:flutter/services.dart';

class MetersInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Удаляем все нецифровые символы из нового ввода
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Ограничиваем до 2 цифр
    if (digits.length > 2) {
      digits = digits.substring(0, 2);
    }

    // Формируем строку "0,XX"
    String formatted = '0,${digits.padLeft(2, '0')}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
