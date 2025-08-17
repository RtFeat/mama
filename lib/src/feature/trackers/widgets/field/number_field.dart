import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mama/src/data.dart';

class NumberField extends StatefulWidget {
  final String? value;
  final void Function(String)? onChanged;
  final int decimals;
  final List<TextInputFormatter>? inputFormatters;

  const NumberField({
    super.key,
    this.value,
    this.onChanged,
    this.decimals = 1,
    this.inputFormatters,
  });

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(covariant NumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.value ?? '';
    if (newText != _controller.text) {
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  void _onChanged(String raw) {
    widget.onChanged?.call(raw);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: _onChanged,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
      ),
      inputFormatters: widget.inputFormatters,
      style: AppTextStyles.f44w400.copyWith(
        color: AppColors.primaryColor,
        fontSize: 64,
        height: 1.2,
      ),
    );
  }
}
