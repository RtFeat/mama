import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama/src/data.dart';

class BasicMeshWidget extends StatefulWidget {
  const BasicMeshWidget({super.key});

  @override
  State<BasicMeshWidget> createState() => _BasicMeshWidgetState();
}

class _BasicMeshWidgetState extends State<BasicMeshWidget> {
  var collapse = false;

  var scheduleTimes = {
    '9:00': '9:30',
    '9:30': '10:00',
    '10:00': '10:30',
    '10:30': '11:00',
    '11:00': '11:30',
    '11:30': '12:00',
    '12:00': '12:30',
    '12:30': '13:00',
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return SpecialistConsultingContainer(
      child: Column(
        children: [
          8.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  "Базовая сетка",
                  style: textTheme.titleLarge
                      ?.copyWith(color: Colors.black, fontSize: 20),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      setState(() {
                        collapse = !collapse;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(collapse
                            ? Assets.icons.chevronDown
                            : Assets.icons.chevronUp),
                        Text(
                          collapse ? "Развернуть" : "Свернуть",
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        )
                      ],
                    ))
              ],
            ),
          ),
          8.h,
          collapse
              ? const SizedBox()
              : Column(
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    12.h,
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          _TextWidget(
                            text: "Рабочие дни",
                            isTitle: true,
                          ),
                          _TextWidget(
                            text:
                                "Установите рабочие дни в неделе. Конкретный день можно переназначить в календаре",
                            isTitle: false,
                          ),
                          WeekContainer()
                        ],
                      ),
                    ),
                    8.h,
                    const Divider(),
                    8.h,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          const _TextWidget(
                            text: "Рабочее время",
                            isTitle: true,
                          ),
                          const _TextWidget(
                            text:
                                "Задайте часы консультации в рабочие дни. Конкретный день можно изменить в календаре",
                            isTitle: false,
                          ),
                          8.h,
                          const TimeContainer(time: '9:00 - 13:00'),
                          5.h,
                          const TimeContainer(time: '14:00 - 18:00'),
                          10.h,
                          CustomButton(
                            type: CustomButtonType.filled,
                            backgroundColor: Colors.white,
                            textStyle: textTheme.bodyMedium
                                ?.copyWith(color: AppColors.primaryColor),
                            title: "Добавить рабочее время",
                            icon: IconModel(icon: Icons.add),
                            onTap: () {},
                          ),
                          10.h
                        ],
                      ),
                    ),
                    8.h,
                    const Divider(),
                    8.h,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          const _TextWidget(
                            text: 'Длительность консультации',
                            isTitle: true,
                          ),
                          const _TextWidget(
                            text:
                                'Задайте длительность консультации и ваши рабочие дни разобьются на слоты, '
                                'в которые смогут записаться ваши пациенты',
                            isTitle: false,
                          ),
                          5.h,
                          Row(
                            children: [
                              SvgPicture.asset(Assets.icons.icGreenWarning),
                              8.w,
                              const Expanded(
                                child: _TextWidget(
                                  text:
                                      'Консультации идут одна за одной. Добавьте себе время на перерыв',
                                  isTitle: false,
                                ),
                              ),
                            ],
                          ),
                          10.h,
                          ConsultationTimeWidget(),
                          10.h,
                          ConsultationScheduleWidget(
                            startTime: '9:00',
                            entTime: '13:00',
                            scheduleTimes: scheduleTimes,
                          ),
                          5.h,
                          ConsultationScheduleWidget(
                            startTime: '14:00',
                            entTime: '18:00',
                            scheduleTimes: scheduleTimes,
                          ),
                          20.h
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _TextWidget extends StatelessWidget {
  final String text;
  final bool isTitle;

  const _TextWidget({super.key, required this.text, required this.isTitle});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: isTitle
              ? textTheme.bodyMedium?.copyWith(color: Colors.black)
              : textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
    );
  }
}
