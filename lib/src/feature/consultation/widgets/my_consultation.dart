import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/consultation/widgets/paragraph.dart';
import 'package:provider/provider.dart';

class MyConsultationWidget extends StatelessWidget {
  final Consultation consultation;
  const MyConsultationWidget({super.key, required this.consultation});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final UserStore userStore = context.watch();

    final Role role = userStore.role;

    return Column(
      children: [
        ParagraphWidget(title: t.consultation.yourRecord, children: [
          ConsultationTypeWidget(
            type: consultation.type,
            mainAxisAlignment: MainAxisAlignment.center,
            textStyle: textTheme.titleSmall,
          ),
          ConsultationTime(
              isWithTimeBefore: true,
              startDate: consultation.startedAt ?? DateTime.now(),
              endDate: consultation.endedAt ?? DateTime.now()),
          20.h,
          DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: 8.r,
                border: Border.all(
                  color: AppColors.purpleLighterBackgroundColor,
                  width: 2,
                )),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(8)),
                          color: AppColors.purpleLighterBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            t.consultation.myComment,
                            maxLines: 1,
                            style: textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    'dgdfgdfg' * 20,
                    style: textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
          30.h,
          switch (role) {
            Role.doctor => CustomButton(
                isSmall: false,
                icon: IconModel(
                    iconPath: Assets.icons.icBnChatsTap.path,
                    size: const Size(24, 24)),
                title: t.consultation.chatWithUser,
                onTap: () {},
              ),
            _ => CustomButton(
                isSmall: false,
                backgroundColor: AppColors.redLighterBackgroundColor,
                title: t.consultation.cancel.title,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const CancelRecordWidget(),
                  );
                },
              ),
          }
        ]),
      ],
    );
  }
}
