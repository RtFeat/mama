import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class MeetingBox extends StatelessWidget {
  final String scheduledTime;
  final String meetingType;
  final bool isCancelled;
  final String tutorFullName;
  final int whichSection;

  final IconModel? icon;

  final TextStyle? timeStyle;

  final String consultationId;

  final Color? backgroundColor;

  final TextStyle? tutorNameStyle;

  final DateTime startedAt;

  const MeetingBox({
    super.key,
    this.icon,
    this.timeStyle,
    required this.startedAt,
    required this.scheduledTime,
    required this.meetingType,
    required this.isCancelled,
    required this.tutorFullName,
    required this.whichSection,
    required this.consultationId,
    this.backgroundColor,
    this.tutorNameStyle,
  });

  @override
  Widget build(BuildContext context) {
    logger.info('consultationId: $consultationId');
    logger.info('startedAt: $startedAt');

    return GestureDetector(
      onTap: () {
        if (consultationId.isNotEmpty) {
          context.pushNamed(AppViews.consultation, extra: {
            'consultation': Consultation(
              id: consultationId,
              startedAt: startedAt,
            )
          });
        }
      },
      child: IntrinsicWidth(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor ??
                (whichSection == 1
                    ? isCancelled
                        ? AppColors.redLighterBackgroundColor
                        : AppColors.greenLighterBackgroundColor
                    : AppColors.purpleLighterBackgroundColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// #time schedule
                Row(
                  children: [
                    Text(
                      scheduledTime,
                      maxLines: 1,
                      style: timeStyle ??
                          const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                    if (icon != null) ...[6.w, IconWidget(model: icon!)]
                  ],
                ),

                /// #type, mark
                if (icon == null)
                  Row(
                    children: [
                      /// #type
                      Text(
                        meetingType,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: whichSection == 1
                              ? isCancelled
                                  ? AppColors.redColor
                                  : AppColors.greenTextColor
                              : AppColors.primaryColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),

                      /// #mark
                      whichSection == 1
                          ? SvgPicture.asset(
                              isCancelled
                                  ? Assets.icons.icXmark
                                  : Assets.icons.icCheckmark,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),

                /// #full name
                Text(
                  tutorFullName,
                  maxLines: 1,
                  style: tutorNameStyle ??
                      const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
