import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/consultation/widgets/paragraph.dart';

class NewConsultationWidget extends StatefulWidget {
  final DoctorWorkTime? workTime;
  const NewConsultationWidget({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final TextStyle inputTextStyle = textTheme.titleSmall!.copyWith(
      color: AppColors.primaryColor,
    );

    final DoctorWorkTime? workTime = widget.workTime;

    // final DoctorWorkTime workTime = DoctorWorkTime(
    //   id: '',
    //   monday: WeekDay(isWork: true, workSlots: [
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //   ]),
    //   tuesday: WeekDay(isWork: true, workSlots: [
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //   ]),
    //   wednesday: WeekDay(isWork: true, workSlots: [
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //   ]),
    //   thursday: WeekDay(isWork: true, workSlots: [
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //     WorkSlot(isBusy: false, workSlot: '10:00'),
    //     WorkSlot(isBusy: false, workSlot: '10:00'),
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //     WorkSlot(isBusy: true, workSlot: '10:00'),
    //   ]),
    //   friday: WeekDay(
    //       isWork: true, workSlots: [WorkSlot(isBusy: true, workSlot: '10:00')]),
    //   saturday: WeekDay(
    //       isWork: true, workSlots: [WorkSlot(isBusy: true, workSlot: '10:00')]),
    //   sunday: WeekDay(
    //       isWork: true, workSlots: [WorkSlot(isBusy: true, workSlot: '10:00')]),
    // );

    return Column(
      children: [
        ParagraphWidget(
          title: t.consultation.format,
          children: [
            CustomToggleButton(
                items: [
                  ToggleButtonItem(
                      text: t.consultation.type_short.chat.title,
                      icon: IconModel(iconPath: Assets.icons.chatIcon)),
                  ToggleButtonItem(
                      text: t.consultation.type_short.video.title,
                      icon: IconModel(iconPath: Assets.icons.videoIcon)),
                  ToggleButtonItem(
                      text: t.consultation.type_short.express.title,
                      icon: IconModel(iconPath: Assets.icons.videoIcon)),
                ],
                onTap: (index) {
                  _tabController.animateTo(index);
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
                        iconPath: Assets.icons.calendar,
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
                        workTime?.setSelectedTime(v!);
                      });
                  }
                },
                btnWidth: MediaQuery.of(context).size.width * .3,
                btnHeight: 48),
            10.h,
            Observer(builder: (_) {
              if ((workTime == null || workTime.slots == null) &&
                  !(workTime?.isWork ?? false)) {
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
                  children: workTime!.slots!.map((e) {
                    if (e.isBusy) {
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
                              context.pushNamed(AppViews.webView, extra: {
                                'url': 'https://google.com',
                              });
                            }
                          : null,
                      title: isSelected
                          ? t.consultation.signUpOnline
                          : t.consultation.selectTime,
                      icon: isSelected
                          ? IconModel(
                              icon: Icons.language,
                            )
                          : null,
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
