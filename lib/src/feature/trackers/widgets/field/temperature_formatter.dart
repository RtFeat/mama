import 'package:flutter/services.dart';

class TemperatureInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Удаляем все нецифровые символы
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }
    String formatted;
    if (digits.length <= 2) {
      formatted = digits;
    } else {
      final before = digits.substring(0, 2);
      final after = digits.substring(2, digits.length > 3 ? 3 : digits.length);
      formatted = '$before,$after';
    }
    // Перемещаем курсор в конец строки
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
