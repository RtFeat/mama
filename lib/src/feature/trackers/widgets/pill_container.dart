import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class PillAndDocVisitContainer extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subTitle;
  final String timeDate;
  final String? description;

  const PillAndDocVisitContainer({
    super.key,
    required this.title,
    this.subTitle,
    required this.timeDate,
    this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.whiteDarkerButtonColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// #pill image

            imageUrl != null
                ? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage(
                          imageUrl!,
                        ),
                      ),
                    ),
                  )
                : const DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.purpleLighterBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Icon(AppIcons.pillsFill,
                            color: AppColors.primaryColor, size: 28),
                      ),
                    ),
                  ),
            const SizedBox(width: 16),

            /// #pill details
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8).copyWith(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// #pill title
                    AutoSizeText(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),

                    /// #pill description
                    subTitle != null
                        ? AutoSizeText(
                            subTitle!,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 14),
                          )
                        : const SizedBox.shrink(),
                    5.h,

                    /// #pill exact time, pill remaining time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// #pill exact time
                        AutoSizeText(
                          timeDate,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontSize: 14),
                        ),
                        description != null ? 5.h : const SizedBox.shrink(),

                        /// #pill remaining time
                        description != null
                            ? AutoSizeText(
                                description!,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        fontSize:
                                            description != null ? 10 : 14),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
