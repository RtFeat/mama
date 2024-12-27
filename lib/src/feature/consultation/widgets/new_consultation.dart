import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/consultation/widgets/paragraph.dart';
import 'package:provider/provider.dart';

class NewConsultationWidget extends StatefulWidget {
  final String doctorId;
  final DoctorWorkTime? workTime;
  const NewConsultationWidget({
    super.key,
    required this.doctorId,
    required this.workTime,
  });

  @override
  State<NewConsultationWidget> createState() => _NewConsultationWidgetState();
}

class _NewConsultationWidgetState extends State<NewConsultationWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _controller;

  @override
  initState() {
    _tabController = TabController(length: 3, vsync: this);
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool isNextWeek(DateTime? weekStart, DateTime? selectedTime) {
    if (weekStart == null || selectedTime == null) return false;

    // Приводим даты к началу недели (например, к понедельнику)
    DateTime startOfWeek(DateTime date) {
      return DateTime(date.year, date.month, date.day)
          .subtract(Duration(days: date.weekday - 1));
    }

    DateTime startSelectedTime = startOfWeek(selectedTime);

    // Рассчитываем разницу в неделях
    final weekDifference = startSelectedTime.difference(weekStart).inDays ~/ 7;

    // Если разница ровно 1 неделя, то это следующая неделя
    return weekDifference == 1;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final TextStyle inputTextStyle = textTheme.titleSmall!.copyWith(
      color: AppColors.primaryColor,
    );

    final UserStore userStore = context.watch();
    final DoctorWorkTime? workTime = widget.workTime;
    final ConsultationStore store = context.watch<ConsultationStore>();

    return Column(
      children: [
        ParagraphWidget(
          title: t.consultation.format,
          children: [
            CustomToggleButton(
                items: [
                  ToggleButtonItem(
                      text: t.consultation.type_short.chat.title,
                      icon: IconModel(
                        // iconPath: Assets.icons.chatIcon
                        icon: AppIcons.messageCircleFill,
                        color: AppColors.primaryColor,
                      )),
                  ToggleButtonItem(
                      text: t.consultation.type_short.video.title,
                      icon: IconModel(
                        // iconPath: Assets.icons.videoIcon
                        icon: AppIcons.videoCircleFill,
                        color: AppColors.primaryColor,
                      )),
                  ToggleButtonItem(
                      text: t.consultation.type_short.express.title,
                      icon: IconModel(
                        // iconPath: Assets.icons.videoIcon,
                        icon: AppIcons.videoCircleFill,
                        color: AppColors.primaryColor,
                      )),
                ],
                onTap: (index) {
                  _tabController.animateTo(index);
                  workTime?.setSelectedConsultationType(index);
                },
                btnWidth: MediaQuery.of(context).size.width * .3,
                btnHeight: 48),
            8.h,
            SizedBox(
              height: 120,
              child: TabBarView(
                  controller: _tabController,
                  children: [
                    t.consultation.type_short.chat.desc,
                    t.consultation.type_short.video.desc,
                    t.consultation.type_short.express.desc,
                  ]
                      .map((e) => AutoSizeText(
                            e,
                            style: textTheme.labelMedium,
                          ))
                      .toList()),
            ),
          ],
        ),
        16.h,
        ParagraphWidget(
          title: t.consultation.comment.title,
          children: [
            AutoSizeText(
              t.consultation.comment.desc,
              style: textTheme.labelMedium,
            ),
            20.h,
            TextField(
              controller: _controller,
              style: inputTextStyle,
              maxLines: null,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                  fillColor: AppColors.lavenderBlue.withOpacity(.5),
                  filled: true,
                  hintText: t.consultation.comment.action,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  hintStyle: inputTextStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  )),
            ),
          ],
        ),
        16.h,
        ParagraphWidget(
          title: t.consultation.timeOfConsultation,
          children: [
            CustomToggleButton(
                items: [
                  ToggleButtonItem(
                    text: t.home.today,
                  ),
                  ToggleButtonItem(
                    text: t.consultation.tomorrow,
                  ),
                  ToggleButtonItem(
                      text: t.consultation.select,
                      icon: IconModel(
                        icon: AppIcons.calendar,
                        color: AppColors.greyLighterColor,
                        // iconPath: Assets.icons.calendar,
                      )),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      workTime?.setSelectedTime(DateTime.now());
                    case 1:
                      workTime?.setSelectedTime(
                          DateTime.now().add(const Duration(days: 1)));
                    case 2:
                      showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(
                            days: 30,
                          ))).then((v) {
                        if (v != null) {
                          workTime?.setSelectedTime(v);
                        }
                      });
                  }
                },
                btnWidth: MediaQuery.of(context).size.width * .3,
                btnHeight: 48),
            10.h,
            Observer(builder: (_) {
              if ((workTime?.slots?.isEmpty ?? true) ||
                  isNextWeek(workTime?.weekStart, workTime?.selectedTime)) {
                return AutoSizeText(
                  t.consultation.noAvailableTime,
                  textAlign: TextAlign.center,
                  style: textTheme.labelMedium,
                );
              }
              return IntrinsicHeight(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: workTime!.intervalSlots.map((e) {
                    if (e.isBusy ?? false) {
                      return const SizedBox.shrink();
                    }

                    return TimeChip(
                      slot: e,
                      onSelect: (v) {
                        workTime.markAllAsNotSelected();
                        e.select(v);
                      },
                    );
                  }).toList(),
                ),
              );
            }),
            30.h,
            Observer(builder: (_) {
              final bool isSelected = workTime?.isSelectedDate ?? true;

              return Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: isSelected
                          ? () {
                              store.addConsultation(
                                  doctorId: widget.doctorId,
                                  userId: userStore.user.id ?? '',
                                  comment: _controller.text.trim(),
                                  slot: workTime?.intervalSlots
                                          .firstWhere((v) => v.isSelected)
                                          .workSlot
                                          .replaceAll(' ', '') ??
                                      '',
                                  type: switch (_tabController.index) {
                                    1 => ConsultationType.video,
                                    2 => ConsultationType.express,
                                    _ => ConsultationType.chat,
                                  },
                                  weekStart:
                                      workTime?.weekStart ?? DateTime.now(),
                                  weekDay: workTime?.selectedTime.weekday ?? 1);
                              // context.pushNamed(AppViews.webView, extra: {
                              //   'url': 'https://google.com',
                              // });
                            }
                          : null,
                      title: isSelected
                          ? t.consultation.makeAnAppointment
                          : t.consultation.selectTime,
                    ),
                  ),
                ],
              );
            }),
            100.h,
          ],
        )
      ],
    );
  }
}
