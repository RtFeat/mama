import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

class AddPumpingInput extends StatefulWidget {
  const AddPumpingInput({super.key});

  @override
  State<AddPumpingInput> createState() => _AddPumpingInputState();
}

class _AddPumpingInputState extends State<AddPumpingInput> {
  bool _rulerOpen = false;
  OverlayEntry? _rulerEntry;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final MaskTextInputFormatter formatter = MaskTextInputFormatter(
        // Без суффикса "мл", чтобы в контрол не попадали буквы
        mask: '####',
        filter: {'#': RegExp('[0-9]')},
        type: MaskAutoCompletionType.eager);

    return Consumer<AddPumping>(builder: (context, model, child) {
      return Observer(builder: (context) {
        // Извлекаем числовые значения из строк, убирая "мл"
        final leftValue = _extractNumericValue(model.left.value);
        final rightValue = _extractNumericValue(model.right.value);
        var total = leftValue + rightValue;
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InputContainer(
                            formatter: formatter,
                            title: t.feeding.left,
                            controlName: 'left',
                            inputHint: '0 мл',
                            readOnly: true,
                            onTap: (_) => _openRuler(context, model, isLeft: true),
                          ),
                          InputContainer(
                            formatter: formatter,
                            title: t.feeding.right,
                            controlName: 'right',
                            inputHint: '0 мл',
                            readOnly: true,
                            onTap: (_) => _openRuler(context, model, isLeft: false),
                          )
                        ],
                      ),
                      25.h,
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          final dynamic leftRaw = form.control('left').value;
                          final dynamic rightRaw = form.control('right').value;
                          final int leftParsed = _extractNumericValue(leftRaw);
                          final int rightParsed = _extractNumericValue(rightRaw);
                          final int totalParsed = leftParsed + rightParsed;

                          return Column(
                            children: [
                              Text(
                                t.feeding.total,
                                style: textTheme.headlineSmall?.copyWith(
                                    color: AppColors.greyBrighterColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              8.h,
                              Text(
                                '$totalParsed мл',
                                style:
                                    textTheme.titleSmall?.copyWith(color: Colors.black),
                              ),
                              10.h,
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }

  int _extractNumericValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      // Убираем все нецифровые символы (включая пробелы, неразрывные пробелы и суффиксы)
      final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digitsOnly.isEmpty) return 0;
      return int.tryParse(digitsOnly) ?? 0;
    }
    return 0;
  }

  void _openRuler(BuildContext context, AddPumping model, {required bool isLeft}) {
    if (_rulerOpen) return;

    final form = model.formGroup;
    final currentRaw = form.control(isLeft ? 'left' : 'right').value;
    final currentValue = _extractNumericValue(currentRaw).toDouble();

    _rulerOpen = true;

    _rulerEntry = OverlayEntry(
      builder: (ctx) {
        double localValue = currentValue.clamp(0, 200);
        return Stack(
          children: [
            // Клик по фону закрывает оверлей
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hideRuler,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: UniversalRuler(
                        config: RulerConfig(
                          height: 180,
                          mainDashHeight: 140,
                          longDashHeight: 110,
                          shortDashHeight: 50,
                          width: 16,
                        ),
                        min: 0,
                        max: 200,
                        step: 1,
                        value: localValue,
                        labelStep: 10,
                        unit: 'мл',
                        onChanged: (v) {
                          localValue = v;
                          final int selected = localValue.round();
                          form.control(isLeft ? 'left' : 'right').value = selected;
                          form.markAsTouched();
                          form.updateValue(form.value, updateParent: true, emitEvent: true);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true)?.insert(_rulerEntry!);
  }

  void _hideRuler() {
    if (_rulerEntry != null) {
      _rulerEntry!.remove();
      _rulerEntry = null;
    }
    _rulerOpen = false;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _hideRuler();
    super.dispose();
  }
}
