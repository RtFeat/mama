import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/consultation/widgets/paragraph.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class MyConsultationWidget extends StatelessWidget {
  final Consultation consultation;
  final Color color;
  const MyConsultationWidget({
    super.key,
    required this.consultation,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final UserStore userStore = context.watch();

    final Role role = userStore.role;

    return Observer(builder: (context) {
      final Color commentColor = switch (consultation.status) {
        ConsultationStatus.completed => AppColors.greenLighterBackgroundColor,
        ConsultationStatus.rejected => AppColors.redLighterBackgroundColor,
        ConsultationStatus.pending => AppColors.purpleLighterBackgroundColor,
      };

      return Column(
        children: [
          ParagraphWidget(title: t.consultation.yourRecord, children: [
            ConsultationTypeWidget(
              iconColor: color,
              type: consultation.type,
              mainAxisAlignment: MainAxisAlignment.center,
              textStyle: textTheme.titleSmall,
            ),
            ConsultationTime(
                status: consultation.status,
                startDate: consultation.startedAt!.toLocal(),
                endDate: consultation.endedAt!.toLocal()),
            20.h,
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: 8.r,
                  border: Border.all(
                    color: commentColor,
                    width: 2,
                  )),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8)),
                            color: commentColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              t.consultation.myComment,
                              maxLines: 1,
                              style: textTheme.labelLarge?.copyWith(
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            consultation.comment ?? '',
                            style: textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            30.h,
            switch (role) {
              Role.doctor => CustomButton(
                  isSmall: false,
                  icon: AppIcons.bubbleLeftFill,
                  iconColor: AppColors.primaryColor,
                  // IconModel(
                  //     iconPath: Assets.icons.icBnChatsTap.path,
                  //     size: const Size(24, 24)

                  // ),
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
    });
  }
}
