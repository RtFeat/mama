import 'package:flutter/services.dart';

class KilogramInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Оставляем только цифры
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted;
    if (digits.length == 1) {
      formatted = digits;
    } else if (digits.length <= 4) {
      formatted = '${digits[0]},${digits.substring(1)}';
    } else {
      formatted = '${digits[0]},${digits.substring(1, 4)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
