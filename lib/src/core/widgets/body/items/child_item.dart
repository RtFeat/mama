import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ChildItem extends StatefulWidget {
  final int index;
  final ChildModel model;
  const ChildItem({
    super.key,
    required this.index,
    required this.model,
  });

  @override
  State<ChildItem> createState() => _ChildItemState();
}

class _ChildItemState extends State<ChildItem> {
  late FormGroup formGroup;

  @override
  void initState() {
    formGroup = FormGroup({
      'name': FormControl<String>(value: widget.model.firstName),
      'weight': FormControl(
        value: widget.model.weight != null
            ? '${widget.model.weight} ${t.profile.unitMeasureWeight}'
            : null,
        validators: [
          Validators.required,
        ],
      ),
      'height': FormControl(
        value: widget.model.height != null
            ? '${widget.model.height} ${t.profile.unitMeasureHeight}'
            : null,
        validators: [
          Validators.required,
        ],
      ),
      'headCircumference': FormControl(
        value: widget.model.headCircumference != null
            ? '${widget.model.headCircumference} ${t.profile.unitMeasureHeight}'
            : null,
        validators: [
          Validators.required,
        ],
      ),
      'dateBirth': FormControl<DateTime>(value: widget.model.birthDate),
      'about': FormControl(value: widget.model.about),
    });
    super.initState();
  }

  @override
  void dispose() {
    formGroup.dispose();
    super.dispose();
  }

  double? _getValue(String? value, [int valueMaxLength = 5]) {
    // Убираем все символы, кроме цифр и запятой
    String? numericValue = value?.replaceAll(RegExp(r'[^0-9,]'), '');
    logger.info('numericValue: $numericValue');

    if (numericValue != null) {
      // Заменяем запятую на точку
      numericValue = numericValue.replaceAll(',', '.');

      // Проверяем длину строки
      if (numericValue.length > valueMaxLength) {
        numericValue = numericValue.substring(0, valueMaxLength);
      }

      // Пробуем преобразовать строку в double
      double? parsedValue = double.tryParse(numericValue);
      return parsedValue;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle titlesStyle =
        textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400);

    final InputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: 6.r,
    );
    const EdgeInsets inputPadding =
        EdgeInsets.symmetric(horizontal: 12, vertical: 4);

    final MaskTextInputFormatter weightFormatter = MaskTextInputFormatter(
        mask: '#,## ${t.profile.unitMeasureWeight}',
        filter: {'#': RegExp('[0-9]')},
        type: MaskAutoCompletionType.eager);

    final MaskTextInputFormatter sizeFormatter = MaskTextInputFormatter(
        mask: '## ${t.profile.unitMeasureHeight}',
        filter: {'#': RegExp('[0-9]')},
        type: MaskAutoCompletionType.eager);

    const TextAlign inputTextAlign = TextAlign.center;

    return Observer(builder: (context) {
      return Column(
        children: [
          BodyGroup(
              title: widget.index == 0 ? t.profile.childTitle : '',
              formGroup: formGroup,
              isDecorated: true,
              items: [
                ChildBarWidget(
                  child: widget.model,
                ),
                BodyItemWidget(
                    item: CustomBodyItem(
                  titleStyle: titlesStyle,
                  title: t.profile.genderTitle,
                  body: FlutterToggleButton(
                    outerContainerMargin: 3,
                    buttonWidth: 128,
                    buttonHeight: 38,
                    buttonColor: Colors.white,
                    enableTextColor: AppColors.primaryColor,
                    buttonTextFontSize: 14,
                    borderRadius: 6,
                    outerContainerColor: AppColors.purpleLighterBackgroundColor,
                    onTap: (index) =>
                        widget.model.setGender(Gender.values[index]),
                    items: [
                      ToggleButtonItem(text: Gender.female.name),
                      ToggleButtonItem(text: Gender.male.name),
                    ],
                  ),
                )),
                BodyItemWidget(
                    item: ItemWithSwitch(
                        title: t.profile.twinsTitle,
                        titleStyle: titlesStyle,
                        subtitle: t.profile.twinsHelper,
                        value: widget.model.isTwins,
                        onChanged: (value) => widget.model.setIsTwins(value))),
                BodyItemWidget(
                  item: ItemWithInput(
                      inputItem: InputItem(
                        controlName: 'weight',
                        isCollapsed: true,
                        textAlign: inputTextAlign,
                        textInputAction: TextInputAction.next,
                        maskFormatter: weightFormatter,
                        border: inputBorder,
                        contentPadding: inputPadding,
                        backgroundColor: AppColors.purpleLighterBackgroundColor,
                        inputHint: t.profile.inputHint,
                        onChanged: (value) {
                          final double? cleanValue = _getValue(value);

                          widget.model.setWeight(cleanValue);
                        },
                        inputHintStyle: titlesStyle.copyWith(
                            color: AppColors.greyBrighterColor),
                      ),
                      bodyItem: CustomBodyItem(
                        title: t.profile.weightTitle,
                        titleStyle: titlesStyle,
                      )),
                ),
                BodyItemWidget(
                  item: ItemWithInput(
                      inputItem: InputItem(
                        controlName: 'height',
                        isCollapsed: true,
                        textAlign: inputTextAlign,
                        textInputAction: TextInputAction.next,
                        maskFormatter: sizeFormatter,
                        border: inputBorder,
                        contentPadding: inputPadding,
                        backgroundColor: AppColors.purpleLighterBackgroundColor,
                        inputHint: t.profile.inputHint,
                        onChanged: (value) {
                          final double? cleanValue = _getValue(value);

                          widget.model.setHeight(cleanValue);
                        },
                        inputHintStyle: titlesStyle.copyWith(
                            color: AppColors.greyBrighterColor),
                      ),
                      bodyItem: CustomBodyItem(
                        title: t.profile.heightTitle,
                        titleStyle: titlesStyle,
                      )),
                ),
                BodyItemWidget(
                  item: ItemWithInput(
                      inputItem: InputItem(
                        controlName: 'headCircumference',
                        isCollapsed: true,
                        textAlign: inputTextAlign,
                        textInputAction: TextInputAction.next,
                        maskFormatter: sizeFormatter,
                        border: inputBorder,
                        contentPadding: inputPadding,
                        backgroundColor: AppColors.purpleLighterBackgroundColor,
                        inputHint: t.profile.inputHint,
                        onChanged: (value) {
                          final double? cleanValue = _getValue(value);

                          widget.model.setHeadCircumference(cleanValue);
                        },
                        inputHintStyle: titlesStyle.copyWith(
                            color: AppColors.greyBrighterColor),
                      ),
                      bodyItem: CustomBodyItem(
                        title: t.profile.headCircumferenceTitle,
                        titleStyle: titlesStyle,
                      )),
                ),
                BodyItemWidget(
                    item: CustomBodyItem(
                        title: t.profile.birthTitle,
                        titleStyle: titlesStyle,
                        hintStyle: textTheme.bodySmall!.copyWith(
                            fontSize: 10,
                            letterSpacing: 0,
                            color: AppColors.redColor),
                        body: CustomToggleButton(
                            initialIndex: widget.model.childbirth.index,
                            items: [
                              ToggleButtonItem(text: Childbirth.natural.name),
                              ToggleButtonItem(text: Childbirth.cesarian.name),
                            ],
                            onTap: (index) => widget.model
                                .setChildbirth(Childbirth.values[index]),
                            btnWidth: 128,
                            btnHeight: 38))),
                BodyItemWidget(
                    item: ItemWithSwitch(
                        title: t.profile.birthComplicationsTitle,
                        titleStyle: titlesStyle,
                        value: widget.model.childBirthWithComplications,
                        onChanged: (value) {
                          widget.model.setChildbirthWithComplications(value);
                        })),
                ItemsNeedToFill(formGroup: formGroup),
                DottedInput(
                  model: widget.model,
                ),
              ]),
        ],
      );
    });
  }
}
